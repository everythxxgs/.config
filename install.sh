#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "Detected macOS"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case $ID in
            fedora)
                OS="fedora"
                print_info "Detected Fedora"
                ;;
            ubuntu)
                OS="ubuntu"
                print_info "Detected Ubuntu"
                ;;
            debian)
                OS="debian"
                print_info "Detected Debian"
                ;;
            *)
                print_error "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    else
        print_error "Cannot detect operating system"
        exit 1
    fi
}

# Ask user questions
ask_install_tmux() {
    read -p "Do you want to install tmux? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_TMUX=true
    else
        INSTALL_TMUX=false
    fi
}

ask_install_extras() {
    read -p "Do you want to install extra tools (lazygit, delta, btop, tldr, jq)? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_EXTRAS=true
    else
        INSTALL_EXTRAS=false
    fi
}

ask_install_node() {
    read -p "Do you want to install Node.js? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_NODE=true
    else
        INSTALL_NODE=false
    fi
}

# Check if running in a visual environment
is_visual_environment() {
    if [[ "$OS" == "macos" ]]; then
        return 0  # macOS is always visual
    elif [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]]; then
        return 0  # Linux with GUI
    else
        return 1  # Headless
    fi
}

# Install Homebrew
install_homebrew() {
    if command -v brew &> /dev/null; then
        print_success "Homebrew already installed"
        return
    fi

    print_header "Installing Homebrew"

    if [[ "$OS" == "macos" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        # Linux
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Linux
        if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        fi
    fi

    print_success "Homebrew installed"
}

# Install system dependencies for Linux
install_system_dependencies() {
    if [[ "$OS" == "macos" ]]; then
        return  # No system dependencies needed on macOS with Homebrew
    fi

    print_header "Installing system dependencies"

    case $OS in
        fedora)
            sudo dnf groupinstall -y 'Development Tools'
            sudo dnf install -y procps-ng curl file git
            ;;
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y build-essential procps curl file git
            ;;
    esac

    print_success "System dependencies installed"
}

# Install core tools via Homebrew
install_core_tools() {
    print_header "Installing core tools"

    local tools=(
        "git"
        "zsh"
        "neovim"
        "zoxide"
        "fzf"
        "ripgrep"
        "fd"
        "bat"
        "eza"
        "gh"
        "starship"
    )

    for tool in "${tools[@]}"; do
        if brew list "$tool" &> /dev/null; then
            print_info "$tool already installed"
        else
            print_info "Installing $tool..."
            brew install "$tool"
            print_success "$tool installed"
        fi
    done
}

# Install tmux
install_tmux_package() {
    if [[ "$INSTALL_TMUX" == true ]]; then
        print_header "Installing tmux"
        if brew list tmux &> /dev/null; then
            print_info "tmux already installed"
        else
            brew install tmux
            print_success "tmux installed"
        fi
    fi
}

# Install extra tools
install_extra_tools() {
    if [[ "$INSTALL_EXTRAS" == true ]]; then
        print_header "Installing extra tools"

        local extras=(
            "lazygit"
            "git-delta"
            "btop"
            "tldr"
            "jq"
        )

        for tool in "${extras[@]}"; do
            if brew list "$tool" &> /dev/null; then
                print_info "$tool already installed"
            else
                print_info "Installing $tool..."
                brew install "$tool"
                print_success "$tool installed"
            fi
        done
    fi
}

# Install Node.js
install_nodejs() {
    if [[ "$INSTALL_NODE" == true ]]; then
        print_header "Installing Node.js"
        if brew list node &> /dev/null; then
            print_info "Node.js already installed"
        else
            brew install node
            print_success "Node.js installed"
        fi
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    print_header "Installing Oh My Zsh"

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_info "Oh My Zsh already installed"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    fi

    # Install popular zsh plugins
    print_info "Installing zsh-autosuggestions..."
    if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    print_info "Installing zsh-syntax-highlighting..."
    if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    # Copy custom theme
    local config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$config_dir/zsh/themes/every.zsh-theme" ]]; then
        print_info "Installing custom theme..."
        mkdir -p "$HOME/.oh-my-zsh/custom/themes"
        cp "$config_dir/zsh/themes/every.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/"
        print_success "Custom theme installed"
    fi

    print_success "Zsh plugins installed"
}

# Install Nerd Fonts
install_nerd_fonts() {
    if ! is_visual_environment; then
        print_info "Skipping Nerd Fonts (headless environment detected)"
        return
    fi

    print_header "Installing Nerd Fonts"

    if [[ "$OS" == "macos" ]]; then
        # Install popular Nerd Fonts on macOS
        brew tap homebrew/cask-fonts

        local fonts=(
            "font-jetbrains-mono-nerd-font"
            "font-fira-code-nerd-font"
            "font-hack-nerd-font"
            "font-meslo-lg-nerd-font"
            "font-0xproto-nerd-font"
        )

        for font in "${fonts[@]}"; do
            if brew list --cask "$font" &> /dev/null; then
                print_info "$font already installed"
            else
                print_info "Installing $font..."
                brew install --cask "$font"
                print_success "$font installed"
            fi
        done
    else
        # Install Nerd Fonts on Linux
        print_info "Installing Nerd Fonts on Linux..."

        local fonts_dir="$HOME/.local/share/fonts"
        mkdir -p "$fonts_dir"

        cd /tmp

        # Download and install popular Nerd Fonts
        local fonts=(
            "JetBrainsMono"
            "FiraCode"
            "Hack"
            "Meslo"
            "0xProto"
        )

        for font in "${fonts[@]}"; do
            if [[ ! -d "$fonts_dir/$font" ]]; then
                print_info "Downloading $font..."
                curl -fLo "${font}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
                unzip -q "${font}.zip" -d "$fonts_dir/$font"
                rm "${font}.zip"
                print_success "$font installed"
            else
                print_info "$font already installed"
            fi
        done

        # Refresh font cache
        fc-cache -fv
        print_success "Font cache refreshed"
    fi
}

# Create symlinks for config files
setup_symlinks() {
    print_header "Setting up configuration symlinks"

    local config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Backup existing configs
    backup_config() {
        local target=$1
        if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
            local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
            print_warning "Backing up $target to $backup"
            mv "$target" "$backup"
        fi
    }

    # Symlink nvim config
    if [[ -d "$config_dir/nvim" ]]; then
        backup_config "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim"
        ln -sf "$config_dir/nvim" "$HOME/.config/nvim"
        print_success "Linked nvim configuration"
    fi

    # Symlink tmux config
    if [[ "$INSTALL_TMUX" == true ]] && [[ -d "$config_dir/tmux" ]]; then
        backup_config "$HOME/.config/tmux"
        rm -rf "$HOME/.config/tmux"
        ln -sf "$config_dir/tmux" "$HOME/.config/tmux"
        print_success "Linked tmux configuration"
    fi

    # Symlink alacritty config
    if [[ -d "$config_dir/alacritty" ]]; then
        backup_config "$HOME/.config/alacritty"
        rm -rf "$HOME/.config/alacritty"
        ln -sf "$config_dir/alacritty" "$HOME/.config/alacritty"
        print_success "Linked alacritty configuration"
    fi

    # Symlink zshrc if exists
    if [[ -f "$config_dir/zsh/.zshrc" ]]; then
        backup_config "$HOME/.zshrc"
        ln -sf "$config_dir/zsh/.zshrc" "$HOME/.zshrc"
        print_success "Linked .zshrc configuration"
    fi

    # Symlink starship config
    if [[ -f "$config_dir/starship.toml" ]]; then
        backup_config "$HOME/.config/starship.toml"
        ln -sf "$config_dir/starship.toml" "$HOME/.config/starship.toml"
        print_success "Linked starship configuration"
    fi
}

# Setup shell integrations
setup_shell_integrations() {
    print_header "Setting up shell integrations"

    local zshrc="$HOME/.zshrc"
    local config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Skip if using custom .zshrc (it already has integrations)
    if [[ -L "$zshrc" ]] && [[ "$(readlink "$zshrc")" == "$config_dir/zsh/.zshrc" ]]; then
        print_info "Using custom .zshrc - integrations already configured"
        return
    fi

    # Ensure .zshrc exists
    touch "$zshrc"

    # Add zoxide init
    if ! grep -q "zoxide init" "$zshrc"; then
        echo '' >> "$zshrc"
        echo '# zoxide initialization' >> "$zshrc"
        echo 'eval "$(zoxide init zsh)"' >> "$zshrc"
        print_success "Added zoxide to .zshrc"
    fi

    # Add fzf keybindings
    if ! grep -q "fzf" "$zshrc"; then
        echo '' >> "$zshrc"
        echo '# fzf keybindings and fuzzy completion' >> "$zshrc"
        if [[ "$OS" == "macos" ]]; then
            echo 'source <(fzf --zsh)' >> "$zshrc"
        else
            echo 'eval "$(fzf --zsh)"' >> "$zshrc"
        fi
        print_success "Added fzf to .zshrc"
    fi

    # Add starship prompt
    if ! grep -q "starship init" "$zshrc"; then
        echo '' >> "$zshrc"
        echo '# starship prompt' >> "$zshrc"
        echo 'export STARSHIP_CONFIG=~/.config/starship.toml' >> "$zshrc"
        echo 'eval "$(starship init zsh)"' >> "$zshrc"
        print_success "Added starship to .zshrc"
    fi

    # Add useful aliases
    if ! grep -q "alias ls='eza'" "$zshrc"; then
        echo '' >> "$zshrc"
        echo '# Aliases' >> "$zshrc"
        echo "alias ls='eza --icons'" >> "$zshrc"
        echo "alias ll='eza -l --icons'" >> "$zshrc"
        echo "alias la='eza -la --icons'" >> "$zshrc"
        echo "alias cat='bat'" >> "$zshrc"
        echo "alias cd='z'" >> "$zshrc"
        print_success "Added aliases to .zshrc"
    fi
}

# Change default shell to zsh
change_shell() {
    print_header "Setting zsh as default shell"

    local zsh_path=$(which zsh)

    if [[ "$SHELL" == "$zsh_path" ]]; then
        print_info "zsh is already the default shell"
        return
    fi

    # Add zsh to valid shells if not already there
    if ! grep -q "$zsh_path" /etc/shells; then
        print_info "Adding zsh to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    print_info "Changing default shell to zsh..."
    chsh -s "$zsh_path"
    print_success "Default shell changed to zsh"
    print_warning "Please log out and log back in for the shell change to take effect"
}

# Main installation flow
main() {
    print_header "Development Environment Setup"
    print_info "This script will set up your development environment"
    echo ""

    # Detect OS
    detect_os

    # Ask user preferences
    ask_install_tmux
    ask_install_extras
    ask_install_node

    # Installation steps
    install_system_dependencies
    install_homebrew
    install_core_tools
    install_tmux_package
    install_extra_tools
    install_nodejs
    install_oh_my_zsh
    install_nerd_fonts
    setup_symlinks
    setup_shell_integrations
    change_shell

    print_header "Installation Complete!"
    print_success "All tools have been installed successfully"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. If you installed Nerd Fonts, configure your terminal to use one"
    echo "  3. Your old config files have been backed up with timestamps"
    echo ""
    print_info "Installed tools:"
    echo "  - Homebrew (package manager)"
    echo "  - Git (version control)"
    echo "  - Zsh + Oh My Zsh (shell)"
    echo "  - Neovim (text editor)"
    echo "  - Zoxide (smarter cd)"
    echo "  - fzf (fuzzy finder)"
    echo "  - ripgrep (better grep)"
    echo "  - fd (better find)"
    echo "  - bat (better cat)"
    echo "  - eza (better ls)"
    echo "  - gh (GitHub CLI)"
    echo "  - starship (prompt)"
    if [[ "$INSTALL_TMUX" == true ]]; then
        echo "  - tmux (terminal multiplexer)"
    fi
    if [[ "$INSTALL_EXTRAS" == true ]]; then
        echo "  - lazygit, delta, btop, tldr, jq"
    fi
    if [[ "$INSTALL_NODE" == true ]]; then
        echo "  - Node.js"
    fi
    if is_visual_environment; then
        echo "  - Nerd Fonts"
    fi
    echo ""
    print_warning "Remember to restart your terminal!"
}

# Run main function
main
