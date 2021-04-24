#!/bin/bash

###############################################################################
#
#   FUNCTIONS DECLARATION
#
###############################################################################

install_package() {
	if pacman -Qi $1 &>/dev/null; then
		tput setaf 2
		echo "###############################################################################"
		echo "################## The package "$1" is already installed"
		echo "###############################################################################"
		echo
		tput sgr0
	else
		tput setaf 3
		echo "###############################################################################"
		echo "##################  Installing package " $1
		echo "###############################################################################"
		echo
		tput sgr0
		sudo pacman -S --noconfirm --needed $1
	fi
}

install_aur_package() {
	if yay -Qi $1 &>/dev/null; then
		tput setaf 49
		echo "###############################################################################"
		echo "################## The package "$1" is already installed"
		echo "###############################################################################"
		echo
		tput sgr0
	else
		tput setaf 94
		echo "###############################################################################"
		echo "##################  Installing package " $1
		echo "###############################################################################"
		echo
		tput sgr0
		sudo yay -S --noconfirm --needed $1
	fi
}

print_package() {
	if dpkg -s $1 &>/dev/null; then
		tput setaf 2
		echo "###############################################################################"
		echo "################## The package "$1" is already installed"
		echo "###############################################################################"
		echo
		tput sgr0
	else
		tput setaf 3
		echo "###############################################################################"
		echo "##################  Installing package " $1
		echo "###############################################################################"
		echo
		tput sgr0
	fi
}

print_category() {
	tput setaf 5
	echo "################################################################"
	echo "##################  Installing software for category " $1
	echo "################################################################"
	echo
	tput sgr0
}

core_configuration() {
	tput setaf 4
	echo "################################################################"
	echo "##################  Running core configuration"
	echo "################################################################"
	echo
	tput sgr0
	echo "config"
	sudo systemctl enable lightdm.service -f
}

copy_config_files() {
	tput setaf 1
	echo "################################################################"
	echo "##################  Copying config files"
	echo "################################################################"
	echo
	tput sgr0
	cp -r .config/* ~/.config
	cp .Xresources ~
}

###############################################################################
#
#   PACKAGES DECLARATION
#
###############################################################################

core=(
	lightdm
	arcolinux-lightdm-gtk-greeter
	arcolinux-lightdm-gtk-greeter-settings
	arcolinux-wallpapers-git
	qtile
	sxhkd
	dmenu
	feh
	python-psutil
	xcb-util-cursor
	awesome-terminal-fonts
	kitty
	# thunar
	# thunar-archive-plugin
	# thunar-volman
	# xfce4-terminal
	# arcolinux-xfce-git
	# arcolinux-local-xfce4-git
	# arcolinux-qtile-git
	# arcolinux-qtile-dconf-git
	# arcolinux-config-qtile-git
	# arcolinux-logout-git
)

core_aur=(
	sunflower
)

###############################################################################

development=(
	firefox
	flameshot
	meld
	the_platinum_searcher-bin
	discord
	simplescreenrecorder
	scrot
)

###############################################################################

categories=(
	'core'
	'development'
)

aur_categories=(
	"core_aur"
)
###############################################################################

declare -n category
for category in ${categories[@]}; do
	print_category ${!category}
	for program in ${category[@]}; do
		# install_package $program
		install_package $program
	done

	case ${!category} in
	"core")
		core_configuration
		;;
	esac
done

declare -n aur_category
for aur_category in ${aur_categories[@]}; do
	print_category ${!aur_category}
	for program in ${aur_category[@]}; do
		# install_package $program
		install_aur_package $program
	done

	# case ${!category} in
	# "core")
	# 	core_configuration
	# 	;;
	# esac
done

copy_config_files