PS1="${USER}@${HOST} $ "
GDK_BACKEND="wayland"
MOZ_USE_XINPUT2=1
export PATH="$HOME/.cargo/bin:$PATH"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/xaiki/.local/share/flatpak/exports/share"q

# include Mycroft commands
source ~/.profile_mycroft
test -e "$TOOLBOX_PATH" && export LANG="C.UTF-8"