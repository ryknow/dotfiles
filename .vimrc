set nocompatible

call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on

filetype on
syntax on

set omnifunc=syntaxcomplete#Complete
set tags=tags;~
set autoindent
set smartindent
set nowrap
set ruler
set showmatch
set tabstop=2
set shiftwidth=2
set scrolloff=5
set nosmarttab
set hlsearch
set incsearch
set titlestring=%f title
set nolazyredraw
set ttyfast
set hidden
set visualbell
set expandtab
set backspace=indent,eol,start

set nu
set history=1000
set statusline=%f
set statusline+=%*
set statusline+=\ %= " left align
set statusline+=%{fugitive#statusline()}
set statusline+=\ Buf:%n
set statusline+=\ %c " cursor column
set statusline+=%l/%L "cursor line / total lines
set statusline+=\ %P

set background=dark
colorscheme solarized

let mapleader=","
let g:NERDTreeDirArrows=0

set laststatus=2

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

vnoremap _( <Esc>`>a)<Esc>`<i(<Esc>
vnoremap _[ <Esc>`>a]<Esc>`<i[<Esc>
vnoremap _{ <Esc>`>a}<Esc>`<i{<Esc>
nnoremap <SPACE> <SPACE>:noh<CR>
nnoremap <Leader>gs :Gstatus<CR><C-w>20+
nnoremap <leader>bd :bp\|bd #<CR>

hi Type ctermfg=magenta
let g:airline_powerline_fonts=1
