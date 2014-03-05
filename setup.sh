#!/bin/bash

PWD=`pwd -P`
# Setup dotfiles
DOTFILES=( .bashrc .dir_colors .git-completion.sh .vimrc .tmux.conf .gitconfig )
for FILE in "${DOTFILES[@]}"; do
  if [ -f ~/${FILE} ] && [ ! \( -L ~/${FILE} \) ]; then
    echo "Moving old ${FILE} file"
    mv ~/${FILE} ~/${FILE}_old
  fi
  if [ ! \( -L ~/${FILE} \) ]; then
    echo "Adding Symbolic Link for ${FILE} to home directory"
    ln -s ${PWD}/${FILE} ~/${FILE}
  fi
done

# Setup VIM
DIRS=( .vim .vim/autoload .vim/bundle .vim/colors )
for DIR in "${DIRS[@]}"; do
  if [ ! \( -d ~/${DIR} \) ]; then
    echo "Creating directory ${DIR}"
    mkdir ~/${DIR}
  fi
done

# Add plugins to vim
if [ ! \( -f ~/.vim/autoload/pathogen.vim \) ]; then
  echo "Adding pathogen.vim"
  curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

pushd $PWD > /dev/null 
cd ~/.vim/bundle
PLUGINS=( kchmck/vim-coffee-script tpope/vim-endwise tpope/vim-fugitive pangloss/vim-javascript scrooloose/nerdtree godlygeek/tabular )
for PLUGIN in "${PLUGINS[@]}"; do
  DIRECTORY=`echo $PLUGIN | sed -e 's/.*\///g'`
  if [ ! \( -d ~/.vim/bundle/${DIRECTORY} \) ]; then
    echo "Cloning ${PLUGIN}"
    git clone git@github.com:${PLUGIN}.git
  fi
done

# Add vividchalk colorscheme to vim
if [ ! \( -f ~/.vim/colors/vividchalk.vim \) ]; then
  echo "Adding vivichalk colorscheme to vim"
  curl -Sso ~/.vim/colors/vividchalk.vim https://raw.github.com/tpope/vim-vividchalk/master/colors/vividchalk.vim
fi

# Install RVM
cd $HOME
curl -sSL https://get.rvm.io | bash -s stable

popd > /dev/null


