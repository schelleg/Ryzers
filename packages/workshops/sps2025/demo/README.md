# Files for SPS Demo 2025

## To Rebuild Demo

Attach 2 cameras to the Strix-Halo machine.  Both SmolVLM and CVML need dedicated access to a webcam.  If only one webcam is available, then only one of SmolVLM or CVML demo can run.  We recommend CVML as it leverages the NPU.

```bash
git clone https://github.com/schelleg/Ryzers -b spsdemo
cd Ryzers
pip install .

# Setup xdna driver
# For NPU to work secure boot needs to be disabled in BIOS
./packages/npu/xdna/install_xdna.sh

# Build the Ryzers for the 3 concurrent demos
ryzers build genesis --name genesis
ryzers build llamacpp smolvlm --name smolvlm
ryzers build xdna ryzenai_cvml ros --name cvml

# Run each of the following ryzers in its own terminal starting from the Ryzers/ folder
```

```bash
# SmolVLM (iGPU) run the camera1 demo ... 
# 1. firefox should do a popup asking for permission to access your camera - I found chrome more stable `apt install chromium`
# 2. if this is the first time running, the smolvlm model will need downloaded ~minutes based on network connection
#    second time it runs, it will use locally cached copy of the model
xdg-open packages/workshops/sps2025/demo/index_2ndcamera.html && \
ryzers run --name smolvlm /ryzers/demo_smolvlm.sh
```


```bash
# CVML (NPU) Demo with various camera0 filters
xdg-open http://127.0.0.1:8080 && ryzers run --name cvml /ryzers/demo_ros.sh
```

```bash
# Genesis (iGPU) run genesis in while True loop
ryzers run --name genesis "python3 /ryzers/demo_genesis.py"
```



# troubleshooting
1. SmolVLM needs camera permissions, so a refresh of page may be needed to get the firefox pop up asking for permission
2. if genesis stops simulating, try to stop all demos and run `pkill -f ryzers` to free up system memory.  Reboot is last resort to free up all memory
3. if you only have 1 webcam, replace smolvlm URL above with `packages/workshops/sps2025/demo/index.html` which will use the first camera