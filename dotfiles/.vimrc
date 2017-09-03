" fzf fuzzy-finder in vim
set rtp+=/usr/local/opt/fzf
set runtimepath^=~/.vim/fzf.vim

" ctags
set autochdir
set tags=tags;/

" plugin manager
execute pathogen#infect()

" make things pretty
syntax enable
syntax on
set number
set relativenumber
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set textwidth=80
set smartindent
set mouse=a
set ttymouse=sgr " make clicking work properly
set scrolloff=999
set splitbelow
set splitright
set textwidth=180
filetype indent on
filetype plugin indent on
set guifont=Roboto_Mono_for_Powerline:h12

" colors
colorscheme solarized
let g:solarized_termcolors=16
let g:solarized_visibility ="high"

" vim-airline statusbar
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='solarized'
set t_Co=256
set laststatus=2

" Asynchronous Linting Engine
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['✗ %d', '⚠ %d', '✓ ok']
hi ALEErrorSign ctermfg=darkred
hi ALEWarningSign ctermfg=darkyellow

"highlight current cursorline number
set cursorline
hi CursorLineNr term=bold ctermfg=darkcyan gui=bold guifg=Green

" make sure indenting works properly with keywords like elsif/end
set runtimepath^=~/.vim/bundle/vim-endwise/plugin/endwise.vim

set runtimepath^=~/.vim/bundle/undotree/plugin/undotree.vim

" Use Mac OS X's clipboard for copy/pasting
set clipboard^=unnamedplus,unnamed

" backspace from anywhere
set backspace=2

" make lowercase searches case insensitive, but keep searches with capitals case sensitive
set smartcase

" make gitgutter update faster
set updatetime=250

" Run checktime in buffers, but avoiding the Command Line (q:) window
au CursorHold * if getcmdwintype() == '' | checktime | endif

" swap files (.swp) in a common location
" // means use the file's full path
set dir=$HOME/.vim/_swap//

" backup files (~) in a common location if possible
set backup
set backupdir=$HOME/.vim/_backup/,~/tmp,.

" turn on undo files, put them in a common location
set undofile
set undodir=$HOME/.vim/_undo/

" autoclosing
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

" navigate between splits more easily (ctrl+HJKL)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> <Leader>= :exe "vertical resize +5"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -5"<CR>

" disable arrow navigation
set noesckeys
inoremap <buffer> <up> <nop>
inoremap <buffer> <down> <nop>
inoremap <buffer> <left> <nop>
inoremap <buffer> <right> <nop>
nnoremap <buffer> <up> <nop>
nnoremap <buffer> <down> <nop>
nnoremap <buffer> <left> <nop>
nnoremap <buffer> <right> <nop>

" quit current split
nnoremap <C-Q> <C-W><C-Q>

" FZF shortcuts
" Open files in current window
nnoremap <silent> <Leader><Leader> :call fzf#run({'sink': 'e'})<CR>

" Open files in new horizontal split
nnoremap <silent> <Leader>s :call fzf#run({
\   'down': '40%',
\   'sink': 'split' })<CR>

" Open files in new vertical horizontal split
nnoremap <silent> <Leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical split' })<CR>

" automatically remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" source .vimrc
command! SO source ~/.vimrc

" shortcut to launch NERDTree
command! NT NERDTree

" shortcut for vim's native Explorer
command! EX Explore

" shortcut for Undotree
command! UN UndotreeToggle

" shortcut for Tagbar
command! TT TagbarToggle

"-----------------
" IF NOT USING VIM-AIRLINE, make statusline pretty
"   displays current filepath below viewport
"set statusline=%F%m%r%<\ %=%l,%v\ [%L]\ %p%%
"   Change the highlighting so it stands out
"hi statusline ctermbg=white ctermfg=black
"   Make sure it always shows
"set laststatus=2

"-----------------
let g:easytags_syntax_keyword = 'always'

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

let g:indent_guides_guide_size=1
