FROM ubuntu
MAINTAINER NAME EMAIL
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    curl \
    make \
    git \
    tmux \
    musl-tools 

RUN mkdir -p ~/zdb
RUN mkdir -p ~/bcdb
RUN mkdir -p ~/crystaltwin

RUN git clone https://github.com/threefoldtech/0-db /tmp/0-db
RUN cd /tmp/0-db && make
RUN cp /tmp/0-db/bin/zdb ~/zdb/zdb

RUN git clone https://github.com/threefoldtech/bcdb /tmp/bcdb
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUn cd /tmp/bcdb && . $HOME/.cargo/env && make
RUN cp /tmp/bcdb/target/x86_64-unknown-linux-musl/release/bcdb ~/bcdb

ARG DEBIAN_FRONTEND=noninteractive
RUN curl -sSL https://dist.crystal-lang.org/apt/setup.sh | bash -s -- -y
RUN apt update && apt install -y \
    crystal \
    libssl-dev \
    libxml2-dev \
    libyaml-dev \
    libgmp-dev \
    libz-dev \
    libsodium-dev

RUN git clone https://github.com/crystaluniverse/crystaltwin /tmp/crystaltwin
RUN cd  /tmp/crystaltwin && shards install && shards build
RUN cp /tmp/crystaltwin/bin/crystaltwin ~/crystaltwin


COPY ./init.sh /tmp/init.sh
RUN chmod u+x /tmp/init.sh
entrypoint /tmp/init.sh
