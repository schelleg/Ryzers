# Copyright(C) 2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN curl -fsSL https://ollama.com/install.sh | sh
RUN python3 -m pip install ollama

# handle add the render group
RUN groupadd -f render
RUN usermod -aG render root

# Copy test script
WORKDIR /ryzers
COPY test.sh /ryzers/test_ollama.sh
COPY test_ollama.py /ryzers/test_ollama.py
RUN chmod +x /ryzers/test_ollama.sh

EXPOSE 11434

# Run ollama prompt/reply test
CMD /ryzers/test_ollama.sh