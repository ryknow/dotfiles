set nocompatible

call pathogen#infect()
call pathogen#helptags()

filetype on
syntax on

set tags=tags;~
set scrolloff=5
set background=dark
set autoindent
set expandtab
set nowrap
set ruler
set showmatch
set tabstop=2
set shiftwidth=2
set nosmarttab
set hlsearch
set incsearch
set titlestring=%f title
set nolazyredraw
set ttyfast
set nu
set hidden
set visualbell
set backspace=indent,eol,start
set history=1000
set statusline=%f
set statusline+=%*
set statusline+=\ %= " left align
set statusline+=%{fugitive#statusline()}
set statusline+=\ Buf:%n
set statusline+=\ %c " cursor column
set statusline+=%l/%L "cursor line / total lines
set statusline+=\ %P

set laststatus=2

let mapleader=","
let g:NERDTreeDirArrows=0

nnoremap <F2> :set invpaste paste?<CR> " disable auto-indent when pasting
vnoremap <leader>te :Tabularize /=<CR>
vnoremap <leader>tc :Tabularize /:<CR>
nnoremap <silent> <c-x> :bprev<CR>
nnoremap <silent> <c-c> :bnext<CR>
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
map <C-s> <Esc>:w<CR>
imap <C-s> <Esc>:w<CR>
map <C-q> <Esc>:q<CR>
imap <C-q> <Esc>:q<CR>
set pastetoggle=<F2>
set showmode

filetype plugin indent on

colorscheme vividchalk
hi Type ctermfg=magenta
let g:airline_powerline_fonts=1
