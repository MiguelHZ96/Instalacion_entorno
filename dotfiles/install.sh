#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "=== Instalador de Dotfiles ==="

echo ""
echo "=== Instalando paquetes ==="
PACKAGES="zsh cargo micro zoxide fzf bat eza curl wget git python3-pip fontconfig"

if command -v nala &> /dev/null; then
    sudo nala install -y $PACKAGES
elif command -v apt &> /dev/null; then
    sudo apt install -y $PACKAGES
else
    echo "No se encontro apt/nala. Instala los paquetes manualmente."
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "=== Instalando Oh My Zsh ==="
if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

echo ""
echo "=== Instalando powerlevel10k ==="
if [[ ! -d "$HOME/.oh-my-zsh/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/themes/powerlevel10k"
fi

echo ""
echo "=== Instalando fzf-tab ==="
FZF_TAB_DIR="$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
if [[ ! -d "$FZF_TAB_DIR" ]]; then
    git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
fi

echo ""
echo "=== Instalando zsh-autosuggestions ==="
ZSH_AUTOSUGGEST_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [[ ! -d "$ZSH_AUTOSUGGEST_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
fi

echo ""
echo "=== Instalando zsh-syntax-highlighting ==="
ZSH_SYNTAX_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [[ ! -d "$ZSH_SYNTAX_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"
fi

echo ""
echo "=== Instalando atuin ==="
if ! command -v atuin &> /dev/null; then
    curl -L https://setup.atuin.sh | sh
fi

echo ""
echo "=== Instalando Nerd Fonts ==="
FONT_DIR="/usr/local/share/fonts/meslo"
if [[ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]]; then
    sudo mkdir -p "$FONT_DIR"
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    sudo fc-cache -f -v
fi

echo ""
echo "=== Respaldando configuraciones existentes ==="
mkdir -p "$BACKUP_DIR"

backup_file() {
    if [[ -e "$HOME/$1" ]]; then
        cp -r "$HOME/$1" "$BACKUP_DIR/"
        echo "  Respaldado: $1"
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
echo "=== Vinculando configuraciones ==="
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
echo "=== Instalando configuraciones de root ==="
if [[ -d "$DOTFILES_DIR/zsh/root" ]]; then
    ROOT_BACKUP="/root/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    sudo mkdir -p "$ROOT_BACKUP"
    
    [[ -f /root/.zshrc ]] && sudo cp -r /root/.zshrc "$ROOT_BACKUP/"
    [[ -f /root/.zshenv ]] && sudo cp -r /root/.zshenv "$ROOT_BACKUP/"
    [[ -f /root/.zprofile ]] && sudo cp -r /root/.zprofile "$ROOT_BACKUP/"
    [[ -f /root/.p10k.zsh ]] && sudo cp -r /root/.p10k.zsh "$ROOT_BACKUP/"
    
    sudo cp "$DOTFILES_DIR/zsh/root/.zshrc" /root/.zshrc
    sudo cp "$DOTFILES_DIR/zsh/root/.zshenv" /root/.zshenv
    [[ -f "$DOTFILES_DIR/zsh/root/.zprofile" ]] && sudo cp "$DOTFILES_DIR/zsh/root/.zprofile" /root/.zprofile
    [[ -f "$DOTFILES_DIR/zsh/root/.p10k.zsh" ]] && sudo cp "$DOTFILES_DIR/zsh/root/.p10k.zsh" /root/.p10k.zsh
    
    [[ -f "$DOTFILES_DIR/zsh/root/.cargo_env" ]] && sudo mkdir -p /root/.cargo && sudo cp "$DOTFILES_DIR/zsh/root/.cargo_env" /root/.cargo/env
    
    sudo mkdir -p /root/.config/micro
    [[ -f "$DOTFILES_DIR/zsh/root/.config/micro/settings.json" ]] && sudo cp "$DOTFILES_DIR/zsh/root/.config/micro/settings.json" /root/.config/micro/settings.json
    [[ -f "$DOTFILES_DIR/zsh/root/.config/micro/bindings.json" ]] && sudo cp "$DOTFILES_DIR/zsh/root/.config/micro/bindings.json" /root/.config/micro/bindings.json
    
    sudo mkdir -p /root/.local/share/zoxide
    [[ -f "$DOTFILES_DIR/zsh/root/.local/share/zoxide/db.zo" ]] && sudo cp "$DOTFILES_DIR/zsh/root/.local/share/zoxide/db.zo" /root/.local/share/zoxide/db.zo
    
    echo "  Instalando Oh My Zsh para root..."
    if [[ ! -f "/root/.oh-my-zsh/oh-my-zsh.sh" ]]; then
        sudo git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh
    fi
    
    echo "  Instalando plugins para root..."
    [[ ! -d "/root/.oh-my-zsh/themes/powerlevel10k" ]] && sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/themes/powerlevel10k
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/fzf-tab" ]] && sudo git clone https://github.com/Aloxaf/fzf-tab /root/.oh-my-zsh/custom/plugins/fzf-tab
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]] && sudo git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]] && sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    
    echo "  Instalando atuin para root..."
    if ! sudo -u root command -v atuin &> /dev/null; then
        curl -L https://setup.atuin.sh | sh -s -- --bin-dir /root/.local/bin
    fi
    
    sudo chsh -s $(which zsh)
    echo "  Configuraciones de root instaladas"
fi

echo ""
echo "=== Cambiando shell a zsh ==="
sudo chsh -s $(which zsh)

echo ""
echo "=== Listo! ==="
echo "Cierra sesion y vuelve a entrar, o ejecuta: exec zsh"
echo "Respaldo guardado en: $BACKUP_DIR"
