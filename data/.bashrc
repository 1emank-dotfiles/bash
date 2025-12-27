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
HISTIGNORE=ls:l:ll:la:pwd:clear:reload:reset

## Opts

shopt -s histappend
shopt -s nullglob
shopt -s globstar
shopt -s autocd
set -o vi
bind 'set completion-ignore-case on'

## Files

[ -f "$HOME/.config/bash/functions" ] && source "$HOME/.config/bash/functions"
[ -f "$HOME/.config/bash/aliases" ] && source "$HOME/.config/bash/aliases"
[ -f "$HOME/.config/bash/extra" ] && source "$HOME/.config/bash/extra"

## PS1

RC_VARS=(RC_VARS COLOR_PROMPT)
# COLOR_PROMPT is intended to be provided at launch like:
#   `COLOR_PROMPT=false bash`
case "$TERM:$COLOR_PROMPT" in
*:false);;
xterm-color:* | *-256color:* | alacritty:* | foot:* | xterm-kitty:* )
        if tput sgr0 >/dev/null 2>&1; then
                RC_VARS+=(SUCCESS TITLE ERROR WARNING RESET)

                SUCCESS=$'\[\E[92m\]'   # \[$(tput setaf 10)\]
                TITLE=$'\[\E[94m\]'     # \[$(tput setaf 12)\]
                ERROR=$'\[\E[91m\]'     # \[$(tput setaf 9)\]
                WARNING=$'\[\E[93m\]'   # \[$(tput setaf 11)\]
                RESET=$'\[\E(B\E[m\]'   # \[$(tput sgr0)\]
        fi;;
esac

case "$HOME" in
*termux*) PS1="[${TITLE}\w${RESET}]" ;;
*) PS1="[${SUCCESS}\u@\h${RESET}:${TITLE}\w${RESET}]" ;;
esac

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
then PS1+="$WARNING# $RESET"
else PS1+='$ '
fi

for var in "${RC_VARS[@]}"; do
        unset -v "$var"
done
