#!/usr/bin/env bash

VENV_DIR="$HOME/local/venv"

# 1. venv 없으면 만들기
if [[ ! -d "$VENV_DIR" ]]; then
  echo "[i] venv not found. creating at $VENV_DIR ..."
  python3 -m venv "$VENV_DIR"
  echo "[+] venv created."
fi

# 2. 필요한 패키지 설치
PKGS=(
  'numpy<2.0'
  pandas
  matplotlib
  torch

  tensorflow
  easydict
 # opencv-python
)

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  # sourced
  echo "[+] activating venv ..."
  # shellcheck disable=SC1090
  source "$VENV_DIR/bin/activate"
  echo "[✓] venv activated."
else
  echo
  echo "[i] To activate, run:"
  echo "    source $VENV_DIR/bin/activate"
fi


"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install "${PKGS[@]}"
