PS1="${USER}@${HOST} $ "
GDK_BACKEND="wayland"
MOZ_USE_XINPUT2=1
export PATH="$HOME/.cargo/bin:$PATH"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/xaiki/.local/share/flatpak/exports/share"q

test -e "$TOOLBOX_PATH" && export LANG="C.UTF-8"
eval "$(~/.cargo/bin/starship init bash)"
. "/home/xaiki/.var/app/org.gnu.emacs/data/cargo/env"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
