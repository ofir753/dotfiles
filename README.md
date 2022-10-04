# Ofir's DotFiles

# Editor - [Neovim (nvim)](https://github.com/neovim/neovim)
![nvim Screenshot](media/nvim/preview.png)

# Terminal - [alacritty](https://github.com/alacritty/alacritty) with [tmux](https://github.com/tmux/tmux) that runs [zsh](https://wiki.archlinux.org/title/zsh) with [zinit](https://github.com/zdharma-continuum/zinit)
![Terminal Screenshot](media/terminal.png)

# Task Managment - [taskwarrior-tui](https://github.com/kdheepak/taskwarrior-tui)
![TaskWarrior Screenshot](media/taskwarrior.png)

# My Workflow
Each workspace usually has 2 windows, terminal with tmux session attached and a webbrowser attached to the tmux session by [tmux-browser](https://github.com/ofirgall/tmux-browser).
The only workspace that uas more 2 windows is the `main` session which runs `slack`, `spotify` and other GUIS I must use. \
I jump between the workspace fast with [tmux-go](https://github.com/ofirgall/tmux-browser)

How I use nvim for [everything everywhere all at once](editors/nvim/README.md).

Q: Why don't you use i3? \
A: This way I have only 2 windows per workspace and I can jump between them with ctrl+tab I don't need tiling manager, I do everything from the terminal.

---

# WARNING
This repo is mainly for saving my dotfiles, I don't recommend to clone and install it. \
Feel free to use it as reference to your own dotfiles/config setup

## Custom Key Mapping
Done by dconf (gnome tweaks):
* Capslock is mapped to Escape - Don't move your hands when escaping insert mode.
* Both shift changes language - Don't move your hands while typing.
* Right Alt is mapped to backspace - Same idea.. (done with ~/.xmodmap too)
* Changing workspaces - Ctrl+Alt+H/J/K/L, Ctrl+Alt+Shift+H/J/K/L
* Maximizing/Restoring window - Super+J/K
* Move window to right/left - Super+H/L
* Move window across monitors - Shift+Super+H/J/K/L
* [tmux-go](https://github.com/ofirgall/tmux-go) shortcuts, Alt+G, Super+J/K/L/M

---

# Install
### Enable pre-commit hook for saving stuff (like dconf)
```bash
ln -s ../../pre-commit .git/hooks/pre-commit
```

### Set Git User
Set your `global` git user at ~/.git_user
```
[user]
	name = "Your Name"
	email = "yourname@gmail.com"
```

### Clone and Run
#### Config
* `touch ~/.remote_indicator` - if remote
* `touch ~/.no_sudo_indicator` - if no sudo on machine
```bash
git clone https://github.com/ofirgall/dotfiles.git && cd dotfiles && ./install
```

### Install TamperMonkey scripts
* Install [TamperMonkey](https://www.tampermonkey.net/)
* View the the [tampermonkey scripts](tampermonkey) as raw

## TODO Clean
* on top of each setup have the githublink
* require standard
* everything to "
* change folder structure (make some thinking)
	* packer.lua -> plugin_list.lua (in main)

---
## TODO
### Important
* nvim - solve https://github.com/neovim/neovim/issues/18625 to be able to format async
* nvim - code compiler to volumez machines
* nvim - transfer telescope binds to <leader>
* nvim - try to default register to the void register and <leader> to actually copy
* nvim - integrate flog in diffview (TODOS)
* git - script for setting upstream remote in a fork
* git - script for changing http to ssh + set git user
* git - change the default git user to personal, and workspace to other
---
* nvim - hover on the function on current line, probably requires treesitter
* nvim - lsp lines put a special color in a error line to empahsise it isn't a code line
* nvim - git commit ft should take source from all buffers & git tree tickets
* nvim - function hydra, copy name to +y or y
* tmux - remove notifcation color in nova, to recreate attach to same session from two other windows (tmux link-window) and run stuff on the linked window
* nvim - lsp signature return value in virtual
* tmux - get all the command lines that ran in this window and let you choose from fzf pop up
* tmux - plugin to add relative line numbers in copy mode
* nvim - config illuminate new version
* playgrounds - create them on first install, like `cg` choose a language and open nvim in left side of tmux and right side leave a pane for run/compile
* nvim - custom textobjects, function name, better call (all call, the function that called)
* nvim - nvim-cmp sources from all buffers/git tree in gitcommit ft
* nvim - cmp-jira (https://gitlab.com/msvechla/cmp-jira)
* nvim - split_if_not_exist, dont add it to the jump list
* tmux - control window size like nvim

## TODO Takes time
* tmux - relative numbers in copy mode
* nvim - leap in nvim-tree
* nvim - git-messanger support multiple lines (maybe like gh)
* tmux - Neo-Oli/tmux-text-macros integrate tmux fzf menu
* tmux - Neo-Oli/tmux-text-macros better syntax for custom-macros
* nvim - autosuspend Lsp/nvim if not active
* nvim - on save session ignore more file like flog diffview fugitive and such
* zellij
* firenvim - paste
* nvim - fix neogen next/prev (collides with snippy (tab/s-tab))
* git squash - if master/base branch moved forward can't find the ref
* nvim - build & run + quickfix errors
* nvim - try distant one day
* tuis to try - slack, mail, calander, jira
* tmux-go
* when opening link ask to which session (can be in taskopen shortcut for now and later inside tmux-browser (maybe a webbrowser wrapper))
* backup non-dotfiles - tmux sessions, tasks of taskwarrior, nvim sessions
* backup firefox extnesions & settings
* tmux - better session workflow, session per feature:repo, fzf for features -> fzf for repo
* convert todos to tasks/issues


## Improvements Ideas
* nvim? - signature renaming using tree sitter and LSP
