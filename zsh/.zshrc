# Zoxide - smart directory jumper
if command -v zoxide &> /dev/null; then
    export _ZO_FZF_OPTS='--ignore-case'
    export _ZO_ECHO='1'
    eval "$(zoxide init zsh --cmd cd)"
fi

# Oh My Zsh
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    export ZSH="$HOME/.oh-my-zsh"

    # Copy custom theme from .config if it exists and isn't already there
    if [[ -f "$HOME/.config/zsh/themes/every.zsh-theme" ]] && [[ ! -f "$ZSH/custom/themes/every.zsh-theme" ]]; then
        mkdir -p "$ZSH/custom/themes"
        cp "$HOME/.config/zsh/themes/every.zsh-theme" "$ZSH/custom/themes/"
    fi

    ZSH_THEME="every"
    plugins=(git)
    source $ZSH/oh-my-zsh.sh
fi

# Homebrew (macOS uses /opt/homebrew, Linux typically uses /home/linuxbrew/.linuxbrew)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f "$HOME/.linuxbrew/bin/brew" ]]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
fi

# User local bin
export PATH="$HOME/.local/bin:$PATH"

# Bob nvim
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"

# Source env file if it exists
if [[ -f "$HOME/.local/bin/env" ]]; then
    . "$HOME/.local/bin/env"
fi

export PATH="$HOME/.yarn/bin:$PATH"

# Typst package path
export TYPST_PACKAGE_PATH="$HOME/.local/share/typst/packages"

# FZF
if command -v fzf &> /dev/null; then
    # FZF key bindings and completion (adjust path based on installation)
    if [[ -f "$HOME/.fzf.zsh" ]]; then
        source "$HOME/.fzf.zsh"
    elif [[ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        source /usr/share/doc/fzf/examples/completion.zsh
    fi
fi

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Eza (modern ls replacement)
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
fi
