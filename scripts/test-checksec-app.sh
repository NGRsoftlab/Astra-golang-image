#!/usr/bin/env bash

set -euo pipefail

## Check command on exist
__is_command() {
  command -v "${1}" >/dev/null
}

for i in app_protected app_unprotected; do
  if ! __is_command "${i}"; then
    printf '%s\n' "Cannot testing app"
    exit 0
  fi
done

UNPROTECT_LOCATION=$(which app_unprotected)
PROTECT_LOCATION=$(which app_protected)
UNPROTECT_COPM_LOCATION=$(which app_unprotected_compressed)
PROTECT_COPM_LOCATION=$(which app_protected_compressed)
UNPROTECT_STRIP_LOCATION=$(which app_unprotected_strip)
PROTECT_STRIP_LOCATION=$(which app_protected_strip)

for i in "${PROTECT_LOCATION}" "${UNPROTECT_LOCATION}"; do
  printf '%s\n' "========================"
  printf '%s\n' "TEST FOR '${i}' ONLY"
  printf '%s\n' "========================"

  ## Get app options
  printf '====>%s\n' "Checking for RELRO support"
  if readelf -l "${i}" 2>/dev/null | grep -q 'GNU_RELRO'; then
    readelf -d "${i}" 2>/dev/null | grep -q 'BIND_NOW' && echo "${i}: Full RELRO" || echo "${i}: Partial RELRO"
  else
    echo "${i}: No RELRO"
  fi
  echo

  printf '====>%s\n' "Checking for NX support"
  readelf -W -l "${i}" 2>/dev/null | grep 'GNU_STACK' | grep -q 'RWE' && echo "${i}: NX disabled" || echo "${i}: NX enabled"
  echo

  printf '====>%s\n' "Checking for PIE support"
  if readelf -h "${i}" 2>/dev/null | grep -q 'Type:[[:space:]]*EXEC'; then
    echo "${i}: No PIE"
  elif readelf -h "${i}" 2>/dev/null | grep -q 'Type:[[:space:]]*DYN'; then
    readelf -d "${i}" 2>/dev/null | grep -q '(DEBUG)' && echo "${i}: PIE enabled" || echo "${i}: DSO"
  else
    echo "${i}: Not an ELF file"
  fi
  echo

  printf '====>%s\n' "Checking for rpath"
  readelf -d "${i}" 2>/dev/null | grep -q 'rpath' && echo "${i}: RPATH" || echo "${i}: No RPATH"
  echo

  printf '====>%s\n' "Checking for run path"
  readelf -d "${i}" 2>/dev/null | grep -q 'runpath' && echo "${i}: RUNPATH" || echo "${i}: No RUNPATH"
  echo

  printf '====>%s\n' "Checking for stack canaries"
  ## readelf -s <bin> 2>/dev/null | grep -q '__stack_chk_fail'
  ## readelf -s <bin> | grep -i canary || echo "${i}: 0 (NO CANARIES)"
  if nm "${i}" 2>/dev/null | grep -q __stack_chk_fail; then
    nm "${i}" 2>/dev/null | grep -c __stack_chk_fail
  else
    echo "${i}: 0 (NO CANARIES)"
  fi
  echo

  printf '====>%s\n' "Checking for FORTIFY"
  nm "${i}" 2>/dev/null | grep -E "(__.*_chk)" | head -5 || echo "${i}: No fortified functions"
  echo

  printf '====>%s\n' "Check Debug symbols"
  readelf -S "${i}" | grep -i debug || echo "${i}: Not found debug symbols"
  nm "${i}" 2>/dev/null | head -5
  echo

  printf '====>%s\n' "Checksec: ${i}"
  checksec file "${i}" --output json | jq '.[0].checks // empty'
  echo

  printf '====>%s: %s\n' "${i} size" "$(du -hs "${i}")"
  echo

  printf '====>%s\n' "${i} interpreter check"
  readelf -l "${i}" | grep interpreter || echo
  echo

  printf '====>%s\n' "${i} lib check"
  ldd "${i}" || echo "${i}: static"
  echo

  printf '====>%s\n' "${i} check type"
  file "${i}"
  echo
done

## Check info for compressed binary
printf '%s\n' "========================"
printf '%s\n' "CHECK INFO FOR COMPRESSED BINARY"
printf '%s\n' "========================"
printf '====>%s: %s\n' "Compressed via UPX binary size" "$(du -hs "${UNPROTECT_COPM_LOCATION}")"
checksec file "${UNPROTECT_COPM_LOCATION}" --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via UPX binary size with protection options" "$(du -hs "${PROTECT_COPM_LOCATION}")"
checksec file "${PROTECT_COPM_LOCATION}" --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via strip binary size" "$(du -hs "${UNPROTECT_STRIP_LOCATION}")"
checksec file "${UNPROTECT_STRIP_LOCATION}" --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via strip binary size with protection options" "$(du -hs "${PROTECT_STRIP_LOCATION}")"
checksec file "${PROTECT_STRIP_LOCATION}" --output json | jq '.[0].checks // empty'
echo

## Test app
printf '%s\n' "========================"
printf '%s\n' "TEST APP"
printf '%s\n' "========================"

printf '====>%s\n' "STACK OVERFLOW"
echo

## Segmentation fault (core dumped)
printf '%s\n' "Testing UNPROTECTED binary"
printf '%s\n' "Expected: SIGSEGV or silent corruption"
"${UNPROTECT_LOCATION}" overflow || echo "${UNPROTECT_LOCATION}: exit code($?)"
echo

## *** stack smashing detected ***: terminated
## Aborted (core dumped)
printf '%s\n' "Testing PROTECTED binary"
printf '%s\n' "Expected: Aborted with 'stack smashing detected'"
"${PROTECT_LOCATION}" overflow || echo "${PROTECT_LOCATION}: exit code($?)"
echo

printf '====>%s\n' "HEAP OVERFLOW"
echo

## Heap damage or silent collapse
printf '%s\n' "Testing UNPROTECTED binary"
printf '%s\n' "Expected: SIGSEGV or silent corruption"
"${UNPROTECT_LOCATION}" read || echo "${UNPROTECT_LOCATION}: exit code($?)"
echo

## *** buffer overflow detected ***: terminated
## Aborted (core dumped)
printf '====>%s\n' "Testing PROTECTED binary FORTIFY_SOURCE"
printf '%s\n' "Expected: Aborted with 'buffer overflow detected'"
"${PROTECT_LOCATION}" read || echo "${PROTECT_LOCATION}: exit code($?)"
echo

printf '====>%s\n' "SAFE CONTROL TEST"
echo

## Safe copy completed successfully
printf '====>%s\n' "Testing UNPROTECTED binary with safe option"
"${UNPROTECT_LOCATION}" safe || echo "${UNPROTECT_LOCATION}: exit code($?)"
echo

## Safe copy completed successfully
printf '====>%s\n' "Testing PROTECTED binary with safe option"
"${PROTECT_LOCATION}" safe || echo "${PROTECT_LOCATION}: exit code($?)"
echo

exit 0
