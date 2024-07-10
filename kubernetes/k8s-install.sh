#!/bin/bash

set -e  # Exit when any command exits with a non-zero status

# Variables
## Temp dirs
TEMP_DIR_CONTAINERD=/tmp/containerd
TEMP_DIR_RUNC=/tmp/runc
TEMP_DIR_CNI=/tmp/cni
## Versions
VERSION_CONTAINERD=1.7.19
VERSION_RUNC=1.1.13
VERSION_CNI=1.5.1
VERSION_KUBERNETES=1.30
## Kubeadm config
KUBEADM_CONFIG_CIDR=192.168.0.0/16

# Required apt packages
echo -----------------------------
echo Installing necessary packages
echo -----------------------------
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y apt-transport-https ca-certificates curl
echo ----------------------------
echo Necessary packages installed
echo ----------------------------

# Containerd
## Config
sudo mkdir -p /etc/containerd
cat <<EOF | sudo tee /etc/containerd/config.toml
version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
    runtime_type = "io.containerd.runc.v2"
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
      SystemdCgroup = true
EOF
echo ---------------------
echo Containerd configured
echo ---------------------
## Download
curl -L --create-dirs --remote-name-all --output-dir $TEMP_DIR_CONTAINERD https://github.com/containerd/containerd/releases/download/v$VERSION_CONTAINERD/containerd-$VERSION_CONTAINERD-linux-amd64.tar.gz{,.sha256sum}
echo ---------------------
echo Containerd downloaded
echo ---------------------
cd $TEMP_DIR_CONTAINERD
## Verify checksum
sha256sum -c *.sha256sum
echo -----------------
echo Checksum verified
echo -----------------
## Install
tar xzf containerd-$VERSION_CONTAINERD-linux-amd64.tar.gz
sudo mv bin/* /usr/local/bin
echo --------------------
echo Containerd installed
echo --------------------
## Install containerd as a service
sudo curl -Lo /etc/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/v$VERSION_CONTAINERD/containerd.service
## Enable the containerd service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
echo --------------------------------
echo Containerd configured as service
echo --------------------------------
cd -
rm -rf $TEMP_DIR_CONTAINERD

# runc
## Download
curl -L --create-dirs --remote-name-all --output-dir $TEMP_DIR_RUNC https://github.com/opencontainers/runc/releases/download/v$VERSION_RUNC/runc.{amd64,sha256sum}
echo ---------------
echo Runc Downloaded
echo ---------------
cd $TEMP_DIR_RUNC
# Checksum
sha256sum --ignore-missing -c *.sha256sum
echo -----------------
echo Checksum verified
echo -----------------
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
echo --------------
echo Runc installed
echo --------------
cd -
rm -rf $TEMP_DIR_RUNC

# cni
## Download
curl -L --create-dirs --remote-name-all --output-dir $TEMP_DIR_CNI https://github.com/containernetworking/plugins/releases/download/v$VERSION_CNI/cni-plugins-linux-amd64-v$VERSION_CNI.tgz{,.sha256}
echo --------------
echo cni downloaded
echo --------------
cd $TEMP_DIR_CNI
## Checksum
sha256sum -c *.sha256
echo -----------------
echo Checksum verified
echo -----------------
## Install
sudo mkdir -p /opt/cni/bin
sudo tar xzf cni-plugins-linux-amd64-v$VERSION_CNI.tgz -C /opt/cni/bin
echo --------------
echo cni installed
echo --------------
cd -
rm -rf $TEMP_DIR_CNI

# Configure system network settings
echo -----------------------------------
echo Configuring system network settings
echo -----------------------------------
sudo mkdir -p /etc/modules-load.d
## overlay - provides overlay filesystem support, which Kubernetes uses for its pod network abstraction.
## br_netfilter - enables bridge netfilter support in the Linux kernel, which is required for Kubernetes networking and policy
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
## Enables modules
sudo modprobe -a overlay br_netfilter
## sysctl params required by setup, params persist across reboots
### net.bridge.bridge-nf-call-iptables - enable bridged IPv4 traffic to be passed to iptables chains. This is required for Kubernetes networking policies and traffic routing to work.
### net.bridge.bridge-nf-call-ip6tables - enable bridged IPv6 traffic to be passed to iptables chains. This is required for Kubernetes networking policies and traffic routing to work.
### net.ipv4.ip_forward - enables IP forwarding in the kernel, which is required for packet routing between pods in Kubernetes.
sudo mkdir -p /etc/sysctl.d
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
## Apply sysctl params without reboot
sudo sysctl --system
echo -----------------------------------------------
echo System network settings Configured successfully
echo -----------------------------------------------

echo -------------------------------------------------------
echo Download and install kubeadm, kubelet, kubectl and helm
echo -------------------------------------------------------
sudo mkdir -p -m 755 /etc/apt/keyrings
# Add Kubernetes GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$VERSION_KUBERNETES/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# Add helm GPG key
curl https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
# Add Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v'$VERSION_KUBERNETES'/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Add helm apt repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# Fetch package list and install
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl helm
# Prevent the downloaded packages from being updated automatically
sudo apt-mark hold kubelet kubeadm kubectl
# Enable the kubelet service
sudo systemctl enable --now kubelet
echo -------------------------------------------------------------------------------------------
echo Successfully downloaded and installed kubeadm, kubelet and kubectl. Started kubelet service 
echo -------------------------------------------------------------------------------------------

echo ------------------------------
echo Starting cluster using kubeadm
echo ------------------------------
# Pod network cidr chosen because that is the default calico value
sudo kubeadm init --pod-network-cidr=$KUBEADM_CONFIG_CIDR
echo ----------------------------
echo Cluster started successfully
echo ----------------------------

echo --------------------------
echo Configuring kubectl access
echo --------------------------
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo -------------------------------
echo Kubectl configured successfully
echo -------------------------------

echo ----------------------
echo Untainting master node
echo ----------------------
# Try to remove taint for master node, continue if taint doesn't exist
kubectl taint nodes --all node-role.kubernetes.io/master- || true
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true
echo ----------------------
echo Master node untainted
echo ----------------------

echo ------------------------------------------------------------
echo Configuring networkManager to allow calico to work correctly
echo ------------------------------------------------------------
sudo mkdir -p /etc/NetworkManager/conf.d
cat <<EOF | sudo tee /etc/NetworkManager/conf.d/calico.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:vxlan-v6.calico;interface-name:wireguard.cali;interface-name:wg-v6.cali
EOF
echo -----------------------------------------------------------
echo NetworkManager configured to allow calico to work correctly
echo -----------------------------------------------------------

echo -----------------------------
echo Enabling completion and alias
echo -----------------------------
# Kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
# Helm
echo 'source <(helm completion bash)' >>~/.bashrc
echo 'alias h=helm' >>~/.bashrc
echo 'complete -o default -F __start_helm h' >>~/.bashrc
echo -----------------------------------------
echo completion and alias enabled successfully 
echo -----------------------------------------
echo Kubernetes configured successfully. Please restart the shell for completion and alias to take effect.