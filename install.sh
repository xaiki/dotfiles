#!/bin/sh

d=$PWD
cd ~/

for i in `ls ~/dotfiles`; do
    ln -sf ~/dotfiles/$i .$i
done

cd $d