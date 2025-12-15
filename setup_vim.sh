#!/usr/bin/env bash
# set -euo pipefail

log(){ printf "\n\033[1;32m==> %s\033[0m\n" "$*"; }
warn(){ printf "\n\033[1;33m[WARN] %s\033[0m\n" "$*"; }
err(){ printf "\n\033[1;31m[ERR] %s\033[0m\n" "$*"; }

have(){ command -v "$1" >/dev/null 2>&1; }

if ! have sudo; then
  err "sudo 가 필요합니다. root로 실행하거나 sudo를 설치하세요."
  exit 1
fi

log "Install base deps (git/curl/ca-certificates)"
sudo apt-get update -y
sudo apt-get install -y git curl ca-certificates

# 1) Vim 버전 체크 (이미 9.1이면 그대로 사용)
if have vim; then
  log "Vim found: $(vim --version | head -n1)"
else
  warn "vim 이 없어서 apt로 설치합니다 (배포판에 따라 버전이 낮을 수 있음)."
  sudo apt-get install -y vim-gtk3
fi

# 2) Node.js (Copilot용) - Node 22 권장 설치
need_node=1
if have node; then
  node_major="$(node -v | sed 's/^v//' | cut -d. -f1 || true)"
  if [[ "${node_major:-0}" -ge 22 ]]; then
    need_node=0
  fi
fi

if [[ "$need_node" -eq 1 ]]; then
  log "Install Node.js 22.x via NodeSource (for Copilot)"
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  log "Node.js found: $(node -v)"
fi

log "Launching Vim and running :Copilot setup (you still need to finish GitHub auth)"
