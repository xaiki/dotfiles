#!/usr/bin/env fish
set themes_length (cat ~/.config/fish/themes.json | sed s/"}"/"\n"/g | sed s/".{"//g | grep -e '"name"' | wc -l)
set theme_id (math (printf "%d" 0x(hostname | shasum | cut -c1-6))%$themes_length)

set colors (string split ' ' (cat ~/.config/fish/themes.json | sed s/"}"/"\n"/g | sed s/".{"//g | grep -e '"name"' | head -$theme_id | tail -1 | sed s/'"#'/"\n"/g | cut -c1-6 | grep -ve '"' | xargs))

set normal (set_color normal)

set cyan $colors[7]
set magenta $colors[6]
set blue $colors[5]
set yellow $colors[4]
set green $colors[3]
set red $colors[2]
set gray $colors[1]
set bcyan $colors[6]

set main_color $red
set seg_color $blue

if test -e "$TOOLBOX_PATH"
    if test "$LANG" = "C.UTF-8"
        set toolbox "📦"
        set main_color green
    else
        set -x LANG C.UTF-8
        fish
        exit
    end
end

# Fish git prompt
set __fish_git_prompt_showdirtystate 'no'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'no'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch -o cyan
set __fish_git_prompt_color_upstream_ahead $green
set __fish_git_prompt_color_upstream_behind $red

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
    set_color $main_color
    printf '┌['
    set_color -o $magenta
    printf (prompt_pwd)
    set_color -o $yellow
    printf '%s' (__fish_git_prompt "%s")
    set_color $main_color
    printf ']\n└[%s' $toolbox
    printf (prompt_hostname)
    set_color $main_color
    printf '] '
    set_color normal
end

function fish_title
    id -un
    echo '@'
    prompt_hostname
    echo ':'
    pwd
    echo ' ' $argv
end

function fish_greeting
    echo 'save the source, save the world'
end
