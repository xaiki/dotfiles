# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

if ! test -f $OMF_PATH/init.fish
	echo "installing omf"
 	curl -L https://get.oh-my.fish > ~/omf.install
	. omf.install
	rm -rf omf.install
end

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
