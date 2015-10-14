shopt -s dotglob #ensure dotfiles are found
#Source all ~/usr/src files (needs to be done before my bashrc)
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
if [ "$(ls -A ${HOME}/usr/src)" ]; then
for f in ${HOME}/usr/src/*; do source "$f" 2>"${HOME}/usr/.src_errors"; done
fi

#Run all scripts in ~/usr/init
if [ "$(ls -A ${HOME}/usr/init)" ]; then
for f in ${HOME}/usr/init/*; do source "$f" 2>"${HOME}/usr/.init_errors"; done
fi
IFS=$SAVEIFS
shopt -u dotglob #disable dotglob, in case I don't want it elsewhere

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH="${HOME}/bin:${PATH}"
fi

# Set MANPATH so it includes users' private man if it exists
if [ -d "${HOME}/man" ]; then
  MANPATH="${HOME}/man:${MANPATH}"
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "${HOME}/info" ]; then
  INFOPATH="${HOME}/info:${INFOPATH}"
fi

#Set PATH so it includes my personal scripts and binaries if I've set up the file
if [ -d "${HOME}/usr/scripts" ] ; then
	PATH="${HOME}/usr/scripts:${PATH}"
	PATH="${HOME}/usr/bin:${PATH}"
fi

#Fortune on startup (from a cow, if possible)
if hash fortune 2>/dev/null; then
	LASTFORTUNE=`fortune`
	if hash cowsay 2>/dev/null; then
		if hash lolcat 2>/dev/null; then
			echo "$LASTFORTUNE" | cowsay | lolcat 
		else
			echo "$LASTFORTUNE" | cowsay
		fi
		#need to include a random cow
	else
		if hash lolcat 2>/dev/null; then
			echo "$LASTFORTUNE" | lolcat
		else
			echo "$LASTFORTUNE"
		fi
	fi
fi

#fish fridays
if hash fish 2>/dev/null; then
	if [[ `date +%w` -eq 5 && "$SHELL" != *"fish"* ]]; then
		echo "It's fish Friday! Changing default shell."
		chsh -s /usr/local/bin/fish
	
		#Open new iTerm tab (Mac-only, requires https://gist.github.com/bobthecow/757788)
		if [ `uname -s` == "Darwin" ]; then tab; exit; fi
	elif [[ `date +%w` -ne 5 && "$SHELL" == *"fish"* ]]; then
		echo "Not Friday, but fish is still the default shell. Let's fix that."
		chsh -s /usr/local/bin/bash
	fi
fi	


#todo.txt 
export TODOTXT_DEFAULT_ACTION=ls #default action: list outstanding tasks
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n' #sort by priority, then number

#Ignore .DS_Store files during tab completion
export FIGNORE=DS_Store

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
#export PATH

##
# Your previous /Users/430011037/.bash_profile file was backed up as /Users/430011037/.bash_profile.macports-saved_2015-07-27_at_11:21:54
##

# MacPorts Installer addition on 2015-07-27_at_11:21:54: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

