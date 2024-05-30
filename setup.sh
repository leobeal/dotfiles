#!/bin/zsh

#COlors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color


REPO_URL="git@github.com:leobeal/dotfiles.git"
DOTFILES_DIR="$HOME/Code/dotfiles"

# Clone the dotfiles repository
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository to $DOTFILES_DIR..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  echo "Dotfiles repository already exists."
fi

cd "$DOTFILES_DIR" || { echo "Failed to change directory to $DOTFILES_DIR"; exit 1; }

echo "Creating symlinks for dotfiles..."

for file in .??*; do
  # Exclude certain files from being symlinked
  case "$file" in
    .git|.gitignore|.DS_Store|README.md|setup.sh|LICENSE|.paths|.idea)
      echo $RED "Skipping $file" $NC
      continue
      ;;
    *)
      echo $GREEN "Creating symlink to $file in home directory." $NC
      ln -svf "$DOTFILES_DIR/$file" "$HOME/$file"
      ;;
  esac
done

echo "Dotfiles setup complete!"

echo "PHP Storm shotcut setup..."
# PHP Storm setup
echo "Creating symlink for PHP Storm CLI launcher..."
ln -svf "$DOTFILES_DIR/phpstorm" /usr/local/bin/phpstorm
#make it executable
chmod +x /usr/local/bin/phpstorm


# add .paths to /etc/paths
sudo rm /etc/paths
sudo cat "$DOTFILES_DIR/.paths" >> /etc/paths
echo "Added paths to /etc/paths"

# Source the .bash_profile
source "$HOME/.zshrc"
echo "Sourced .zshrc"