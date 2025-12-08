#!/bin/bash

PWD="$(pwd -P)"
trap 'cd "$PWD"' EXIT

OPENCV_VERSION="4.x"

INSTALL_DIR="$HOME/install_files"
LOCAL_DIR="$HOME/local/"
OPENCV_DIR="${LOCAL_DIR}/opencv"
VENV_DIR="${LOCAL_DIR}/venv"

"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install "${PKGS[@]}"


#export CC="$HOME/local/gcc-9.5.0/bin/gcc"
#export CXX="$HOME/local/gcc-9.5.0/bin/g++"
export CC="/usr/bin/gcc"
export CXX="/usr/bin/g++"

# PY=$(command -v python3 || command -v python)
# PYVER=$($PY -c 'import sys;print(f"{sys.version_info.major}.{sys.version_info.minor}")')
# SITE=$($PY -c 'import site; print(site.getusersitepackages())')  # 예: ~/.local/lib/python3.x/site-packages
 
PY="$VENV_DIR/bin/python" 
SITE="$VENV_DIR/lib/$("$PY" -c 'import sys; print(f"python{sys.version_info.major}.{sys.version_info.minor}")')/site-packages"

echo "[+] install dir: ${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"
cd "${INSTALL_DIR}"

if [ ! -d "opencv" ]; then
	git clone https://github.com/opencv/opencv.git
fi

cd ./opencv
#rm -rf build
mkdir -p build && cd build

unset LD_LIBRARY_PATH
cmake -D CMAKE_C_COMPILER="$CC" \
	-D CMAKE_CXX_COMPILER="$CXX" \
	-D CMAKE_INSTALL_PREFIX=$HOME/local/opencv -D CMAKE_BUILD_TYPE=RELEASE \
	-D WITH_QT=ON \
	-D WITH_GTK=ON \
	-D WITH_FFMPEG=ON \
	-D BUILD_NEW_PYTHON_SUPPORT=ON \
	-D BUILD_opencv_python_bindings_generator=ON \
	-D PYTHON3_EXECUTABLE="$PY" \
    -D PYTHON3_PACKAGES_PATH="$SITE" \
	-D OPENCV_GENERATE_PKGCONFIG=ON \
	-D PYTHON_DEFAULT_EXECUTABLE=$(which python) \
	-D WITH_OPENEXR=OFF \
	..

make -j$(( $(nproc)  ))

make install

cd "${OLDPWD}"  
