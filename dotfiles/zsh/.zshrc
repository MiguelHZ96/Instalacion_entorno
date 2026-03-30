# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias apt='nala'
alias apt-get='nala'
alias cine='asciinema'
alias sudo='sudo '
alias up='sudo nala update && sudo nala upgrade -y'
alias ins='sudo nala install'
alias fast='fastfetch'
alias mic='micro'
alias nano='micro'
alias bat='batcat'
alias fd='fdfind'
alias batdiff='batcat --diff'
alias cat='batcat --style=plain --paging=never'
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -l --icons --git --color=always --group-directories-first'
alias la='eza -la --icons --git --color=always --group-directories-first'
alias lt='eza --tree --level=2 --icons --group-directories-first'
alias wgett='aria2c'

export PATH="$PATH:/usr/sbin"

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=93,bold'

FAST_SYNTAX_HIGHLIGHTING_THEME="$HOME/.config/fsh/mytheme.ini"
source "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
