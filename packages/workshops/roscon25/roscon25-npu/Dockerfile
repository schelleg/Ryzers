# Copyright (C) 2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-lc"]

ARG DRIVER_VERSION="0ad5aa3"

WORKDIR /ryzers

RUN apt-get update && apt-get install -y \
	git \
	curl \
	bash \
	wget

RUN git clone https://github.com/amd/xdna-driver && \
    cd xdna-driver && \
    git checkout $DRIVER_VERSION && \
    git submodule update --init --recursive

# Install build dependencies
RUN cd /ryzers/xdna-driver/tools && \
    apt-get update && \
    ./amdxdna_deps.sh -docker

# Build XRT
RUN cd /ryzers/xdna-driver/xrt/build/ && \
    ./build.sh -npu -opt -noctest

# Build XDNA driver
RUN cd /ryzers/xdna-driver/build && \
    ./build.sh -release && \
    ./build.sh -package

# Finally, save and install the XRT/XDNA debian packages
# these will also need to be installed on the host system
# if they haven't been already
RUN mkdir /ryzers/debs && \
    cp /ryzers/xdna-driver/build/Release/xrt_plugin.2.20.0_24.04-amd64-amdxdna.deb /ryzers/debs/ && \
    cp /ryzers/xdna-driver/xrt/build/Release/xrt_202520.2.20.0_24.04-amd64-base.deb /ryzers/debs/ && \
	dpkg -i /ryzers/debs/*.deb

ENV SHELL=/bin/bash


WORKDIR /ryzers
COPY setup.sh /ryzers/setup.sh
COPY entrypoint.sh /ryzers/entrypoint.sh

# Set environment variable to suppress prompts in scripts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV HSA_OVERRIDE_GFX_VERSION=11.0.0
SHELL ["/bin/bash", "-l", "-c"]

# IRON requires python venv
RUN apt-get -y install python3.12-venv

# Make life easier
RUN apt-get -y install vim

RUN git clone --recursive https://github.com/xilinx/mlir-aie.git /ryzers/mlir-aie && \
    cd /ryzers/mlir-aie && \
    git checkout c105c0b && \
    git submodule update --recursive

# Comment out NPU check - we don't have access to /dev/accel during docker build
RUN sed -i '31s/^/#/' /ryzers/mlir-aie/utils/quick_setup.sh

# Lock down wheels
RUN sed -i '61s|.*|pip install mlir_aie -f https://github.com/Xilinx/mlir-aie/releases/download/latest-wheels/mlir_aie-0.0.1.2025051904+c105c0b-cp312-cp312-manylinux_2_35_x86_64.whl|' /ryzers/mlir-aie/utils/quick_setup.sh
RUN sed -i '64s|.*|pip install llvm_aie -f https://github.com/Xilinx/llvm-aie/releases/download/nightly/llvm_aie-19.0.0.2025041501+b2a279c1-py3-none-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl|' /ryzers/mlir-aie/utils/quick_setup.sh

# Setup IRON
RUN cd /ryzers/mlir-aie && \
    source /opt/xilinx/xrt/setup.sh && \
    source /ryzers/mlir-aie/utils/quick_setup.sh

# Copy the new AIE pragma utils.h to mlir_aie/include/ so it's picked up when doing #include "aie_kernel_utils.h"
RUN cp /ryzers/mlir-aie/aie_kernels/aie_kernel_utils.h /ryzers/mlir-aie/ironenv/lib/python3.12/site-packages/mlir_aie/include/

# Install jupyter for notebooks
RUN source /ryzers/setup.sh && \
    pip install jupyterlab

# Cleanup
ENV SHELL=/bin/bash

WORKDIR /ryzers

# Install NPUEval
RUN git clone https://github.com/amdresearch/npueval
RUN source /ryzers/setup.sh && \
    cd /ryzers/npueval && \
    python3 -m pip install -e .

# Cleanup
ENV SHELL=/bin/bash

# Allow build-time argument for ROS distro (jazzy or kilted)
ARG ROS_DISTRO=kilted
ENV ROS_DISTRO=${ROS_DISTRO}

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV HSA_OVERRIDE_GFX_VERSION=11.0.0

# 1. Set locale
RUN apt-get update && apt-get install -y locales \
 && locale-gen en_US en_US.UTF-8 \
 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
 && rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 2. Enable universe repo
RUN apt-get update && apt-get install -y software-properties-common curl gnupg2 \
 && add-apt-repository universe \
 && rm -rf /var/lib/apt/lists/*

# 3. Add ROS 2 apt repository
RUN apt update && sudo apt install curl -y && \
   export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && \
   curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" && \
dpkg -i /tmp/ros2-apt-source.deb


# 4. Install ROS 2 (desktop variant)
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y ros-${ROS_DISTRO}-desktop \
 && rm -rf /var/lib/apt/lists/*

# 5. Install dev tools
RUN apt-get update \
 && apt-get install -y \
    ros-dev-tools \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-web-video-server \
    ros-${ROS_DISTRO}-v4l2-camera \
 && rm -rf /var/lib/apt/lists/*


# 6. Install Python packages
RUN source /ryzers/setup.sh && pip install catkin_pkg opencv-python
RUN source /ryzers/setup.sh && pip install "numpy<2"

# 7. Source ROS environment
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc

WORKDIR /ryzers

# Suppress prompts in scripts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV HSA_OVERRIDE_GFX_VERSION=11.0.0

RUN apt-get update && apt-get install -y \
	libboost-filesystem1.74.0 \
	vulkan-tools \
	mesa-vulkan-drivers \
	git-lfs

RUN apt install -y vulkan-tools mesa-vulkan-drivers
RUN add-apt-repository ppa:deadsnakes/ppa && \
	apt update && \
	apt install -y python3.10 python3.10-venv python3.10-dev libboost-filesystem1.74.0

RUN git clone https://github.com/amd/RyzenAI-SW
RUN cd RyzenAI-SW && \
    git lfs install && \
    git lfs pull

COPY fix_symlinks.sh /ryzers/
RUN cp /ryzers/fix_symlinks.sh RyzenAI-SW/Ryzen-AI-CVML-Library/linux/onnx/ryzen14/
RUN cd RyzenAI-SW/Ryzen-AI-CVML-Library/linux/onnx/ryzen14/ && ./fix_symlinks.sh

RUN cp /ryzers/fix_symlinks.sh RyzenAI-SW/Ryzen-AI-CVML-Library/linux/onnx/cpu/
RUN cd RyzenAI-SW/Ryzen-AI-CVML-Library/linux/onnx/cpu/ && ./fix_symlinks.sh

RUN cd RyzenAI-SW/Ryzen-AI-CVML-Library/samples && \
	curl -o video_call.mp4 https://videos.pexels.com/video-files/8136072/8136072-hd_1920_1080_25fps.mp4 && \
	mkdir build-samples && \
	cmake -S $PWD -B $PWD/build-samples && \
	cmake --build $PWD/build-samples --config Release

ENV LD_LIBRARY_PATH=/ryzers/RyzenAI-SW/Ryzen-AI-CVML-Library/linux/onnx/cpu:/ryzers/RyzenAI-SW/Ryzen-AI-CVML-Library/linux:$LD_LIBRARY_PATH

# Cleanup
RUN rm -rf /ryzers/xdna-driver
RUN source /ryzers/setup.sh && \
    pip install jupyterlab matplotlib timm

RUN apt-get install tree

COPY notebooks /ryzers/notebooks
WORKDIR /ryzers/notebooks

RUN chmod -R 777 /ryzers/notebooks

# Make ROS environment variables available to all users and shells
#ENV ROS_DISTRO=kilted
ENV AMENT_PREFIX_PATH=/opt/ros/$ROS_DISTRO:$AMENT_PREFIX_PATH
ENV LD_LIBRARY_PATH=/opt/ros/$ROS_DISTRO/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH=/opt/ros/$ROS_DISTRO/lib/python3.12/site-packages:$PYTHONPATH
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc

    
# === JupyterHub Integration ===
RUN source /ryzers/setup.sh && pip install --no-cache-dir --break-system-packages \
    jupyterhub==4.0.2 \
    jupyterlab==4.0.9 \
    notebook==7.0.6 \
    ipywidgets==8.1.1 \
    ipykernel==6.27.1

EXPOSE 8888

ENTRYPOINT ["/ryzers/entrypoint.sh"]
CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--notebook-dir=/ryzers/notebooks", "--allow-root"]
