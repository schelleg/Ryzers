#!/bin/bash


# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi

set_video_format() {
    local DEVICE="$1"

    if [ -z "$DEVICE" ]; then
        echo "Usage: set_video_format /dev/videoX"
        return 1
    fi

    if [ -e "$DEVICE" ]; then
        echo "$DEVICE found. Setting video format to 640x480..."
        v4l2-ctl -d "$DEVICE" --set-fmt-video=width=640,height=480
    else
        echo "$DEVICE not found."
        return 1
    fi
}

source $SPSDEMO_VENV/bin/activate
pip install --upgrade $SPSDEMO_PATH/Ryzers/

# Setup xdna driver (only needed one time)
# For NPU to work secure boot needs to be disabled in BIOS
pushd $SPSDEMO_PATH
./Ryzers/packages/npu/xdna/install_xdna.sh
popd

set_video_format /dev/video0
set_video_format /dev/video2
