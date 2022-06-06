# https://github.com/IL2HorusTeam/docker-wine
  
FROM debian:buster-slim as config

FROM config as dev

RUN apt update \
    && apt -y install build-essential git cmake

ARG BUILD_TYPE=Release
RUN apt -y install gdb
RUN mkdir -p /workspaces/rpclib_ \
    && git clone https://github.com/rpclib/rpclib /workspaces/rpclib_/ \
    && cmake -E make_directory /workspaces/rpclib_-build \
    && cmake -S /workspaces/rpclib_ -B /workspaces/rpclib_-build \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    && cmake --build /workspaces/rpclib_-build --target install  -- -j

FROM dev as src

COPY . /workspaces/test

FROM src as build

RUN cmake -E make_directory /workspaces/test-build \
    && cmake -S /workspaces/test -B /workspaces/test-build \
    && cmake --build /workspaces/test-build -- -j

FROM build as deploy

ENTRYPOINT ["/usr/bin/client"]
