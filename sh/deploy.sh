#!/bin/sh
set -e
root="${1?Unless you know what you are doing, run through the Makefile}"

exit_code=0
while read -r file; do
        if [ -d "./data/$file/" ]
        then rsync -i "./data/$file/" "$root/$file/" \
                --delete --recursive --mkpath || exit_code=$?
        elif [ -f "./data/$file" ]
        then rsync -i "./data/$file" "$root/$file" --mkpath || exit_code=$?
        fi
done < watchlist

exit $exit_code
