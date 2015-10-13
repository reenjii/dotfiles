#!/bin/bash

echoerr() { cat <<< "$@" 1>&2; }

DOTFILES="$HOME/dotfiles"

GIT=git

OH_MY_ZSH="$HOME/.oh-my-zsh"
VUNDLE="$HOME/.vim/bundle/Vundle.vim"

PWD=$(pwd)

function rmgit {
	DIR=$1
	echo "[I] Remove git repository $DIR"
	if [ -e "$DIR" ]
	then
		echo "[I] Folder $DIR exists"
		echo "[?] Delete folder $DIR ?"
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) rm -rf "$DIR" && echo "[I] Deleted $DIR"; break;;
				No ) break;;
			esac
		done
	else
		echo "[I] Folder $DIR not found"
	fi
}

function rmlink {
	LINK=$1
	echo "[I] Remove link $LINK"
	if [ -e "$LINK" ]
	then
		if [ -L "$LINK" ]
		then
			LINKTARGET=$(readlink "$LINK")
			echo "[I] $LINK is a symbolic link to $LINKTARGET"
			echo "[?] Do you want to delete $LINK ?"
				select yn in "Yes" "No"; do
					case $yn in
						Yes ) rm -v -f "$LINK" && echo "[OK] Deleted $LINK"; break;;
						No ) break;;
					esac
				done
		else
			echo "[E] $LINK already exists but is not a symbolic link"
		fi
	else
		echo "[I] $LINK not found"
	fi
}

rmgit "$OH_MY_ZSH"
rmgit "$VUNDLE"

# Symbolic links for dirs
for dir in shell
do
	rmlink "$HOME/.$dir"
done

# Symbolic links for files in .shell
for file in bashrc zshrc
do
	rmlink "$HOME/.$file"
done

# Links for files in .config/{NAME}/{NAME}rc
for file in screen htop
do
	rmlink "$HOME/.${file}rc"
done

# Uninstall custom oh-my-zsh theme
if [ -f "$OH_MY_ZSH/custom/themes/reenjii.zsh-theme" ]
then
	rm -v -f "$OH_MY_ZSH/custom/themes/reenjii.zsh-theme"
fi

# Vim
rmlink "$HOME/.vimrc"
rmlink "$HOME/.vim/vimrc"
if [ -e "$HOME/.vim/bundle" ]
then
	echo "[?] Uninstall VundleVim plugins (remove $HOME/.vim/bundle) ?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) rm -rf "$HOME/.vim/bundle" ; break;;
			No ) break;;
		esac
	done
fi

