FROM debian:bullseye-slim

# Install dependencies
RUN apt update && apt install -y \
    git build-essential cmake libuv1-dev libssl-dev libhwloc-dev screen && \
    rm -rf /var/lib/apt/lists/*

# Clone xmrig and xmrig-proxy
RUN git clone https://github.com/xmrig/xmrig.git /xmrig
RUN git clone https://github.com/xmrig/xmrig-proxy.git /xmrig-proxy

# Build xmrig
WORKDIR /xmrig
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

# Build proxy
WORKDIR /xmrig-proxy
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

# Copy configs
COPY config.json /xmrig/build/config.json
COPY config_proxy.json /xmrig-proxy/build/config.json

# Start proxy + miner in background
CMD screen -dmS proxy /xmrig-proxy/build/xmrig-proxy -c /xmrig-proxy/build/config.json && \
    /xmrig/build/xmrig -c /xmrig/build/config.json
