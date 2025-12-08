#!/usr/bin/env bash
# set -euo pipefail

echo "== Linux용 OpenCL + llama.cpp(OpenCL backend) 설치 스크립트 =="

# ===== 0. 설정값 =====
LLAMA_ROOT="${HOME}/install_files/llama.cpp"   # llama.cpp를 둘 경로 (원하면 바꿔도 됨)

# ===== 1. 패키지 설치 =====
echo "[1/4] OpenCL 및 빌드 도구 패키지 설치 (sudo 필요)"

# sudo apt-get update
# sudo apt-get install -y \
#     git cmake ninja-build build-essential \
#     ocl-icd-opencl-dev clinfo
echo "  - Packages needed: git cmake ninja-build build-essential ocl-icd-opencl-dev clinfo"


# ===== 2. OpenCL 디바이스 확인 =====
echo "[2/4] clinfo로 OpenCL 플랫폼/디바이스 확인"

if clinfo >/dev/null 2>&1; then
    echo "  - clinfo 실행 성공. 아래는 요약 정보입니다:"
    clinfo | head -n 20 || true
else
    echo "  [경고] clinfo 실행 실패. OpenCL 드라이버/ICD가 없을 수 있습니다."
    echo "  - 보드 공급사에서 OpenCL 드라이버를 제공하는지 확인해야 할 수 있습니다."
fi
