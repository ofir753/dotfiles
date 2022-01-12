# Ofir's DotFiles

## Install
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

### Set Local Repo (for me)
Set `this repo` git user
```
git config user.email "your mail"
git config user.user "Ofir Gal"
```

### Clone and Run for Remote
```bash
git clone https://github.com/ofirgall/dotfiles.git && cd dotfiles && sudo echo a && ./install --config-file remote.conf.yaml && touch ~/.remote_indicator
```

### Clone and Run for PC
```bash
git clone https://github.com/ofirgall/dotfiles.git && cd dotfiles && sudo echo a && ./install
```

Incase you are using windows terminal add `windows_terminal_binds.json` to your windows terminal

### Install Fonts for Terminal Icons
* [Normal](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf)

---

## TODO
* spt - reslove https://github.com/Rigellute/spotify-tui/issues/518
* general - manage tasks with select_tmux_session
* dock-redock fix
* git squash - if master/base branch moved forward can't find the ref
* tmux - ssh connection when asked
* tmux - not suspended (not active) change status colors 
* tmux - cpu & ram usage
* nvim - stop lsp server on background
* nvim - lsp status
* nvim - color for nvim-gps
* nvim - smaller quickfix list
* nvim - fix pair if already insert on pair 
* nvim - c-d remap to something else
* nvim - surround replaced colors
* nvim - jump to matching ()
* nvim - nN doesnt work good
* nvim - TSLabel is like keyword, need different color
* nvim&tmux - C-hjkl to move in panes/splits, resize splits with tmux binds too?
* terminal - avoid using arrows in terminal
* tmux - copy cursor not same as vim?
* nvim - session manager still makeing trouble
* nvim - split all config (lua config maybe), keybindings in one place will be nice, large plugin inits
* nvim - copy path/relative path & find with already inputed glob
* nvim - https://github.com/pechorin/any-jump.vim
* nvim - build & run + quickfix errors
* nvim-git - reset lines (not very useful in gitsigns)
* nvim-git - history date&authro with search
* nvim-git - go to changed line/file on git history (telescope)
* nvim-git - git add -i alternative
* nvim - try distant one day
* tmux - learn copy-mode-vi
* tmux - make a valid fix for suspend/resume copy like copycat mode

---

## How to set VIM binds with Capslock modifer
### Sources
* https://wiki.archlinux.org/title/X_keyboard_extension#Caps_hjkl_as_vimlike_arrow_keys
* https://ts-cubed.github.io/roam/20210525184028-keyboard_mapping.html#orgc60c5b3

`/usr/share/X11/xkb/types/complete`
```
default xkb_types "complete" {
	...
	type "CUST_CAPSLOCK" {
       modifiers= Shift+Lock; 
       map[Shift] = Level2;            //maps shift and no Lock. Shift+Alt goes here, too, because Alt isn't in modifiers.
       map[Lock] = Level3;
       map[Shift+Lock] = Level3;       //maps shift and Lock. Shift+Lock+Alt goes here, too.
       level_name[Level1]= "Base";
       level_name[Level2]= "Shift";
       level_name[Level3]= "Lock";
   };
};
```
`/usr/share/X11/xkb/types/complete`
```
default xkb_compatibility "complete" {
	...
    interpret Caps_Lock+AnyOfOrNone(all) {
       action= SetMods(modifiers=Lock);
   };
};
```
`/usr/share/X11/xkb/symbols/us`
```
key <AE04> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               4,               dollar,        End ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<END>, clearmods=Lock) ]
    };
key <AE10> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               0,               parenright,        Home ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<HOME>, clearmods=Lock) ]
    };
key <AD07> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               u,               U,        Prior ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<PGUP>, clearmods=Lock) ]
    };
key <AC03> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               d,               D,        Next ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<PGDN>, clearmods=Lock) ]
    };
key <AC06> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               h,               H,        Left ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<LEFT>, clearmods=Lock) ]
    };
key <AC07> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               j,               J,       Down ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<DOWN>, clearmods=Lock) ]
    };
key <AC08> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               k,               K,       Up ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<UP>, clearmods=Lock) ]
    };
key <AC09> {
        type= "CUST_CAPSLOCK",
        symbols[Group1]= [               l,               L,       Right ],
        actions[Group1]= [      NoAction(),     NoAction(),    RedirectKey(Keycode=<RGHT>, clearmods=Lock) ]
    };
```
