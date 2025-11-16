#
# ~/.bash_profile
#
# vi: ft=sh
#

add_to_path() {
        [ -d "$1" ] || return
        local dir="$1"

        case ":${PATH}:" in
        *":${dir}:"*) ;;
        *) PATH="${PATH}:${dir}" ;;
        esac
}

# shellcheck disable=SC2155
command -v manpath >/dev/null 2>&1 &&
    export MANPATH="$(manpath -g):${HOME}/.local/share/man"

export EDITOR=nvim
export PAGER=less
export BROWSER=brave
export LESS='-R --mouse'

add_to_path "${HOME}/.local/bin"
add_to_path "${HOME}/node_modules/.bin"
add_to_path "${HOME}/.cargo/bin"
add_to_path "${HOME}/.nix-profile/bin"

export PATH

[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
