#!/usr/bin/env bash

set -e


LOCAL="${HOME}/local"
INSTALL_FILES="${HOME}/install_files"
GCC_VER="9.5.0"
GCC_DIR="gcc-${GCC_VER}"
PREFIX="${LOCAL}/${GCC_DIR}"
GCC_TARBALL="${GCC_DIR}.tar.gz"
GCC_URL="https://ftp.gnu.org/gnu/gcc/${GCC_DIR}/${GCC_TARBALL}"


if [ -x "${PREFIX}/bin/gcc" ]; then
    if "${PREFIX}/bin/gcc" -v 2>&1 | grep -q " ${GCC_VER}"; then
        echo "gcc ${GCC_VER} already installed at ${PREFIX}"
        exit 0
    fi
fi


PWD="$(pwd)"          # 지금 위치 기억


mkdir -p "${INSTALL_FILES}"
cd "${INSTALL_FILES}"


if [ ! -f "${GCC_TARBALL}" ]; then
    echo "Downloading ${GCC_TARBALL} ..."
    curl -L -o "${GCC_TARBALL}" "${GCC_URL}"
fi


mkdir -p "${INSTALL_FILES}/${GCC_DIR}-build"
cd "${INSTALL_FILES}/${GCC_DIR}-build"


"../${GCC_DIR}/configure" \
  --prefix="${PREFIX}" \
  --enable-checking=release \
  --enable-languages=c,c++ \
  --disable-multilib

make -j"$(nproc)"
make install

cd "${PWD}"  

