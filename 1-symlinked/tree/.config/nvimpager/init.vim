" options {{{

set expandtab             " Use spaces instead of tabs.
set tabstop     =4        " Tab key indents by 4 spaces.
set softtabstop =4        " Tab key indents by 4 spaces.

set splitbelow            " Open new windows below the current window.
set splitright            " Open new windows right of the current window.

set number

set synmaxcol   =400      " Only highlight the first 400 columns.

set mouse       =a

set termguicolors

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

set langmap=ЁФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;~ABCDEFGHIJKLMNOPQRSTUVWXYZ,ёфисвуапршолдьтщзйкыегмцчня;`abcdefghijklmnopqrstuvwxyz

set timeoutlen=3000

" }}}
" editing of binary files using hexmode {{{

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    au!

    " set binary option for all binary files before reading them
    au BufReadPre *.bin,*.hex setlocal binary

    " if on a fresh read the buffer variable is already set, it's wrong
    au BufReadPost *
          \ if exists('b:editHex') && b:editHex |
          \   let b:editHex = 0 |
          \ endif

    " convert to hex on startup for binary files automatically
    au BufReadPost *
          \ if &binary | Hexmode | endif

    " When the text is freed, the next time the buffer is made active it will
    " re-read the text and thus not match the correct mode, we will need to
    " convert it again if the buffer is again loaded.
    au BufUnload *
          \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
          \   call setbufvar(expand("<afile>"), 'editHex', 0) |
          \ endif

    " before writing a file when editing in hex mode, convert back to non-hex
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif

    " after writing a binary file, if we're in hex mode, restore hex mode
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END
endif

" }}}
" custom mappings {{{

let mapleader=","
let maplocalleader=" "

" }}}
" user interface operations mappings {{{

let g:no_man_maps = v:true

" Close window
nnoremap <silent> <C-Q> :q<CR>

" Resize windows
nnoremap <silent> <C-W><C-H> :vert res -10<CR>
nnoremap <silent> <C-W><C-J> :res -5<CR>
nnoremap <silent> <C-W><C-K> :res +5<CR>
nnoremap <silent> <C-W><C-L> :vert res +10<CR>
" Switch between windows: nmap <silent> <C-hjkl> :wincmd hjkl<CR>

nnoremap <silent> gb :bnext<CR>
nnoremap <silent> gB :bprev<CR>

nnoremap <silent> <leader>n :set relativenumber!<CR>

" }}}
" plug.vim {{{

call plug#begin($XDG_CACHE_HOME . '/nvim/plugged')

" Appearance
Plug 'fxn/vim-monochrome'
Plug 'raymond-w-ko/vim-niji'
Plug 'Yggdroot/indentLine'

" Syntax highlighting
Plug 'jaxbot/semantic-highlight.vim'
Plug 'ivanp7/lisp-semantic-highlight.vim'

" Interface enhancement
Plug 'qpkorr/vim-bufkill'
Plug 'rbgrouleff/bclose.vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" }}}
" appearance {{{

" ******************** COLOR SCHEME ********************

colorscheme monochrome

" tweak color scheme
highlight CursorLine        guibg=#444444
highlight CursorColumn      guibg=#444444
highlight CursorLineNR      guifg=#ee3333
highlight LineNr            guifg=#999999
highlight MatchParen        guifg=#ffffff guibg=#ff0000
highlight ColorColumn       guibg=#3a3a3a
highlight IncSearch         guifg=#aa2200 guibg=#ffffff

highlight debugPC           guibg=#4444aa
highlight debugBreakPoint   guibg=#aa0000

" ******************** indentLine **************************

let g:indentLine_char = '·'
let g:indentLine_color_gui = '#888888'

" }}}
" syntax highlighting {{{

let g:semanticEnableFileTypes = ['c', 'cpp', 'java', 'javascript', 'python', 'vim']
let g:semanticPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-highlight-cache"

let g:semanticLispPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-lisp-highlight-cache"

" }}}
" tmux integration {{{

" ******************** vim-tmux navigator ********************

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-M-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-M-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-M-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-M-l> :TmuxNavigateRight<CR>

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" }}}

" vim: foldmethod=marker:
