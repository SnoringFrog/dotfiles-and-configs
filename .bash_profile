shopt -s dotglob #ensure dotfiles are found
#Source all ~/usr/src files (needs to be done before my bashrc)
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for f in ${HOME}/usr/src/*; do source "$f" 2> "${HOME}/usr/.src_errors"; done

#Run all scripts in ~/usr/init
for f in ${HOME}/usr/init/*; do . "$f" & 2> "${HOME}/usr/.init_errors"; done
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
	if hash cowsay 2>/dev/null; then
		fortune | cowsay
		#need to include a random cow
	else
		fortune
	fi
fi

#todo.txt 
export TODOTXT_DEFAULT_ACTION=ls #default action: list outstanding tasks
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n' #sort by priority, then number

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH
