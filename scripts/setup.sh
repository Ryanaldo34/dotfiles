#!/bin/bash

if [ "$EUID" -nq 0 ]; then
  echo "This script requires you to run as root with 'sudo'"
  exit 1
fi

if command -v git &>/dev/null; then
  echo "This script requires you to have git installed already"
  exit 1
fi

distro="macOS"

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
else
  if command -v pacman >/dev/null 2>&1; then
    distro="arch"
  else
    distro="deb"
  fi
fi

install_linux_package() {
  for package in "$@"; do
    if [ "$distro" = "arch" ]; then
      pacman -S $package
    else
      apt install $package -y
    fi
  done
}

if [ "$OSTYPE" = "darwin" ]; then
  brew install fd
  brew install tree
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
  if [ "$distro" = "arch"]; then
    pacman -Sy
    pacman -S iputils dnsutils fd go i3
    pacman -U python312
    echo "exec i3" | tee -a /etc/X11/xinit/xinitrc > /dev/null
  else
    add-apt-repository ppa:aslatter/ppa -y
    add-apt-repository ppa:longsleep/golang-backports -y
    add-apt-repository ppa:deadsnakes/ppa -y
    apt-update && apt-upgrade -y
    apt install net-tools python3.12 golang-go fd-find alacritty -y
    echo "Install nerd fonts"
    wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
    && cd ~/.local/share/fonts \
    && unzip JetBrainsMono.zip \
    && rm JetBrainsMono.zip \
    && fc-cache -fv
    update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
    update-alternatives --config x-terminal-emulator
  fi

  install_linux_package zsh tree alacritty tmux icu unzip dotnet-sdk feh
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Install Node JS"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# install node lts
nvm install 20
curl -fsSL https://bun.sh/install | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "Install Bob and Nvim"
cargo install bob-nvim
bob install latest

if [ "$SHELL" = "/bin/bash" ]; then
  echo "Setting zsh as default shell"
  echo "y" | sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
fi

mkdir -p ~/.config/nvim
git clone https://github.com/Ryanaldo34/NeoVimConfig.git ~/.config/nvim
cd ~/.config/nvim && git checkout me && cd ~
echo "Setting sym links for configs"
rm -f ~/.config/alacritty/alacritty.toml
rm -f ~/.config/tmux/tmux.conf
rm -f ~/.config/i3/config
cd ~/dotfiles && stow .
echo "Setup completed!"
