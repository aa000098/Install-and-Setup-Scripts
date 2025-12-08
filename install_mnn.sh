#!/usr/bin/env bash
#set -euo pipefail

# 기본 설정
INSTALL_ROOT="${HOME}/install_files"
MNN_SRC_DIR="${INSTALL_ROOT}/MNN"
BUILD_DIR="${MNN_SRC_DIR}/build"
PYMNN_DIR="${MNN_SRC_DIR}/pymnn"

echo ">>> INSTALL_ROOT : ${INSTALL_ROOT}"
echo ">>> MNN_SRC_DIR  : ${MNN_SRC_DIR}"

mkdir -p "${INSTALL_ROOT}"

# 1. MNN 소스 가져오기 (없으면 clone, 있으면 pull)
if [ ! -d "${MNN_SRC_DIR}" ]; then
    echo ">>> Cloning MNN repository..."
    git clone --recursive https://github.com/alibaba/MNN.git "${MNN_SRC_DIR}"
else
    echo ">>> MNN repo already exists, updating..."
    cd "${MNN_SRC_DIR}"
    git pull --recurse-submodules
fi

# 2. MNN 빌드 (OpenCL + Converter + Shared Libs)
echo ">>> Configuring and building MNN..."
cd "${MNN_SRC_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DMNN_BUILD_CONVERTER=ON \
  -DMNN_BUILD_SHARED_LIBS=ON \
  -DMNN_OPENCL=ON \
  -DMNN_BUILD_TRAIN=OFF

make -j"$(nproc)"

echo ">>> MNN build finished. Binaries in: ${BUILD_DIR}"

# (선택) 설치 위치로 복사하고 싶으면 아래 주석 해제
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DMNN_BUILD_CONVERTER=ON \
  -DMNN_BUILD_SHARED_LIBS=ON \
  -DMNN_OPENCL=ON \
  -DMNN_BUILD_TRAIN=OFF \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_ROOT}/mnn-install"
make -j"$(nproc)"
make install

# 3. Python 바인딩(PyMNN) 빌드 & 설치
echo ">>> Building PyMNN (Python binding)..."
cd "${PYMNN_DIR}"

if [ -n "${VIRTUAL_ENV-}" ]; then
    echo ">>> Detected virtualenv: ${VIRTUAL_ENV}"
else
    echo ">>> WARNING: VIRTUAL_ENV not set. You probably want to:"
    echo "    source /path/to/venv/bin/activate"
    echo "    then re-run this script so PyMNN is installed into that venv."
fi

# 기존 pip 패키지 제거 (있다면)
python -m pip uninstall -y mnn MNN || true
pip install wheel setuptools

# wheel 빌드 & 설치
cd pip_package
python build_deps.py opencl
python setup.py install --version 3.3.0 --deps opencl
#python setup.py bdist_wheel
python -m pip install dist/*.whl

echo ">>> Done!"
echo "    - MNN source   : ${MNN_SRC_DIR}"
echo "    - MNN build    : ${BUILD_DIR}"
echo "    - PyMNN (mnn) installed into current Python environment."
echo ">>> If you use GPU, set backend='OPENCL' in your MNN session config."

