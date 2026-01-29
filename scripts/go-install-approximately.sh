#!/usr/bin/env bash

set -Eeuo pipefail

## Check url for valid link
__validate_url() {
  if [[ $# -lt 1 ]]; then
    printf "%s" \
      "__validate_url requires at least one argument: <list-urls-to-check>"
    return 2
  fi

  local url re domain domain_length
  local -i error_count=0

  ## Strict check
  ## Schema
  re='^(https?|ftp)://'
  ## Auth
  re+='([^\/@]+(:([^\/@]|%[0-9a-fA-F]{2})*)?@)?'
  ## Domain
  re+='(([a-zA-Z0-9-]{1,63}\.)+[a-zA-Z]{2,63}|'
  ## IPv4
  re+='((25[0-5]|2[0-4][0-9]'
  re+='|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|'
  re+='[01]?[0-9][0-9]?)|'
  ## IPv6
  re+='(\[(([a-fA-F0-9]{1,4}:){7}[a-fA-F0-9]{1,4}|'
  re+='(:[a-fA-F0-9]{1,4}){1,7}|'
  re+='[a-fA-F0-9]{1,4}(:[a-fA-F0-9]{1,4}){1,7}|'
  re+='([a-fA-F0-9]{1,4}:){1,6}:[a-fA-F0-9]{1,4}|'
  re+='([a-fA-F0-9]{1,4}:){1,5}(:[a-fA-F0-9]{1,4}){1,2}|'
  re+='([a-fA-F0-9]{1,4}:){1,4}(:[a-fA-F0-9]{1,4}){1,3}|'
  re+='([a-fA-F0-9]{1,4}:){1,3}(:[a-fA-F0-9]{1,4}){1,4}|'
  re+='([a-fA-F0-9]{1,4}:){1,2}(:[a-fA-F0-9]{1,4}){1,5}|'
  re+='[a-fA-F0-9]{1,4}:((:[a-fA-F0-9]{1,4}){1,6})|'
  re+=':((:[a-fA-F0-9]{1,4}){1,7}|:)|'
  re+='fe80:(:[a-fA-F0-9]{0,4}){0,4}%[0-9a-zA-Z]+|'
  re+='::(ffff(:0{1,4})?:)?((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\.){3}'
  re+='(25[0-5]|(2[0-4]|1?[0-9])?[0-9])|([a-fA-F0-9]{1,4}:){1,4}'
  re+=':((25[0-5]|(2[0-4]|1?[0-9])?[0-9])\.){3}(25[0-5]|(2[0-4]|1?[0-9])'
  re+='?[0-9]))\]))'
  ## Port
  re+='(:[0-9]{1,5})?'
  ## Path
  re+='(\/[^[:space:]?#]*)?'
  ## Query
  re+='(\?[^[:space:]#<>]*)?'
  ## Fragment
  re+='(\#[^[:space:]]*)?$'

  for url in "$@"; do
    ## Check main catch
    [[ ${url} =~ ${re} ]] || {
      : $((error_count++))
      continue
    }

    ## Check domain length
    if [[ ${url} =~ ://([^/@:]+) ]]; then
      domain=${BASH_REMATCH[1]%:*}
      [[ -n ${domain} ]] || {
        : $((error_count++))
        continue
      }
      domain_length=${#domain}
      if ((domain_length > 253)); then
        : $((error_count++))
        continue
      fi
    fi
  done

  return "${error_count}"
}

## Check first arg on exist
: "${1:?Define Golang version or URL and try again}"

install_golang() {
  local full_version
  local desired="${1}"

  ## Check if identity is link or specific version
  if __validate_url "${desired}"; then
    ## Install deps
    apt-install.sh curl tar

    ## Download and install Golang from URL
    curl --silent \
      "${desired}" \
      | tar -C "/usr/local" -zx

    ## Remove deps
    apt-env.sh apt-remove.sh curl

    ## Define variables for /etc/environment
    go_revision='Installed-from-URL'

  ## Else installed base component form aptitude source
  else
    ## Update cache
    apt-env.sh apt-get update -qq

    ## Search Golang version on repository if received version is approximately
    full_version=$(apt-cache show golang \
      | grep -E '^Version:' \
      | grep "${desired}" \
      | sort -rV \
      | head -n1 \
      | awk '{print $2}' || echo '')

    ## Return error if version is not find
    [[ -n ${full_version} ]] || {
      echo "[Error]: Could not find Golang version matching '${desired}'" >&2
      return 1
    }

    ## Install Golang with deps
    apt-install.sh \
      "golang=${full_version}"

    ## Define variables for /etc/environment
    go_revision="${full_version}"
  fi

  ## Clean cache
  apt-clean.sh

  ## Filling /etc/environment
  local go_major_minor_patch_version go_major_minor_version
  go_major_minor_patch_version=$(go version | tr -d '[:alpha:]' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2,3)
  go_major_minor_version=$(go version | tr -d '[:alpha:]' | awk -F' ' '{print $1}' | cut -d '.' -f 1,2)
  {
    echo "GO_MAJOR_MINOR_PATCH_VERSION=${go_major_minor_patch_version}"
    echo "GO_MAJOR_MINOR_VERSION=${go_major_minor_version}"
    echo "GO_REVISION=${go_revision}"
    echo "BEGIN_BUILD_IN_EPOCH=$(date '+%s')"
  } >>/etc/environment
}

install_golang "${1}"

exit 0
