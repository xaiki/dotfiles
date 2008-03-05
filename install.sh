#!/bin/sh

d=$PWD
cd ~/

for i in `ls ~/dotfiles`; do
    rm -rf .$i
    ln -sf ~/dotfiles/$i .$i
done
cd $d
