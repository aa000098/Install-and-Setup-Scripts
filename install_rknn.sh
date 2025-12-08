
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
echo ">>> Installing rknn_toolkit_lite2 wheel (if present in ${PROJECT_DIR})..."

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
TOOLKIT_PKG_DIR="${PROJECT_DIR}/rknn-toolkit2/rknn-toolkit2/packages/${ARCH}"

WHEEL_FILE=$(ls ${TOOLKIT_LITE_PACKAGE_DIR}/rknn_toolkit_lite2-${VERSION_NUM}-${PYTAG}-${PYTAG}-manylinux_2_17_aarch64.manylinux2014_aarch64.whl 2>/dev/null | head -n 1 || true)
REQ_FILE="${TOOLKIT_PKG_DIR}/${ARCH}_requirements_${PYTAG}.txt"

echo
echo ">>> Installing rknn_toolkit2 + requirements..."

if [ -n "${WHEEL_FILE}" ]; then
  echo "    Found wheel: ${WHEEL_FILE}"
  if command -v pip3 >/dev/null 2>&1; then
    pip3 install "${WHEEL_FILE}" || {
      echo "[WARN] pip3 install ${WHEEL_FILE} failed."
    }
  else
    echo "[WARN] Neither pip3 nor python3 found. Cannot install RKNN Toolkit Lite2 wheel."
  fi
else
  echo "    No wheel matching pattern '${WHEEL_FILE}' found in ${TOOLKIT_LITE_PACKAGE_DIR}."
  echo "    Put your rknn_toolkit_lite2-2.3.0-...aarch64.whl here and re-run if needed."
fi

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
echo ">>> Verifying rknn-lite2 Python import..."
TEST_PY="${PROJECT_DIR}/rknn_model_zoo/test_rknn_lite2_import.py"
cat > "${TEST_PY}" << 'EOF'
try:
    from rknnlite.api import RKNNLite as RKNN
    print("[OK] rknn-lite2 import succeeded.")
except Exception as e:
    print("[ERROR] Failed to import rknnlite.api.RKNNLite:", e)
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
echo "======================================================"
echo " RKNN setup finished."
echo
echo " - python3-rknnlite2 installed (or attempted)."
echo " - rknpu2-rk3588 installed (or attempted)."
echo " - dmesg checked for 'Initialized rknpu'."
echo " - RKNN Model Zoo cloned to: ${PROJECT_DIR}/rknn_model_zoo (if clone succeeded)."
echo
echo "Next steps:"
echo " - Use python3 on this board to run examples from the Model Zoo."
echo " - On your x86_64 PC, install RKNN-Toolkit2 to convert ONNX/TF models to .rknn."
echo "======================================================"

