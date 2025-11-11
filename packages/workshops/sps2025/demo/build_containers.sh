#!/bin/bash

# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi    

source $SPSDEMO_VENV/bin/activate

pushd $SPSDEMO_PATH
ryzers build genesis --name genesis
ryzers build llamacpp smolvlm --name smolvlm
ryzers build xdna ryzenai_cvml ros --name cvml
popd
