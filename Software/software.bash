#!/bin/bash

# VIDEO
AMD='xf86-video-amdgpu mesa lib32-mesa vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver libva-vdpau-driver mesa-vdpau lib32-mesa-vdpau'
INTEL='xf86-video-intel mesa lib32-mesa'
NVIDIA='nvidia nvidia-utils lib32-nvidia-utils libva-vdpau-driver'
XORG='xorg-server xorg-apps xorg-server-xwayland'

# KDE
KDE='sddm'

# GNOME
GNOME='gdm gnome gnome-extra'
GNOME_EXTRA_PACKAGES='gnome-boxes gnome-games gnome-multi-writer simple-scan'

# SYSTEM
SYSTEM='htop wget tmux samba pavucontrol bluez-utils'
FILESYSTEMS='ntfs-3g'
PRINTER='cups cups-pdf sane xsane foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds gutenprint ghostscript gsfonts'
GRAPICS='gimp poppler-glib krita dia inkscape blender handbrake kdenlive openshot obs-studio simplescreenrecorder'
MEDIA='vlc qt4 libcdio mplayer gnome-mplayer lollypop rhythmbox ardour audacity gnome-sound-recorder mpv smplayer kodi'
CODECS='celt faac faad2 flac libfdk-aac jasper lame a52dec libdca libdv libmpeg2 libmad libmpcdec opencore-amr schroedinger speex libtheora libvorbis wavpack xvidcore'
NETWORK='networkmanager network-manager-applet dhclient qbittorrent youtube-dl'
VPN='openvpn networkmanager-openvpn networkmanager-openconnect networkmanager-vpnc networkmanager-strongswan'
DEV='atom vim codeblocks eclipse-cpp geany netbeans'
OFFICE='libreoffice-fresh hunspell hunspell-en hyphen hyphen-en libmythes mythes-en languagetool atril pdfmod xournal'
OFFICE_EXTRA='libreoffice-extension-texmaths libreoffice-extension-writer2latex'
RECOVERY='testdisk ddrescue'
SSH='openssh rsync'

# Theming
ICONS='papirus-icon-theme arc-icon-theme deepin-icon-theme elementary-icon-theme faenza-icon-theme faience-icon-theme gnome-icon-theme gnome-icon-theme-extras gnome-icon-theme-symbolic hicolor-icon-theme human-icon-theme lxde-icon-theme mate-icon-theme mate-icon-theme-faenza tangerine-icon-theme'
SHELL_THEME='adapta-gtk-theme arc-gtk-theme arc-solid-gtk-theme breeze-gtk deepin-gtk-theme numix-gtk-theme'

# Fonts
FONTS='ttf-anonymous-pro ttf-bitstream-vera ttf-croscore ttf-droid ttf-fira-mono ttf-freefont ttf-hack ttf-inconsolata ttf-liberation ttf-roboto adobe-source-code-pro-fonts dina-font artwiz-fonts profont tamsyn-font terminus-font bdf-unifont ttf-ubuntu-font-family ttf-gentium ttf-linux-libertine font-bh-ttf ttf-cheapskate ttf-junicode ttf-mph-2b-damase xorg-fonts-type1 noto-fonts'
FONTS_EXTRA='ttf-ubraille adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts wqy-zenhei wqy-bitmapfont ttf-arphic-ukai ttf-arphic-uming opendesktop-fonts ttf-hannom adobe-source-han-sans-jp-fonts otf-ipafont ttf-hanazono ttf-sazanami adobe-source-han-sans-kr-fonts ttf-baekmuk ttf-freebanglafont ttf-indic-otf ttf-khmer fonts-tlwg'
FONTS_CHARACTERS='noto-fonts-emoji ttf-symbola font-mathematica texlive-core texlive-fontsextra'

# Web
BROWSERS='firefox chromium opera'

# AUR
AUR_SYSTEM='brother-hl2270dw chrome-gnome-shell-git dpkg'
AUR_FIXES='pulseaudio-bluetooth-a2dp-gdm-fix'
AUR_MEDIA='spotify google-chrome'

# Bluetooth Fix
bluetooth ()
{
	systemctl status bluetooth
	pacmd list-sinks

	# index: 3
	# name: <bluez_sink.20_16_03_17_4D_E3.headset_head_unit>
	# driver: <module-bluez5-device.c>
	# flags: HARDWARE HW_VOLUME_CTRL LATENCY
	# state: SUSPENDED
	# suspend cause: IDLE
	# priority: 9050
	# volume: mono: 27775 /  42%
	# 				balance 0.00
	# base volume: 65536 / 100%
	# volume steps: 16
	# muted: no
	# current latency: 0.00 ms
	# max request: 0 KiB
	# max rewind: 0 KiB
	# monitor source: 5
	# sample spec: s16le 1ch 8000Hz
	# channel map: mono
	# 						 Mono
	# used by: 0
	# linked by: 0
	# fixed latency: 128.00 ms
	# card: 3 <bluez_card.20_16_03_17_4D_E3>
	# module: 28
	# properties:
	# 	bluetooth.protocol = "headset_head_unit"
	# 	device.intended_roles = "phone"
	# 	device.description = "PH-BTH3 Headphones"
	# 	device.string = "20:16:03:17:4D:E3"
	# 	device.api = "bluez"
	# 	device.class = "sound"
	# 	device.bus = "bluetooth"
	# 	device.form_factor = "headset"
	# 	bluez.path = "/org/bluez/hci0/dev_20_16_03_17_4D_E3"
	# 	bluez.class = "0x240404"
	# 	bluez.alias = "PH-BTH3 Headphones"
	# 	device.icon_name = "audio-headset-bluetooth"
	# ports:
	# 	headset-output: Headset (priority 0, latency offset 0 usec, available: unknown)
	# 		properties:
	# active port: <headset-output>

	pacmd set-card-profile 3 a2dp_sink
}

# Installation
install()
{
	MY_HOST_NAME='Nabler'
	INSTALL_DISK='/dev/sda'
	ESP='/dev/sda1'
	ESP_MOUNT='/boot/efi'
	ROOT='/dev/sda2'
	SWAP='/dev/sda3'
	HOME='/dev/sda4'

	# ls /sys/firmware/efi/efivars
	# ping archlinux.org

	timedatectl set-ntp true

	parted $INSTALL_DISK mklabel gpt
	parted $INSTALL_DISK mkpart ESP fat32 1MiB 513MiB
	parted $INSTALL_DISK set 1 boot on
	parted $INSTALL_DISK mkpart primary ext4 513MiB 70.5GiB
	parted $INSTALL_DISK mkpart primary linux-swap 70.5GiB 80.5GiB
	parted $INSTALL_DISK mkpart primary ext4 80.5GiB 100%

	mkfs.fat -F32 $ESP
	mkswap $SWAP
	swapon $SWAP
	mkfs.ext4 $ROOT
	mkfs.ext4 $HOME

	mount $ROOT /mnt
	mkdir -p /mnt/boot/efi
	mkdir -p /mnt/home
	mount $ESP /mnt/boot/efi
	mount $HOME /mnt/home

	pacstrap /mnt base base-devel

	genfstab -U /mnt >> /mnt/etc/fstab

	arch-chroot /mnt

	ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
	hwclock --systohc

	sudo nano /etc/locale.gen # uncomment en_US.UTF-8 UTF-8
	locale-gen
	echo 'LANG=en_US.UTF-8' > /etc/locale.conf

	echo $MY_HOST_NAME > /etc/hostname

	echo -e "127.0.0.1\tlocalhost.localdomain\tlocalhost" >> /etc/hosts
	echo -e "::1\t\tlocalhost.localdomain\tlocalhost" >> /etc/hosts
	echo -e "127.0.1.1\t$MY_HOST_NAME.localdomain\t$MY_HOST_NAME" >> /etc/hosts

	mkinitcpio -p linux
	passwd

	pacman -Syu intel-ucode grub os-prober efibootmgr
	grub-install --target=x86_64-efi --efi-directory=$ESP_MOUNT --bootloader-id=grub
	grub-mkconfig -o /boot/grub/grub.cfg

	exit
	umount -R /mnt
	systemctl poweroff
}

# Post Installation
postInstall()
{

	USERNAME='nabler'

	useradd -m -G wheel -s /bin/bash $USERNAME
	passwd $USERNAME

	nano /etc/sudoers # uncomment %wheel ALL=(ALL) ALL
	nano /etc/pacman.conf # uncomment [multilib], and Include=/etc/pacman.d/mirrolist

	pacman -Syy
	pacman-key --refresh-keys
	pacman -Syu $XORG $AMD $GNOME $GNOME_EXTRA_PACKAGES $NETWORK

	systemctl enable gdm.service
	systemctl enable NetworkManager
	systemctl reboot
}
