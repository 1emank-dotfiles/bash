# 1emank's bash dotfiles

## What is this?

Quite self-explanatory, these are the dotfiles that define my Bash setup. It
has the following features between others:

- git integration: It shows you if your are in a git repo by showing the name
  of the active branch. It also shows how many items are in `git status -s`.
- Vi mode
- Termux integration
- Case insensitive autocomplete
- Lazy loaded fzf
- add_to_path function in .bash_profile: Checks if dir is already in $PATH
- rc_local function in .bashrc: Declares variables for easy cleanup. Similar to
  `local` but since these files are `source`d and not run, there's no easy
  mechanism to have temporal variables.

## Requirements

For the simplest and documented workflow you will need `make` and `rsync` to
take advantage of the Makefile (and probably `git` to copy the repo). A
Makefile command uses `tree` but it's not important. Feel free to follow the
instructions and use the Makefile or not.

## Instructions

You are free to do whatever you want with the files. Inspect, copy, paste,
partially or completely. But I recommend you to use the Makefile because it provides
the following commands.

If you use the Makefile you need to know about the watchlist file. It declares
the files and directories to be copied. The syntax is the following:

```
#/absolute/path
foo/bar
baz
```

The relative paths are interpreted as relative to `#/absolute/path`. You can
use POSIX variable expansion in the absolute path, like `#$HOME` or
`#$XDG_CONFIG_DIR/subdir`.

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
