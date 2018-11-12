#!/bin/bash

# VIDEO
AMD='xf86-video-amdgpu xf86-video-ati mesa lib32-mesa vulkan-radeon libva-mesa-driver
	lib32-libva-mesa-driver libva-vdpau-driver mesa-vdpau lib32-mesa-vdpau'
INTEL='xf86-video-intel mesa lib32-mesa'
NVIDIA='nvidia nvidia-utils lib32-nvidia-utils libva-vdpau-driver'
XORG='xorg-server xorg-apps xorg-server-xwayland'

# KDE
KDE='sddm'

# GNOME
GNOME='gdm gnome gnome-extra chrome-gnome-shell'
GNOME_EXTRA_PACKAGES='gnome-boxes gnome-games gnome-multi-writer simple-scan'

# SYSTEM
SYSTEM='htop wget tmux samba pavucontrol bluez-utils'
COMPRESSION='lrzip lzip lzop unrar unarchiver'
FILESYSTEMS='ntfs-3g f2fs-tools p7zip exfat-utils xfsprogs udftools
			reiserfsprogs nilfs-utils btrfs-progs dosfstools curlftpfs davfs2
			encfs fuseiso s3fs-fuse sshfs ecryptfs-utils unionfs-fuse
			squashfs-tools ceph glusterfs go-ipfs moosefs'
PRINTER='cups cups-pdf sane xsane foomatic-db-engine foomatic-db
		foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds
		gutenprint ghostscript gsfonts'
GRAPICS='gimp poppler-glib krita dia inkscape blender handbrake kdenlive
		openshot obs-studio simplescreenrecorder'
MEDIA='vlc qt4 libcdio mplayer gnome-mplayer lollypop rhythmbox ardour
		audacity gnome-sound-recorder mpv smplayer kodi'
CODECS='celt faac faad2 flac libfdk-aac jasper lame a52dec libdca libdv
		libmpeg2 libmad libmpcdec opencore-amr schroedinger speex
		libtheora libvorbis wavpack xvidcore'
NETWORK='networkmanager network-manager-applet dhclient qbittorrent youtube-dl'
VPN='openvpn networkmanager-openvpn networkmanager-openconnect
	networkmanager-vpnc networkmanager-strongswan'
DEV='atom vim codeblocks eclipse-cpp geany netbeans git'
OFFICE='libreoffice-fresh hunspell hyphen hyphen-en
		libmythes mythes-en languagetool atril pdfmod xournal'
OFFICE_EXTRA='libreoffice-extension-texmaths libreoffice-extension-writer2latex'
RECOVERY='testdisk ddrescue'
SSH='openssh rsync'

# Theming
ICONS='papirus-icon-theme arc-icon-theme deepin-icon-theme elementary-icon-theme
	  faenza-icon-theme gnome-icon-theme
	  gnome-icon-theme-extras gnome-icon-theme-symbolic hicolor-icon-theme
	  human-icon-theme lxde-icon-theme mate-icon-theme mate-icon-theme-faenza
	  tangerine-icon-theme'
SHELL_THEME='adapta-gtk-theme arc-gtk-theme arc-solid-gtk-theme breeze-gtk
			deepin-gtk-theme numix-gtk-theme'

# Fonts
FONTS='ttf-anonymous-pro ttf-bitstream-vera ttf-croscore ttf-droid
	  ttf-fira-mono ttf-freefont ttf-hack ttf-inconsolata ttf-liberation
	  ttf-roboto adobe-source-code-pro-fonts dina-font artwiz-fonts
	  tamsyn-font terminus-font bdf-unifont ttf-ubuntu-font-family ttf-gentium
	  ttf-linux-libertine font-bh-ttf ttf-cheapskate ttf-junicode
	  ttf-mph-2b-damase xorg-fonts-type1 noto-fonts'
FONTS_EXTRA='ttf-ubraille adobe-source-han-sans-otc-fonts
			adobe-source-han-serif-otc-fonts noto-fonts-cjk
			adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts
			adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts
			wqy-zenhei wqy-bitmapfont ttf-arphic-ukai ttf-arphic-uming
			opendesktop-fonts ttf-hannom adobe-source-han-sans-jp-fonts
			otf-ipafont ttf-hanazono ttf-sazanami adobe-source-han-sans-kr-fonts
			ttf-baekmuk ttf-freebanglafont ttf-indic-otf ttf-khmer fonts-tlwg'
FONTS_CHARACTERS='noto-fonts-emoji ttf-symbola font-mathematica texlive-core
				  texlive-fontsextra'

# Web
BROWSERS='firefox chromium opera'

# AUR
AUR_SYSTEM='brother-hl2270dw dpkg'
AUR_FIXES='pulseaudio-bluetooth-a2dp-gdm-fix'
AUR_MEDIA='spotify google-chrome'


# Post Installation
all()
{
	pacman -Syu $XORG $FILESYSTEMS $AMD $GNOME $GNOME_EXTRA_PACKAGES $NETWORK $PRINTER $GRAPICS $MEDIA $CODECS $VPN $BROWSERS $SYSTEM $DEV $FONTS $OFFICE $SSH $ICONS $SHELL_THEME

	#systemctl enable gdm.service NetworkManager.service org.cups.cupsd.service bluetooth.serive
}

if ! [ $(id -u) = 0 ]; then
   echo "RUN AS ROOT"
   exit 1
fi

all
