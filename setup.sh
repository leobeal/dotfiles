#!/bin/zsh

#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color


REPO_URL="git@github.com:leobeal/dotfiles.git"
# read DOTFILES_DIR from user folder parameter passed by user

DOTFILES_DIR="$HOME/dotfiles"

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
      echo $GREEN "Creating backup of $file in home directory" $NC
      if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        mv -v "$HOME/$file" "$HOME/dotfiles_backup/$file"
      else
        echo $YELLOW "No backup created for $file. File does not exist or is a symlink." $NC
      fi

      echo $GREEN "Creating symlink to $file in home directory." $NC
      ln -svf "$DOTFILES_DIR/$file" "$HOME/$file"
      ;;
  esac
done

echo "Dotfiles setup complete!"

echo "PHP Storm shortcut setup..."
# PHP Storm setup
echo "Creating symlink for PHP Storm CLI launcher..."
sudo -k ln -svf "$DOTFILES_DIR/phpstorm" /usr/local/bin/phpstorm
#make it executable
chmod +x /usr/local/bin/phpstorm
echo "PHP Storm CLI launcher setup complete!"

echo "Adding paths to /etc/paths..."
# add .paths to /etc/paths
sudo -k rm /etc/paths
sudo -k cat "$DOTFILES_DIR/.paths" >> /etc/paths

echo "Added paths to /etc/paths"

# Source the .zshrc
#source "$HOME/.zshrc"
#echo "Sourced .zshrc"