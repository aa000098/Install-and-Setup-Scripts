
PROJECT_DIR="${HOME}/install_files"
mkdir -p "${PROJECT_DIR}"
cd "${PROJECT_DIR}"
VERSION="v2.3.0"
VERSION_NUM="${VERSION#v}"

ARCH_RAW="$(uname -m)"   # aarch64, x86_64 ...
echo "    Detected machine arch: ${ARCH_RAW}"

case "${ARCH_RAW}" in
  aarch64)
    ARCH="arm64"
    ;;
  x86_64)
    ARCH="x86_64"
    ;;
  *)
    echo "[WARN] Unknown arch '${ARCH_RAW}'."
    ;;
esac

if [ -d "rknn_model_zoo" ]; then
  echo "    Found existing rknn_model_zoo in ${PROJECT_DIR}/rknn_model_zoo"
  echo "    Skipping clone."
else
  echo "    Cloning RKNN Model Zoo (branch ${VERSION}) into ${PROJECT_DIR}/rknn_model_zoo ..."
  git clone -b ${VERSION} https://github.com/airockchip/rknn_model_zoo.git || {
    echo "[WARN] Failed to clone rknn_model_zoo. You can clone it manually later:"
    echo "       git clone -b ${VERSION} https://github.com/airockchip/rknn_model_zoo.git"
  }
fi

if [ -d "rknn-toolkit2" ]; then
  echo "    Found existing rknn_model_zoo in ${PROJECT_DIR}/rknn-toolkit2"
  echo "    Skipping clone."
else
  echo "    Cloning RKNN Toolkit2 (branch ${VERSION}) into ${PROJECT_DIR}/rknn_toolkit2 ..."
  git clone -b ${VERSION} https://github.com/airockchip/rknn-toolkit2.git || {
    echo "[WARN] Failed to clone rknn_toolkit2. You can clone it manually later:"
    echo "       git clone -b ${VERSION} https://github.com/airockchip/rknn_toolkit2.git"
  }
fi

echo
echo ">>> Installing rknn-toolkit-lite2 / rknn-toolkit2 + requirements..."

# wheel 파일 이름이 정확히 아래처럼 있다고 가정
#  (cp3X 부분은 실제 환경에 맞게 cp310, cp311 등으로 되어 있을 것)

# python3 ABI 태그(cp310, cp311, ...) 자동 감지
if command -v python3 >/dev/null 2>&1; then
  PYTAG=$(python3 - << 'EOF'
import sys
print(f"cp{sys.version_info.major}{sys.version_info.minor}")
EOF
)
  echo "    Detected python3 ABI tag: ${PYTAG}"
else
  echo "[WARN] python3 not found; defaulting ABI tag to cp310"
  PYTAG="cp310"
fi

TOOLKIT_LITE_PACKAGE_DIR="${PROJECT_DIR}/rknn-toolkit2/rknn-toolkit-lite2/packages"
TOOLKIT_PACKAGE_DIR="${PROJECT_DIR}/rknn-toolkit2/rknn-toolkit2/packages/${ARCH}"

RKNN_LITE_WHEEL_FILE=$(ls ${TOOLKIT_LITE_PACKAGE_DIR}/rknn_toolkit_lite2-${VERSION_NUM}-${PYTAG}-${PYTAG}-manylinux_2_17_aarch64.manylinux2014_aarch64.whl 2>/dev/null | head -n 1 || true)
RKNN_WHEEL_FILE=$(ls ${TOOLKIT_PACKAGE_DIR}/rknn_toolkit2-${VERSION_NUM}-${PYTAG}-${PYTAG}-manylinux_2_17_aarch64.manylinux2014_aarch64.whl 2>/dev/null | head -n 1 || true)
REQ_FILE="${TOOLKIT_PACKAGE_DIR}/${ARCH}_requirements_${PYTAG}.txt"

# 1) rknn_toolkit_lite2 wheel 설치
if [ -n "${RKNN_LITE_WHEEL_FILE}" ]; then
  echo "    Found lite2 wheel: ${RKNN_LITE_WHEEL_FILE}"
  if command -v pip3 >/dev/null 2>&1; then
    pip3 install "${RKNN_LITE_WHEEL_FILE}" || {
      echo "[WARN] pip3 install ${RKNN_LITE_WHEEL_FILE} failed."
    }
  else
    echo "[WARN] pip3 not found. Cannot install RKNN Toolkit Lite2 wheel."
  fi
else
  echo "    No rknn_toolkit_lite2 wheel found in:"
  echo "        ${TOOLKIT_LITE_PACKAGE_DIR}"
  echo "    Put your rknn_toolkit_lite2-${VERSION_NUM}-${PYTAG}-${PYTAG}-manylinux_2_17_aarch64.manylinux2014_aarch64.whl here and re-run if needed."
fi

# 2) rknn_toolkit2 wheel 설치
if [ -n "${RKNN_WHEEL_FILE}" ]; then
  echo "    Found toolkit2 wheel: ${RKNN_WHEEL_FILE}"
  if command -v pip3 >/dev/null 2>&1; then
    pip3 install "${RKNN_WHEEL_FILE}" || {
      echo "[WARN] pip3 install ${RKNN_WHEEL_FILE} failed."
    }
  else
    echo "[WARN] pip3 not found. Cannot install RKNN Toolkit2 wheel."
  fi
else
  echo "    No rknn_toolkit2 wheel found in:"
  echo "        ${TOOLKIT_PACKAGE_DIR}"
  echo "    Expecting something like:"
  echo "        rknn_toolkit2-${VERSION_NUM}-${PYTAG}-${PYTAG}-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
fi

# 3) requirements 설치
if [ -f "${REQ_FILE}" ]; then
  echo "    Installing toolkit2 dependencies from: ${REQ_FILE}"
  python3 -m pip install -r "${REQ_FILE}" || {
    echo "[ERROR] Failed to install toolkit2 dependencies from ${REQ_FILE}"
  }
else
  echo "    [WARN] Requirements file not found:"
  echo "           ${REQ_FILE}"
fi

echo
echo ">>> Verifying rknn-lite2 / rknn-toolkit2 Python import..."
TEST_PY="${PROJECT_DIR}/rknn_model_zoo/test_rknn_imports.py"
cat > "${TEST_PY}" << 'EOF'
ok = True
try:
    from rknnlite.api import RKNNLite as RKNNLite
    print("[OK] rknn-lite2 import succeeded.")
except Exception as e:
    print("[ERROR] Failed to import rknnlite.api.RKNNLite:", e)
    ok = False

try:
    from rknn.api import RKNN
    print("[OK] rnnk-toolkit2 import succeeded.")
except Exception as e:
    print("[ERROR] Failed to import rknn.api.RKNN:", e)
    ok = False

if not ok:
    raise SystemExit(1)
EOF

if command -v python3 >/dev/null 2>&1; then
  python3 "${TEST_PY}" || {
    echo "[WARN] Python import test failed. Please check your Python environment."
  }
else
  echo "[WARN] python3 not found. Skipping Python import test."
fi

echo
echo ">>> RKLLM (rknn-llm) runtime repo for LLM on NPU..."

RKLLM_BRANCH="release-v1.2.1b1"
RKLLM_DIR="${PROJECT_DIR}/rknn-llm"

if [ -d "${RKLLM_DIR}" ]; then
  echo "    Found existing rknn-llm repo at: ${RKLLM_DIR}"
  # 원하면 최신 상태만 살짝 확인
  (cd "${RKLLM_DIR}" && git rev-parse --abbrev-ref HEAD && git log -1 --oneline || true)
else
  echo "    Cloning rknn-llm (branch ${RKLLM_BRANCH}) into ${RKLLM_DIR} ..."
  git clone -b "${RKLLM_BRANCH}" https://github.com/airockchip/rknn-llm.git "${RKLLM_DIR}" || {
    echo "[WARN] Failed to clone rknn-llm."
    echo "       You can clone it manually later with:"
    echo "         git clone -b ${RKLLM_BRANCH} https://github.com/airockchip/rknn-llm.git \"${RKLLM_DIR}\""
  }
fi


echo
echo "======================================================"
echo " RKNN setup finished."
echo
echo " - python3-rknnlite2 installed (or attempted)."
echo " - rknpu2-rk3588 installed (or attempted)."
echo " - dmesg checked for 'Initialized rknpu'."
echo " - RKNN Model Zoo cloned to: ${PROJECT_DIR}/rknn_model_zoo (if clone succeeded)."
echo " - RKLLM runtime repo cloned to: ${PROJECT_DIR}/rknn-llm (if clone succeeded)."
echo
echo "Next steps:"
echo " - Use python3 on this board to run examples from the Model Zoo."
echo " - Use rknn-llm examples on this board to run .rkllm LLM models on NPU."
echo " - On your x86_64 PC, install RKNN-Toolkit2 to convert ONNX/TF models to .rknn."
echo "======================================================"

echo
echo "[주의]"
echo "RKNPU 디바이스는 기본적으로 root 또는 video 그룹에 속한 사용자만 접근할 수 있습니다."
echo "RKNN 예제는 sudo 권한을 가진 유저가 rknn_toolkit_lite2가 설치된 같은 Python(예: venv)을 써야 합니다."
echo
echo "1) [권장] 현재 사용자를 video 그룹에 추가해서 sudo 없이 실행:"
echo "   sudo usermod -aG video \$USER"
echo "   # 로그아웃 후 다시 로그인해야 반영됩니다."
echo "   python test.py"
echo
echo "2) video 그룹에 추가하지 않고 일시적으로 root 권한으로 실행:"
echo "   sudo \"\$(which python)\" test.py"
echo
echo "위 두 방법 중 하나를 사용해 활성화된 venv의 python 바이너리로 test.py를 실행하세요."
echo
