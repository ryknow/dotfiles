/bin/bash

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
DIRS=( .vim .vim/autoload .vim/bundle )
for DIR in "${DIRS[@]}"; do
  if [ ! \( -d ~/${DIR} \) ]; then
    echo "Creating directory ${DIR}"
    mkdir ~/${DIR}
  fi
done

# Add plugins to vim
if [ ! \( -f ~/.vim/autoload/pathogen.vim \) ]; then
  echo "Adding pathogen.vim"
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe./pathogen.vim
fi

pushd $PWD > /dev/null 
cd ~/.vim/bundle
PLUGINS=( jnwhiteh/vim-golang kchmck/vim-coffee-script tpope/vim-endwise tpope/vim-fugitive \
  pangloss/vim-javascript scrooloose/nerdtree godlygeek/tabular altercation/vim-colors-solarized \
  leshill/vim-json tpope/vim-surround)
for PLUGIN in "${PLUGINS[@]}"; do
  DIRECTORY=`echo $PLUGIN | sed -e 's/.*\///g'`
  if [ ! \( -d ~/.vim/bundle/${DIRECTORY} \) ]; then
    echo "Cloning ${PLUGIN}"
    git clone git@github.com:${PLUGIN}.git
  fi
done

# Add vividchalk colorscheme to vim
if [ ! \( -f ~/.vim/colors/vividchalk.vim \) ]; then
  cd ~/.vim
  echo "Adding vivichalk colorscheme to vim"
  git clone git@github.com:tpope/vim-vividchalk.git
fi

# Install RVM
cd $HOME
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 
curl -sSL https://get.rvm.io | bash -s stable

# Install NVM
cd $HOME
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

popd > /dev/null
