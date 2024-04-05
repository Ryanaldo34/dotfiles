#!/bin/bash

if [ "$EUID" -nq 0 ]; then
  echo "This script requires you to run as root with 'sudo'"
  exit 1
fi

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
  rm -f ~/.config/alacritty/alacritty.toml
  echo "Setup Stow"
  brew install stow
  echo "Setup Zsh"
  brew install zsh
  echo "Install Rectangle"
  brew install --cask rectangle
  echo "Install Tmux"
  brew install tmux
  rm -f ~/.config/tmux/tmux.conf
  echo "Install Python"
  brew install python@3.12
  echo "Install Go"
  brew install go
  echo "Install Dotnet"
  brew install --cask dotnet
  echo "Install nerd fonts"
  brew tap homebrew/cask-fonts && brew install font-hack-nerd-font
else
  sudo apt update && sudo apt upgrade -y
  echo "Setup zsh"
  sudo apt install zsh -y
  echo "Add apt repositories"
  sudo add-apt-repository ppa:aslatter/ppa -y
  sudo add-apt-repository ppa:longsleep/golang-backports -y
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt update
  echo "Install Dotnet"
  sudo apt-get install -y dotnet-sdk-8.0
  echo "Install Python"
  sudo apt install python3.12 -y
  echo "Install GO"
  sudo apt install golang-go -y
  echo "Install Alacritty"
  sudo apt install alacritty -y
  rm -f ~/.config/alacritty/alacritty.toml
  echo "Install Tmux"
  sudo apt install tmux -y
  rm -f ~/.config/tmux/tmux.conf
  echo "Install nerd fonts"
  wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
  && cd ~/.local/share/fonts \
  && unzip JetBrainsMono.zip \
  && rm JetBrainsMono.zip \
  && fc-cache -fv
fi

echo "Install Node JS"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# install node lts
nvm install 20
echo "Install Bun JS"
curl -fsSL https://bun.sh/install | bash
echo "Install Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "Install Bob and Nvim"
cargo install bob-nvim
bob install latest

echo "Set zsh as default shell"
if [ "$SHELL" = "/bin/bash" ]; then
  echo "Setting zsh as default shell"
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" | echo "y"
fi

echo "Setting sym links for configs"
stow ~/dotfiles/
echo "Setup completed!"
