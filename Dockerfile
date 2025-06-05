# Base image
FROM debian:bullseye-slim

# Install dependencies
RUN apt update && apt install -y \
    git build-essential cmake libuv1-dev libssl-dev libhwloc-dev && \
    rm -rf /var/lib/apt/lists/*

# Clone xmrig-proxy
RUN git clone https://github.com/xmrig/xmrig-proxy.git /xmrig-proxy
WORKDIR /xmrig-proxy
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

# Copy in proxy config
COPY config_proxy.json /xmrig-proxy/build/config.json

# Run the proxy
CMD ["/xmrig-proxy/build/xmrig-proxy", "-c", "/xmrig-proxy/build/config.json"]
