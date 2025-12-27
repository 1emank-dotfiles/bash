#!/bin/sh
set -e
root="${1?Unless you know what you are doing, run through the Makefile}"

exit_code=0
while read -r file; do
        if [ -d "./backup/$file/" ]
        then rsync -i "./backup/$file/" "$root/$file/" \
                --delete --recursive --mkpath || exit_code=$?
        elif [ -f "./backup/$file" ]
        then rsync -i "./backup/$file" "$root/$file" --mkpath || exit_code=$?
        fi
done < watchlist

exit $exit_code
