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

rsync -v "$repo_dir/bash"           "$HOME/.config" --delete --recursive
rsync -v "$repo_dir/bash_profile"   "$HOME/.bash_profile"
rsync -v "$repo_dir/bashrc"         "$HOME/.bashrc"
