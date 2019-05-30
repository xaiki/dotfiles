#!/usr/bin/env fish
set fish_greeting
set -gx local_fish ~/.config/fish/(hostname).fish

source ~/.config/fish/conf.d/*.fish
test -f $local_fish && source $local_fish

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[ -f /home/xaiki/.config/yarn/global/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish ]; and . /home/xaiki/.config/yarn/global/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish
