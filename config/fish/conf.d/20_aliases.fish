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

alias egrep 'egrep --color'
alias fgrep 'fgrep --color'
alias grep 'grep --color'

alias less 'less -R'

alias rm 'rm -i'

alias clbin "curl -F 'clbin <-' 'https://clbin.com?<hl>'"

if which flatpak 2> /dev/null > /dev/null && flatpak list | grep org.gnu.emacs > /dev/null
    set emacs 'flatpak run org.gnu.emacs'
    set emacsclient 'flatpak run --command=emacsclient org.gnu.emacs'
else
    for e in emacs emacs-snapshot
        if test -e /usr/bin/$e
            set emacs /usr/bin/$e
            set emacsclient /usr/bin/$e.emacsclient
        end
    end
end

function e --description 'launch the best editor on the face of the earth'
    command flatpak run --command="emacsclient" org.gnu.emacs --alternate-editor emacs --no-wait $argv > /dev/null 2>&1 &
end
alias t "e -t"
alias v "$VISUAL"

alias br 'bts --mbox show'
