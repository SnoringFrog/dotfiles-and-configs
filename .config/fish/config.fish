if test (date +%w) -ne 5
	switch $SHELL
		case '*fish*'
			echo -e "Default shell is fish and it isn't Friday.\nSwitching back to bash."
			chsh -s /bin/bash
			# Open new tab, requires https://gist.github.com/bobthecow/757788
			tab #Need to check if this is installed
			exit
	end
end

# Set various environment variables
set -Ux EDITOR vim
