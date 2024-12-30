#!/bin/bash
clear
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

# Function: Check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Function: Print Banner
print_banner() {
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${CYAN}==========================================${NC}"
}

# Step 0: ASCII Art Banner
print_ascii_banner() {
    clear
    if check_command toilet; then
        toilet -f smblock -F border "  TERMUX BANNER  " | lolcat
    else
        echo -e "${RED}Toilet not installed. Skipping banner.${NC}"
    fi
    echo -e "${CYAN}Tool by: Mr-Sunil ${NC}"
    echo -e "${CYAN}Follow us:${NC}"
    echo -e "${YELLOW}YouTube: https://youtube.com/@noobcybertech2024${NC}"
    echo -e "${YELLOW}Telegram: https://t.me/Annon4you${NC}"
    echo -e "${YELLOW}Facebook: https://facebook.com/share/1HrTAb9GoH/${NC}"
    echo -e "${YELLOW}Instagram: annon_4you${NC}"
    echo -e "${CYAN}==========================================${NC}"
}
print_ascii_banner
sleep 5

# Step 1: Update and Upgrade Termux
print_banner "Updating and Upgrading Termux Packages"
pkg update -y && pkg upgrade -y
echo -e "${GREEN}Packages updated successfully.${NC}"

# Step 2: Install Required Packages
print_banner "Installing Required Packages"
packages=(starship termimage fish python wget toilet)
for pkg in "${packages[@]}"; do
    if ! check_command "$pkg"; then
        echo -e "${BLUE}Installing $pkg...${NC}"
        pkg install "$pkg" -y
    else
        echo -e "${GREEN}$pkg is already installed.${NC}"
    fi
done

# Step 3: Install Python Package (lolcat)
print_banner "Installing Lolcat Python Package"
if ! check_command lolcat; then
    pip install lolcat
    echo -e "${GREEN}Lolcat installed.${NC}"
else
    echo -e "${GREEN}Lolcat is already installed.${NC}"
fi

# Step 4: Set Fish as the Default Shell
print_banner "Setting Fish Shell as Default"
if ! check_command fish; then
    echo -e "${RED}Fish shell is not installed. Skipping.${NC}"
else
    chsh -s fish
    echo -e "${GREEN}Fish is now the default shell. Restart Termux to apply changes.${NC}"
fi

# Step 5: Remove Fish Greeting
print_banner "Removing Fish Greeting"
FISH_CONFIG_DIR="/data/data/com.termux/files/usr/etc/fish"
mkdir -p "$FISH_CONFIG_DIR"
FISH_CONFIG_FILE="$FISH_CONFIG_DIR/config.fish"
echo "set -U fish_greeting ''" > "$FISH_CONFIG_FILE"
echo -e "${GREEN}Fish greeting removed.${NC}"

# Step 6: Configure Starship with Fish
print_banner "Configuring Starship with Fish"
if ! grep -q "starship init fish" "$FISH_CONFIG_FILE"; then
    echo "starship init fish | source" >> "$FISH_CONFIG_FILE"
    echo -e "${GREEN}Starship initialization added to Fish config.${NC}"
else
    echo -e "${YELLOW}Starship is already configured in Fish.${NC}"
fi

# Step 7: Download and Set TermImage Banner
print_banner "Setting Up TermImage Banner"
IMAGE_URL="https://github.com/prince4you/Term-Banner/raw/main/Hacker.jpg"
IMAGE_PATH="$HOME/Hacker.jpg"

echo -e "${BLUE}Downloading banner image...${NC}"
wget -q $IMAGE_URL -O $IMAGE_PATH

if [ -f "$IMAGE_PATH" ]; then
    echo -e "${BLUE}Generating TermImage output...${NC}"
    if check_command termimage; then
        termimage "$IMAGE_PATH" > "$PREFIX/etc/motd"
        echo -e "${GREEN}Banner set successfully in MOTD.${NC}"
    else
        echo -e "${RED}TermImage not installed. Skipping banner setup.${NC}"
    fi
else
    echo -e "${RED}Failed to download the banner image.${NC}"
fi

# Step 8: Download Custom Starship Config
print_banner "Downloading Custom Starship Config"
mkdir -p ~/.config
wget https://raw.githubusercontent.com/prince4you/Term-Banner/main/starship.toml -O ~/.config/starship.toml

# Step 9: ASCII Art Banner
print_ascii_banner

# Step 10: Completion Message
print_banner "Setup Complete"
echo -e "${GREEN}Restart your Termux.${NC}"
