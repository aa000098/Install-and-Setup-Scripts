#!/usr/bin/env bash
set -e

# 현재 디렉터리 기억
ORIG_DIR="$(pwd)"
cleanup() { cd "$ORIG_DIR"; }
trap cleanup EXIT

LOCAL="${HOME}/local"
VENV_DIR="${LOCAL}/venv"

echo "[+] Checking Python3 installation..."
if ! command -v python3 >/dev/null 2>&1; then
  echo "[!] python3 not found. Installing..."
  sudo apt-get update -y
  sudo apt-get install -y python3 python3-pip
fi

echo "[+] Checking venv module..."
if ! python3 -m venv --help >/dev/null 2>&1; then
  echo "[!] python3-venv not found. Installing..."
  sudo apt-get update -y
  sudo apt-get install -y python3-venv
fi

# venv 디렉터리 생성
mkdir -p "${LOCAL}"

if [ -d "${VENV_DIR}" ]; then
  echo "[=] Virtual environment already exists at ${VENV_DIR}"
else
  echo "[+] Creating new virtual environment at ${VENV_DIR} ..."
  python3 -m venv "${VENV_DIR}"
  echo "[+] Virtual environment created successfully."
fi

# pip 업그레이드 및 기본 패키지 업데이트
echo "[+] Upgrading pip..."
"${VENV_DIR}/bin/pip" install --upgrade pip setuptools wheel

source ${VENV_DIR}/bin/activate

echo
echo "[✓] Python venv is ready!"
echo "    To activate:  source ${VENV_DIR}/bin/activate"
echo "    To deactivate: deactivate"
