#!/bin/sh
set -e

missing_deps=false
exists() { 
    if ! command -v "$1" >/dev/null 2>&1; then
        echo The program "$1" is missing, you need to install it 1>&2
        missing_deps=true
    fi
}

exists git
exists rsync
exists realpath
exists dirname

$missing_deps && exit 1

repo_dir="$(dirname "$( realpath "$0")" )"

rsync "$repo_dir/bash_aliases"   "$HOME/.config/bash_aliases"
rsync "$repo_dir/bash_functions" "$HOME/.config/bash_functions"
rsync "$repo_dir/bash_profile"   "$HOME/.bash_profile"
rsync "$repo_dir/bashrc"         "$HOME/.bashrc"
