### SETTINGS ###
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g display-panes-time 800
set -g display-time 1000
set -g monitor-activity off
set -g visual-activity off
set -g status-left-length 1000
set -g status-right-length 1000
set -g set-titles-string "#S - TMUX"
set -g set-titles on

set -q -g status-utf8 on
setw -q -g utf8 on

### PANE COLORS ###
set -g window-style 'bg=#00121f'
set -g window-active-style 'bg=#000000'

### THEME ###
set -g @nova-nerdfonts true
set -g @nova-nerdfonts-left 
set -g @nova-nerdfonts-right 

set -g @nova-pane "#I #W"
set -g @nova-rows 0

### COLORS ###
sides_color="#a89984 #282828"
active_tab_bg="#504945"
active_tab_color="$active_tab_bg #ddc7a1"

inactive_bg="#282923" # Same as nvim background
inactive_fg="#ddc7a1"
active_bg=$active_tab_bg
active_fg="#ddc7a1"

suspended_inactive_bg="#1f1c1b"
suspended_inactive_fg="#000000"
suspended_active_bg="#2b2726"
suspended_active_fg="#000000"

set -gw window-status-current-style bold
set -g "@nova-status-style-bg" "$inactive_bg"
set -g "@nova-status-style-fg" "$inactive_fg"
set -g "@nova-status-style-active-bg" "$active_bg"
set -g "@nova-status-style-active-fg" "$active_fg"

set -g "@nova-pane-active-border-style" "#44475a"
set -g "@nova-pane-border-style" "#fad7ab"
set-window-option -g mode-style "bg=#27406b,fg=#ffffff"

### STATUS BAR ###
set -g @nova-segment-prefix "#{?client_prefix,PREFIX,}"
set -g @nova-segment-prefix-colors "$active_tab_color"

set -g @nova-segment-synced "#{?pane_synchronized,SYNCED,}"
set -g @nova-segment-synced-colors "$active_tab_color"

set -g @nova-segment-zoomed "#{?window_zoomed_flag,ZOOMED,}"
set -g @nova-segment-zoomed-colors "$active_tab_color"

set -g @nova-segment-session "#{session_name}"
set -g @nova-segment-session-colors "$sides_color"

set -g @nova-segment-whoami "#(whoami)@#h"
set -g @nova-segment-whoami-colors "$sides_color"

set -g @nova-segment-suspended "#{@suspended_mode}"
set -g @nova-segment-suspended-colors "$sides_color"

set -g @nova-segments-0-left "session"
set -g @nova-segments-0-right "zoomed synced prefix whoami"

### SUSPENDED MODE ###
set -g @suspend_on_resume_command "tmux \
	set -u status-style \\; \
	set -u window-status-format \\; \
	set -u window-status-current-format \\; \
	run -b 'bash $HOME/.tmux/plugins/tmux-nova/scripts/nova.sh'"

set -g @suspend_on_suspend_command "tmux \
	set window-status-current-format '#[fg=$suspended_active_fg]#[bg=$suspended_inactive_bg]\#I \#W' \\; \
	set status-style 'fg=$suspended_inactive_fg,bg=$suspended_inactive_bg'"

set -g @plugin 'o0th/tmux-nova'
