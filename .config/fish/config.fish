if test (date +%w) -ne 5
	switch $SHELL
	case '*fish*'
		echo -e "Default shell is fish and it isn't Friday.\nSwitching back to bash."
		if chsh -s /usr/local/bin/bash
			# Open new tab, requires https://gist.github.com/bobthecow/757788
			tab #Need to check if this is installed
			exit
		end
	end
end

# Import location/computer-specific configs (if they exist)
set --global --export FISH_CONFIG_DIR "~/.config/fish"
source $FISH_CONFIG_DIR/config_genworth.fish
source $FISH_CONFIG_DIR/config_osx.fish
source $FISH_CONFIG_DIR/config_windows.fish

# Set various environment variables
set --global --export EDITOR vim
