export _ZO_FZF_OPTS='--ignore-case'
export _ZO_ECHO='1'
eval "$(zoxide init zsh --cmd cd)"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="every"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Homebrew PATH (ensure it comes first)
eval "$(/opt/homebrew/bin/brew shellenv)"

# User local bin
export PATH="$HOME/.local/bin:$PATH"

# Bob nvim
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"

. "$HOME/.local/bin/env"
export PATH="$HOME/.yarn/bin:$PATH"

# Typst package path
export TYPST_PACKAGE_PATH="$HOME/.local/share/typst/packages"
