#
# ~/.bashrc
#
# vi: ft=sh
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
HISTIGNORE=ls:pwd:clear:reload:reset

[ -f "$HOME/.config/bash/functions" ] && source "$HOME/.config/bash/functions"
[ -f "$HOME/.config/bash/aliases" ] && source "$HOME/.config/bash/aliases"
[ -f "$HOME/.config/bash/extra" ] && source "$HOME/.config/bash/extra"

use_color && {
        SUCCESS=$'\[\E[92m\]'   #\[$(tput setaf 10)\]
        TITLE=$'\[\E[94m\]'     #\[$(tput setaf 12)\]
        ERROR=$'\[\E[91m\]'     #\[$(tput setaf 9)\]
        WARNING=$'\[\E[93m\]'   #\[$(tput setaf 11)\]
        RESET=$'\[\E(B\E[m\]'   #\[$(tput sgr0)\]
}

__PROMPT_COMMAND() {
        __errno=$?
        [ "$__errno" = 0 ] && __errno=
        if __branch="$(git branch --show-current 2>/dev/null)"; then
                __status="$(git status -s 2>/dev/null | wc -l)"
                [ "$__status" = 0 ] && __status=
        else
                __status=
        fi
}

PROMPT_COMMAND=__PROMPT_COMMAND

case "$HOME" in
*termux*) #[USER@HOSTNAME:PWD], [PWD] in termux
        PS1="[${TITLE}\w${RESET}]" ;;
*)
        PS1="[${SUCCESS}\u@\h${RESET}:${TITLE}\w${RESET}]" ;;
esac

PS1+=`  #[git branch<status>] #if they exist
        `'${__branch:+'`
                `'['"${SUCCESS}"'$__branch${__status:+'`
                        `"$WARNING"'<'"$RESET"'$__status'"$WARNING"'>}'`
                `"${RESET}"']'`
        `'}'`

        #[$?] if different than 0
        `'${__errno:+'"$ERROR"'['"$RESET"'$__errno'"$ERROR"']}'"$RESET"`

        # '$' if normal user, '#' if root
        `"$({ [ $UID = 0 ] && echo '# '; } || echo '$ ')"


## Opts
shopt -s histappend
shopt -s checkwinsize
shopt -s nullglob
bind 'set completion-ignore-case on'

if [ ! -f /tmp/bash_welcome_$UID ] && [ -z "${TMUX}${NVIM}" ]; then
        :> /tmp/bash_welcome_$UID
        if exists fastfetch; then
                if $color_prompt
                then fastfetch
                else fastfetch --pipe
                fi
        #TODO: else some fallback, maybe
        fi
fi

unset \
    SUCCESS \
    TITLE \
    ERROR \
    WARNING \
    RESET \
    color_prompt \
    use_color
