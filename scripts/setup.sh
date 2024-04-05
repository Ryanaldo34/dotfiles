#!/bin/bash

if [ "$OSTYPE" = "darwin" ]; then
  echo "Setting up Homebrew"
  if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -eq 0 ]; then
        echo "Homebrew has been installed successfully."
    else
        echo "Failed to install Homebrew. Exiting..."
        exit 1
    fi
  else
      echo "Homebrew is already installed."
  fi

if [ "$OSTYPE" = "darwin" ]; then
  echo "Setup Alacritty"
  brew install alacritty
  echo "Setup Stow"
  brew install stow
  echo "Setup Zsh"
  brew install zsh
  echo "Install Rectangle"
  brew install --cask rectangle
  echo "Install Tmux"
  brew install tmux
  echo "Install nerd fonts"
  brew tap homebrew/cask-fonts && brew install font-hack-nerd-font
else
  sudo apt update && sudo apt upgrade -y
  echo "Setup zsh"
  sudo apt install zsh -y
  echo "Setup Alacritty"
  sudo add-apt-repository ppa:aslatter/ppa -y
  sudo apt update
  sudo apt install alacritty -y
  echo "Install Tmux"
  sudo apt install tmux -y
  echo "Install nerd fonts"
  wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
  && cd ~/.local/share/fonts \
  && unzip JetBrainsMono.zip \
  && rm JetBrainsMono.zip \
  && fc-cache -fv
fi

echo "Set zsh as default shell"
if [ "$SHELL" = "/bin/bash" ]; then
  echo "Setting zsh as default shell"
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" | echo "y"
echo "Setting sym links for configs"
stow ~/dotfiles/

