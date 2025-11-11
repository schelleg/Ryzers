#/!bin/bash


# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


source $SPSDEMO_VENV/bin/activate
export SPSDEMO_PACKAGE_PATH=$SPSDEMO_PATH/Ryzers/packages/workshops/sps2025/demo


cd $SPSDEMO_PATH && \
    xdg-open $SPSDEMO_PACKAGE_PATH/index.html && \
    ryzers run --name smolvlm /ryzers/demo_smolvlm.sh
