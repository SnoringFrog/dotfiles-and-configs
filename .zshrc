# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' menu select
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/Users/430011037/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=50000
setopt appendhistory autocd extendedglob sharehistory
bindkey -v
# End of lines configured by zsh-newuser-install

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

autoload -U colors && colors #%{$fg[blue]%}%m "# %{$fg_no_bold[yellow]%}%0~ %{$reset_color%}"
PROMPT="
%F{002}⎡%f%F{202}%n@%m%f %{$fg_no_bold[yellow]%}%0~ %{$reset_color%} 
%F{002}⎣¬%f%F{002}º%f%F{002}-%f%F{002}°%f%F{002}⎤⎯%f%# " 
RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"

#⎣¬º-°⎤¬"
#(✌ ﾟ∀ﾟ)☞ "
# ⚠  ⚔  ✠ ©© 💨  ➡ 💤💤  🗣  💥  💣  ☠  🗿  ⛔️  ⚠️  🔚  🔜  🐚  ☛  ➤  ➣  ⇶  ⤷  ⇲ ↘︎  ∴ ∵ ∶ ∷ ⊐ ⊻ ⋙ ⨠ ⨴ ⫸ ⎡zsh⎤ ¿? 
#⥍

function print_colors () {
	for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done
}

env_specific_rc_dir="${HOME}"
macrc=".mac_zshrc"
if [ -f "$env_specific_rc_dir/$macrc" ]; then
	source "$env_specific_rc_dir/$macrc"
fi
