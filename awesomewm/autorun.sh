#!/usr/bin/env sh

xset r rate 200 35 # Faster repeat rate
setxkbmap -option caps:escape # Capslock to escape

# Touchpad
xinput set-prop "DELL0A36:00 0488:101A Touchpad" 324 1 # Natural scrolling
xinput set-prop "DELL0A36:00 0488:101A Touchpad" 347 1 # Tapping enabled
xinput set-prop "DELL0A36:00 0488:101A Touchpad" "libinput Scrolling Pixel Distance" 40
xinput set-prop "DELL0A36:00 0488:101A Touchpad" "libinput High Resolution Wheel Scroll Enabled" 0

# Mouse speed at home
xinput --set-prop 'Glorious Model O Wireless' 'libinput Accel Speed' -0.5

# Mouse speed at work
xinput --set-prop 'pointer:Logitech MX Master 3' 'libinput Accel Speed' -0.6

xmodmap ~/.xmodmaprc 2> /dev/null # key mapping, xev to see keys

# Start user services at ~/.config/systemd/user
systemctl --user start $(ls ~/.config/systemd/user/* | xargs basename)

echo 'done'
