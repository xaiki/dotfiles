function __fish_git_prompt
    set branch_name (git symbolic-ref HEAD 2>/dev/null)
    if test -n "$branch_name"
        set __git_status (git status --porcelain)
        printf ':'
        set_color $__fish_git_prompt_color_branch
        echo "$branch_name" | sed 's!refs/heads/!!'
        set_color white

        set __git_uncommited (echo $__git_status | grep "^M" | wc -l)
        set __git_untracked (echo $__git_status | grep "^ M" | wc -l)

        if test "$__git_uncommited"
            printf $__fish_git_prompt_char_dirtystate
        end
        if test "$__git_untracked"
            printf $__fish_git_prompt_char_untrackedfiles
        end
    end
end
