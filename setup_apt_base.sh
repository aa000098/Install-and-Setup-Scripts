#!/usr/bin/env bash

# 설치할 기본 패키지 목록
PKGS=(
  cmake
  build-essential
  python3-dev
#  ninja-build
  universal-ctags

  git
  openssh-server
  iptables-persistent
  rsyslog
  htop
  python3-venv
  curl
#  mdadm

  # For tcmalloc
#   libgoogle-perftools-dev

  libgtk-3-dev

  # For vim
  vim-gtk3
#  ncurses-dev
#  libacl1-dev
#  gawk

  # For opencl
#  ocl-icd-opencl-dev
#  opencl-headers
#  clinfo

  # For acl
#   scons
)

echo "[+] Updating apt package index..."
sudo apt-get update -y

echo "[+] Installing base packages..."
# 비대화형 모드로 설치 (중간에 Y/N 물어보지 않게)
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${PKGS[@]}"

echo "[+] Enabling and starting rsyslog service..."
sudo systemctl enable rsyslog
sudo systemctl start rsyslog

echo "[+] Base setup complete."
