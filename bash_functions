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
__char_alias=
char_alias() {
        local args='\$@'
        [ "$2" = '--no-args' ] && args=''
        if [ "${1:1:1}" != '=' ]; then
                echo 'The alias name must be a single letter'
                return 1
        fi

        local char="${1:0:1}"
        local meaning="${1:2}"

        if eval "$char(){"$'\n'"$meaning $args"$'\n'"}"
        then __char_alias+="${char}"
        else return
        fi
}
reload() { welcome=false exec "${SHELL:-/bin/bash}"; }
reset() { [ -n "$TMUX" ] && tmux clear-history; command reset; }
theme() {
        local check=false
        local silent=false
        local chosen_theme
        while [ $# -gt 0 ]; do case "$1" in
            --check) check=true; shift;;
            --silent) silent=true; shift;;
            *) chosen_theme="$1"; shift;;
        esac done

        local PREFIX="$HOME/.config/alacritty"
        if cmp --silent "$PREFIX/dark_mode.toml" "$PREFIX/alacritty.toml"
        then THEME=dark
        else THEME=light
        fi

        if $check; then
            $silent || echo "$THEME"
            return 0
        fi

        case "$THEME:$chosen_theme" in
        *:light|dark:)
                THEME=light
                cp "$PREFIX/light_mode.toml" "$PREFIX/alacritty.toml"
                ;;
        *:dark|light:)
                THEME=dark
                cp "$PREFIX/dark_mode.toml" "$PREFIX/alacritty.toml"
                ;;
        *) return 1 ;;
        esac
}

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
command_not_found_handle() {
        if [ -n "$__char_alias_return" ]; then
                local out="$__char_alias_return"
                unset __char_alias_return
                return "$out"
        fi
        local comm="$1"
        local char="${comm:0:1}"

        bash -c "$@"
        __cnf_handle_distro "$comm"
        return 127
}
__cnf_handle_distro() {
        exists pacman && pkgfile "$1"
        #TODO: additional package managers
        true
}
__char_alias_runner() {
        # shellcheck disable=SC2086
        set -- $1
        local comm="$1"
        local char="${comm:0:1}"
        local len="${#comm}"

        shift
        if [ -n "$1" ]; then
                for ((i=0; i<len; i++)); do
                        $char "$@"
                done
        else
                for ((i=0; i<len; i++)); do
                        $char
                done
        fi
        __char_alias_return=$?
}
