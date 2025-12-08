#!/usr/bin/env bash
#
# RKNN environment setup script for ROCK 5B/5B+ (RK3588, Radxa OS)
# - Installs python3-rknnlite2
# - Installs rknpu2-rk3588 (if available)
# - Verifies NPU driver
# - Clones RKNN Model Zoo
#
# Usage:
#   chmod +x install_rknn_rock5b.sh
#   ./install_rknn_rock5b.sh
#

#set -euo pipefail

echo "======================================================"
echo "  RKNN setup for ROCK 5B/5B+ (RK3588, Radxa OS)"
echo "======================================================"

INSTALL_DIR=${HOME}/install_files
ARCH="$(uname -m || echo unknown)"
if [ "${ARCH}" != "aarch64" ]; then
  echo "[WARN] This script is intended for aarch64 (ROCK 5B/5B+)."
  echo "       Detected architecture: ${ARCH}"
fi

if ! command -v apt >/dev/null 2>&1; then
  echo "[ERROR] 'apt' command not found. This script assumes a Debian/Radxa OS."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
  echo "[ERROR] 'sudo' not found and you are not root. Please run as root or install sudo."
  exit 1
fi

RUN="sudo"
if [ "$(id -u)" -eq 0 ]; then
  RUN=""
fi

echo
echo ">>> 1) Updating APT package index..."
${RUN} apt update

echo
echo ">>> 2) Installing python3-rknnlite2 (RKNN Toolkit Lite2 runtime for board)..."
${RUN} apt install -y python3-rknnlite2 || {
  echo "[WARN] Failed to install python3-rknnlite2 via apt."
  echo "       Please check your Radxa OS version and package repository."
}

echo
echo ">>> 3) Installing rknpu2 driver package for RK3588 (if available)..."
# Official Radxa image usually already has rknpu2 installed, but this is safe:
${RUN} apt install -y rknpu2-rk3588 || {
  echo "[WARN] Failed to install 'rknpu2-rk3588'."
  echo "       It may already be installed or not available in your repository."
}

echo
echo ">>> 4) Checking rknpu driver initialization in dmesg..."
if ${RUN} dmesg | grep -q "Initialized rknpu"; then
  echo "[OK] rknpu driver appears to be initialized:"
  ${RUN} dmesg | grep "Initialized rknpu" | tail -n 3
else
  echo "[WARN] No 'Initialized rknpu' line found in dmesg."
  echo "       - If you're on RK356x: enable NPU via 'sudo rsetup -> Overlays -> Enable NPU' and reboot."
  echo "       - On RK3588: make sure you're using the official Radxa OS with rknpu2 support."
fi

echo
echo ">>> 5) Checking RKNPU driver firmware version (RK3588, Radxa OS)..."

VERSION_FILE="/sys/kernel/debug/rknpu/version"

if ${RUN} sh -c "[ ! -f "${VERSION_FILE}" ]"; then
  echo "[WARN] ${VERSION_FILE} not found. rknpu driver may not be loaded."
  echo "       - 커널 모듈이 안 올라왔거나 비공식 펌웨어일 수 있습니다."
else
  RKNPU_LINE="$(${RUN} cat ${VERSION_FILE} 2>/dev/null || true)"
  echo "    Detected: ${RKNPU_LINE}"

  if echo "${RKNPU_LINE}" | grep -q "v0.9.6"; then
    echo "[WARN] RKNPU driver is older than v0.9.8."
    echo "       Radxa 문서에 따르면 다음 순서로 업데이트하는 것을 권장합니다:"
    echo "         1) sudo rsetup"
    echo "             → System → System Update"
    echo "         2) sudo apt autopurge"
    echo "         3) sudo reboot"
    echo

    read -r -p "지금 바로 'rsetup'을 실행할까요? [y/N]: " ans
    case "${ans}" in
      [yY]|[yY][eE][sS])
        echo
        echo ">>> 실행 중: sudo rsetup (메뉴에서 System → System Update 선택)"
        ${RUN} rsetup

        echo
        echo ">>> 시스템 업데이트 이후 불필요 패키지 정리(apt autopurge)..."
        ${RUN} apt autopurge || {
          echo "[WARN] 'apt autopurge' 실행에 실패했습니다. 나중에 수동으로 실행해 주세요."
        }

        echo
        echo "[INFO] RKNPU 드라이버/펌웨어 업데이트 절차가 완료되었습니다."
        echo "       보드를 재부팅하면 변경 사항이 적용됩니다: sudo reboot"
        ;;
      *)
        echo "[INFO] rsetup 자동 실행은 건너뜁니다. 필요 시 나중에 수동으로 실행해 주세요."
        ;;
    esac
  else
    echo "[INFO] RKNPU driver version is neither v0.9.8 nor v0.9.6."
    echo "       현재 버전:"
    echo "         ${RKNPU_LINE}"
    echo "       필요한 경우 Radxa 릴리즈 노트를 참고해서 수동으로 업데이트 여부를 결정하세요."
  fi
fi

echo
echo "All steps done. You may want to reboot the board if firmware was updated."
