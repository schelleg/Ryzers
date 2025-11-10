#!/bin/bash


# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi

source $SPSDEMO_VENV/bin/activate

pip install --upgrade $SPSDEMO_PATH/Ryzers/

# Setup xdna driver (only needed one time)
# For NPU to work secure boot needs to be disabled in BIOS
pushd $SPSDEMO_PATH
./Ryzers/packages/npu/xdna/install_xdna.sh

popd
