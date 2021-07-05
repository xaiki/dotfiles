#!/usr/bin/env fish

#alias su 'export XAUTHORITY ${HOME}/.Xauthority ; sudo -s'
function sudo --description 'sudo wrapper'
    set -gx XAUTHORITY {$HOME}/.Xauthority
    command sudo $argv
end 

alias du "du -hcs"
alias df "df -h"

if command -v exa > /dev/null
    alias ls "exa"
    alias lstree "exa --long --tree"
end
if command -v lsd > /dev/null
    alias ls "lsd"
end
if command -v bat > /dev/null
    alias cat "bat"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    function tail --description 'uses bat with tail'
        command /usr/bin/tail $argv | bat --paging=never -l log
    end
end
if command -v delta > /dev/null
    set -gx GIT_PAGER delta
end
if command -v dust > /dev/null
    alias du "dust"
end
if command -v duf > /dev/null
    alias df "duf"
end

alias ip "ip -c=auto"

alias egrep 'egrep --color'
alias fgrep 'fgrep --color'
alias grep 'grep --color'

alias less 'less -R'

alias rm 'rm -i'

alias clbin "curl -F 'clbin <-' 'https://clbin.com?<hl>'"

if command -v flatpak 2> /dev/null > /dev/null && flatpak list | grep org.gnu.emacs > /dev/null
    set emacs flatpak run org.gnu.emacs
    set emacsclient flatpak run --command=emacsclient org.gnu.emacs
else
    for e in emacs emacs-snapshot
        if test -e /usr/bin/$e
            set emacs /usr/bin/$e
            set emacsclient /usr/bin/emacsclient.$e
        end
    end
end

set -gx EDITOR env TMPDIR=/tmp $emacsclient -a nano
set -gx VISUAL env TMPDIR=/tmp $emacsclient -a nano

function e --description 'launch the best editor on the face of the earth'
    command $emacsclient --alternate-editor emacs --no-wait $argv > /dev/null 2>&1 &
end

alias t "e -t"
alias v "$VISUAL"

alias br 'bts --mbox show'
