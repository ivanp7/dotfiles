" ####################################################################################
" General settings

set nocompatible

set background  =dark

set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.
set number

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set clipboard=unnamed

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set spelllang=ru_yo,en_us

" 256-colors support
set t_Co=256

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#handling-backup-swap-undo-and-viminfo-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap/
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo     ='100,n$HOME/.vim/files/info/viminfo

" ####################################################################################
" Custom key bindings

nnoremap <silent> <C-^> :let &iminsert = (&iminsert == 0 ? 1 : 0)<CR>

:nmap <silent> <C-h> :wincmd h<CR>
:nmap <silent> <C-j> :wincmd j<CR>
:nmap <silent> <C-k> :wincmd k<CR>
:nmap <silent> <C-l> :wincmd l<CR>

let mapleader=","
let maplocalleader=";"

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
            \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
            \gvy/<C-R><C-R>=substitute(
            \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
            \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
            \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
            \gvy?<C-R><C-R>=substitute(
            \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
            \gV:call setreg('"', old_reg, old_regtype)<CR>

" ####################################################################################
" Plug.vim plugin system

" Autoload plug.vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Basic things
Plug 'tpope/vim-sensible'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'svermeulen/vim-easyclip'
Plug 'tpope/vim-commentary'

" Fixes for things
Plug 'godlygeek/csapprox'
Plug 'vim-utils/vim-alt-mappings'

" Color theme and highlighting
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'smancill/darkglass'
Plug 'vim-scripts/vim-niji'

" S-expressions and Lisp
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

Plug 'l04m33/vlime', {'rtp': 'vim/'}

" Initialize plugin system
call plug#end()

" ####################################################################################
" Basic things

" Vim Easyclip ************************

nnoremap gm m
nnoremap gM M
nmap M <Plug>MoveMotionEndOfLinePlug
let g:EasyClipAutoFormat = 1
let g:EasyClipPreserveCursorPositionAfterYank = 1
let g:EasyClipShareYanks = 1
let g:EasyClipShareYanksDirectory='$HOME/.vim'

" Vim Commentary **********************

autocmd FileType lisp setlocal commentstring=;\ %s

" ####################################################################################
" Fixes for things

" CSApprox ****************************

" after CSApprox work we re-enable the transparent background
let g:CSApprox_hook_post = [
            \ 'highlight Normal            ctermbg=NONE',
            \ 'highlight LineNr            ctermbg=NONE',
            \ 'highlight SignifyLineAdd    cterm=bold ctermbg=NONE ctermfg=green',
            \ 'highlight SignifyLineDelete cterm=bold ctermbg=NONE ctermfg=red',
            \ 'highlight SignifyLineChange cterm=bold ctermbg=NONE ctermfg=yellow',
            \ 'highlight SignifySignAdd    cterm=bold ctermbg=NONE ctermfg=green',
            \ 'highlight SignifySignDelete cterm=bold ctermbg=NONE ctermfg=red',
            \ 'highlight SignifySignChange cterm=bold ctermbg=NONE ctermfg=yellow',
            \ 'highlight SignColumn        ctermbg=NONE',
            \ 'highlight CursorLine        ctermbg=NONE cterm=underline',
            \ 'highlight Folded            ctermbg=NONE cterm=bold',
            \ 'highlight FoldColumn        ctermbg=NONE cterm=bold',
            \ 'highlight NonText           ctermbg=NONE',
            \ 'highlight clear LineNr'
            \]
" let g:CSApprox_hook_post = ['hi Normal  ctermbg=NONE ctermfg=NONE',
"             \ 'hi NonText ctermbg=NONE ctermfg=NONE']

" ####################################################################################
" Color theme and highlighting

" Vim-airline *************************

let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#keymap#enabled = 0

let g:airline_theme='term'

" Vim color scheme ********************

" termguicolors should not be set under any circumstances, it conflicts with CSApprox:
" set termguicolors

colorscheme darkglass

" ####################################################################################
" S-expressions and Lisp

" Vim-Sexp ****************************

let g:sexp_insert_after_wrap = 0

let g:sexp_mappings = {
            \ 'sexp_flow_to_prev_close':        '<M-)>',
            \ 'sexp_flow_to_next_open':         '<M-(>',
            \ 'sexp_flow_to_prev_open':         '<M-9>',
            \ 'sexp_flow_to_next_close':        '<M-0>',
            \ }

" Vlime *******************************

let g:vlime_enable_autodoc = v:true
let g:vlime_window_settings = {'sldb': {'pos': 'belowright', 'vertical': v:true}, 
            \ 'inspector': {'pos': 'belowright', 'vertical': v:true}, 
            \ 'preview': {'pos': 'belowright', 'size': v:null, 'vertical': v:true}}

