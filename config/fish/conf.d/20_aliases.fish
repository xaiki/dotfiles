#!/usr/bin/env fish

alias vlc 'G_SLICE always-malloc vlc'

#alias su 'export XAUTHORITY ${HOME}/.Xauthority ; sudo -s'
function sudo --description 'sudo wrapper'
    set -gx XAUTHORITY {$HOME}/.Xauthority
    command sudo $argv
end 

alias du "du -hcs"
alias df "df -h"

alias btgui "btdownloadgui --max_upload_rate 2 --responsefile"
alias btnc "btdownloadcurses --max_upload_rate 2 --responsefil"
alias btm "btlaunchmanycurses"

alias la "ls --color always -a"
alias ll "ls --color always -l"
alias lla "ls --color always -la"
alias lal "ls --color always -la"

alias egrep 'egrep --color tty -d skip'
alias fgrep 'fgrep --color tty -d skip'
alias grep 'grep --color tty -d skip'

alias less 'less -R'

alias rm 'rm -i'

alias clbin "curl -F 'clbin <-' 'https://clbin.com?<hl>'"

function e --description 'launch the best editor on the face of the earth'
    command emacsclient --alternate-editor emacs --no-wait $argv > /dev/null 2>&1 &
end
alias t "e -t"
alias v "$VISUAL"

alias br 'bts --mbox show'
