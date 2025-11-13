#
# ~/.bashrc
#
# vi: ft=sh
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

rc_vars=()
rc_local() {
        local name
        local value
        IFS='=' read -r name value <<< "$1"
        eval "$name='$value'"
        rc_vars+=("$name")
}
rc_unset() {
        local var
        for var in "${rc_vars[@]}"; do
                unset "$var"
        done
        unset rc_local
        unset rc_unset
        unset rc_vars
}

HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
HISTIGNORE=ls:pwd:clear:reload:reset

## Opts

shopt -s histappend
shopt -s checkwinsize
shopt -s nullglob
set -o vi #some macros conflicts with fzf, so fzf has to be after this
bind 'set completion-ignore-case on'

## Files

[ -f "$HOME/.config/bash/functions" ] && source "$HOME/.config/bash/functions"
[ -f "$HOME/.config/bash/aliases" ] && source "$HOME/.config/bash/aliases"
[ -f "$HOME/.config/bash/extra" ] && source "$HOME/.config/bash/extra"

## PS1

use_color && {
        rc_local SUCCESS=$'\[\E[92m\]'   #\[$(tput setaf 10)\]
        rc_local TITLE=$'\[\E[94m\]'     #\[$(tput setaf 12)\]
        rc_local ERROR=$'\[\E[91m\]'     #\[$(tput setaf 9)\]
        rc_local WARNING=$'\[\E[93m\]'   #\[$(tput setaf 11)\]
        rc_local RESET=$'\[\E(B\E[m\]'   #\[$(tput sgr0)\]
}

rc_local TERMUX

case "$HOME" in
*termux*) TERMUX=true ;;
*) TERMUX=false ;;
esac

if $TERMUX
then PS1="[${TITLE}\w${RESET}]"
else PS1="[${SUCCESS}\u@\h${RESET}:${TITLE}\w${RESET}]"
fi

if exists git; then
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
        #[git branch<status>][$?] (only if they exist)
        PS1+='${__branch:+'`
                `'['"${SUCCESS}"'$__branch${__status:+'`
                        `"$WARNING"'<'"$RESET"'$__status'"$WARNING"'>}'`
                `"${RESET}"']'`
        `'}'`
        `'${__errno:+'"$ERROR"'['"$RESET"'$__errno'"$ERROR"']}'"$RESET"
fi

if [ $UID = 0 ]
then PS1+="$WARNING"'# '"$RESET"
else PS1+='$ '
fi

## Welcome

if $TERMUX && exists fastfetch; then #implies color support
        if [ -f ~/../../cache/bash_welcome ]; then
                fastfetch
                rm ~/../../cache/bash_welcome
        else
                :> ~/../../cache/bash_welcome
        fi
elif
        exists fastfetch &&
        [ ! -f /tmp/bash_welcome_$UID ] &&
        [ -z "${TMUX}${NVIM}" ]
then
        :> /tmp/bash_welcome_$UID
        if [ -n "$SUCCESS" ] #implies color support
        then fastfetch
        else fastfetch --pipe
        fi
fi

rc_unset #cleanup
