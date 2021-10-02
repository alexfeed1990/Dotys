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
yay -S betterlockscreen deadbeef-git trayer-srg
betterlockscreen -u ~/Wallpaper.jpg
nitrogen --set-zoom-fill ~/Wallpaper.jpg
nitrogen --save
sudo systemctl enable sddm
sudo systemctl enable dunst
echo "Everything should be setup as intended. Enjoy your setup!"
exit
