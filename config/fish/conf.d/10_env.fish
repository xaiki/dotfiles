#!/usr/bin/env fish

test -f ~/.env && . ~/.env

set -gx PATH \
"./node_modules/.bin" \
"/usr/lib/ccache" \
"$HOME/bin" \
"$HOME/.local/bin" \
"$HOME/.yarn/bin" \
"$HOME/.cargo/bin" \
$PATH

set -gx EMAIL xaiki@evilgiggle.com
set -gx FULLNAME Niv Sardi

set -gx DEBEMAIL xaiki@debian.org
set -gx DEBFULLNAME $FULLNAME

#set -gx GTI_AUTHOR_NAME $FULLNAME
#set -gx GIT_COMMITTER_NAME $FULLNAME
#set -gx GIT_AUTHOR_EMAIL $DEBEMAIL
#set -gx GIT_COMMITTER_EMAIL $DEBEMAIL

if which emacsclient.emacs-snapshot > /dev/null
	set -gx EMACS_FLAVOUR .emacs-snapshot
end

#set -gx LANG `echo $LANG | sed s/utf8/UTF8/`
set -gx CVS_RSH ssh
set -gx MANWIDTH 80
set -gx EDITOR env TMPDIR /tmp emacsclient{$EMACS_FLAVOUR} -a nano
set -gx VISUAL env TMPDIR /tmp emacsclient{$EMACS_FLAVOUR} -a nano
set -gx CCACHE_DIR $HOME/.ccache

set -gx RLWRAP_HOME ~/.cache/rlwrap/
set -gx GTK_IM_MODULE xim
set -gx MOZ_USE_XINPUT2 1

set -gx LC_MESSAGES C
set -gx LC_ALL 

set -gx MOSH_TITLE_NOPREFIX true

set -gx HOME (readlink -f $HOME)
