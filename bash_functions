#
# ~/.config/bash_functions
#
# vi: ft=sh
#

## Functions

exists() { command -v "$1" >/dev/null 2>&1; }
launch() {
        case "$1" in
        -q) shift; { ( launch "$@" & ) } >/dev/null 2>&1; return;;
        '') return 1;;
        *) nohup "$@" >/dev/null 2>&1 & return;;
        esac
}
reload() { exec "${SHELL:-/bin/bash}"; }
reset() { [ -n "$TMUX" ] && tmux clear-history; command reset; }

## RC
use_color() {
        # shellcheck disable=SC2154
        case "$TERM:$color_prompt" in
        *:false) return 1 ;;
        xterm-color:* | *-256color:* | alacritty:* | foot:* )
                if tput sgr0 >/dev/null 2>&1
                then return 0
                else return 1
                fi ;;
        *) return 1 ;;
        esac
}
script_is_old() {
        local program="$1"
        [ ! -f "$HOME/.config/term/$program" ] && return 0

        local now modified age one_week
        now="$( date '+%s' )"
        modified="$( stat -c '%Y' "$HOME/.config/term/$program" 2>/dev/null )"
        age="$(( "$now" - "$modified" ))"
        one_week="$(( 7 *24 *60 *60 ))"

        if [ "$age" -gt "$one_week" ]
        then return 0
        else return 1
        fi
}
update_script(){
        local comm="$1"
        if [ -n "$comm" ] && exists "$comm" && script_is_old "$comm"; then
                launch -q "$@" ||
                        printf 'Error writing the "%s" script\n' "$comm" 1>&2
        fi
}
