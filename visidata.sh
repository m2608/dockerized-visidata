#!/bin/sh

if test -n "$1" -a -f "$1"; then
    host_path=`realpath "$1"`
    cont_path="/root/`basename "$host_path"`"

    docker run --rm -it \
        -e TERM=xterm-256color \
        -e EDITOR=nvi \
        -v "$host_path":"$cont_path" \
        void:visidata \
        visidata "$cont_path"
elif test -n "$1" -a "${1:0:13}" = "postgresql://"; then
    db_string="$1"

    docker run --rm -it \
        -e TERM=xterm-256color \
        -e EDITOR=nvi \
        --network="host" \
        void:visidata \
        visidata "$db_string"
else
    echo "Usage: `basename $0` <file>|<postgresql db>"
    exit 1
fi
