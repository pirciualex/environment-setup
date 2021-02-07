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
	# sudo systemctl enable lightdm.service -f
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
	thunar
	thunar-archive-plugin
	thunar-volman
	# xfce4-terminal
	# arcolinux-xfce-git
	# arcolinux-local-xfce4-git
	qtile
	sxhkd
	dmenu
	feh
	python-psutil
	xcb-util-cursor
	# arcolinux-qtile-git
	# arcolinux-qtile-dconf-git
	# arcolinux-config-qtile-git
	awesome-terminal-fonts
	# arcolinux-logout-git
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

###############################################################################

declare -n category
for category in ${categories[@]}; do
	print_category ${!category}
	for program in ${category[@]}; do
		# install_package $program
		print_package $program
	done

	case ${!category} in
	"core")
		core_configuration
		;;
	esac
done
