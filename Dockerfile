ARG BOOTSTRAP_SOURCE=ghcr.io/void-linux/docker-bootstrap
ARG BOOTSTRAP_VERSION=latest-x86_64-musl
FROM ${BOOTSTRAP_SOURCE}:${BOOTSTRAP_VERSION} as build
COPY keys/* /target/var/db/xbps/keys/
COPY noextract.conf /target/etc/xbps.d/noextract.conf
ARG REPOSITORY=https://mirror.yandex.ru/mirrors/voidlinux

# musl lib, because it is smaller.
ARG ARCH=x86_64-musl

# binary files which needed only for image building
RUN xbps-install -yMU \
    --repository=${REPOSITORY}/current/musl \
    xbps busybox-huge binutils

# busybox instead of common coreutils, because it is smaller
# download packages to /target folder
RUN XBPS_ARCH=${ARCH} xbps-install -ySMU \
        --repository=${REPOSITORY}/current/musl \
        -r /target \
        xbps base-files busybox ncurses-term python3-pip python3-psycopg2 visidata nvi

# symbolinc links for busybox
RUN for util in $(busybox --list) ; do [ ! -f /target/usr/bin/$util ] && ln -svf /usr/bin/busybox /target/usr/bin/$util ; done

# strip symbols from binary files
RUN strip /target/usr/lib* /target/usr/bin* || exit 0
# remove cache
RUN rm -rf /target/var/cache

FROM scratch
LABEL org.opencontainers.image.source https://github.com/void-linux/void-docker

COPY --from=build /target /

RUN python3 -m pip install openpyxl lxml

RUN xbps-reconfigure -a

CMD sh
