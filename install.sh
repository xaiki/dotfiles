#! sh
set -e

d=`realpath $0 | sed s/'\/install.sh$'//`
home=$HOME 
s="config fonts"
n="bin ssh mail-scripts elisp Pods"
sr=`echo $s | sed s/' '/'|'/g`
nr=`echo $n | sed s/' '/'|'/g`
f=$@
test -z $f && f=`ls ${d} | egrep -ve '(#|$nr)'`

cd ${home}

echo -n "Installing dotfiles:"
for i in `echo $f | xargs -n1 | egrep -ve "^($sr|$nr)$"`; do
    echo -n " $i"
    rm -rf .$i
    ln -sf ${d}/$i .$i
done
echo "."

for e in $s; do
        if echo $f | grep $e > /dev/null; then
                echo -n "$e:"
                mkdir -p ${home}/.$e
                for i in `ls ${d}/$e/`; do
                        echo -n " $i"
                        rm -rf .$e/$i
                        ln -sf ${d}/$e/$i ${home}/.$e/$i || true
                done
                echo "."
                cd $d
        fi
done

e=bin
mkdir -p ${home}/.local
if echo $f | grep $e  > /dev/null; then
        echo -n "$e:"
        mkdir -p ${home}/.local/$e
        for i in `ls ${d}/$e/`; do
                x=`echo $i | sed s/'\.sh$'//`
                echo -n " $i"
                rm -rf ${home}/.local/$e/$x
                ln -sf ${d}/$e/$i ${home}/.local/$e/$x || true
        done
        echo "."
        cd $d
fi

e=Pods
if echo $f | grep $e > /dev/null; then
        mkdir -p ~/.zsh_cache
        for i in `ls ${d}/$e/`; do
                echo "$e: $i"

                (cd ${d}/${e}/${i} && podman build -t $i .)
        done
fi
#cp $d/.id_rsa.pub ~/.ssh/authorized_key
