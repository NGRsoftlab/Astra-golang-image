#!/bin/sh
set -e

# Check can be loaded '/etc/environment' as default?
# shellcheck disable=SC2163
if [ -f /etc/environment ]; then
  while IFS= read -r line; do
    [ -z "${line}" ] && continue
    case "${line}" in
      \#*) continue ;;
      *) export "${line}" ;;
    esac
  done </etc/environment
fi

# Check, can preview '/etc/issue'?
if [ -s /etc/issue ] && [ ! -t 0 ]; then
  cat /etc/issue
fi

# Run command with go if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- go "$@"
fi

exec "$@"
