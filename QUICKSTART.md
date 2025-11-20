# Quick Start Guide

## For a New Machine

### 1. Clone the repository
```bash
git clone <your-repo-url> ~/.config
cd ~/.config
```

### 2. Run the installer
```bash
./install.sh
```

### 3. Answer the prompts
- Do you want to install tmux? (y/n)
- Do you want to install extra tools? (y/n)
- Do you want to install Node.js? (y/n)

### 4. Restart your terminal
```bash
# Or source your new shell configuration
source ~/.zshrc
```

## What You Get

### Core Tools
- Homebrew, Git, Zsh, Neovim, Zoxide, fzf, ripgrep, fd, bat, eza, gh, starship

### Optional Tools
- tmux, lazygit, git-delta, btop, tldr, jq, Node.js

### Configurations
- Neovim with LSP, Treesitter, and plugins
- Tmux with custom statusline
- Alacritty terminal config
- Starship prompt theme
- Zsh with Oh My Zsh and plugins

### Nerd Fonts (visual environments)
- JetBrains Mono, Fira Code, Hack, Meslo LG, 0xProto

## Essential Commands

### Navigation
```bash
z documents    # Jump to frequently used directory
zi            # Interactive directory jump
ctrl+r        # Search command history
ctrl+t        # Find files
alt+c         # Change directory fuzzy search
```

### File Operations
```bash
ls            # Better ls with icons (eza)
ll            # Long listing
la            # Show all files
cat file.txt  # View file with syntax (bat)
```

### Neovim
```bash
nvim          # Launch neovim
Space+f       # Find files
Space+e       # File explorer
Space+w       # Save
Space+q       # Quit
```

### Git
```bash
gh            # GitHub CLI
lazygit       # Git TUI (if installed extras)
```

## Troubleshooting

### Command not found after installation
```bash
source ~/.zshrc
# or restart terminal
```

### Fonts not working
```bash
fc-cache -fv  # Linux
# Restart terminal on macOS
```

### Change shell manually
```bash
chsh -s $(which zsh)
```

## Updating Tools

```bash
brew update && brew upgrade
omz update
```

## Repository Structure

```
~/.config/
├── install.sh          # Main installer
├── README.md           # Full documentation
├── QUICKSTART.md       # This file
├── .gitignore          # Git ignore rules
├── .zshrc              # Zsh configuration
├── starship.toml       # Prompt configuration
├── nvim/               # Neovim config
├── tmux/               # Tmux config
└── alacritty/          # Alacritty config
```

## Next Steps

1. Customize configurations in ~/.config/
2. Changes auto-apply (files are symlinked)
3. Add your own tools to install.sh
4. Commit and push your changes
5. Pull on new machines and run ./install.sh
