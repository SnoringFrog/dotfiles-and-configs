# ~/.bashrc: executed by bash(1) for interactive shells.

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell
# 
# Use extended pattern matching
shopt -s extglob

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Use vim
export EDITOR=vim

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredup
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
#
# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND="history -a"
#
# Bigger history file
export HISTSIZE=10000
export HISTFILESIZE=50000

# Use auto-completion after the following commands:
complete -cf sudo
complete -cf man

# Aliases
#
# Source external alias file, if available
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi
#
# Safe(r) rm/cp/mv
alias rm='rm -i'
alias cp='cp -iR'
alias mv='mv -i'
#
# Default to human readable figures
alias df='df -h'
alias du='du -h'
#
# Misc
# alias less='less -r'                          # raw control characters
alias whence='type -a'                        # locate all executables of a given name
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias diff='diff -s'						  # say when files are identical
alias crontab="VIM_CRONTAB=true crontab"	  # fix "temp file must be edited in place" error with crontab/vim
#
# Directory listings
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -lh'                              # long list, human readable
alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #
alias ls='ls -hAF --color --group-directories-first' #human readable, dotfiles, classify, color, directories first
# alias ls='gls -AF --color --group-directories-first' #Mac with gnu ls
#
alias ..='cd ..'
alias ...='cd ../..'
alias bd='. bd -s'
alias mkdir='mkdir -pv' #mkdir always creates intermediate directories and tells us about it
# alias touchallthethings='find / -exec touch {} \;' #Touch EVERYTHING
#
alias sl='sl -a' #make the experience of typing 'ls' incorrectly as traumatic as possible

# Make cd select folders in $HOME if not found in current
export CDPATH=".:$HOME"

# Enable stderred (use before command to make stderr red), if it's installed
stderred_lib="${HOME}/usr/share/stderred/build/libstderred.so"
if [ -f "$stderred_lib" ]; then
	alias stderred="DYLD_INSERT_LIBRARIES=$stderred_lib\${DYLD_INSERT_LIBRARIES:+:\$DYLD_INSERT_LIBRARIES}"
fi
# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Source external functions file, if available
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi
#
# change directories and print contents
cdls (){
	cd "$@"
	ls
}
#
# Get external ip via www.icanhazip.com
eip() {
	wget -q -O - www.icanhazip.com
	if [ $? -ne 0 ]; then
		echo "Error connecting to internet";
	fi
}
#
# Create a quick, timestamped backup of a file
backup() {
	local extension
	extension=$(date +".bu-%Y%m%d-%H%M")
	cp "$1" "$1$extension"
}
#
# Set up recycle command if recycle bin exists
RECYCLE_BIN="${HOME}/recycle_bin"
if [ -d "$RECYCLE_BIN" ]; then
	function recycle () {
		mv "$@" "$RECYCLE_BIN"
	}
fi
#
# Pwd, but report if there is a difference between physical and logical location
#	maybe look into making this a builtin?
pwdiligent(){
	if [ "$1" == "-P" -o "$1" == "-L" ]; then
		\pwd "$1"
		return 0
	fi
	local logical
	local physical
	logical=`\pwd -L`
	physical=`\pwd -P`
	if [ "$physical" == "$logical" ]; then
		pwd
	else
		echo "Logical: $logical"
		echo "Physical: $physical"
	fi
}
alias pwd='pwdiligent'
#
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
# 
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
# 
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
# 
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
# 
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
# 
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
# 
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
# 
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
# 
#   return 0
# }
# alias cd=cd_func
#
# Create a directory and cd into it
function mkcd {
	mkdir -p "$@" && cd "$@";
}
#
# Remove duplicate lines in a file without changing line order (keeps first occurence)
function remove_duplicate_lines {
	awk '!a[$0]++' $1 > .rdltmp && mv .rdltmp $1 
}
#
# Needs to appear before g function (I think)
if hash hub 2>/dev/null; then
	alias git='hub'
fi
#
# Map g to git status and g <arg> to git <arg>
function g {
	if [[ $# > 0  ]]; then
		git $@
	else
		git status
	fi
}
#
# Find all hard and soft links for a particular file
function findlinks {
	find "$1" -L -samefile "$2" -exec ls -li {} \; 2>/dev/null
}
#
# Copy single source file into multiple directories
function distribute {
	arguments=""
	destinations=""
	sourcefile=""
	while [[ $# -ge 1 ]]; do
		key="$1"

		if [[ "$key" == "-h" ]]; then
			echo "usage: $0 [flags to cp] source_file destination_1 [... destination_N]"
		elif [[ "$key" == -* ]]; then
			arguments+=" $key"
		elif [ -z "$sourcefile" ]; then
			sourcefile="$key"
		else
			destinations+=" $key"
		fi

		shift
	done

	echo $destinations | xargs -n 1 cp $arguments $sourcefile	
}
#
# Counts the total number of files and directories in the current directory (recursive)
function fid {
	# expand to include links as well
	local filecount
	local dircount
	filecount=$(find . -type f | wc -l | tr -d '[[:space:]]')
	dircount=$(find . -mindepth 1 -type d | wc -l | tr -d '[[:space:]]')
	if [ "$filecount" -eq 1 ]; then
		echo "$filecount file"
	else 
		echo "$filecount files"
	fi
	if [ "$dircount" -eq 1 ]; then
		echo "$dircount directory"
	else
		echo "$dircount directories"
	fi
}
# Pulled this out into it's own file and sourced that
#function follow {
	#Need to make this work when follow is used as such: [command with destination]; follow; [command]
	#Potential imrpovement: allow run as 'follow [command with destination]' where command is run then followed
#	last_command=`history 1`
#	final_arg=`echo $last_command | awk '{print \$NF}'`

	#If follow is last on a line, the first half of this should run
	#If follow is first, or alone on a line, the latter half of this should run
	#If follow is in the middle of a line, discard end of line then treat as last

#	if [[ "$last_command" =~ .*\;.* && $final_arg == "${FUNCNAME[0]}" ]]; then
#		locale=`echo $last_command | perl -pe 's/;.*//' | awk '{print $NF}'`
#	else
#		locale=`history 2 | head -n 1 | awk '{print $NF}'`
#	fi
	
#	if [[ -e $locale ]]; then
#		if [[ -f $locale ]]; then
#			locale=`dirname $locale`
#		fi

#		if [[ -d $locale ]]; then
#			cd "$locale"
#		fi
#	else
#		>&2 echo "Nowhere to follow"	
#	fi
#}
#
# Create 6 quick text files.
# Assumes Magic School Bus/Captain Planet are connected
# -s produces files silently
planeteers=(earth fire wind water heart)
function captain-planet {
	touch "captain planet" #hehe
	
	if [[ "$1" != "-s" ]]; then
		echo "Let our powers combine!"
		echo -e "\033[0;32mEarth!\033[0m"
		echo -e "\033[0;31mFire!\033[0m"
		echo -e "\033[0;36mWind!\033[0m"
		echo -e "\033[0;34mWater!\033[0m"
		echo -e "\033[0;35mHeart!\033[0m"

		let "num=$RANDOM%100"
		if [ "$num" -eq 0 ]; then
			echo "Bus, do your stuff..."
		else
			echo "With your powers combined, I am Captain Planet!"
		fi
	fi
	
	for planeteer in ${planeteers[@]}; do
		echo "This is $planeteer!" >> $planeteer
		echo "$planeteer" >> "captain planet"
	done
}
#
# Remove test files from captain-planet()
# -f uses rm -f
function captain-pollution {
	if [[ "$1" == "-f" ]]; then
		arg="-f"
	else
		arg=""
	fi	

	for planeteer in ${planeteers[@]}; do
		rm $arg $planeteer
	done
	rm $arg "captain planet"
}
#
# Output blinking text
# Accepts 0-7 as arguments for black, red, green, yellow, blue, magenta, cyan, white
# Defaults to red
function blink {
	num=$1
	if [[ $num =~ [0-7] ]]; then
		color=$((num+30))
		msg=${@:2}
	else
		color=31
		msg=$@
	fi
	echo -e "\033[5;${color}m$msg\033[0m"
}
#
# Change displayed username/host in prompt
function changePS1 {
	PS1="\n\e[0;32m$1\e[m \e[0;33m\w\e[m\e[0;36m$(__git_ps1 2>/dev/null)\e[m\n\$ "
}
#
# Follow symlink (to file or directory)
function symcd {
	dest=`realpath $1`
	if [[ -d ""$dest"" ]]; then
		cd "$dest"
	else 
		cd `dirname "$dest"`
	fi
}
#
# Use all 5 format modes for figlet
function figtree {
	for mode in {-s,-S,-k,-o,-W}; do
		echo $mode
		figlet $m $@
	done	
}
#
# Random fortune for commit message
# http://www.reddit.com/r/archlinux/comments/26is44/alias_yoloyaourt_syyuua_devel_noconfirm/
function yolo-commit() {
	git commit -am "$(fortune -s)"
}
#
# Pull a random commit from whatthecommit.com
function whatthecommit(){
	curl whatthecommit.com/index.txt
}

# Customize prompt
# Requires .git-prompt.sh to be sourced, appends current branch to prompt. Causes no issues if command isn't available
# Blank line, user@host (green), space, current directory (yellow/brown), current git branch (cyan), newline, dollar sign, space
#PS1='\n\e[0;32m\u@\h\e[m \e[0;33m\w\e[m\e[0;36m\$(__git_ps1 2>/dev/null)\e[m\n\$ ' 
#Sets title bar to current directory
#PS1="\[\033]0;\w\007\]"${PS1} 

#PS1="\n\[\e[0;34m\]┌─[\[\e[0m\]\[\e[0;32m\]\u@\h\[\e[0m\]\[\e[0;34m\]] \[\e[0m\]\[\e[0;33m\]\w\[\e[0m\]\e[0;31m\]\$(__git_ps1 2>/dev/null)\[\e[0m\]\n\[\e[0;34m\]└─[\[\e[0m\]\[\e[1;37m\]$\[\e[0m\]\[\e[0;34m\]]› \[\e[0m\]"

PS1="\n\[\e[0;34m\]┌─[\[\e[0m\]\[\e[0;32m\]\u@\h\[\e[0m\]\[\e[0;34m\]] \[\e[0m\]\[\e[0;33m\]\w\[\e[0m\]\e[0;31m\]\$(__git_ps1 2>/dev/null)\[\e[0m\]\n\[\e[0;34m\]└─[\[\e[0m\]\[\e[1;37m\]\$ ︻デ═━\[\e[0;31m\]☆ﾟ\[\e[0m\]\[\e[0;34m\]› \[\e[0m\]"
export PS1

# Fun things to add to prompt:
# Wizard: (∩｀-´)⊃━☆ﾟ.*･｡ﾟ
# Guns: ︻デ═一 ⌐╦╦═─ ︻デ═━☆ﾟ
# Hadoken: ༼つಠ益ಠ༽つ ─=≡ΣO))
# Zombie: [¬º-°]¬
# Running away: ε＝ε＝ε＝┌(;ﾟдﾟ)┘
# Pipe smoking: (ಠ_ಠ)ᓄ°°
# Bow and arrow: (´･ω･)~[}  »━>
#				(‘∀`)~[} »━☆ﾟ
# NES controller: [+..••]
#︻デ═━☆ﾟ

# Current directory in window title (not working on Mac? maybe not at all, need to test)
# export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'
# export PROMPT_COMMAND='echo -ne "\033]0;${USER}: ${PWD##*/}\007"'

# Misc
#Use colordiff instead of diff, if it's available
# Also output explicitly when files are identical
if hash colordiff 2>/dev/null; then
	alias diff='colordiff -s'
fi

#Who doesn't want fortunes from a cow?
if (hash fortune 2>/dev/null) && (hash cowsay 2>/dev/null); then
	function forcow(){
		LASTFORTUNE=`fortune`
		echo "$LASTFORTUNE" | cowsay
		export LASTFORTUNE
	}
	alias forcow=forcow
	#alias forcow='fortune | cowsay'
fi

#START:todo.txt/todo.sh 
# todo.txt-specific tweaks
	alias todo='todo.sh -nt -d ~/.todo/config/todo.cfg'

	#Tab completion for todo.txt
	complete -F _todo todo
#END:todo.txt/todo.sh

## Colored manpages (from: https://github.com/Arkham/dotfiles/blob/master/bashrc)
export LESS_TERMCAP_mb=$'\E[01;31m'		# begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'		# begin bold	
export LESS_TERMCAP_me=$'\E[0m'			# end mode
export LESS_TERMCAP_se=$'\E[0m'			# end standout-mode
#export LESS_TERMCAP_so=$'\E[01;44;33m'	# begin standout-mode - info box # yellow on blue
export LESS_TERMCAP_so=$'\E[38;5;246m'	# begin standout-mode - info box # dark grey
export LESS_TERMCAP_ue=$'\E[0m'			# end underline
export LESS_TERMCAP_us=$'\E[01;32m'		# begin underline

# Syntax highlighting in less 
#	requires GNU source-higlight (http://www.gnu.org/software/src-highlite/)
#	which in turn requires boost (http://www.boost.org/)
#	Helpful for Mac: https://wincent.com/wiki/Installing_GNU_Source-highlight_on_Mac_OS_X_10.6.7_Snow_Leopard
#export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"

# Swithed from gnu-source-highlight to using lesspipe with syntax-highlighting
# This gives the added benefit of being able to open .zip's and some other similar things
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s"
export LESSCOLORIZER="pygmentize"
export LESS=' -R -i-P%f (%i/%m) Page %db/%D'

# Environment-specific rc's
#TODO: more efficient loading of custom rcs, loop of some sort (through usr/rcs?)
env_specific_rc_dir="${HOME}"

# Mac-specific bashrc
#NOTE: should be loaded after aliases so ls is defined properly
macrc=".mac_bashrc"
if [ -f "$env_specific_rc_dir/$macrc" ] ; then
  source "$env_specific_rc_dir/$macrc"
fi

# Genworth-specific bashrc
genworthrc=".genworth_bashrc"
if [ -f "$env_specific_rc_dir/$genworthrc" ] ; then
  source "$env_specific_rc_dir/$genworthrc"
fi

