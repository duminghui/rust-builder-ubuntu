FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# COPY sources.list /etc/apt/sources.list

ENV TZ=Asia/Shanghai

RUN set -eux; \
    apt-get update ; \
    apt-get install -y tzdata ; \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ; \
    dpkg-reconfigure -f noninteractive tzdata

RUN set -eux; \
    apt-get install -y  \
    build-essential \
    git \
    curl \
    cmake \
    file \
    sudo \
    xutils-dev \
    unzip \
    ca-certificates \
    python3 \
    python3-pip \
    autoconf \
    autoconf-archive \
    automake \
    flex \
    bison \
    llvm-dev \
    libclang-dev \
    clang \
    pkg-config \
    libssl-dev


ENV PATH /root/.cargo/bin:$PATH
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

RUN set -eux; \
    curl https://mirrors.ustc.edu.cn/rust-static/rustup/rustup-init.sh > rustup-init.sh ; \
    chmod +x rustup-init.sh ; \
    ./rustup-init.sh -y ; \
    rm -rf rustup-init.sh ; \
    rustup --version ; \
    cargo --version ; \
    rustc --version ; \
    mkdir -p /home/rust/src ; \
    echo "End"


# COPY config.toml /root/.cargo/config.toml
# RUN set -eux; \
#     cargo install sccache ; \
#     rm -rf /root/.cargo/registry

COPY --chown=0755 sccache-0.3.3 /root/.cargo/bin/sccache
ENV SCCACHE_DIR=/root/.cache/sccache
ENV SCCACHE_CACHE_SIZE="3G"

COPY config-sccache.toml /root/.cargo/config.toml

WORKDIR /home/rust/src

