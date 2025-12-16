#!/usr/bin/env bash
#
# setup_opencl_rk3588.sh
#
# ROCK 5B/5B+ (RK3588)에서 기본 Panthor → Mali(OpenCL 가능)로 전환하는 스크립트.
# Radxa 공식 문서 "Switch GPU driver" 절차를 기반으로 함:
#   https://docs.radxa.com/en/rock5/rock5c/radxa-os/mali-gpu
#
# 사용 방법:
#   chmod +x setup_opencl_rk3588.sh
#   sudo ./setup_opencl_rk3588.sh
#
# 스크립트가 해주는 것:
#   1) 기본 정보 출력
#   2) /etc/apt/preferences.d/mali 작성 (Rockchip xserver 핀)
#   3) libmali-valhall-g610-g24p0-x11-wayland-gbm 설치 (RK3588용)
#   4) /etc/modprobe.d/panfrost.conf 수정 → panfrost 블랙리스트, mali는 enable
#   5) LIBGL_KOPPER_DISABLE=true 를 /etc/environment에 추가(Zink off)
#   6) sudo 실행한 일반 유저를 video/render 그룹에 추가 (GPU 접근용)
#   7) 마지막에 rsetup 로 해야 할 수동 작업 안내 + reboot 안내

#set -euo pipefail

echo "=== ROCK 5B/5B+ RK3588 Mali(OpenCL) 전환 스크립트 시작 ==="

#-------------------------------------------------------
# 0. root 체크
#-------------------------------------------------------
if [[ "${EUID}" -ne 0 ]]; then
    echo "[!] root 권한이 필요합니다. sudo 로 다시 실행해 주세요."
    exit 1
fi

#-------------------------------------------------------
# 1. 기본 정보 출력
#-------------------------------------------------------
ARCH="$(uname -m)"
OS_ID="unknown"
OS_NAME="unknown"
OS_VERSION="unknown"
OS_CODENAME="unknown"

if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    OS_ID="${ID:-unknown}"
    OS_NAME="${NAME:-unknown}"
    OS_VERSION="${VERSION_ID:-unknown}"
    OS_CODENAME="${VERSION_CODENAME:-unknown}"
fi

echo "[i] Architecture : ${ARCH}"
echo "[i] OS          : ${OS_NAME} ${OS_VERSION} (${OS_ID}, ${OS_CODENAME})"

if [[ "${ARCH}" != "aarch64" && "${ARCH}" != "arm64" ]]; then
    echo "[!] RK3588/Mali 용이 아닌 아키텍처입니다: ${ARCH}"
    echo "    계속 진행은 가능하지만, libmali 패키지가 맞지 않을 수 있습니다."
fi

# Radxa OS + Debian 12(bookworm) 기준
if [[ "${OS_ID}" != "debian" || "${OS_CODENAME}" != "bookworm" ]]; then
    echo "[!] 이 스크립트는 Radxa OS (Debian 12 bookworm) 기준으로 작성되었습니다."
    echo "    지금 OS: ${OS_ID} ${OS_CODENAME}"
    echo "    계속 진행은 가능하지만, radxa 전용 libmali 패키지가 없을 수도 있습니다."
fi

# rsetup 존재 여부 확인 (Radxa OS용 툴)
if ! command -v rsetup >/dev/null 2>&1; then
    echo "[!] 경고: 'rsetup' 명령을 찾을 수 없습니다."
    echo "    Radxa OS가 아니거나 rsetup 패키지가 설치되지 않았을 수 있습니다."
    echo "    이 경우 Radxa 전용 libmali 패키지 설치가 실패할 수 있습니다."
fi

#-------------------------------------------------------
# 2. Rockchip xorg-xserver용 APT Pinning 설정 (/etc/apt/preferences.d/mali)
#   Radxa 문서 'Using Rockchip's proprietary xorg-xserver version' 부분
#-------------------------------------------------------
echo "=== /etc/apt/preferences.d/mali 설정 ==="

MALI_PREF="/etc/apt/preferences.d/mali"

cat > "${MALI_PREF}" <<'EOF'
Package: *xserver*
Pin: release a=rk3566-bookworm
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3566-bookworm-test
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3566t-bookworm
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3566t-bookworm-test
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3568-bookworm
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3568-bookworm-test
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3576-bookworm
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3576-bookworm-test
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3588-bookworm
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3588-bookworm-test
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3588s2-bookworm
Pin-Priority: 1001

Package: *xserver*
Pin: release a=rk3588s2-bookworm-test
Pin-Priority: 1001
EOF

echo "[i] APT Pinning 파일 생성/갱신 완료: ${MALI_PREF}"

echo "=== APT 업데이트 ==="
apt-get update -y

#-------------------------------------------------------
# 3. RK3588용 Mali user-level driver 설치
#    Radxa 문서 'Installing the Mali User-Level Driver'
#       if grep -qE 'rk3588' <(rsetup get_product_ids)
#           sudo apt-get install libmali-valhall-g610-g24p0-x11-wayland-gbm
#-------------------------------------------------------
echo "=== RK3588 Mali user-level driver 설치 시도 ==="

IS_RK3588="unknown"

if command -v rsetup >/dev/null 2>&1; then
    if rsetup get_product_ids 2>/dev/null | grep -qE 'rk3588'; then
        IS_RK3588="yes"
    else
        IS_RK3588="no"
    fi
else
    echo "[!] rsetup 이 없어 보드 ID 확인은 건너뜁니다."
    echo "    Rock 5B+/RK3588이라는 전제 하에 libmali 설치를 시도합니다."
    IS_RK3588="yes"
fi

if [[ "${IS_RK3588}" == "yes" ]]; then
    echo "[i] RK3588 계열로 판단, libmali-valhall-g610-g24p0-x11-wayland-gbm 설치를 시도합니다."
    if ! apt-get install -y libmali-valhall-g610-g24p0-x11-wayland-gbm; then
        echo "[!] libmali-valhall-g610-g24p0-x11-wayland-gbm 설치 실패."
        echo "    - Radxa OS가 아닌 일반 Debian일 수도 있습니다."
        echo "    - Radxa 전용 APT repo가 설정되어 있는지 확인해 주세요."
        echo "    여기서 스크립트를 중단합니다."
        exit 1
    fi
else
    echo "[!] rsetup get_product_ids 출력에 'rk3588' 이 없습니다."
    echo "    이 보드는 RK3588이 아닌 것 같습니다. 스크립트를 중단합니다."
    exit 1
fi

echo "[i] libmali 설치 완료. 설치된 libmali 패키지:"
apt list libmali-* --installed 2>/dev/null || true

#-------------------------------------------------------
# 4. /etc/modprobe.d/panfrost.conf 수정
#    Radxa 문서 'Modify Module Blacklist'에 맞게 panfrost 블랙리스트,
#    mali/bifrost_kbase/midgard_kbase는 활성화
#-------------------------------------------------------
echo "=== /etc/modprobe.d/panfrost.conf 설정 ==="

PANFROST_CONF="/etc/modprobe.d/panfrost.conf"

cat > "${PANFROST_CONF}" <<'EOF'
# settings for panfrost / panthor vs mali

# to use mali driver for GPU instead
# You will have to install desktop from vendor repo
blacklist       panfrost
# blacklist       panthor

# Disable mali driver by default to prefer panfrost driver
# (주석 처리하여 mali/bifrost_kbase/midgard_kbase 활성화)
#blacklist   mali
#blacklist   bifrost_kbase
#blacklist   midgard_kbase
EOF

echo "[i] panfrost/panthor 블랙리스트 설정 완료: ${PANFROST_CONF}"

#-------------------------------------------------------
# 5. Zink 비활성화 (LIBGL_KOPPER_DISABLE=true)
#    Radxa 문서 'Turn off Zink support'
#-------------------------------------------------------
echo "=== Zink 비활성화 설정 (/etc/environment) ==="

ENV_FILE="/etc/environment"
if grep -q 'LIBGL_KOPPER_DISABLE' "${ENV_FILE}" 2>/dev/null; then
    echo "[i] /etc/environment 에 LIBGL_KOPPER_DISABLE 항목이 이미 있습니다. 건너뜁니다."
else
    echo 'LIBGL_KOPPER_DISABLE=true' >> "${ENV_FILE}"
    echo "[i] /etc/environment 에 LIBGL_KOPPER_DISABLE=true 추가 완료."
fi

#-------------------------------------------------------
# 6. GPU 디바이스 접근을 위해 일반 사용자 video/render 그룹 추가
#   - sudo 로 실행한 경우 SUDO_USER 를 기준으로 함
#   - /dev/dri/renderD* / /dev/mali* 가 대개 root:video, root:render 이므로
#     해당 그룹에 유저를 추가해 두면 sudo 없이도 OpenCL 사용 가능
#-------------------------------------------------------
echo "=== 일반 유저를 video/render 그룹에 추가 (GPU 디바이스 권한) ==="

TARGET_USER="${SUDO_USER:-}"

if [[ -z "${TARGET_USER}" || "${TARGET_USER}" == "root" ]]; then
    echo "[!] SUDO_USER 정보를 찾을 수 없어 비 root 계정을 자동으로 추가할 수 없습니다."
    echo "    필요하다면 다음 명령으로 수동으로 추가해 주세요 (예: hyunho.son):"
    echo "      sudo usermod -aG video,render <username>"
else
    echo "[i] sudo 를 실행한 사용자: ${TARGET_USER}"

    # video 그룹이 있으면 추가
    if getent group video >/dev/null 2>&1; then
        if id -nG "${TARGET_USER}" | grep -qw "video"; then
            echo "[i] ${TARGET_USER} 는 이미 video 그룹에 속해 있습니다."
        else
            usermod -aG video "${TARGET_USER}"
            echo "[i] ${TARGET_USER} 를 video 그룹에 추가했습니다."
        fi
    else
        echo "[!] 'video' 그룹이 존재하지 않습니다. /dev 권한 구조를 확인해 주세요."
    fi

    # render 그룹이 있으면 같이 추가
    if getent group render >/dev/null 2>&1; then
        if id -nG "${TARGET_USER}" | grep -qw "render"; then
            echo "[i] ${TARGET_USER} 는 이미 render 그룹에 속해 있습니다."
        else
            usermod -aG render "${TARGET_USER}"
            echo "[i] ${TARGET_USER} 를 render 그룹에 추가했습니다."
        fi
    else
        echo "[i] 'render' 그룹은 없는 것으로 보입니다. (문제 없을 수 있음)"
    fi

    echo "[i] 그룹 변경 사항은 ${TARGET_USER} 가 로그아웃 후 다시 로그인해야 적용됩니다."
fi

#-------------------------------------------------------
# 7. 요약 및 이후 수동 단계 안내
#-------------------------------------------------------
echo
echo "=== 작업 요약 ==="
echo "- /etc/apt/preferences.d/mali 생성/갱신 (Rockchip xserver 핀)"
echo "- (있다면) 이전 비공식 g13p0 libmali 패키지 제거 시도"
echo "- libmali-valhall-g610-g24p0-x11-wayland-gbm 설치 (RK3588용)"
echo "- /etc/modprobe.d/panfrost.conf 수정 (panfrost/panthor blacklist, mali enable)"
echo "- /etc/environment 에 LIBGL_KOPPER_DISABLE=true 추가"

echo
echo "=== 다음은 수동으로 해줘야 하는 단계입니다 ==="
echo "1) 'sudo rsetup' 실행"
echo "   - 메뉴: Overlays → Manage overlayes → 'Enable Arm Mali GPU driver' 체크 → 저장 후 종료"
echo "2) 필요하다면 rsetup → System Maintenance → System Update 로 시스템 업그레이드"
echo "3) 그 다음 재부팅:"
echo "      sudo reboot"
echo
echo "재부팅 후에 다음으로 GPU 드라이버를 확인할 수 있습니다:"
echo "  lsmod | grep -E 'bifrost_kbase|mali'"
echo "또는 OpenCL 플랫폼 확인:"
echo "  clinfo | grep -E 'Platform Name|Device Name|OpenCL'"
echo
echo "Mali(OpenCL) 모드로 전환이 완료되면, ARM Platform / Mali GPU 디바이스가 clinfo 에 나타날 것입니다."
echo
echo "=== 스크립트 완료: setup_opencl_rk3588.sh ==="

