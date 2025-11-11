#!/bin/bash

# Check if SPSDEMO_VENV or SPSDEMO_PATH is unset or empty
if [[ -z "$SPSDEMO_VENV" || -z "$SPSDEMO_PATH" ]]; then
    echo "Error: SPSDEMO_VENV and SPSDEMO_PATH must be set."
    exit 1
fi    

source $SPSDEMO_VENV/bin/activate

export SPSDEMO_PACKAGE_PATH=$SPSDEMO_PATH/Ryzers/packages/workshops/sps2025/demo

gnome-terminal --tab --title="SmolVLM" -- bash -c 'echo -ne "\033]0;SmolVLM\007"; $SPSDEMO_PACKAGE_PATH/start_smolvlm.sh; exec bash'

sleep 5
gnome-terminal --tab --title="Genesis" -- bash -c 'echo -ne "\033]0;Genesis\007"; $SPSDEMO_PACKAGE_PATH/start_genesis.sh; exec bash'

sleep 5
gnome-terminal --tab --title="CVML" -- bash -c 'echo -ne "\033]0;CVML\007"; $SPSDEMO_PACKAGE_PATH/start_cvml.sh; exec bash'
