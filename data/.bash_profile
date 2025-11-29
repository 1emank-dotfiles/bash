#
# ~/.bash_profile
#
# vi: ft=sh
#
[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] &&
        source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

add_to() {
        local variable="$1"
        # shellcheck disable=SC2155
        local dir="$(realpath "$2" 2>/dev/null)"
        local previous
        [ -n "$variable" ] || return 1
        [ -d "$dir" ] || return 1

        case "$(eval echo ':${'"$variable"'}:' )" in
        *":${dir}:"*) ;;
        *)
            # shellcheck disable=SC2016
            previous='${'"$variable"':+$'"$variable"':}'
            eval "$variable=$(eval echo "$previous")$dir" ;;
        esac
}

add_to MANPATH "$HOME/.local/share/man"

add_to PATH "$HOME/.local/bin"
add_to PATH "$HOME/.cargo/bin"

export MANPATH
export PATH

export EDITOR=nvim
export PAGER=less
export BROWSER=brave
export LESS='-R --mouse'

[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
