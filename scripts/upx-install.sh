#!/usr/bin/env bash

set -ex

## Check command on exist
__is_command() {
  command -v "${1}" >/dev/null
}

if __is_command upx; then
  return 0
fi

## Install deps
apt-install.sh xz-utils curl

## Define base vars
DPKG_ARCH="$(dpkg --print-architecture)"
UPX_VERSION="${1}"
UPX_BASE="https://github.com/upx/upx"

## Via git
# git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' "${UPX_BASE}.git" \
#   | tail --lines=1 \
#   | cut --delimiter='/' --fields=3

[[ -n ${UPX_VERSION} ]] || {
  UPX_VERSION=$(curl -Ls -o /dev/null -w '%{url_effective}' "${UPX_BASE}/releases/latest")
  UPX_VERSION="${UPX_VERSION##*/}"
  UPX_VERSION="${UPX_VERSION#v*}"
}

UPX_URL="${UPX_BASE}/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${DPKG_ARCH}_linux.tar.xz"

## Don't take much space when downloading or less space on hard drive
## Example: 20.1MB == 6.73MB
curl -Ls \
  "${UPX_URL}" \
  | tar -C "/usr/local/bin" --strip-components 1 -Jx

chmod +x /usr/local/bin/upx

## Remove deps
apt-env.sh apt-remove.sh xz-utils curl
apt-clean.sh

exit 0
