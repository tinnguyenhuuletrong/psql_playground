# FROM postgres:16-alpine

# # Install build dependencies
# RUN apk add --no-cache \
#     git \
#     build-base \
#     clang \
#     llvm \
#     llvm-dev \
#     clang-dev \
#     cargo \
#     rust \
#     rustup

# # Clone and build pg_graphql
# RUN git clone https://github.com/supabase/pg_graphql.git /tmp/pg_graphql \
#     && cd /tmp/pg_graphql \
#     && cargo build --release \
#     && cp target/release/libpg_graphql.so /usr/local/lib/postgresql/ \
#     && cp pg_graphql.control /usr/local/share/postgresql/extension/ \
#     && cp sql/pg_graphql--*.sql /usr/local/share/postgresql/extension/ \
#     && rm -rf /tmp/pg_graphql

# # Clean up build dependencies
# RUN apk del git build-base clang llvm llvm-dev clang-dev cargo rust rustup 


ARG PG_VERSION=16
FROM postgres:${PG_VERSION}
RUN apt-get update

ENV build_deps ca-certificates \
  git \
  build-essential \
  libpq-dev \
  postgresql-server-dev-${PG_MAJOR} \
  curl \
  libreadline6-dev \
  zlib1g-dev


RUN apt-get install -y --no-install-recommends $build_deps pkg-config cmake

WORKDIR /home/pg_graphql

ENV HOME=/home/pg_graphql \
  PATH=/home/pg_graphql/.cargo/bin:$PATH
RUN chown postgres:postgres /home/pg_graphql
USER postgres

RUN \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal --default-toolchain stable && \
  rustup --version && \
  rustc --version && \
  cargo --version

# PGRX
RUN cargo install cargo-pgrx --version 0.12.9 --locked

RUN cargo pgrx init --pg${PG_MAJOR} $(which pg_config)

USER root

RUN git clone https://github.com/supabase/pg_graphql.git /tmp/pg_graphql \
    && cd /tmp/pg_graphql \
    && cargo pgrx install

USER root