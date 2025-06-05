FROM debian:bullseye-slim

# Install dependencies
RUN apt update && apt install -y \
    git build-essential cmake libuv1-dev libssl-dev libhwloc-dev && \
    rm -rf /var/lib/apt/lists/*

# Clone XMRig
RUN git clone https://github.com/xmrig/xmrig.git /xmrig
WORKDIR /xmrig
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

# Add your Zephyr config
COPY config_zephyr.json /xmrig/build/config.json

# Run miner on start
CMD ["/xmrig/build/xmrig", "-c", "/xmrig/build/config.json"]
