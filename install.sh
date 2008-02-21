#!/bin/sh

pushd ~/

for i in `ls ~/dotfiles`; do
    ln -sf ~/dotfiles/$i .$i
done