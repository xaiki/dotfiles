#!/bin/sh

d=$PWD
c=~/
if echo $PWD | egrep 'dotfiles\/?$'; then
	c=`echo $PWD | sed s/dotfiles//`
fi
cd ~/

for i in `ls $c/dotfiles | grep -ve '#' | grep -ve config`; do
    echo -n "$i "
    rm -rf .$i
    ln -sf $c/dotfiles/$i .$i
done
echo "done."

echo -n "config: "
mkdir -p ~/.config
for i in `ls $c/dotfiles/config/`; do
    echo -n "$i "
    rm -rf .config/$i
    ln -sf $c/dotfiles/config/$i $c.config/$i
done
echo "done."
cd $d

mkdir -p ~/.zsh_cache
mkdir -p ~/.ssh

cp $d/.id_rsa.pub ~/.ssh/authorized_key
