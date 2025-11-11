#/!bin/bash

# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi

source $SPSDEMO_VENV/bin/activate
SPSDEMO_PACKAGE_PATH=$SPSDEMO_PATH/Ryzers/packages/workshops/sps2025/demo


cd $SPSDEMO_PATH && \
    xdg-open $SPSDEMO_PACKAGE_PATH/index.html && \
    ryzers run --name smolvlm /ryzers/demo_smolvlm.sh
