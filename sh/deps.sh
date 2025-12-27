#!/bin/sh
set -e
dep() {
        if ! command -v "$1" >/dev/null 2>&1; then
                echo Missing dependency: "$1"
                return 1
        fi
        return 0
}

missing=false
while [ -n "$1" ]; do
    dep "$1" || missing=true
    shift
done

! $missing
