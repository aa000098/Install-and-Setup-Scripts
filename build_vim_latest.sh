#!/usr/bin/env bash
#set -e

########################################
# Build & Install Latest Vim from source
# - Tested on Ubuntu/Debian 계열
# - 설치 경로: /usr/local
########################################

# 원하는 설치 prefix (기본: ${HOME}/local)
PREFIX="${HOME}/local/vim"


#echo "=== [1/6] 기존 vim 패키지 정리 (optional) ==="
#echo "기본 apt vim을 제거할까요? (y/N)"
#read -r ANS
#if [[ "$ANS" == "y" || "$ANS" == "Y" ]]; then
#    sudo apt remove -y vim vim-runtime vim-tiny vim-common || true
#else
#    echo "기존 vim 패키지는 유지합니다."
#fi


#echo
#echo "=== [2/6] 빌드에 필요한 패키지 설치 ==="
#sudo apt update
#sudo apt install -y \
#    git build-essential ncurses-dev \
#    python3 python3-dev \
#    libacl1-dev gawk

echo
echo "=== [3/6] Vim 소스코드 받기 ==="
# 빌드용 디렉토리 설정 (원하면 바꿔도 됨)
SRC_DIR="$HOME/install_files/vim"
mkdir -p "$(dirname "$SRC_DIR")"

if [[ -d "$SRC_DIR/.git" ]]; then
    echo "기존 vim repo 발견: $SRC_DIR"
    echo "git pull로 업데이트합니다."
    cd "$SRC_DIR"
    git pull
else
    echo "새로 clone 합니다: $SRC_DIR"
    git clone https://github.com/vim/vim.git "$SRC_DIR"
    cd "$SRC_DIR"
fi

echo
echo "=== [4/6] configure 설정 ==="
# 필요하면 옵션 더 추가 가능 (Lua, Ruby 등)
./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-terminal \
    --enable-cscope \
    --enable-python3interp=yes \
    --with-python3-command=python3 \
    --prefix="$PREFIX"

echo
echo "=== [5/6] 컴파일 & 설치 ==="
make -j"$(nproc)"
make install

echo
echo "=== [6/6] PATH 설정 안내 ==="
VIM_BIN_DIR="$PREFIX/bin"
# 기본적으로 $HOME/local/bin 을 PATH에 추가해야 함
if ! echo "$PATH" | grep -q "$VIM_BIN_DIR" ; then
    echo
    echo "⚠️ 현재 PATH에 $VIM_BIN_DIR 이 없습니다."
    echo "다음 내용을 ~/.bashrc (또는 사용하는 쉘 설정 파일)에 추가하세요:"
    echo
    echo "    export PATH=\"$VIM_BIN_DIR:\$PATH\""
    echo
fi

echo
echo "=== 설치 완료! 버전 확인 ==="
$VIM_BIN_DIR/vim --version | head -n 5

echo
echo "👉 위에 나온 버전이 9.x 이상이면 Copilot.vim 써도 됩니다."

