#!/bin/bash

# Install NerdFonts monospaced with icons and ligatures
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
apt-get update
command -v unzip >/dev/null 2>&1 || apt-get install -y unzip
dpkg -s fontconfig >/dev/null 2>&1 || apt-get install -y fontconfig
curl -OL $FONT_URL
FONT_NAME=$(basename $FONT_URL .zip)
unzip -o $FONT_NAME.zip -d /usr/share/fonts/$FONT_NAME
fc-cache -fv
rm $FONT_NAME.zip

# Install OhMyPosh
if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Determine the current shell
SHELL_NAME=$(oh-my-posh get shell)
THEME_URL="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cloud-native-azure.omp.json"

# Create a shared directory for Oh My Posh themes
POSHTHEMES_DIR="/usr/local/share/oh-my-posh/themes"
mkdir -p $POSHTHEMES_DIR

# Download and set permissions for the theme
curl -sL $THEME_URL -o $POSHTHEMES_DIR/wholespace.omp.json
chmod rw $POSHTHEMES_DIR/wholespace.omp.json

# Add Oh My Posh configuration to the shell profile if not already present
if [ "$SHELL_NAME" = "bash" ]; then
    if ! grep -q 'oh-my-posh init bash' ~/.bashrc; then
        echo "eval \"\$(oh-my-posh init bash --config $POSHTHEMES_DIR/wholespace.omp.json)\"" >> ~/.bashrc
    fi
elif [ "$SHELL_NAME" = "zsh" ]; then
    if ! grep -q 'oh-my-posh init zsh' ~/.zshrc; then
        echo "eval \"\$(oh-my-posh init zsh --config $POSHTHEMES_DIR/wholespace.omp.json)\"" >> ~/.zshrc
    fi
else
    echo "Shell $SHELL_NAME is not supported by this script. Please configure Oh My Posh manually."
fi
