#!/usr/bin/env bash

set -euo pipefail

: "${version:=1.0.0}"

## Build default app with no protection options and CGO_ENABLED=0 and static link
# shellcheck disable=SC2154
CGO_ENABLED=0 \
  go build \
  -v \
  -ldflags "-extldflags '-static' -w -s -X 'main.AppVersion=${version}'" \
  -installsuffix=static \
  -o curl_uri \
  main.go

## Build default app with protection options and CGO_ENABLED=1 and dynamic link
# shellcheck disable=SC2154
CGO_ENABLED=1 \
  CGO_CFLAGS="-O2 -D_FORTIFY_SOURCE=2 -fstack-protector-strong" \
  CGO_LDFLAGS="-Wl,-z,relro,-z,now" \
  go build \
  -v \
  -ldflags "-extldflags '-static -z,relro,-z,now,-z,noexecstack -Wl,--as-needed' -w -s -X 'main.AppVersion=${version}'" \
  -installsuffix=netgo \
  -trimpath \
  -tags "netgo osusergo production" \
  -o curl_uri_secup \
  main.go

## Compress via UPX
upx --best --lzma -o curl_uri_compressed curl_uri

## Compress via UPX and CGO_ENABLED=1
upx --best --lzma -o curl_uri_compressed_secup curl_uri_secup

## Compress via strip
## -w -s - strip debug info 'strip --strip-all' is excess
cp curl_uri curl_uri_strip \
  && strip --strip-all curl_uri_strip

## Compress via strip and CGO_ENABLED=1
## -w -s - strip debug info 'strip --strip-all' is excess
cp curl_uri_secup curl_uri_strip_secup \
  && strip --strip-all curl_uri_strip_secup

## Print result and diagnostic binary
printf '====>%s: %s\n' "Original binary size" "$(du -hs curl_uri)"
checksec file curl_uri --output json | jq '.[0].checks'
echo

printf '====>%s: %s\n' "Original binary size with protection options" "$(du -hs curl_uri_secup)"
checksec file curl_uri_secup --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via UPX binary size" "$(du -hs curl_uri_compressed)"
checksec file curl_uri_compressed --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via UPX binary size with protection options" "$(du -hs curl_uri_compressed_secup)"
checksec file curl_uri_compressed_secup --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via strip binary size" "$(du -hs curl_uri_strip)"
checksec file curl_uri_strip --output json | jq '.[0].checks // empty'
echo

printf '====>%s: %s\n' "Compressed via strip binary size with protection options" "$(du -hs curl_uri_strip_secup)"
checksec file curl_uri_strip_secup --output json | jq '.[0].checks // empty'
echo

## Copy to scratch
cp curl_uri /base/usr/src/app/
cp curl_uri_secup /base/usr/src/app/
cp curl_uri_compressed /base/usr/src/app/
cp curl_uri_compressed_secup /base/usr/src/app/
cp curl_uri_strip /base/usr/src/app/
cp curl_uri_strip_secup /base/usr/src/app/

chmod 755 /base/usr/src/app/*

exit 0
