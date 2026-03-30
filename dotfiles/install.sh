#!/bin/bash

set -e

PURPLE='\033[0;35m'
PURPLE_BRIGHT='\033[1;35m'
PURPLE_GLOW='\033[38;5;135m'
DARK='\033[0;30m'
BG='\033[48;5;27m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

clear
echo -e "${PURPLE}"
echo "  ██████╗ ██████╗ ██████╗ ███████╗███████╗████████╗ ██████╗ ███╗   ██╗"
echo "  ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║"
echo "  ██████╔╝██████╔╝██████╔╝█████╗  ███████╗   ██║   ██║   ██║██╔██╗ ██║"
echo "  ██╔═══╝ ██╔══██╗██╔══██╗██╔══╝  ╚════██║   ██║   ██║   ██║██║╚██╗██║"
echo -e "  ██║     ██║  ██║██║  ██║███████╗███████║   ██║   ╚██████╔╝██║ ╚████║"
echo "  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝"
echo -e "                     ${PURPLE_GLOW}▓▓▓ ${WHITE}INSTALADOR ${PURPLE_GLOW}▓▓▓${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando paquetes...${NC}"
PACKAGES="zsh cargo micro zoxide fzf bat eza curl wget git python3-pip fontconfig"

if command -v nala &> /dev/null; then
    sudo nala install -y $PACKAGES
elif command -v apt &> /dev/null; then
    sudo apt install -y $PACKAGES
else
    echo -e "${PURPLE_GLOW}[!]${NC} No se encontro apt/nala."
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

echo ""
echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando Oh My Zsh...${NC}"
if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando powerlevel10k...${NC}"
if [[ ! -d "$HOME/.oh-my-zsh/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/themes/powerlevel10k"
fi

echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando fzf-tab...${NC}"
FZF_TAB_DIR="$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
if [[ ! -d "$FZF_TAB_DIR" ]]; then
    git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
fi

echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando zsh-autosuggestions...${NC}"
ZSH_AUTOSUGGEST_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [[ ! -d "$ZSH_AUTOSUGGEST_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
fi

echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando zsh-syntax-highlighting...${NC}"
ZSH_SYNTAX_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [[ ! -d "$ZSH_SYNTAX_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"
fi

echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando atuin...${NC}"
if ! command -v atuin &> /dev/null; then
    curl -L https://setup.atuin.sh | sh
fi

echo ""
echo -e "${PURPLE_GLOW}[♦]${NC} ${BOLD}Instalando Nerd Fonts (MesloLGS)...${NC}"
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
echo -e "${PURPLE_GLOW}[▓]${NC} ${BOLD}Respaldando configuraciones existentes...${NC}"
mkdir -p "$BACKUP_DIR"

backup_file() {
    if [[ -e "$HOME/$1" ]]; then
        cp -r "$HOME/$1" "$BACKUP_DIR/"
        echo -e "${PURPLE_GLOW}  ✓${NC} Respaldado: $1"
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
echo -e "${PURPLE_GLOW}[▓]${NC} ${BOLD}Vinculando configuraciones...${NC}"
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
echo -e "${PURPLE_GLOW}[▓]${NC} ${BOLD}Instalando configuraciones de ROOT...${NC}"
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
    
    echo -e "${PURPLE_GLOW}  →${NC} Instalando Oh My Zsh para root..."
    if [[ ! -f "/root/.oh-my-zsh/oh-my-zsh.sh" ]]; then
        sudo git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh
    fi
    
    echo -e "${PURPLE_GLOW}  →${NC} Instalando plugins para root..."
    [[ ! -d "/root/.oh-my-zsh/themes/powerlevel10k" ]] && sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/themes/powerlevel10k
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/fzf-tab" ]] && sudo git clone https://github.com/Aloxaf/fzf-tab /root/.oh-my-zsh/custom/plugins/fzf-tab
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]] && sudo git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]] && sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    
    echo -e "${PURPLE_GLOW}  →${NC} Instalando atuin para root..."
    if ! sudo -u root command -v atuin &> /dev/null; then
        curl -L https://setup.atuin.sh | sh -s -- --bin-dir /root/.local/bin
    fi
    
    sudo chsh -s $(which zsh)
fi

echo ""
echo -e "${PURPLE_GLOW}[▓]${NC} ${BOLD}Cambiando shell a zsh...${NC}"
sudo chsh -s $(which zsh)

echo ""
echo -e "${PURPLE_BRIGHT}"
echo "  ╔═══════════════════════════════════════════════════════════════╗"
echo "  ║                                                               ║"
echo "  ║${WHITE}            ██╗   ██╗██╗ ██████╗████████╗██╗   ██╗██████╗       ${PURPLE_BRIGHT}║"
echo "  ║${WHITE}            ██║   ██║██║██╔════╝╚══██╔══╝██║   ██║██╔══██╗      ${PURPLE_BRIGHT}║"
echo "  ║${WHITE}            ██║   ██║██║██║        ██║   ██║   ██║██████╔╝      ${PURPLE_BRIGHT}║"
echo "  ║${WHITE}            ╚██╗ ██╔╝██║██║        ██║   ██║   ██║██╔══██╗      ${PURPLE_BRIGHT}║"
echo "  ║${WHITE}             ╚████╔╝ ██║╚██████╗   ██║   ╚██████╔╝██║  ██║      ${PURPLE_BRIGHT}║"
echo "  ║${WHITE}              ╚═══╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝      ${PURPLE_BRIGHT}║"
echo "  ║                                                               ║"
echo -e "  ╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${PURPLE_GLOW}[✓]${NC} ${BOLD}Cierra sesion y vuelve a entrar, o ejecuta: ${WHITE}exec zsh${NC}"
echo -e "${PURPLE_GLOW}[✓]${NC} ${BOLD}Respaldo guardado en: ${WHITE}$BACKUP_DIR${NC}"
echo ""
