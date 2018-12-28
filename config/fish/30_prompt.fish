#!/usr/bin/env fish
set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)
set bcyan (set_color -o cyan)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch -o cyan
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
#set __fish_git_prompt_char_upstream_ahead '+'
#set __fish_git_prompt_char_upstream_behind '-'
set ___fish_git_prompt_color_prefix ':'

set fish_prompt_pwd_dir_length 32

function fish_prompt
    set last_status $status
    set_color red
    printf '┌['
    set_color -o brmagenta
    printf (prompt_pwd)
    set_color -o yellow
    printf '%s' (__fish_git_prompt "%s")
    set_color red
    printf ']\n└['
    printf (prompt_hostname)
    set_color red
    printf '] '
  set_color normal
end
