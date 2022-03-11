#!/bin/sh
set -e
set -x

apg=`which apg || podman run apg`
apg_container=apg
xelatex_container=moss/xelatex
pdftk_container=mnuessler/pdftk


filename=`realpath ${1}`
pw=`${apg} -n1`
realname=`echo ${1} | sed s/.org$//`
realfullname=`echo ${filename} | sed s/.org$//`
basename=`basename ${realfullname}`
dirname=`dirname ${1}`

cmd="xelatex -interaction nonstopmode ${basename}.tex"

flatpak run --command='emacsclient' org.gnu.emacs -e "(save-excursion
        (setq org-latex-compiler \"xelatex\")
        (find-file \"${filename}\")
        (org-export-to-file 'latex \"${realfullname}.tex\" nil nil nil nil nil))"
podman run -ti -v ${PWD}:/data:Z ${xelatex_container} sh -c "(cd ${dirname}; ${cmd}; ${cmd};)"
podman run -v ${PWD}:/work:Z ${pdftk_container} ${realname}.pdf output ${realname}.crypt.pdf owner_pw ${pw}
