#!/bin/bash
set -ex

if [[ -n $SUDO_USER ]]; then
	echo -n "Error: Do not run this script with sudo."
	exit 1
fi

OS=$(uname -s | tr A-Z a-z)

case $OS in
	linux)
		source /etc/os-release
		case $ID in
			debian|ubuntu|mint)
        sudo apt update
        sudo apt install gcc -y
				curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
				chmod u+x nvim.appimage
				sudo ln -sf ~/nvchad/nvim.appimage /usr/local/bin/nvim
				;;

			fedora|rhel|centos)
				sudo yum update
				sudo yum install -y python3-neovim
				;;

			*)
				echo -n "Unsupported linux distro"
				;;
		esac
	;;

	darwin)
		sudo brew update
		sudo brew install neovim -y
	;;

	*)
		echo -n "Unsupported OS"
		;;
esac


grep -qxF 'alias vim=nvim' ~/.bashrc || echo 'alias vim=nvim' >> ~/.bashrc
source ~/.bashrc

rm -rf ~/.local/share/nvim
rm -rf ~/.config/nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
