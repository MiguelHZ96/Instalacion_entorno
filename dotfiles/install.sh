#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
PACKAGES="zsh cargo micro zoxide fzf bat eza curl wget git"

echo "=== Dotfiles Installer ==="
echo "Installing packages: $PACKAGES"
echo ""

if command -v nala &> /dev/null; then
    sudo nala install -y $PACKAGES
elif command -v apt &> /dev/null; then
    sudo apt install -y $PACKAGES
else
    echo "No apt/nala found. Install packages manually."
    exit 1
fi

echo ""
echo "Backing up existing configs to: $BACKUP_DIR"
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
backup_file ".oh-my-zsh"
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
ln -sf "$DOTFILES_DIR/zsh/oh-my-zsh" "$HOME/.oh-my-zsh"

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
