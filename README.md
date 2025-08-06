<!-- markdownlint-disable MD033 MD041 -->
<p><img src="https://static.tildacdn.com/tild3733-3430-4331-a637-336233396534/logo.svg" alt="NGRSOFTLAB logo" title="NGR" align="right" height="60" /></p>
<!-- markdownlint-enable MD033 MD041 -->

# Golang

<!-- markdownlint-disable MD033 -->
<div>
  <h4 align="center">
    <img src="https://img.shields.io/badge/Dive%20efficiency-100%25-brightgreen.svg?logo=Docker&style=plastic" alt="Dive efficiency"/>
    <img src="https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-9cf?style=plastic" alt="Made with love"/>
    <img src="https://img.shields.io/badge/Powered%20by-Docker-blue?logo=Docker&style=plastic" alt="Powered by Docker"/>
    <img src="https://shields.io/badge/NGR -Team-yellow?style=plastic&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGZpbGw9Im5vbmUiIHZpZXdCb3g9IjIyLjcgMCA1MS45IDUxLjciPjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNNzQuNSAwSDYzLjhsMy42IDMuNWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNTguOSAwSDUzbDE0LjUgMTMuOWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNDkgMGgtNi44bDI1LjMgMjQuM2MuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMMzkgMGgtNy43bDM2LjEgMzQuN2MuNy43LjcgMS45IDAgMi42cy0xLjkuNy0yLjYgMEwyOSAwYy0zLjUuNC02LjMgMy40LTYuMyA3djQ0LjdoMTAuNmwtMy42LTMuNGMtLjctLjctLjctMS45IDAtMi42czEuOS0uNyAyLjcgMGw1LjggNmg1LjlMMjkuNyAzNy45Yy0uNy0uNy0uNy0xLjkgMC0yLjcuNy0uNyAxLjktLjcgMi43IDBsMTUuOCAxNi40SDU1TDI5LjggMjcuNGMtLjctLjctLjctMS45IDAtMi43LjctLjcgMS45LS43IDIuNyAwbDI1LjggMjYuOEg2NkwyOS45IDE2LjljLS43LS43LS43LTEuOSAwLTIuNnMxLjktLjcgMi43IDBsMzUuNyAzNy4yYzMuNS0uMyA2LjMtMy4zIDYuMy03VjB6IiBmaWxsPSIjRjhBRDAwIi8+PC9zdmc+" alt="NGR Team" />
  </h4>
</div>

<div align="center">

![Golang image](docs/images/logo.svg)
</div>

<div align="center"> <sub> Ascii svg art by <a href="https://GitHub.com/martinthomson/aasvg">aasvg</a>. </sub> </div>

<!-- markdownlint-enable MD033 -->

## Description

**Golang container image** - это реализация легковесной сборки ЯП Golang на базе Astra Linux

Присоединяйтесь к нашим социальным сетям:

<!-- markdownlint-disable MD033 -->

<div class="badges-row-public">
  <h4 align="center">
    <a href="https://t.me/NGR_Softlab">
      <img src="https://shields.io/badge/ngr-telegram-blue?logo=telegram&style=for-the-badge" alt="NGR Social Telegram" height="40" />
    </a>
    &emsp; &emsp; &emsp;
    <a href="https://www.ngrsoftlab.ru/?utm_source=tg&utm_medium=start" >
      <img src="https://shields.io/badge/ngr-web--page-yellow?style=for-the-badge&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGZpbGw9Im5vbmUiIHZpZXdCb3g9IjIyLjcgMCA1MS45IDUxLjciPjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNNzQuNSAwSDYzLjhsMy42IDMuNWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNTguOSAwSDUzbDE0LjUgMTMuOWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNDkgMGgtNi44bDI1LjMgMjQuM2MuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMMzkgMGgtNy43bDM2LjEgMzQuN2MuNy43LjcgMS45IDAgMi42cy0xLjkuNy0yLjYgMEwyOSAwYy0zLjUuNC02LjMgMy40LTYuMyA3djQ0LjdoMTAuNmwtMy42LTMuNGMtLjctLjctLjctMS45IDAtMi42czEuOS0uNyAyLjcgMGw1LjggNmg1LjlMMjkuNyAzNy45Yy0uNy0uNy0uNy0xLjkgMC0yLjcuNy0uNyAxLjktLjcgMi43IDBsMTUuOCAxNi40SDU1TDI5LjggMjcuNGMtLjctLjctLjctMS45IDAtMi43LjctLjcgMS45LS43IDIuNyAwbDI1LjggMjYuOEg2NkwyOS45IDE2LjljLS43LS43LS43LTEuOSAwLTIuNnMxLjktLjcgMi43IDBsMzUuNyAzNy4yYzMuNS0uMyA2LjMtMy4zIDYuMy03VjB6IiBmaWxsPSIjRjhBRDAwIi8+PC9zdmc+" alt="NGR Social Media" height="40" />
    </a>
  </h4>
</div>

<!-- markdownlint-enable MD033 -->

## Contents

- [Golang](#golang)
  - [Description](#description)
  - [Contents](#contents)
  - [Requirements](#requirements)
  - [Supported Technologies](#supported-technologies)
  - [What it is](#what-it-is)
  - [How to work with](#how-to-work-with)
    - [Container variables](#container-variables)
    - [Advanced environment](#advanced-environment)
  - [How to use this image](#how-to-use-this-image)
  - [How to test local](#how-to-test-local)
  - [Scratch](#scratch)
    - [Interaction with third-party software components](#interaction-with-third-party-software-components)
    - [Interaction with private software components](#interaction-with-private-software-components)
  - [Miscellaneous](#miscellaneous)
    - [Cya!](#cya)

## [Requirements](#contents)

- Docker >= 28.1.1 (возможно работает в предыдущих версиях, но мы не можем это гарантировать)

## [Supported Technologies](#contents)

<!-- markdownlint-disable MD033 -->
|                                                 OS                                                  |                                                                                                          Golang                                                                                                          | Status            |
| :-------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------- |
| ![Astra 1.7](https://img.shields.io/badge/Astra-1.7.x-00ADD8?style=flat&logo=astra&logoColor=white) |                                                        ![Golang 1.19](https://img.shields.io/badge/Golang-1.19-%2300ADD8.svg?style=flat&logo=go&logoColor=white)                                                         | ✅ Fully supported |
| ![Astra 1.8](https://img.shields.io/badge/Astra-1.8.x-00ADD8?style=flat&logo=astra&logoColor=white) | ![Golang 1.21](https://img.shields.io/badge/Golang-1.21-%2300ADD8.svg?style=flat&logo=go&logoColor=white) <br> ![Golang 1.23](https://img.shields.io/badge/Golang-1.23-%2300ADD8.svg?style=flat&logo=go&logoColor=white) | ✅ Fully supported |

<div align="center"> <sub> Таблица 1. Поддерживаемые ОС-ы. </sub> </div>
<p>&nbsp;</p>
<!-- markdownlint-enable MD033 -->

## [What it is](#contents)

Go(a.k.a Golang) - язык программирования, впервые разработанный в Google. Это статически типизированный язык с синтаксисом, в некоторой степени производным от C, но с дополнительными функциями, такими как сборщик мусора, безопасность типов, некоторые возможности динамической типизации, дополнительные встроенные типы (например, массивы переменной длины и карты ключ-значение) и большая стандартная библиотека. Образ построен на основе отечественной ОС Astra Linux

## [How to work with](#contents)

Для начала работы необходимо установить [pre-commit](https://pre-commit.com/) и хуки

```console
$ pip install pre-commit
$ pre-commit --version

pre-commit 4.2.0

$ pre-commit install

pre-commit installed at .git/hooks/pre-commit
pre-commit installed at .git/hooks/commit-msg
pre-commit installed at .git/hooks/pre-push
```

> [!warning]
> Чтобы проверить свои изменения, воспользуйтесь командой `pre-commit run --all-files`.
> Чтобы проверить конкретную задачу, воспользуетесь командой `pre-commit run <target> --all-files`.
> Если Вы понимаете что творите и хотите пропустить проверку `pre-commit`-ом воспользуйтесь `--no-verify`, пример `git commit -m "Добавил изменения и не хочу проверки" --no-verify`

Существует несколько способов как можно взаимодействовать со сборкой образа. Благодаря скрипту[^2] может существовать 3 способа передачи аргумента в `Dockerfile`:

1. Передача 'примерной' версии. В результате передачи данной строки, скрипт [попытается найти](scripts/go-install-approximately.sh#L74-80) точную версии, если таковой нет, то будет возвращена пустая строка

    ```console
    ## Export Golang version for 1.7.5
    $ export GOLANG_VERSION='1.19-astra1.7.5-slim'

    ## Golang image: 512MB
    docker build \
      --progress=plain \
      --build-arg go_identity=1.19 \
      --build-arg image_version=1.7.5-slim \
      -t golang:"${GOLANG_VERSION}" \
      .

    .. build ...
    ```

2. Передача точной версии

    ```console
    ## Export Golang version for 1.8.2
    $ export GOLANG_VERSION='1.21-astra1.8.2-slim'

    ## Golang build utils image: 632MB
    docker build \
      --progress=plain \
      --build-arg go_identity='2:1.21~2.astra1+b1' \
      --build-arg image_version=1.8.2-slim \
      -t golang:"${GOLANG_VERSION}" \
      .

    .. build ...
    ```

3. Передача ссылки, на заранее собранный из исходников Golang

    ```console
    ## Export Golang version for 1.8.2
    $ export GOLANG_VERSION='1.23-astra1.8.2-slim'

    ## Golang build utils image: 645MB
    docker build \
      --progress=plain \
      --build-arg go_identity=https://example-registry.com/repository/golang/go-v1.23.5-linux-amd64.tar.gz \
      --build-arg image_version=1.8.2-slim \
      -t golang:"${GOLANG_VERSION}" \
      .

    .. build ...
    ```

> [!tip]
> Примеры просмотра версии пакета -
> `apt show golang`,
> `apt-cache policy golang`,
> `apt-cache show golang`

### [Container variables](#contents)

| Имя                 | Значение по умолчанию |  Тип   |                                                    Описание |
| :------------------ | :-------------------: | :----: | ----------------------------------------------------------: |
| `image_name`        |         astra         | string |                                                 Имя образа. |
| `image_registry`    |          ''           | string |                                Адрес до реестра образа[^1]. |
| `image_version`     |      1.8.2-slim       | string |                                              Версия образа. |
| `go_registry_proxy` |          ''           | string | Переменная, для установки своего проксирующего репозитория. |
| `go_identity`       |         1.21          | string |                                Ожидаемая версия Golang[^2]. |

<!-- markdownlint-disable MD033 -->
<div align="center"> <sub> Таблица 2. Переопределяемые аргументы для сборки образа. </sub> </div>
<p>&nbsp;</p>
<!-- markdownlint-enable MD033 -->

### [Advanced environment](#contents)

В результате сборки базового образа идёт наполнение файла `/etc/environment`. В нём отражены общие переменные, которые могут использоваться в сборочных образах приложений

1. Пример переменных для образа `1.23` установленного из удаленного и скомпилированного Golang

    ```console
    $ cat /etc/environment

    GO_REVISION=Installed-from-URL
    BEGIN_BUILD_IN_EPOCH=1746645898
    GO_MAJOR_MINOR_PATCH_VERSION=1.23.4
    GO_MAJOR_MINOR_VERSION=1.23
    ```

2. Пример переменных для образа `1.21` из репозиториев Astra Linux

    ```console
    $ cat /etc/environment

    GO_REVISION=2:1.21~2.astra1+b1
    BEGIN_BUILD_IN_EPOCH=1746643737
    GO_MAJOR_MINOR_PATCH_VERSION=1.21.10
    GO_MAJOR_MINOR_VERSION=1.21
    ```

3. Пример переменных для образа `1.19` из репозиториев Astra Linux

    ```console
    $ cat /etc/environment

    GO_REVISION=2:1.19~1
    BEGIN_BUILD_IN_EPOCH=1746643927
    GO_MAJOR_MINOR_PATCH_VERSION=1.19.12
    GO_MAJOR_MINOR_VERSION=1.19
    ```

## [How to use this image](#contents)

Для того чтобы начать использовать данный образ, создайте `Dockerfile` с простыми настройками

```Dockerfile
FROM golang:1.21-astra1.8.2-slim

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

CMD ["app"]
```

Затем соберите и запустите полученный образ

```console
$ docker build -t my-golang-app .
$ docker run -it --rm --name my-running-app my-golang-app

...run logic...
```

Для того, чтобы запустить компиляцию внутри докер контейнера

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.21-astra1.8.2-slim go build -v

...run logic...
```

Кросс-компиляция приложения внутри контейнера

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e GOOS=windows -e GOARCH=386 golang:1.21-astra1.8.2-slim go build -v

...run logic...
```

Альтернативный подход для сборки всех платформ за один раз

```console
$ docker run --rm -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.21-astra1.8.2-slim bash
$ for GOOS in darwin linux; do
>   for GOARCH in 386 amd64; do
>     export GOOS GOARCH
>     go build -v -o myapp-$GOOS-$GOARCH
>   done
> done

...run logic...
```

## [How to test local](#contents)

Простой тест:

```shell
docker run --rm golang:1.21-astra1.8.2 bash -c "go install github.com/cosmos72/gomacro@latest && gomacro -e 'import \"fmt\"' -e 'fmt.Println(\"Hello from Go\")'"
```

## [Scratch](#contents)

Данный раздел будет обеспечивать краткие вводные для того, чтобы Вы в дальнейшем могла проектировать свои `Scratch` сборки, на примере [небольшой утилиты](scratch/main.go). Все, что демонстрируется, также подкреплено и всеми задействованными скриптами [сборочными](scripts/) или специализированными для [сборки](scratch/) через `scratch`. Все манипуляции поделены на определенное количество 'шагов' для которых будут даны краткие комментарии:

1. Первый этап - установка базовых компонентов для сборки

    ```Dockerfile
    ## Install upx and base components
    RUN \
        --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
        upx-install.sh \
        && apt-install.sh \
            tzdata \
            zip \
            ca-certificates \
            build-essential \
        && apt-remove.sh
    ```

2. Второй этап - упаковка минимального набора компонентов для переноса в `Scratch`

    ```Dockerfile
    ## Create anonymous user
    RUN \
        mkdir -p \
            /base/etc/ssl/certs \
            /base/sbin \
            /base/usr/src/app \
    ## UID and GID
        && echo 'root:x:0:' > /base/etc/group \
        && echo "${user}:x:${gid}:" >> /base/etc/group \
        && echo 'root:x:0:0:root:/root:/sbin/nologin' > /base/etc/passwd \
        && echo "${user}:x:${uid}:${gid}:${user}:/nonexistent:/sbin/nologin" >> /base/etc/passwd \
    ## Nologin binary
        && echo 'int main() { return 1; }' > nologin.c \
        && gcc -Os -no-pie -static -std=gnu99 -s -Wall -Werror -o /base/sbin/nologin nologin.c \
    ## Copy root cert
        && cp /etc/ssl/certs/ca-certificates.crt /base/etc/ssl/certs/ca-certificates.crt

    WORKDIR /usr/share/zoneinfo

    RUN zip -q -r -0 /base/zoneinfo.zip .
    ```

3. Третий этап - сборка и оптимизация приложения при помощи [`upx`](https://github.com/upx/upx)

    ```Dockerfile
    WORKDIR /opt

    COPY scratch/go.* .
    RUN go mod download

    COPY scratch/main.go .

    RUN \
        go build \
            -v \
            -ldflags "-extldflags '-static' -w -s -X 'main.AppVersion=${version}'" \
            -installsuffix=static \
            -o curl-uri main.go

    ## Reduce binary size: ~5.7Mb => ~1,8Mb
    RUN \
        echo "Original binary size: $(du -hs curl-uri)" \
        && upx --best --lzma -o curl_uri_compressed curl-uri \
        && echo "Compressed binary size: $(du -hs curl_uri_compressed)"

    ## Copy optimized app
    RUN \
        cp curl_uri_compressed /base/usr/src/app/curl-uri \
        && chmod 755 /base/usr/src/app/curl-uri
    ```

4. Заключительный этап - миграция к скретч и запуск приложения

    ```Dockerfile
    ## Import the user and group files from the base-stage
    COPY --from=base-stage /base/ /

    ## Use an unprivileged user
    USER anonymous:anonymous

    ## Set timezone data environment
    ENV \
        ZONEINFO=/zoneinfo.zip \
        PATH="/usr/src/app" \
        SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
        REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

    ## Run dir
    WORKDIR /usr/src/app

    ## Be gentle and expose port
    EXPOSE 8080

    ENTRYPOINT [ "curl-uri" ]
    ```

Сборка: `docker build --progress=plain -f Dockerfile-scratch -t curl-uri:1.0.0 .`

Запуск: `docker run --rm --network=host --dns 8.8.8.8 -e IPINFO_TOKEN=4426e4d4334a8d curl-uri:1.0.0`

> [!warning]
> Если `IPINFO_TOKEN` не определяется, то зарегистрируйте новый на [`ipinfo.io`](https://ipinfo.io/)

Примеры использования:

1. Route `/` - вывод версии приложения

    ```console
    $ curl http://localhost:8080

    Golang UPX Demo v1.0.0
    ```

2. Route `/location` - запрос информации о своём местонахождении

    ```console
    $ curl http://localhost:8080/location

     ____                   __                             Welcome to the bloated Golang server!
    /\  _'\                /\ \
    \ \ \L\_\   ___   _____\ \ \___      __  _ __  ____    [+] Server IP: 8.8.8.8
     \ \ \L_L  / __'\/\ '__'\ \  _ '\  /'__'/\''__/',__\   [+] Country:   ZN
      \ \ \/, /\ \L\ \ \ \L\ \ \ \ \ \/\  __\ \ \/\__, '\  [+] Region:    Amsterdam
       \ \____\ \____/\ \ ,__/\ \_\ \_\ \____\ \_\/\____/  [+] City:      Amsterdam
        \/___/ \/___/  \ \ \/  \/_/\/_/\/____/\/_/\/___/   [+] ISP:       Google cloud
                        \ \_\                              [+] Lat/Lon:   11.1111, 11.1111
                         \/_/                              [+] Timezone:  Europe/Amsterdam

                                                           Server started at: Wed May  7 23:27:27 MSK 2025
                                                           Current time:      Wed May  7 23:27:33 MSK 2025
    ```

3. Route `/stream` - последовательно выводит framerate из `Ascii` артов

    ```console
    $ curl http://localhost:8080/stream

     ____                   __
    /\  _'\                /\ \
    \ \ \L\_\   ___   _____\ \ \___      __  _ __  ____
     \ \ \L_L  / __'\/\ '__'\ \  _ '\  /'__'/\''__/',__\
      \ \ \/, /\ \L\ \ \ \L\ \ \ \ \ \/\  __\ \ \/\__, '\
       \ \____\ \____/\ \ ,__/\ \_\ \_\ \____\ \_\/\____/
        \/___/ \/___/  \ \ \/  \/_/\/_/\/____/\/_/\/___/
                        \ \_\
                         \/_/

    Uptime: 1s
    ```

4. Route `/live` - выводит `text/plain`(по умолчанию) проверку работоспособности сервера и функционала. Также поддерживает работу с query

    ```console
    $ curl http://localhost:8080/live
    OK

    $ curl http://localhost:8080/live
    failed to fetch public IP

    $ curl http://localhost:8080/live?format=json
    {"error":"failed to fetch public IP","status":"error"}
    ```

5. Route `/healthz` - выводит `text/plain`(по умолчанию) проверку сервера на его способность принимать запросы. Также поддерживает работу с query

    ```console
    $ curl http://localhost:8080/healthz
    OK

    $ curl http://localhost:8080/healthz?format=json
    {"status":"ok"}
    ```

6. Route `/metrics` - выводит `text/plain` Prometheus метрики

    ```console
    $ curl http://localhost:8080/metrics

    ...
    # HELP upx_server_requests_total Total number of HTTP requests.
    # TYPE upx_server_requests_total counter
    upx_server_requests_total{handler="location",method="GET"} 1
    # HELP upx_server_up Whether the server is up and responding (1 = yes, 0 = no)
    # TYPE upx_server_up gauge
    upx_server_up 1
    ```

Полный `Dockerfile`:

```Dockerfile
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                         Base image                          #
#               First stage, prepare environment              #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM golang:1.21-astra1.8.2-slim AS base-stage

SHELL [ "/bin/bash", "-exo", "pipefail", "-c" ]

ARG \
    user=anonymous \
    uid=100000 \
    gid=65536 \
    version=1.0.0

## Disable CGO by default and try to avoid installing the package: `libc6-compat`
# Source: https://stackoverflow.com/questions/62634820/build-small-image-from-scratch-open-no-such-file-or-directory
# Source: https://www.reddit.com/r/golang/comments/pi97sp/what_is_the_consequence_of_using_cgo_enabled0/
ENV CGO_ENABLED=0

## Install upx and base components
RUN \
    --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
    upx-install.sh \
    && apt-install.sh \
        tzdata \
        zip \
        ca-certificates \
        build-essential \
    && apt-remove.sh

## Create anonymous user
# hadolint ignore=SC2154
RUN \
    mkdir -p \
        /base/etc/ssl/certs \
        /base/sbin \
        /base/usr/src/app \
## UID and GID
    && echo 'root:x:0:' > /base/etc/group \
    && echo "${user}:x:${gid}:" >> /base/etc/group \
    && echo 'root:x:0:0:root:/root:/sbin/nologin' > /base/etc/passwd \
    && echo "${user}:x:${uid}:${gid}:${user}:/nonexistent:/sbin/nologin" >> /base/etc/passwd \
## Nologin binary
    && echo 'int main() { return 1; }' > nologin.c \
    && gcc -Os -no-pie -static -std=gnu99 -s -Wall -Werror -o /base/sbin/nologin nologin.c \
## Copy root cert
    && cp /etc/ssl/certs/ca-certificates.crt /base/etc/ssl/certs/ca-certificates.crt

WORKDIR /usr/share/zoneinfo

## -0 means no compression.  Needed because go's
## tz loader doesn't handle compressed data
RUN zip -q -r -0 /base/zoneinfo.zip .

WORKDIR /opt

## Top-level layer for pumping dependencies
## Necessary, because subsequently the changeable
## layers, which are located below, will change
## and this layer will not be recreated, thereby
## optimizing the build time
COPY scratch/go.* .
RUN go mod download

## The level below, which assumes frequent changes.
## In order to optimize the build time, it is necessary
## to place it below, because the subsequent build
## will analyze the hash checksums, and based on them
## skip the main "long" build, going straight to the
## final part, where the code base will change
## regularly, thereby rebuilding only this layer
## Copy app
COPY scratch/main.go .

## Build app
# hadolint ignore=SC2154
RUN \
    go build \
        -v \
        -ldflags "-extldflags '-static' -w -s -X 'main.AppVersion=${version}'" \
        -installsuffix=static \
        -o curl-uri main.go

## Reduce binary size: ~9.0Mb => ~2.7Mb
RUN \
    echo "Original binary size: $(du -hs curl-uri)" \
    && upx --best --lzma -o curl_uri_compressed curl-uri \
    && echo "Compressed binary size: $(du -hs curl_uri_compressed)"

## Copy optimized app
RUN \
    cp curl_uri_compressed /base/usr/src/app/curl-uri \
    && chmod 755 /base/usr/src/app/curl-uri

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                        Final image                          #
#      Third stage, add only minimal application and deps     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM scratch

## Set base label
LABEL \
    maintainer="Vladislav Avdeev" \
    organization="NGRSoftlab"

## Import the user and group files from the base-stage
COPY --from=base-stage /base/ /

## Use an unprivileged user
USER anonymous:anonymous

## Set timezone data environment
ENV \
    ZONEINFO=/zoneinfo.zip \
    PATH="/usr/src/app" \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

## Run dir
WORKDIR /usr/src/app

## Be gentle and expose port
EXPOSE 8080

ENTRYPOINT [ "curl-uri" ]
```

### [Interaction with third-party software components](#contents)

Чтобы переопределить/переназначить проектную область на свои источники в зависимостях, можно воспользоваться следующей инструкцией:

1. Создать форк необходимого проекта
2. Изменить `go.mod` источник на имя нового форка, зафиксировать и отправить изменения
3. Добавить в `go.mod` директиву replace. Пример содержимого:

```plaintext
module <yourname>

go 1.18

require (
    github.com/versent/saml2aws/v2 v2.35.0
)

replace github.com/versent/saml2aws/v2 v2.35.0 => github.com/marcottedan/saml2aws/v2 master
```

Более подробно можно ознакомиться [тут](https://go.dev/ref/mod#go-mod-file-replace)

### [Interaction with private software components](#contents)

Команда go поддерживает базовую аутентификацию HTTP при обмене данными с прокси-серверами

Учетные данные могут быть указаны в файле `.netrc`. Например, файл `.netrc`, содержащий следующие строки, будет настраивать команду go для подключения к машине `proxy.corp.example.com` с заданными именем пользователя и паролем

```plaintext
machine proxy.corp.example.com
login user
password password
```

Местоположение файла может быть установлено с помощью переменной среды `NETRC`. Если `NETRC` не установлен, команда `go` будет читать `$HOME/.netrc` на UNIX-подобных платформах или `%USERPROFILE%\_netrc` в Windows

Поля в `.netrc` разделяются пробелами, табуляциями и символами новой строки. К сожалению, эти символы нельзя использовать в именах пользователей или паролях. Также обратите внимание, что имя компьютера не может быть полным URL-адресом, поэтому невозможно указать разные имена пользователей и пароли для разных путей на одном компьютере

В качестве альтернативы учетные данные могут быть указаны непосредственно в URL-адресах `GOPROXY`. Например:

`GOPROXY=https://user:password@proxy.corp.example.com`

Альтернативная опция при помощи `git`-a при `CI/CD`

```shell
# От пользователя

git config --global credential.helper store
git credential fill <<! | git credential approve
url=https://proxy.corp.example.com
username=user
password=password
!
```

> [!warning]
> Соблюдайте осторожность при использовании этого подхода: переменные среды могут отображаться в истории оболочки и в журналах

## [Miscellaneous](#contents)

Лого для проекта создано при помощи [`aasvg`](https://github.com/martinthomson/aasvg) проекта. Вы можете создать такое же и/или модифицировать имеющееся. Для этого воспользуйтесь [сайтом](https://patorjk.com/software/taag/#p=display&f=Doom) или установите `figlet`. Если Вы используете способ с установкой `figlet`, то вдобавок необходимо сказать необходимый шрифт, например я использую `Doom`. Далее, необходимо воспользоваться `aasvg` и конвертировать `ascii` арт в `svg`. Обратите внимание - по умолчанию будет svg в красном цвете, чтобы изменить цвет, необходимо изменить его определение [тут](docs/images/logo.svg#L76)

```console
$ curl 'http://www.figlet.org/fonts/doom.flf' -o /usr/share/figlet/doom.flf
$ curl 'http://www.figlet.org/fonts/larry3d.flf' -o /usr/share/figlet/larry3d.flf
$ figlet -f doom 'Golang'

 _____       _
|  __ \     | |
| |  \/ ___ | | __ _ _ __   __ _
| | __ / _ \| |/ _` | '_ \ / _` |
| |_\ | (_) | | (_| | | | | (_| |
 \____/\___/|_|\__,_|_| |_|\__, |
                            __/ |
                           |___/

$ aasvg --source --embed < docs/ascii.txt > docs/images/logo.svg
```

<!-- markdownlint-disable MD033 MD041 MD051 -->
<table align="center"><tr><td align="center" width="9999">
<img src="docs/images/cya.png" align="center" alt="Gopher">

<div align="center"> <sub> Gopher mascot. </sub> </div>

### [Cya!](#contents)

</td></tr></table>
<!-- markdownlint-enable MD033 MD041 MD051 -->

---

[^1]: 🛠️ Например можно использовать свой приватный реестр образов: `--build-arg image_registry=my-container-registry:1111/`
[^2]: 🛠️ За счёт скрипта [`go-install-approximately.sh`](scripts/go-install-approximately.sh) нас может не волновать полная версия Golang, мы можем передавать лишь приблизительно желаемую версию, а скрипт позаботится чтобы была выбрана последняя и актуальная из списка
