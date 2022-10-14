# ---------------------------------------------------------------------------------------
# Zephyr dev base image (almost complete)
# https://github.com/zephyrproject-rtos/docker-image/blob/master/Dockerfile.user
# ---------------------------------------------------------------------------------------
FROM ghcr.io/zephyrproject-rtos/zephyr-build:v0.24.3

USER root

# Enable running renode-test by downloading robot-framework.
RUN pip install -r /opt/renode/tests/requirements.txt --no-cache-dir


# ---------------------------------------------------------------------------------------
# nrfjprog for "west flash"
# from https://github.com/NordicPlayground/nrf-docker
# ---------------------------------------------------------------------------------------

# Add libxcb* packages for jlink
RUN wget https://apt.kitware.com/kitware-archive.sh && bash kitware-archive.sh

WORKDIR /nclt_tmp
RUN NCLT_URL="https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-17-0/nrf-command-line-tools-10.17.0_Linux-amd64.tar.gz" && \
    wget -qO - "${NCLT_URL}" | tar xz && \
    # Install included JLink
    apt -y install ./*.deb && \
    # Install nrf-command-line-tools
    cp -r ./nrf-command-line-tools /opt && \
    ln -s /opt/nrf-command-line-tools/bin/nrfjprog /usr/local/bin/nrfjprog
WORKDIR /
RUN rm -rf nclt_tmp

USER user
