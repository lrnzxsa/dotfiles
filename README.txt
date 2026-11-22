Arch Installation

Installer network configuration:
	rfkill unblock all
	nano /var/lib/iwd/networkname.psk:
		[Security]
		Passphrase=password
		
		[Settings]
		AutoConnect=True
	systemctl restart iwd



Disk Partitioning:
	1GB fat32 /boot
	499GB btrfs subvolumes:
		@		/
		@home		/home
		@log		/var/log
		@pkg		/var/cache/pacman/pkg
		@.snapshot	/.snapshot


Additional packages:
	hyprland hyprpickr hyprpaper hyprpolkitagent kitty waybar rofi pipewire swaync thunar wl-clipboard brightnessctl playerctl wireplumber wl-clipboard qt5-wayland qt6-wayland ttf-jetbrains-mono-nerd git base-devel qt6-svg qt6-declarative flatpak


Enable SDDM on startup
	sudo systemctl enable sddm.service

Install yay (Aur)
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

Install firefox:
	flatpak remote-add --if-not-exist flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub org.mozilla.firefox


Install Mullvad:
	yay -S mullvad-vpn-bin
	sudo systemctl enable --now mullvad-daemon.service
	sudo firewall-cmd --get-active-zones
	sudo firewall-cmd --permanent --zone=trusted --add-interface=wg0-mullvad
	sudo firewall-cmd --permanent --zone=public --add-masquerade
	sudo firewall-cmd --reload
	sudo systemctl restart mullvad-daemon.service
