#!/bin/sh

pushd ~/

for i in `ls ~/dotfiles`; do
    rm -rf .$i
    ln -sf ~/dotfiles/$i .$i
done
