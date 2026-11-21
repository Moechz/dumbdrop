#!/bin/sh
# ===========================================================================
# TOS wrapper for DumbDrop - start-up preparation only.
# ===========================================================================
# The upstream image is used unmodified. Its application tree (/usr/src/app,
# including node_modules) already exists and is owned by uid 1000, so nothing
# is copied onto the data volume. The previous wrapper copied the whole image
# tree to /data/app on first start (~355 MB); that copy is gone - it wasted
# space, slowed the first start and contributed to the aarch64 install test
# timing out.
#
# DumbDrop only needs writable paths on the persistent volume:
#   /data/uploads   uploaded files and the .metadata/ upload-session folder
#   /data           HOME for node/npm and for optional Apprise state
# ===========================================================================
set -u
set -e

mkdir -p /data/uploads
export HOME=/data
export UPLOAD_DIR=/data/uploads

exec node src/server.js
