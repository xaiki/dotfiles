#!/bin/sh
#set -x
set -e

key=`gpg --list-only --decrypt ~/.authinfo.gpg 2>&1 | egrep -oe 'ID ([0-9A-F]+)' | cut -d' ' -f 2`
wc=`echo $@ | wc -w`;
case $wc in
        0)
                gpg --decrypt ~/.authinfo.gpg
                ;;
        1)
                gpg --decrypt ~/.authinfo.gpg | grep $1
                ;;
        2)
                (echo "machine $1 password $2"; gpg  --decrypt ~/.authinfo.gpg) | gpg --encrypt -r ${key} > ~/.authinfo.gpg.2
                mv ~/.authinfo.gpg.2 ~/.authinfo.gpg
                ;;
        3)
                (echo "machine $1 login $2 password $3"; gpg  --decrypt ~/.authinfo.gpg) | gpg --encrypt -r ${key} > ~/.authinfo.gpg.2
                mv ~/.authinfo.gpg.2 ~/.authinfo.gpg
                ;;
        *)
                (echo "$@"; gpg  --decrypt ~/.authinfo.gpg) | gpg --encrypt -r ${key} > ~/.authinfo.gpg.2
                mv ~/.authinfo.gpg.2 ~/.authinfo.gpg
                ;;
esac
