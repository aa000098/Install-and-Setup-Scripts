#!/usr/bin/env bash
#set -euo pipefail

# Arm Compute Library 설치/빌드 전용 스크립트
# 대상: RK3588 (ARM64, Ubuntu 계열 가정)

ACL_DIR="$HOME/install_files/ComputeLibrary"
JOBS=$(nproc)

echo ">>> [1/3] 빌드 의존성 설치"
#sudo apt update
#sudo apt install -y \
#  git scons cmake g++ \
#  ocl-icd-opencl-dev opencl-headers

echo
echo ">>> [2/3] Arm Compute Library 클론: $ACL_DIR"
if [ ! -d "$ACL_DIR" ]; then
  git clone --depth=1 https://github.com/ARM-software/ComputeLibrary.git "$ACL_DIR"
else
  echo "    이미 $ACL_DIR 가 존재합니다. (업데이트는 수동으로 git pull 하세요)"
fi

echo
echo ">>> [3/3] ACL 빌드 (arch=arm64-v8a, opencl=1, neon=1, build=native)"
cd "$ACL_DIR"

# 필요한 경우 기존 빌드 아티팩트 정리
# scons --clean

scons Werror=0 -j"$JOBS" \
  arch=arm64-v8a \
  opencl=1 neon=1 \
  build=native

echo
echo "✅ Arm Compute Library 빌드 완료"
echo "   - 라이브러리: $ACL_DIR/build"
echo "   - 헤더:       $ACL_DIR/include"
echo
echo "CMake 나 g++에서 사용할 때 예시:"
echo "  include_dirs:  $ACL_DIR/include"
echo "  link_dirs:     $ACL_DIR/build"
echo "  link libs:     arm_compute, arm_compute_core, OpenCL"

