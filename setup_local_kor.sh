#!/usr/bin/env bash
set -euo pipefail

TARGET_LOCALE="ko_KR.UTF-8"
TARGET_GEN_LINE="ko_KR.UTF-8 UTF-8"

echo "[1/4] Installing locales package..."
sudo apt-get update -y
sudo apt-get install -y locales

echo "[2/4] Enabling ${TARGET_GEN_LINE} in /etc/locale.gen ..."
if ! grep -qE "^[[:space:]]*${TARGET_GEN_LINE}[[:space:]]*$" /etc/locale.gen; then
  if grep -qE "^[[:space:]]*#\s*${TARGET_GEN_LINE}[[:space:]]*$" /etc/locale.gen; then
    sudo sed -i "s/^[[:space:]]*#\s*${TARGET_GEN_LINE}[[:space:]]*$/${TARGET_GEN_LINE}/" /etc/locale.gen
  else
    echo "${TARGET_GEN_LINE}" | sudo tee -a /etc/locale.gen >/dev/null
  fi
fi

echo "[3/4] Generating locales..."
sudo locale-gen

echo "[4/4] Setting default locale to ${TARGET_LOCALE} ..."
sudo update-locale LANG="${TARGET_LOCALE}" LANGUAGE="ko_KR:ko"

echo
echo "Done."
echo "- Available locales now include:"
locale -a | grep -i "ko_kr" || true
echo
echo "TIP: open a new shell (or re-login) to fully apply."

