#/!bin/bash

# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd $SCRIPT_DIR && \
    ryzers run --name genesis "python3 /ryzers/demo_genesis.py"
