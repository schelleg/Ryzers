#!/bin/bash

gnome-terminal --tab --title="SmolVLM" -- bash -c 'echo -ne "\033]0;SmolVLM\007"
; ./start_smolvlm.sh; exec bash'

sleep 5
gnome-terminal --tab --title="Genesis" -- bash -c 'echo -ne "\033]0;Genesis\007"
; ./start_genesis.sh; exec bash'

sleep 5
gnome-terminal --tab --title="CVML" -- bash -c 'echo -ne "\033]0;CVML\007"; 
./start_cvml.sh; exec bash'
