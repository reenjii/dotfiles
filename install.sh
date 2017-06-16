#!/bin/bash

echoerr() { cat <<< "$@" 1>&2; }

# dotfiles folder
DOTFILES="$HOME/dotfiles"

# git
GIT=git

# oh-my-zsh install folder
OH_MY_ZSH="$HOME/.oh-my-zsh"
# Vumdle.Vim install folder
VUNDLE="$HOME/.vim/bundle/Vundle.vim"

PWD=$(pwd)

# Checks that the given git repository exists
function checkgit {
	LIB=$1
	DIR=$2
	REPO=$3
	echo "[I] Check git repository $DIR"
	if [ -e "$DIR" ]
	then
		echo "[I] Folder $DIR exists"
		cd "$DIR" || exit 1
		$GIT status
		cd "$PWD" || exit 1
		echo "[?] Run git pull ?"
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) cd "$DIR" || exit 1 ; $GIT pull ; cd "$PWD" || exit 1 ; break;;
				No ) break;;
			esac
		done
	else
		echo "[?] Folder $DIR not found, install $LIB ?"
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) $GIT clone "$REPO" "$DIR" ; break;;
				No ) break;;
			esac
		done
	fi
}

# Check that LINK file is a link to TARGET
# If not, creates this link
# $1 = LINK
# $2 = TARGET
function checklink {
	LINK=$1
	TARGET=$2
	echo "[I] Check file $LINK"
	if [ -L "$LINK" ]
	then
		LINKTARGET=$(readlink "$LINK")
		if [ "$LINKTARGET" != "$TARGET" ]
		then
			echoerr "[E] $LINK is a symbolic link to $LINKTARGET"
			echoerr "[E] It should link to $TARGET instead"
			echo "[?] Do you want to change link $LINK target to $TARGET ?"
			select yn in "Yes" "No"; do
				case $yn in
					Yes ) rm -v -f "$LINK" ; ln -v -s "$TARGET" "$LINK" ; break;;
					No ) break;;
				esac
			done
		else
			echo "[I] $LINK is a symbolic link to $LINKTARGET"
		fi
	else
		if [ -e "$LINK" ]
		then
			echoerr "[E] $LINK already exists but is not a symbolic link"
			echoerr "[E] You must remove $LINK to install $TARGET config file"
		else
			echo "[I] $LINK not found"
			echo "[I] Install $TARGET config file"
			ln -v -s "$TARGET" "$LINK"
		fi
	fi
}

checkgit "oh-my-zsh" "$OH_MY_ZSH" "git://github.com/robbyrussell/oh-my-zsh.git"
checkgit "Vundle" "$VUNDLE" "https://github.com/VundleVim/Vundle.vim"

# Symbolic links for folders
for dir in shell
do
	checklink "$HOME/.$dir" "$DOTFILES/$dir"
done

# Symbolic links for files in .shell
for file in bashrc zshrc
do
	checklink "$HOME/.$file" "$DOTFILES/shell/$file"
done

# Links for files in config/{NAME}/{NAME}rc
for file in screen htop
do
	checklink "$HOME/.${file}rc" "$DOTFILES/config/$file/${file}rc"
done

# tmux config
checklink "$HOME/.tmux.conf" "$DOTFILES/config/tmux/tmux.conf"

# git
checklink "$HOME/.gitconfig" "$DOTFILES/git/gitconfig"

# Install custom oh-my-zsh theme
if [ -d "$OH_MY_ZSH" ]
then
	echo "[I] Install oh-my-zsh custom theme"
	mkdir -v -p "$OH_MY_ZSH/custom/themes"
	cp -v "$DOTFILES/oh-my-zsh/custom/themes/reenjii.zsh-theme" "$OH_MY_ZSH/custom/themes/"
fi

# Vim
checklink "$HOME/.vimrc" "$DOTFILES/vim/vimrc/vimrc"
checklink "$HOME/.vim/vimrc" "$DOTFILES/vim/vimrc"
mkdir "$HOME/.vim/undofiles" 2> /dev/null
echo "[?] Install VundleVim plugins ?"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) vim +PluginInstall +qall ; break;;
		No ) break;;
	esac
done
