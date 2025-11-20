# Development Environment Configuration

A comprehensive, cross-platform development environment setup that works on macOS, Fedora, Ubuntu, and Debian. This repository contains configurations and an automated installation script for setting up a modern terminal-based development environment.

## Features

- Cross-platform support (macOS, Fedora, Ubuntu, Debian)
- Interactive installation with customizable options
- Automatic detection of visual vs headless environments
- Configuration backup system
- Homebrew-based package management for consistency

## What Gets Installed

### Core Tools

- **Homebrew**: Universal package manager for macOS and Linux
- **Git**: Version control system
- **Zsh**: Modern shell
- **Oh My Zsh**: Zsh framework with plugins
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- **Neovim**: Modern text editor with LSP support
- **Zoxide**: Smarter cd command that learns your habits
- **fzf**: Fuzzy finder for files and command history
- **ripgrep**: Fast grep alternative
- **fd**: User-friendly find alternative
- **bat**: Cat with syntax highlighting
- **eza**: Modern ls replacement with icons
- **gh**: GitHub CLI
- **starship**: Fast, customizable prompt

### Optional Tools

- **tmux**: Terminal multiplexer (asked during installation)
- **lazygit**: Terminal UI for git
- **git-delta**: Better git diff viewer
- **btop**: Resource monitor
- **tldr**: Simplified man pages
- **jq**: JSON processor
- **Node.js**: JavaScript runtime (asked during installation)

### Nerd Fonts

In visual environments, the following Nerd Fonts are installed:
- JetBrains Mono Nerd Font
- Fira Code Nerd Font
- Hack Nerd Font
- Meslo LG Nerd Font
- 0xProto Nerd Font

## Configurations Included

- **Neovim**: Full LSP setup with treesitter, mini.pick, oil.nvim
- **Tmux**: Custom configuration with purple statusline
- **Alacritty**: Terminal emulator configuration with Nerd Font
- **Zsh**: Shell integrations and useful aliases

## Quick Start

### Installation

1. Clone this repository:
```bash
git clone https://github.com/everythxxgs/.config ~/.config
cd ~/.config
```

2. Run the installation script:
```bash
./install.sh
```

3. Follow the interactive prompts to customize your installation

4. Restart your terminal or source your zshrc:
```bash
source ~/.zshrc
```

### What the Script Does

1. Detects your operating system
2. Asks for your preferences:
   - Install tmux?
   - Install extra tools?
   - Install Node.js?
3. Installs system dependencies (Linux only)
4. Installs Homebrew if not present
5. Installs all core development tools
6. Sets up Oh My Zsh with popular plugins
7. Installs Nerd Fonts (if in visual environment)
8. Creates symlinks to configuration files
9. Sets up shell integrations
10. Changes default shell to zsh

## Supported Operating Systems

- macOS (any recent version)
- Fedora
- Ubuntu
- Debian

## Configuration Locations

After installation, your configurations will be symlinked from this repository to:

- `~/.config/nvim/` - Neovim configuration
- `~/.config/tmux/` - Tmux configuration
- `~/.config/alacritty/` - Alacritty configuration
- `~/.zshrc` - Zsh configuration

## Backup System

The installation script automatically backs up any existing configuration files before creating symlinks. Backups are saved with timestamps in the format:

```
<original-file>.backup.YYYYMMDD_HHMMSS
```

For example: `.zshrc.backup.20231120_143052`

## Post-Installation

### Using the Tools

#### Zoxide (Smart Directory Navigation)
```bash
z documents      # Jump to frequently used directories
zi documents     # Interactive selection with fzf
```

#### fzf (Fuzzy Finder)
- `Ctrl+R` - Search command history
- `Ctrl+T` - Search files in current directory
- `Alt+C` - Change directory using fuzzy search

#### Aliases
The following aliases are automatically configured:
```bash
ls    # Uses eza with icons
ll    # Long listing with icons
la    # All files with icons
cat   # Uses bat with syntax highlighting
cd    # Uses zoxide
```

#### Neovim
Your nvim is configured with:
- LSP support for multiple languages
- Treesitter for syntax highlighting
- mini.pick for file navigation (Space + f)
- oil.nvim for file management (Space + e)

Key bindings (Space is leader):
- `Space + w` - Save file
- `Space + q` - Quit
- `Space + f` - Find files
- `Space + e` - File explorer

#### Tmux
If you installed tmux, the prefix key is set to `Ctrl+Space`.

### Configuring Your Terminal

If you're using a visual terminal emulator (not Alacritty), configure it to use one of the installed Nerd Fonts:
- JetBrains Mono Nerd Font
- Fira Code Nerd Font
- Hack Nerd Font
- Meslo LG Nerd Font
- 0xProto Nerd Font

## Updating

To update your tools:

```bash
brew update && brew upgrade
```

To update Oh My Zsh and plugins:

```bash
omz update
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && git pull
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && git pull
```

## Customization

All configuration files are in this repository. To customize:

1. Edit the configuration files in this directory
2. Changes will automatically apply (since they're symlinked)
3. For shell changes, run `source ~/.zshrc`
4. For nvim changes, restart nvim or run `:source %`

## Troubleshooting

### Homebrew not found after installation on Linux

Add this to your shell configuration:
```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### Shell didn't change to zsh

Log out and log back in, or run:
```bash
chsh -s $(which zsh)
```

### Fonts not showing up

After installing fonts:
- On macOS: Restart your terminal
- On Linux: Run `fc-cache -fv` and restart your terminal

### Permission denied when running install.sh

Make sure the script is executable:
```bash
chmod +x install.sh
```

## Adding This to a New Machine

1. Clone the repository:
```bash
git clone <your-repo-url> ~/.config
```

2. Run the installer:
```bash
cd ~/.config
./install.sh
```

3. Restart your terminal

That's it! Your entire development environment is now set up.

## Uninstalling

To remove installed tools:

```bash
brew uninstall neovim zoxide fzf ripgrep fd bat eza gh starship
brew uninstall tmux lazygit git-delta btop tldr jq node  # if installed
```

To remove Oh My Zsh:
```bash
uninstall_oh_my_zsh
```

To remove Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Contributing

Feel free to fork this repository and customize it for your own needs!

## License

MIT License - Feel free to use and modify as needed.
