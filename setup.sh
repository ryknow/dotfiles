#!/bin/bash

PWD=`pwd -P`
# Setup dotfiles
DOTFILES=( .bashrc .dir_colors .git-completion.sh .vimrc .tmux.conf .gitconfig )
for FILE in "${DOTFILES[@]}"; do
  if [ -f ~/${FILE} ]; then
    echo "Moving old ${FILE} file"
    mv ~/${FILE} ~/${FILE}_old
  fi
  echo "Adding Symbolic Link for ${FILE} to home directory"
  ln -s ${PWD}/${FILE} ~/${FILE}
done

# Setup VIM
DIRS=( .vim .vim/autoload .vim/bundle .vim/colors )
for DIR in "${DIRS[@]}"; do
  if [ ! -d $DIR ]; then
    echo "Creating directory ${DIR}"
    mkdir ~/${DIR}
  fi
done

# Add plugins to vim
echo "Adding pathogen.vim"
curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

pushd $PWD
cd ~/.vim/bundle
PLUGINS=( kchmck/vim-coffee-script tpope/vim-endwise tpope/vim-fugitive pangloss/vim-javascript scrooloose/nerdtree godlygeek/tabular )
for PLUGIN in "${PLUGINS[@]}"; do
  if [ ! -d ~/.vim/bundle/${PLUGIN} ]; then
    echo "Cloning ${PLUGIN}"
    git clone git@github.com:${PLUGIN}.git
  fi
done

# Add vividchalk colorscheme to vim
curl -Sso ~/.vim/colors/vividchalk.vim https://raw.github.com/tpope/vim-vividchalk/master/colors/vividchalk.vim

popd
