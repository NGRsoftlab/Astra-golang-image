#!/usr/bin/env bash

set -e

source /etc/environment

DPKG_ARCH="$(dpkg --print-architecture)"
CURRENT_ARCH="linux_${DPKG_ARCH}"

if [[ ${GO_REVISION,,} == 'installed-from-url' ]]; then
  GO_LOCATION='/usr/local/go'
else
  GO_LOCATION="/usr/lib/go-${GO_MAJOR_MINOR_VERSION}"
fi

## Docs in HTML (20-50 Mb)
rm -rf "${GO_LOCATION}"/doc/
## Go tests
rm -rf "${GO_LOCATION}"/test/
## Code examples
rm -rf "${GO_LOCATION}"/sample/
## API JSON (can be regenerate)
rm -rf "${GO_LOCATION}"/api/
## Blog go.dev
rm -rf "${GO_LOCATION}"/blog/
## CGO/Vim/Emacs/GDB
rm -rf "${GO_LOCATION}"/misc/

## Remove objects and object archive
find "${GO_LOCATION}"/pkg -type f -name "*.a" -delete
find "${GO_LOCATION}"/pkg -type d -name "obj" -exec rm -rf {} +

## Remove all mess arch
find "${GO_LOCATION}"/pkg/tool -mindepth 1 -maxdepth 1 -type d ! -name "${CURRENT_ARCH}" -exec rm -rf {} +
rm -rf /tmp/*

exit 0
