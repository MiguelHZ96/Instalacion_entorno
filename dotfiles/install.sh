#!/bin/bash

set -e

PURPLE='\033[0;35m'
PURPLE_BRIGHT='\033[1;35m'
PURPLE_GLOW='\033[38;5;135m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

clear

echo -e "${PURPLE}"
echo "    ███╗   ███╗███████╗██████╗  ██████╗  ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗███████╗██████╗ "
echo "    ████╗ ████║██╔════╝██╔══██╗██╔═══██╗██╔════╝██║  ██║██╔══██╗██║████╗  ██║██╔════╝██╔══██╗"
echo "    ██╔████╔██║█████╗  ██████╔╝██║   ██║██║     ███████║███████║██║██╔██╗ ██║█████╗  ██████╔╝"
echo "    ██║╚██╔╝██║██╔══╝  ██╔══██╗██║   ██║██║     ██╔══██║██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗"
echo "    ██║ ╚═╝ ██║███████╗██║  ██║╚██████╔╝╚██████╗██║  ██║██║  ██║██║██║ ╚████║███████╗██║  ██║"
echo -e "    ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "${PURPLE_GLOW}═══════════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE_BRIGHT}                         ⚡ CONFIGURACION DEL ENTORNO ⚡${NC}"
echo -e "${PURPLE_GLOW}                              by MiguelHZ96${NC}"
echo -e "${PURPLE_GLOW}═══════════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

spinner() {
    local delay=0.1
    local duration=$1
    local start=$SECONDS
    while (( SECONDS - start < duration )); do
        for s in / - \\ \|; do
            printf "\r${PURPLE_GLOW}[${s}]${NC} $2"
            sleep $delay
        done
    done
    printf "\r${PURPLE_BRIGHT}[✓]${NC} $2\n"
}

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando paquetes...${NC}"
(spinner 1 "Paquetes instalados" &) || true
PACKAGES="zsh cargo micro zoxide fzf bat eza curl wget git python3-pip fontconfig"
if command -v nala &> /dev/null; then
    sudo nala install -y $PACKAGES
elif command -v apt &> /dev/null; then
    sudo apt install -y $PACKAGES
else
    echo -e "${PURPLE_GLOW}✗${NC} No se encontro apt/nala."
    exit 1
fi
wait 2>/dev/null

export PATH="$HOME/.local/bin:$PATH"

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando Oh My Zsh...${NC}"
(spinner 1 "Oh My Zsh instalado" &) || true
if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi
wait 2>/dev/null

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando powerlevel10k...${NC}"
(spinner 1 "powerlevel10k instalado" &) || true
if [[ ! -d "$HOME/.oh-my-zsh/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/themes/powerlevel10k"
fi
wait 2>/dev/null

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando fzf-tab...${NC}"
(spinner 1 "fzf-tab instalado" &) || true
FZF_TAB_DIR="$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
if [[ ! -d "$FZF_TAB_DIR" ]]; then
    git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
fi
wait 2>/dev/null

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando zsh-autosuggestions...${NC}"
(spinner 1 "zsh-autosuggestions instalado" &) || true
ZSH_AUTOSUGGEST_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [[ ! -d "$ZSH_AUTOSUGGEST_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
fi
wait 2>/dev/null

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando zsh-syntax-highlighting...${NC}"
(spinner 1 "zsh-syntax-highlighting instalado" &) || true
ZSH_SYNTAX_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [[ ! -d "$ZSH_SYNTAX_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"
fi
wait 2>/dev/null

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando atuin...${NC}"
(spinner 1 "atuin instalado" &) || true
if ! command -v atuin &> /dev/null; then
    curl -L https://setup.atuin.sh | sh
fi
wait 2>/dev/null

echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando Nerd Fonts (MesloLGS)...${NC}"
(spinner 1 "Nerd Fonts instalados" &) || true
FONT_DIR="/usr/local/share/fonts/meslo"
if [[ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]]; then
    sudo mkdir -p "$FONT_DIR"
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    sudo curl -fLo "$FONT_DIR/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    sudo fc-cache -f -v
fi
wait 2>/dev/null

echo ""
echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Respaldando configuraciones existentes...${NC}"
mkdir -p "$BACKUP_DIR"

backup_file() {
    if [[ -e "$HOME/$1" ]]; then
        cp -r "$HOME/$1" "$BACKUP_DIR/"
        echo -e "${PURPLE_BRIGHT}  ├─${NC} Respaldado: $1"
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
echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Vinculando configuraciones...${NC}"
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
echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Instalando configuraciones de ROOT...${NC}"
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
    
    echo -e "${PURPLE_GLOW}  ├─${NC} Instalando Oh My Zsh para root..."
    if [[ ! -f "/root/.oh-my-zsh/oh-my-zsh.sh" ]]; then
        sudo rm -rf /root/.oh-my-zsh
        sudo git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh
    fi
    
    echo -e "${PURPLE_GLOW}  ├─${NC} Instalando plugins para root..."
    [[ ! -d "/root/.oh-my-zsh/themes/powerlevel10k" ]] && sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/themes/powerlevel10k
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/fzf-tab" ]] && sudo git clone https://github.com/Aloxaf/fzf-tab /root/.oh-my-zsh/custom/plugins/fzf-tab
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]] && sudo git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    [[ ! -d "/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]] && sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    
    echo -e "${PURPLE_GLOW}  └─${NC} Instalando atuin para root..."
    ATUIN_USER="$HOME/.atuin/bin/atuin"
    if [[ -f "$ATUIN_USER" ]]; then
        sudo mkdir -p /root/.atuin/bin
        sudo cp "$ATUIN_USER" /root/.atuin/bin/
        [[ -f "$HOME/.atuin/bin/atuin-update" ]] && sudo cp "$HOME/.atuin/bin/atuin-update" /root/.atuin/bin/
        [[ -f "$HOME/.atuin/bin/env" ]] && sudo cp "$HOME/.atuin/bin/env" /root/.atuin/bin/
        echo -e "${PURPLE_BRIGHT}    ✓${NC} Atuin copiado a root"
    elif ! command -v atuin &> /dev/null; then
        curl -L https://setup.atuin.sh | sh -s -- --bin-dir /root/.local/bin
    fi
    
    sudo chsh -s $(which zsh)
fi

echo ""
echo -e "${PURPLE_GLOW}▸${NC} ${BOLD}Cambiando shell a zsh...${NC}"
sudo chsh -s $(which zsh)

echo ""
echo -e "${PURPLE_GLOW}═══════════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE_BRIGHT}"
echo "     ▄▀▄ █▀▄ ▄▀▀   █▀▀ █▀█ █▀█ █ █▀ █▀▀   █▀▄ █▀▀ █▀ ▀█▀"
echo "     █▀█ █▀▄ ░▀▄   █▀  █▄█ █▀▄ █ █▀ ▀▀█   █▀▄ █▀  █▀  █ "
echo -e "     ▀ ▀ ▀▀  ▀▀▀   ▀   ▀ ▀ ▀  ▀ ▀ ▀▀ ▀▀▀   ▀ ▀ ▀▀▀ ▀   ▀"
echo -e "${NC}"
echo -e "${PURPLE_GLOW}═══════════════════════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${PURPLE_GLOW}[✓]${NC} ${BOLD}Cierra sesion y vuelve a entrar, o ejecuta: ${WHITE}exec zsh${NC}"
echo -e "${PURPLE_GLOW}[✓]${NC} ${BOLD}Respaldo guardado en: ${WHITE}$BACKUP_DIR${NC}"
echo ""
