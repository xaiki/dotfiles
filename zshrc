#! /bin/zsh

autoload -U compinit zrecompile

zsh_cache=${HOME}/.zsh_cache

if [ $UID -eq 0 ]; then
    compinit
else
    compinit -d $zsh_cache/zcomp-$HOST

    for f in ~/.zshrc $zsh_cache/zcomp-$HOST; do
        zrecompile -p $f && rm -f $f.zwc.old
    done
fi

setopt extended_glob
for zshrc_snipplet in ~/.zsh/[0-9][0-9][^.]#; do
    source $zshrc_snipplet
done

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /home/xaiki/src/Butter/Components/butter-ninja/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /home/xaiki/src/Butter/Components/butter-ninja/node_modules/tabtab/.completions/electron-forge.zsh
# added by travis gem
[ -f /home/xaiki/.travis/travis.sh ] && source /home/xaiki/.travis/travis.sh
