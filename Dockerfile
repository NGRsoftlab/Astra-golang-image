# syntax=docker/dockerfile:1.7-labs

## Definite image args
ARG image_registry
ARG image_name=astra
ARG image_version=1.8.2-slim

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                         Base image                          #
#               First stage, prepare environment              #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM ${image_registry}${image_name}:${image_version} AS base-stage

SHELL [ "/bin/bash", "-exo", "pipefail", "-c" ]

## Define DEFAULT args
ARG go_identity='1.21'
ARG install_additional_tools

## Define environment
ENV \
    GOPATH=/go \
    PATH="/go/bin:/usr/local/go/bin:${PATH}"

## Copy issue
COPY docs/issue /etc/issue

## Install and setup application
RUN \
    --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
    go-install-approximately.sh "${go_identity}" \
## Base deps to communicate with packages
    && apt-install.sh \
## Small init process
        dumb-init \
        git \
        make \
        gcc \
        g++ \
        pkg-config \
        libc6-dev \
## Additional tools
        ${install_additional_tools} \
    && apt-clean.sh \
## Mock test
    && go version \
## Create golang root path
    && mkdir -p "${GOPATH}"/{src,bin} \
    && chmod -R 1777 "${GOPATH}" \
## Remove unneeded component and cache
    && go-rm-unneeded.sh \
    && find "/usr/" -iname '*.exe' -ls -delete \
## Create link
    && ln -s "$(which go)" /usr/local/bin/golang \
## Deduplication cleanup
    && dedup-clean.sh /usr/ \
## Get image package dump
    && mkdir -p /usr/share/rocks \
    && ( \
        echo "# os-release" && cat /etc/os-release \
        && echo "# dpkg-query" \
        && dpkg-query -f \
            '${db:Status-Abbrev},${binary:Package},${Version},${source:Package},${Source:Version}\n' \
            -W \
        ) >/usr/share/rocks/dpkg.query \
## Check can be preview /etc/issue
    && { \
        grep -qF 'cat /etc/issue' /etc/bash.bashrc \
        || echo 'cat /etc/issue' >> /etc/bash.bashrc; \
    }

## Copy entrypoint
COPY scripts/docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                        Final image                          #
#             Second stage, compact optimize layer            #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM scratch

COPY --from=base-stage / /

## Set base label
LABEL \
    maintainer="Vladislav Avdeev" \
    organization="NGRSoftlab"

## Set environment
ENV \
    LANG='en_US.UTF8' \
    LC_ALL='en_US.UTF8' \
    TERM='xterm-256color' \
    TZ=Etc/UTC \
    DEBIAN_FRONTEND='noninteractive' \
    GOPATH=/go \
    PATH="/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
## Don't auto-upgrade the gotoolchain
## https://github.com/docker-library/golang/issues/472
    GOTOOLCHAIN=local

## Set work directory
WORKDIR "${GOPATH}"

ENTRYPOINT [ "dumb-init", "docker-entrypoint.sh" ]
