#!/bin/bash
set -e  # Exit when any command exits with a non-zero status

# Required apt packages
echo -----------------------------
echo Installing necessary packages
echo -----------------------------
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y apt-transport-https ca-certificates curl

# Containerd - config
echo ----------------------
echo Configuring containerd
echo ----------------------
sudo mkdir /etc/containerd
sudo cp containerd-config.toml /etc/containerd/config.toml

# Containerd - checksum
echo ----------------------------
echo Checking containerd checksum
echo ----------------------------
curl -L --create-dirs --remote-name-all --output-dir /tmp/check https://github.com/containerd/containerd/releases/download/v1.7.19/containerd-1.7.19-linux-amd64.tar.gz{,.sha256sum}
cd /tmp/check
sha256sum -c *.sha256sum
rm *
cd -
echo -----------------
echo Checksum verified
echo -----------------

# Containerd - install
echo ------------------------------------------------
echo Installing containerd and configuring as service
echo ------------------------------------------------
## Download & Unpack to bin folder
sudo curl -L https://github.com/containerd/containerd/releases/download/v1.7.19/containerd-1.7.19-linux-amd64.tar.gz | sudo tar Cxzvf /usr/local/bin/ -
## Install containerd as a service
sudo curl -Lo /etc/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/v1.7.19/containerd.service
## Enable the containerd service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
echo -----------------------------------------------
echo Containerd installed and configuring as service
echo -----------------------------------------------

# runc - checksum and install
echo -------------------------------------------
echo Checking runc file signature and installing
echo -------------------------------------------
curl -L --create-dirs --remote-name-all --output-dir /tmp/check https://github.com/opencontainers/runc/releases/download/v1.1.13/runc.{amd64,sha256sum}
cd /tmp/check
sha256sum --ignore-missing -c *.sha256sum
echo -----------------
echo Checksum verified
echo -----------------
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
rm *
cd -
echo --------------
echo Runc installed
echo --------------

# cni - checksum
echo ------------------------------------------
echo Checking cni file signature and installing
echo ------------------------------------------
curl -L --create-dirs --remote-name-all --output-dir /tmp/check https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-amd64-v1.5.1.tgz{,.sha256}
cd /tmp/check
sha256sum -c *.sha256
echo -----------------
echo Checksum verified
echo -----------------
rm *
cd -

# cni - install
echo --------------
echo Installing cni
echo --------------
## Download & Unpack to bin folder
sudo mkdir -p /opt/cni/bin
sudo curl -L https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-amd64-v1.5.1.tgz | sudo tar Cxzvf /opt/cni/bin -
echo -------------
echo cni installed
echo -------------

# Configure system network settings
echo -----------------------------------
echo Configuring system network settings
echo -----------------------------------
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

echo -------------------------------------------------
echo Download and install kubeadm, kubelet and kubectl
echo -------------------------------------------------
# Add Kubernetes GPG key
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# Add Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Fetch package list and install
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
# Prevent the downloaded packages from being updated automatically
sudo apt-mark hold kubelet kubeadm kubectl
echo ------------------------------------------------------------------
echo Successfully downloaded and installed kubeadm, kubelet and kubectl
echo ------------------------------------------------------------------

echo ------------------------------
echo Starting cluster using kubeadm
echo ------------------------------
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
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

