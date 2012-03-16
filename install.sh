OB#!/bin/sh

d=$PWD
c=~/
if echo $PWD | egrep 'dotfiles\/?$'; then
	c=`echo $PWD | sed s/dotfiles//`
fi
cd ~/

for i in `ls $c/dotfiles | grep -ve '#'`; do
    echo -n "$i "
    rm -rf .$i
    ln -sf $c/dotfiles/$i .$i
done
cd $d
echo "done."
mkdir ~/.zsh_cache
mkdir -p ~/.ssh

cp $d/.id_rsa.pub ~/.ssh/authorized_key
