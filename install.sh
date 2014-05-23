#!/bin/sh

d=$PWD
c=~/
f=$@
test -z $f && f=`ls $c/dotfiles | grep -ve '#'`

if echo $PWD | egrep 'dotfiles\/?$' > /dev/null; then
	c=`echo $PWD | sed s/dotfiles//`
fi
cd ~/

echo -n "Installing dotfiles:"
for i in `echo $f | xargs -n1 | grep -ve config`; do
    echo -n " $i"
    rm -rf .$i
    ln -sf $c/dotfiles/$i .$i
done
echo "."

if echo $f | grep config > /dev/null; then
   echo -n "config:"
   mkdir -p ~/.config
   for i in `ls $c/dotfiles/config/`; do
           echo -n " $i"
           rm -rf .config/$i
           ln -sf $c/dotfiles/config/$i $c.config/$i
   done
   echo "."
   cd $d
fi

mkdir -p ~/.zsh_cache
mkdir -p ~/.ssh

#cp $d/.id_rsa.pub ~/.ssh/authorized_key
