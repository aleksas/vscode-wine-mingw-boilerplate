#!/bin/sh

export WINEPATH=$(winepath -w /usr/i686-w64-mingw32/lib)

# This will exec the CMD from your Dockerfile, i.e. "wine payment-manager.exe ..."
exec "$@"