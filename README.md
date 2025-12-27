# 1emank's Bash dotfiles

## What is this?

Quite self-explanatory, these are the dotfiles that define my Bash setup. It
has the following features between others:

- git integration: It shows the status and branch if you are in a repo
- Vi mode
- Termux integration
- Case insensitive tab completion
- Lazy loaded fzf (if you have it installed)
- `add_to PATH or PATH-like`: Checks if dir is already in the variable

## Requirements

Everything is optional:

- `make`: To take advantage of the Makefile
- `rsync`: Same as above. It will install the files.
- `git`: To clone the repo and for the git integration
- `tree`: (Very optional) See `make tree` in this README

## Instructions

You are free to do whatever you want with the files. Inspect, copy, paste,
partially or completely. But I recommend you to use the Makefile because it provides
the following commands.

### Main commands

- `make tree` (or just `make`): You'll see an overview of the file tree that
  would be installed (needs the `tree` command).

- `make install`: It will make a backup of your files and it will install the
  files of the repo.

- `make recover`: To uninstall the repo files and deploy your backup.

### Other

Some of this commands run automatically as a requirement for other commands.

- `make backup`: To make a backup manually.

- `make deploy`: To install without doing a backup.

- `make deps`: To check dependencies, if you fulfill the requirements, nothing
  will happen.

- `make repo`: To modify repo with your files.

- `make valid_root`: To test if your watchlist has a valid root defined in the first line

## Note

If you want to make your own repo using my Makefile you need to know about the
watchlist file. It declares the files and directories to be copied. The syntax
is the following:

```
#/absolute/path
foo/bar
baz
```

The relative paths are interpreted as relative to `#/absolute/path`. You can
use POSIX variable expansion in the absolute path, like `#$HOME` or
`#$XDG_CONFIG_DIR/subdir`.

IMPORTANT: All items must end without slash "/". By now it's not super
safe/ergonomic so this is important, although in the future it might be a
better implementation of it (it's a one-liner, what did I expect?).

