#!/bin/sh
set -e
root="${1?Unless you know what you are doing, run through the Makefile}"

exit_code=0
while read -r file; do
        if [ -d "$root/$file/" ]
        then rsync -i "$root/$file/" "./backup/$file/" \
                --delete --recursive --mkpath || exit_code=$?
        elif [ -f "$root/$file" ]
        then rsync -i "$root/$file" "./backup/$file" --mkpath || exit_code=$?
        fi
done < watchlist

exit $exit_code
