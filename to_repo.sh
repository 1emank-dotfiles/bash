#!/bin/sh
set -e
check_dependencies() {
        missing_deps=false
        while [ -n "$1" ]; do
                if ! command -v "$1" >/dev/null 2>&1; then
                        echo "$1" is missing 1>&2
                        missing_deps=true
                fi
                shift
        done
        if $missing_deps; then
                echo; echo The operation cannot proceed
                exit 1
        fi
}
check_dependencies rsync realpath dirname

repo_dir="$(dirname "$( realpath "$0")" )"

rsync -v "$HOME/.config/bash"   "$repo_dir" --delete --recursive
rsync -v "$HOME/.bash_profile"  "$repo_dir/bash_profile"
rsync -v "$HOME/.bashrc"        "$repo_dir/bashrc"
