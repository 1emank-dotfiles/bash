#
# ~/.config/bash_aliases
#
# vi: ft=sh
#

nv() {
        case "$NVIM::$@" in
        '::') nvim ;;
        '::'*) nvim "$@" ;;
        '*::') nvr ;;
        '*::'*) nvr "$@" ;;
        esac
}
tmux() {
        if [ -n "$1" ]
        then command tmux "$@"
        else command tmux attach 2>/dev/null || command tmux
        fi
}
alias nman='NVIM_LISTEN_ADDRESS=/tmp/nvimsocket MANPAGER="nvim +Man!" man'
alias work='launch -q brave --user-data-dir="$HOME/.local/work"'
alias luaf='stylua --config-path ~/.config/stylua.toml'

char_alias x='pushd ..'
char_alias z='popd'
char_alias t='echo'
alias c='pushd'

alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'

notes() {
        [ -z "$NOTES_DIR" ] && local NOTES_DIR="$HOME/repos/notes"
        [ -d "$NOTES_DIR" ] || return 1

        case "$(pwd)" in
        "$NOTES_DIR"*)
                git add . &&
                        git commit -m "$(git diff --cached --name-status)" &&
                        git push origin main

                if [ -n "$__notes_uncd" ]; then
                        cd "$__notes_uncd" || return 1
                        unset __notes_uncd
                fi
                ;;
        *)
                __notes_uncd="$(pwd)"
                cd "$NOTES_DIR" || return 1
                git pull origin main
                ;;
        esac
}
upa_distro() {
        local SUDO="$1"
        if exists pacman; then
                $SUDO pacman -Syu --noconfirm
                exists paru && paru -Syu --noconfirm && return
                exists yay && yay -Syu --noconfirm && return 
                return 0
        fi
        if exists pkg; then
                $SUDO pkg upgrade -y && exists apt &&
                        $SUDO apt autoremove --purge -y
                return 0
        fi
        if exists apt; then
                $SUDO apt full-upgrade -y && $SUDO apt autoremove --purge -y
                return 0
        fi
}
update_all() {
        local SUDO root
        if [ "$EUID" -eq 0 ]
        then root=true
        else root=false
        fi
        exists sudo && ! $root && SUDO=sudo

        upa_distro $SUDO
        nvim --headless '+Lazy! sync' +qa
        exists rustup && ! $root && rustup update
        true
}
alias upa=update_all

fzf_programs() {
    return 1
}
alias ht='npm create parcel vanilla'
