#!/usr/bin/env bash

# This font shit is directly grabbed from the rofi repository

# Dirs
DIR=`pwd`
FONT_DIR="$HOME/.local/share/fonts"

# Install Fonts
install_fonts() {
	if [[ -d "$FONT_DIR" ]]; then
		cp -rf $DIR/fonts/* "$FONT_DIR"
	else
		mkdir -p "$FONT_DIR"
		cp -rf $DIR/fonts/* "$FONT_DIR"
	fi
}

git clone https://github.com/alexfeed1990/dotys
cd dotys
sudo pacman -Syu ttf-font-awesome noto-fonts-emoji xmonad xmonad-contrib xmobar alsa-utils pulseaudio pulsemixer picom flameshot dunst rofi spotify alacritty firefox arandr feh nitrogen sddm xorg-xrandr xorg-xsetroot xorg-server xorg git
cp -a * . ~/
pacman -S --needed git base-devel
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git
cd yay-git
makepkg -si
yay -S betterlockscreen trayer-srg ttf-font-awesome-4
betterlockscreen -u ~/Wallpaper.jpg
echo "Use nitrogen after getting into xmonad to set the wallpaper, as stated in the readme."
sudo systemctl enable sddm
sudo systemctl enable dunst
git clone https://github.com/alexfeed1990/shetch
cd shetch
sudo make install
shetch
cd ..
install_fonts
echo "Everything should be setup as intended. Enjoy your setup!"
exit
