#/!bin/bash

# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


source $SPSDEMO_VENV/bin/activate

cd $SCRIPT_DIR/Ryzers && \
    xdg-open http://127.0.0.1:8080 && \
    ryzers run --name cvml /ryzers/demo_ros.sh
