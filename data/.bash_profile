#
# ~/.bash_profile
#
# vi: ft=sh
#
[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] &&
        source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

[ -n "$__BASH_PROFILE_SOURCED" ] && return

normalize_search_variable() {
        local array out
        local list="${1?missing PATH-like string}"
        mapfile -t array < <(echo "$list" | tr : '\n' | awk 'NF && !x[$0]++')

        out=$(( ${#array[@]} -1 ))
        printf '%s:' "${array[@]:0:$out}"
        printf '%s' "${array[$out]}"
}

PATH="$(normalize_search_variable "$HOME/.local/bin:$HOME/.cargo/bin:$PATH")"
MANPATH="$(normalize_search_variable "$HOME/.local/share/man:$MANPATH")"
# Is better that the search variables are at the end to prioritize the custom
# sources. Otherwise, the custom sources won't be loaded when there's already a
# system version (which is not usually what you want).

MANPATH=":$MANPATH" #leading ":" adds sources from /etc/man_db.conf

export MANPATH
export PATH

export EDITOR=nvim
export PAGER=less
export BROWSER=brave

export __BASH_PROFILE_SOURCED=1
