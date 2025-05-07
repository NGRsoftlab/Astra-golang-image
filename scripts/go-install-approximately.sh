#!/usr/bin/env bash

set -Eeuo pipefail

## Check url for valid link
__validate_url() {
  local url RE DOMAIN DOMAIN_LENGTH

  ## Schema
  RE='^(https?|ftp)://'
  ## Auth
  RE+='([^\/@]+(:([^\/@]|%[0-9a-fA-F]{2})*)?@)?'
  ## Domain
  RE+='(([a-zA-Z0-9-]{1,63}\.)+[a-zA-Z]{2,63}|'
  ## IPv4
  RE+='((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|'
  ## IPv6
  RE+='(\[(([a-fA-F0-9]{1,4}:){7}[a-fA-F0-9]{1,4}|(:[a-fA-F0-9]{1,4}){1,7}|[a-fA-F0-9]{1,4}(:[a-fA-F0-9]{1,4}){1,7}|([a-fA-F0-9]{1,4}:){1,6}:[a-fA-F0-9]{1,4}|([a-fA-F0-9]{1,4}:){1,5}(:[a-fA-F0-9]{1,4}){1,2}|([a-fA-F0-9]{1,4}:){1,4}(:[a-fA-F0-9]{1,4}){1,3}|([a-fA-F0-9]{1,4}:){1,3}(:[a-fA-F0-9]{1,4}){1,4}|([a-fA-F0-9]{1,4}:){1,2}(:[a-fA-F0-9]{1,4}){1,5}|[a-fA-F0-9]{1,4}:((:[a-fA-F0-9]{1,4}){1,6})|:((:[a-fA-F0-9]{1,4}){1,7}|:)|fe80:(:[a-fA-F0-9]{0,4}){0,4}%[0-9a-zA-Z]+|::(ffff(:0{1,4})?:)?((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\.){3}(25[0-5]|(2[0-4]|1?[0-9])?[0-9])|([a-fA-F0-9]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\.){3}(25[0-5]|(2[0-4]|1?[0-9])?[0-9]))\]))'
  ## Port
  RE+='(:[0-9]{1,5})?'
  ## Path
  RE+='(\/[^[:space:]?#]*)?'
  ## Query
  RE+='(\?[^[:space:]#<>]*)?'
  ## Fragment
  RE+='(\#[^[:space:]]*)?$'

  for url in "$@"; do
    ## Check main catch
    [[ ${url} =~ ${RE} ]] || return 1

    ## Check domain length
    if [[ ${url} =~ ://([^/@:]+) ]]; then
      DOMAIN=${BASH_REMATCH[1]%:*}
      [[ -n ${DOMAIN} ]] || return 1
      DOMAIN_LENGTH=${#DOMAIN}
      if ((DOMAIN_LENGTH > 253)); then
        return 1
      fi
    fi
  done

  return 0
}

## Check first arg on exist
: "${1:?Define Golang version or URL and try again}"

install_golang() {
  local DESIRED FULL_VERSION GO_REVISION
  DESIRED="${1}"

  ## Check if identity is link or specific version
  if __validate_url "${DESIRED}"; then
    ## Install deps
    apt-install.sh curl tar

    ## Download and install Golang from URL
    curl --silent \
      "${DESIRED}" \
      | tar -C "/usr/local" -zx

    ## Remove deps
    apt-env.sh apt-remove.sh curl

    ## Define variables for /etc/environment
    GO_REVISION='Installed-from-URL'

  ## Else installed base component form aptitude source
  else
    ## Update cache
    apt-env.sh apt-get update -qq

    ## Search Golang version on repository if received version is approximately
    FULL_VERSION=$(apt-cache show golang \
      | grep -E '^Version:' \
      | grep "${DESIRED}" \
      | sort -rV \
      | head -n1 \
      | awk '{print $2}' || echo '')

    ## Return error if version is not find
    [[ -n ${FULL_VERSION} ]] || {
      echo "[Error]: Could not find Golang version matching '${DESIRED}'" >&2
      return 1
    }

    ## Install Golang with deps
    apt-install.sh \
      "golang=${FULL_VERSION}"

    ## Define variables for /etc/environment
    GO_REVISION="${FULL_VERSION}"
  fi

  ## Clean cache
  apt-clean.sh

  ## Filling /etc/environment
  GO_MAJOR_MINOR_PATCH_VERSION=$(go version | tr -d '[:alpha:]' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2,3)
  GO_MAJOR_MINOR_VERSION=$(go version | tr -d '[:alpha:]' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2)
  {
    echo "GO_MAJOR_MINOR_PATCH_VERSION=${GO_MAJOR_MINOR_PATCH_VERSION}"
    echo "GO_MAJOR_MINOR_VERSION=${GO_MAJOR_MINOR_VERSION}"
    echo "GO_REVISION=${GO_REVISION}"
    echo "BEGIN_BUILD_IN_EPOCH=$(date '+%s')"
  } >>/etc/environment
}

install_golang "${1}"

exit 0
