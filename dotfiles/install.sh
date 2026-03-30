#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "=== Dotfiles Installer ==="

echo ""
echo "=== Installing packages ==="
PACKAGES="zsh cargo micro zoxide fzf bat eza curl wget git python3-pip fontconfig"

if command -v nala &> /dev/null; then
    sudo nala install -y $PACKAGES
elif command -v apt &> /dev/null; then
    sudo apt install -y $PACKAGES
else
    echo "No apt/nala found. Install packages manually."
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "=== Installing Oh My Zsh (if not exists) ==="
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo ""
echo "=== Installing zsh-autosuggestions ==="
ZSH_AUTOSUGGEST_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [[ ! -d "$ZSH_AUTOSUGGEST_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
fi

echo ""
echo "=== Installing thefuck ==="
if ! command -v thefuck &> /dev/null; then
    pip3 install thefuck --break-system-packages
fi

echo ""
echo "=== Installing atuin ==="
if ! command -v atuin &> /dev/null; then
    curl -L https://setup.atuin.sh | sh
fi

echo ""
echo "=== Backing up existing configs ==="
mkdir -p "$BACKUP_DIR"

backup_file() {
    if [[ -e "$HOME/$1" ]]; then
        cp -r "$HOME/$1" "$BACKUP_DIR/"
        echo "  Backed up: $1"
    fi
}

backup_file ".zshrc"
backup_file ".zprofile"
backup_file ".zshenv"
backup_file ".p10k.zsh"
backup_file ".cargo/env"
[[ -f "$HOME/.config/micro/settings.json" ]] && backup_file ".config/micro/settings.json"
[[ -f "$HOME/.config/micro/bindings.json" ]] && backup_file ".config/micro/bindings.json"
[[ -f "$HOME/.local/share/zoxide/db.zo" ]] && backup_file ".local/share/zoxide"

echo ""
echo "=== Linking configs ==="
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

mkdir -p "$HOME/.cargo"
ln -sf "$DOTFILES_DIR/cargo/env" "$HOME/.cargo/env"

mkdir -p "$HOME/.config/micro"
ln -sf "$DOTFILES_DIR/micro/settings.json" "$HOME/.config/micro/settings.json"
[[ -f "$DOTFILES_DIR/micro/bindings.json" ]] && ln -sf "$DOTFILES_DIR/micro/bindings.json" "$HOME/.config/micro/bindings.json"

mkdir -p "$HOME/.local/share/zoxide"
[[ -f "$DOTFILES_DIR/zoxide/db.zo" ]] && ln -sf "$DOTFILES_DIR/zoxide/db.zo" "$HOME/.local/share/zoxide/db.zo"

echo ""
echo "=== Changing shell to zsh ==="
sudo chsh -s /bin/zsh

echo ""
echo "=== Done! ==="
echo "Log out and log back in, or run: exec zsh"
echo "Backup saved at: $BACKUP_DIR"
