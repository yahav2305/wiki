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