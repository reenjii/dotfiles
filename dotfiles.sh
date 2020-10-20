#!/bin/bash

# dotfiles folder
DOTFILES="$HOME/dotfiles"

# ohmyzsh install folder
OH_MY_ZSH="$HOME/.oh-my-zsh"
VUNDLE="$HOME/.vim/bundle/Vundle.vim"

# Check that a given command exists
need_cmd() {
    if ! hash "$1" &>/dev/null; then
        error "$1 is needed (command not found)"
        exit 1
    fi
    success "$1 check"
}

### Display
COLOR_OFF='\033[0m' # Text Reset
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
msg()      { printf '%b\n' "$1" >&2; }
success() { msg "${GREEN}[✔]${COLOR_OFF} $1"; }
info()    { msg "${BLUE}[ℹ]${COLOR_OFF} $1"; }
warn()    { msg "${RED}[✘]${COLOR_OFF} $1"; }
error()   { msg "${RED}[✘]${COLOR_OFF} $1"; exit 1; }

# Clones or updates a git repository
# $1 = repository
# $2 = directory absolute path
function fetch_repo {
    local repo=$1
    local dir=$2
    if [[ -d "$dir" ]]; then
        info "Update $dir"
        git -C "$dir" pull
    else
        info "Clone $repo"
        git clone --depth=1 "$repo" "$dir"
    fi
}

# Creates a symbolic link
# $1 = target
# $2 = link name
function make_link {
    local target=$1
    local linkname=$2
    if [[ -L "$linkname" ]]; then
        local linktarget=$(readlink "$linkname")
        if [[ "$linktarget" != "$target" ]]; then
            warn "$linkname is a symbolic link to $linktarget but should target $target instead"
        else
            success "$linkname config file"
        fi
    else
        if [[ -e "$linkname" ]]; then
            warn "$linkname already exists but is not a symbolic link"
            warn "Please remove $linkname to install $target config file"
        else
            info "Install $target config file"
            ln -v -s "$target" "$linkname"
        fi
    fi
}

# Deletes a symbolic link
# $1 = target
# $2 = link name
function unmake_link {
    local target=$1
    local linkname=$2
    if [[ -L "$linkname" ]]; then
        local linktarget=$(readlink "$linkname")
        if [[ "$linktarget" =~ "$target" ]]; then
            rm -v "$linkname"
            success "Removed $target config file"
        fi
    fi
}

usage () {
    echo "dotfiles install script"
    echo ""
    echo "Usage : dotfiles (install|uninstall)"
}

if [[ $# -gt 0 ]]; then
    case $1 in
        install|i)
            info "Install dotfiles"

            # Needed commands
            need_cmd 'git'
            need_cmd 'curl'
            need_cmd 'ln'

            # Install oh-my-zsh
            fetch_repo "git://github.com/ohmyzsh/ohmyzsh.git" "$OH_MY_ZSH"
            # Install powerlevel10k for zsh
            fetch_repo https://github.com/romkatv/powerlevel10k.git "$OH_MY_ZSH/custom/themes/powerlevel10k"
            # Install zsh-syntax-highlighting
            fetch_repo https://github.com/zsh-users/zsh-syntax-highlighting.git "$OH_MY_ZSH/custom/plugins/zsh-syntax-highlighting"
            # Install zsh-autosuggestions
            fetch_repo https://github.com/zsh-users/zsh-autosuggestions "$OH_MY_ZSH/custom/plugins/zsh-autosuggestions"
            make_link "$DOTFILES/oh-my-zsh/custom/zsh-autosuggestions.zsh" "$OH_MY_ZSH/custom/zsh-autosuggestions.zsh"

            # Symbolic link for shell folder
            make_link "$DOTFILES/shell" "$HOME/.shell"

            # Symbolic links for files in shell folder
            make_link "$DOTFILES/shell/bashrc" "$HOME/.bashrc"
            make_link "$DOTFILES/shell/zshrc" "$HOME/.zshrc"

            # Symbolic links for files in config folder
            make_link "$DOTFILES/config/htoprc" "$HOME/.htoprc"
            make_link "$DOTFILES/config/screenrc" "$HOME/.screenrc"
            make_link "$DOTFILES/config/tmux.conf" "$HOME/.tmux.conf"

            # git
            make_link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"

            # Vim
            # Install Vundle
            fetch_repo "https://github.com/VundleVim/Vundle.vim.git" "$VUNDLE"
            make_link "$DOTFILES/vim/vimrc/vimrc" "$HOME/.vimrc"
            make_link "$DOTFILES/vim/vimrc" "$HOME/.vim/vimrc"
            mkdir "$HOME/.vim/undofiles" 2> /dev/null

            info "Install complete"
            exit 0
            ;;
        uninstall|u)
            info "Uninstall dotfiles"

            # Needed commands
            need_cmd 'git'
            need_cmd 'curl'
            need_cmd 'ln'

            # We leave oh-my-zsh repo

            # Symbolic link for shell folder
            unmake_link "$DOTFILES/shell" "$HOME/.shell"

            # Symbolic links for files in shell folder
            unmake_link "$DOTFILES/shell/bashrc" "$HOME/.bashrc"
            unmake_link "$DOTFILES/shell/zshrc" "$HOME/.zshrc"

            # Symbolic links for files in config folder
            unmake_link "$DOTFILES/config/htoprc" "$HOME/.htoprc"
            unmake_link "$DOTFILES/config/screenrc" "$HOME/.screenrc"
            unmake_link "$DOTFILES/config/tmux.conf" "$HOME/.tmux.conf"

            # git
            unmake_link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"

            # Vim
            unmake_link "$DOTFILES/vim/vimrc/vimrc" "$HOME/.vimrc"
            unmake_link "$DOTFILES/vim/vimrc" "$HOME/.vim/vimrc"

            info "Uninstall complete"
            exit 0
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 0
            ;;
    esac
fi

usage
