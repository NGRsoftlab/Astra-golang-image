#!/usr/bin/env bash

set -ex

## Check command on exist
__is_command() {
  command -v "${1}" >/dev/null
}

if __is_command checksec; then
  exit 0
fi

## Install deps
apt-install.sh curl

DPKG_ARCH="$(dpkg --print-architecture)"
CHECKSEC_VERSION="${1}"
CHECKSEC_BASE="https://github.com/slimm609/checksec"

[[ -n ${CHECKSEC_VERSION} ]] || {
  CHECKSEC_VERSION=$(curl -Ls -o /dev/null -w '%{url_effective}' "${CHECKSEC_BASE}/releases/latest")
  CHECKSEC_VERSION="${CHECKSEC_VERSION##*/}"
  CHECKSEC_VERSION="${CHECKSEC_VERSION#v*}"
}

CHECKSEC_URL="${CHECKSEC_BASE}/releases/download/${CHECKSEC_VERSION}/checksec_${CHECKSEC_VERSION}_${DPKG_ARCH}.deb"

## Download
curl -sLO "${CHECKSEC_URL}"

## Install
apt install "./${CHECKSEC_URL##*/}"

## Remove installer
rm -f "./${CHECKSEC_URL##*/}"

## Check version
checksec -v

## Remove deps
apt-env.sh apt-remove.sh curl
apt-clean.sh

exit 0
