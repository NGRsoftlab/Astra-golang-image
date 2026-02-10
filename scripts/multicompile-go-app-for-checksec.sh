#!/usr/bin/env bash

set -euo pipefail

## Build default app with no protection options
## -x -v - full trace debug
CGO_ENABLED=1 \
  CGO_CFLAGS="-O2" \
  CGO_LDFLAGS="" \
  go build \
  -trimpath \
  -ldflags="-s -w" \
  -o app_unprotected \
  .

## Build default app with protection options and dynamic link
CGO_ENABLED=1 \
  CGO_CFLAGS="-O2 -D_FORTIFY_SOURCE=2 -fstack-protector-strong" \
  CGO_LDFLAGS="-Wl,-z,relro,-z,now" \
  go build \
  -trimpath \
  -ldflags="-s -w -extldflags '-Wl,-z,relro,-z,now,-z,noexecstack -pie'" \
  -buildmode=pie \
  -o app_protected \
  .

## Compress via UPX
upx --best --lzma -o app_unprotected_compressed app_unprotected

## Compress via UPX and CGO_ENABLED=1
upx --best --lzma -o app_protected_compressed app_protected

## Compress via strip
## -w -s - strip debug info 'strip --strip-all' is excess
cp app_unprotected app_unprotected_strip \
  && strip --strip-all app_unprotected_strip

## Compress via strip and CGO_ENABLED=1
## -w -s - strip debug info 'strip --strip-all' is excess
cp app_protected app_protected_strip \
  && strip --strip-all app_protected_strip

## Print result and diagnostic binary
printf '====>%s: %s\n' "Original binary size" "$(du -hs app_unprotected)"
checksec file app_unprotected --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Original binary size with protection options" "$(du -hs app_protected)"
checksec file app_protected --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via UPX binary size" "$(du -hs app_unprotected_compressed)"
checksec file app_unprotected_compressed --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via UPX binary size with protection options" "$(du -hs app_protected_compressed)"
checksec file app_protected_compressed --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via strip binary size" "$(du -hs app_unprotected_strip)"
checksec file app_unprotected_strip --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via strip binary size with protection options" "$(du -hs app_protected_strip)"
checksec file app_protected_strip --output json | jq '.[0].checks // empty'
echo

chmod 755 ./*

mv -f ./app_unprotected* /usr/bin/
mv -f ./app_protected* /usr/bin/

## Run tests
test-checksec-app

exit 0
