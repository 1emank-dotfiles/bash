#!/bin/sh
set -e
root="$1"

case "$root" in
//*) exit 1;;
esac

[ -d "$root" ]
