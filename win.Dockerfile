# https://github.com/IL2HorusTeam/docker-wine
  
FROM debian:buster-slim as config

ARG WINEVERSION="5.0"

ENV WINEVERSION=$WINEVERSION
ENV WINEHOME="/home/root"
ENV WINEPREFIX="$WINEHOME/.wine32"
ENV WINEARCH="win32"
ENV WINEDEBUG=-all

LABEL org.opencontainers.image.title="Wine"
LABEL org.opencontainers.image.ref.name="il2horusteam/wine"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/il2horusteam/wine"
LABEL org.opencontainers.image.authors="Oleksandr Oblovatnyi <oblovatniy@gmail.com>"
LABEL org.opencontainers.image.description="Wine $WINEVERSION 32-bit"

RUN export DEBIAN_FRONTEND=noninteractive \
 && dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      telnet \
      cabextract \
      gnupg2 \
      wget \
 && mkdir -p $WINEPREFIX \
 && wget https://dl.winehq.org/wine-builds/winehq.key -O - | apt-key add - \
 && echo "deb https://dl.winehq.org/wine-builds/debian buster main" > /etc/apt/sources.list.d/winehq.list \
 && wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key -O - | apt-key add - \
 && echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" > /etc/apt/sources.list.d/obs.list \
 && { \
	   echo "Package: *wine* *wine*:i386"; \
		echo "Pin: version $WINEVERSION~buster"; \
		echo "Pin-Priority: 1001"; \
  } > /etc/apt/preferences.d/winehq.pref \
 && apt-get update \
 && apt-get install -y --no-install-recommends winehq-stable \
 && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/bin/winetricks \
 && chmod +rx /usr/bin/winetricks \
 && wine wineboot --init \
 && winetricks d3dx9 corefonts \
 && apt purge --auto-remove -y \
 && apt autoremove --purge -y \
 && rm -rf /var/lib/apt/lists/*

#RUN mkdir -p /workspaces/payment-manager
#WORKDIR /workspaces/payment-manager

#COPY ./bin/Win32/* /workspaces/payment-manager/
#COPY ./bin/extra/* /workspaces/payment-manager/
#RUN chmod +x ./entrypoint.sh

FROM config as dev

RUN apt update \
    && apt -y install mingw-w64 mingw-w64-i686-dev mingw-w64-x86-64-dev gcc-multilib g++-multilib build-essential git cmake

ARG BUILD_TYPE=Release
RUN apt -y install gdb
RUN mkdir -p /workspaces/rpclib_ \
    && git clone https://github.com/rpclib/rpclib /workspaces/rpclib_/ \
    && cmake -E make_directory /workspaces/rpclib_-build \
    && cmake -S /workspaces/rpclib_ -B /workspaces/rpclib_-build \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_SYSTEM_NAME=Generic \
        -DCMAKE_SYSTEM_PROCESSOR=x86 \
        -DCMAKE_C_COMPILER=i686-w64-mingw32-gcc-posix \
        -DCMAKE_CXX_COMPILER=i686-w64-mingw32-g++-posix \
        -DCMAKE_C_FLAGS=-m32 \
        -DCMAKE_CXX_FLAGS=-m32 \
    && cmake --build /workspaces/rpclib_-build --target install  -- -j

FROM dev as src

COPY . /workspaces/test

FROM src as build

RUN cmake -E make_directory /workspaces/test-build \
    && cmake -S /workspaces/test -B /workspaces/test-build \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_SYSTEM_NAME=Windows \
        -DCMAKE_C_COMPILER=i686-w64-mingw32-gcc-posix \
        -DCMAKE_CXX_COMPILER=i686-w64-mingw32-g++-posix \
        -DCMAKE_C_FLAGS=-m32 \
        -DCMAKE_CXX_FLAGS=-m32 \
    && cmake --build /workspaces/test-build -- -j

FROM build as deploy

# ENTRYPOINT ["/workspaces/test/entrypoint.sh", "wine"]
