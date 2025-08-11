#!/bin/bash
# Thanks to this guy for kindly providing inspiration:
# https://github.com/JaKooLit

clear

# Packages to install with Pacman
PACMAN_PACKAGES="hyprland networkmanager kitty rofi playerctl tldr fish openssh brightnessctl wl-clipboard pipewire pwvucontrol wireplumber alsa-utils pipewire-alsa pipewire-pulse nvim lazygit egl-wayland yazi bluez bluez-utils ripgrep"

# Dotfiles Directory
DOTFILES_DIR="$HOME/hyprdots"

# Create a backup directory for existing dotfiles

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"


mkdir -p "$BACKUP_DIR"


echo "Backup directory created: $BACKUP_DIR"

# Function to create symlinks

create_symlink() {

    local source="$1"

    local target="$2"




    if [ -e "$target" ]; then


        echo "Backing up existing file: $target"

        mv "$target" "$BACKUP_DIR/"

    fi




    echo "Creating symlink: $target -> $source"


    ln -s "$source" "$target"


}

echo "Starting dotfiles installation..."


# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/01-Hyprland-Install-Scripts-$(date +%d-%H%M%S).log"

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "${ERROR}  This script should ${WARNING}NOT${RESET} be executed as root!! Exiting......." | tee -a "$LOG"
    printf "\n%.0s" {1..2} 
    exit 1
fi

# Pacman Packages
# These are installed first because later commands need ripgrep
echo "$NOTE Install required packages........"
if sudo pacman -S --noconfirm base-devel; then 
    echo "$OK Packages were installed successfully" | tee -a "$LOG"
else
    echo "$ERROR Packages could not be installed" | tee -a "$LOG"
    exit 1

# Check if PulseAudio package is installed
if pacman -Qq | rg -qw '^pulseaudio$'; then
    echo "$ERROR PulseAudio is detected as installed. Uninstall it first." | tee -a "$LOG"
    printf "\n%.0s" {1..2} 
    exit 1
fi

# Check if base-devel is installed
if pacman -Q base-devel &> /dev/null; then
    echo "base-devel is already installed."
else
    echo "$NOTE Install base-devel.........."

    if sudo pacman -S --noconfirm base-devel; then
        echo "👌 ${OK} base-devel has been installed successfully." | tee -a "$LOG"
    else
        echo "❌ $ERROR base-devel not found nor cannot be installed."  | tee -a "$LOG"
        echo "$ACTION Please install base-devel manually before running this script... Exiting" | tee -a "$LOG"
        exit 1
    fi
fi


for file in "$DOTFILES_DIR"/.*; do
    # Skip the current and parent directory entries
    if [[ "$file" == "$DOTFILES_DIR"/. || "$file" == "$DOTFILES_DIR"/.. ]]; then
        continue
    fi
    # Skip .gitignore if you don't want it in your home directory
    #
    if [[ "$(basename "$file")" == ".gitignore" ]]; then
        echo "Skipping .gitignore"
        continue
    fi

    # Get the base filename
    filename=$(basename "$file")
    target="$HOME/$filename"

    echo "Processing: $filename"  # Add this line for debugging
    create_symlink "$file" "$target"
done
echo "Dotfiles installation complete!"
