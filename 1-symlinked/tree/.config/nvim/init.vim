" options {{{

set expandtab             " Use spaces instead of tabs.
set tabstop     =4        " Tab key indents by 4 spaces.
set softtabstop =4        " Tab key indents by 4 spaces.
set shiftwidth  =4        " >> indents by 4 spaces.
set shiftround            " >> indents to next multiple of 'shiftwidth'.

set hidden                " Switch between buffers without having to save first.
set splitbelow            " Open new windows below the current window.
set splitright            " Open new windows right of the current window.

set number
set relativenumber
set cursorline            " Find the current line quickly.
set scroll      =10

set report      =0        " Always report changed lines.
set wrapscan              " Searches wrap around end-of-file.
set noshowmode

set inccommand  =nosplit

set synmaxcol   =400      " Only highlight the first 400 columns.
set colorcolumn =80,100

set mouse       =a

set termguicolors

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

set clipboard+=unnamedplus

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=-1
set spelllang=en_us,ru_yo

set timeoutlen=3000

set backup
set backupdir   -=.
set backupext    =-vimbackup
set updatecount =100
set undofile

set viewdir=$XDG_CACHE_HOME/nvim/view
set shada+='1000,n$XDG_CACHE_HOME/nvim/info

" }}}
" custom mappings {{{

" Reload vimrc
map <F5> :source $MYVIMRC<CR>

" Record into register 'q', playback with 'Q'
nnoremap Q @q

noremap ,, ,
noremap ,; ,

let mapleader=","
let maplocalleader=" "

set cedit=\<C-Y>

" Paste mode toggle
autocmd VimEnter * set pastetoggle=<F2>

" Switch language
nnoremap <silent> <C-^> :let &iminsert = (&iminsert == 0 ? 1 : 0)<CR>
nnoremap <silent> <C-S> :let &iminsert = (&iminsert == 0 ? 1 : 0)<CR>
inoremap <silent> <C-S> <C-O>:let &iminsert = (&iminsert == 0 ? 1 : 0)<CR>

" Lose terminal focus
tnoremap <silent> <C-\><C-\> <C-\><C-N>

" }}}
" movement mappings {{{

" Map the cursor keys for precision scrolling by visual lines
imap <up> <C-O>gk
imap <down> <C-O>gj
nmap <up> gk
nmap <down> gj
vmap <up> gk
vmap <down> gj

" Emacs-style editing in insert mode and on the command-line: 
" start of line
noremap! <C-A>		<Home>
" back one character
noremap! <C-B>		<Left>
" delete character under cursor
noremap! <C-D>		<Del>
" end of line
noremap! <C-E>		<End>
" forward one character
noremap! <C-F>		<Right>

" }}}
" copy-paste mappings {{{

noremap Y y$

" black hole register operations
map <leader>d "_d
map <leader>D "_D
map <leader>x "_x
map <leader>X "_X
map <leader>c "_c
map <leader>C "_C
map <leader>s "_s
map <leader>S "_S

" }}}
" indentation mappings {{{

" Visual mode blockwise indent
vmap > >gv
vmap < <gv

" Ident the whole buffer
map <F7> mzgg=G`z

" }}}
" search&replace mappings {{{

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

vmap <leader>v <Esc>/<c-r>=GetVisual()<cr>
vmap <leader>z <Esc>:%s/<c-r>=GetVisual()<cr>//gc<left><left><left>
vmap <leader>Z <Esc>:%s/<c-r>=GetVisual()<cr>/<c-r>=GetVisual()<cr>/gc<left><left><left>

" }}}
" user interface operations mappings {{{

" Close window
nnoremap <silent> <C-Q> :q<CR>

" Horizontal (column) ruler
function! ShowColumnRuler()
    setl scrollbind scrollopt+=hor cursorcolumn
    abo sp +enew
    call setline(1,'....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....|....+....|....+....|')
    let &l:stl="%#Normal#".repeat(' ',winwidth(0))
    res 1
    setl scrollbind nomod buftype=nofile winfixheight nonumber nocursorline
    let w:column_ruler = v:true
    wincmd p
    let w:column_ruler_shown = v:true
endfunction

function! HideColumnRuler()
    wincmd k
    bdelete
    setl scrollopt-=hor noscrollbind nocursorcolumn
    let w:column_ruler_shown = v:false
endfunction

function! SwitchColumnRuler()
    if !exists("w:column_ruler") || !w:column_ruler
        if !exists("w:column_ruler_shown") || !w:column_ruler_shown
            call ShowColumnRuler()
        else
            call HideColumnRuler()
        endif
    endif
endfunction

nnoremap <silent> <C-T> :call SwitchColumnRuler()<CR>

" Resize windows
nnoremap <silent> <C-W><C-H> :vert res -10<CR>
nnoremap <silent> <C-W><C-J> :res -5<CR>
nnoremap <silent> <C-W><C-K> :res +5<CR>
nnoremap <silent> <C-W><C-L> :vert res +10<CR>
" Switch between windows: nmap <silent> <C-hjkl> :wincmd hjkl<CR>

function! SwitchToNextBuffer(incr)
    let help_buffer = (&filetype == 'help')
    let current = bufnr("%")
    let last = bufnr("$")
    let new = current + a:incr
    while 1
        if new != 0 && bufexists(new) &&
           \ ((getbufvar(new, "&filetype") == 'help') == help_buffer)
            execute ":buffer ".new
            break
        else
            let new = new + a:incr
            if new < 1
                let new = last
            elseif new > last
                let new = 1
            endif
            if new == current
                break
            endif
        endif
    endwhile
endfunction

nnoremap <silent> gb :call SwitchToNextBuffer(1)<CR>
nnoremap <silent> gB :call SwitchToNextBuffer(-1)<CR>

" Copy text to/from the system clipboard
command! CCI let @" = @+
command! CCO let @+ = @" | let @* = @"

" }}}
" plug.vim {{{

call plug#begin($XDG_CACHE_HOME . '/nvim/plugged')

" Basic things
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-eunuch'
Plug 'farmergreg/vim-lastplace'

" Appearance
Plug 'fxn/vim-monochrome'
Plug 'itchyny/lightline.vim'
Plug 'raymond-w-ko/vim-niji'
Plug 'Yggdroot/indentLine'

" Syntax highlighting
Plug 'jaxbot/semantic-highlight.vim'
Plug 'ivanp7/lisp-semantic-highlight.vim'

" Interface enhancement
Plug 'qpkorr/vim-bufkill'
Plug 'rbgrouleff/bclose.vim'

Plug 'ptzz/lf.vim'
Plug 'majutsushi/tagbar'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux'
Plug 'edkolev/tmuxline.vim'

" S-expressions and Lisp
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'vlime/vlime', {'rtp': 'vim/'}

call plug#end()

" }}}
" appearance {{{

" ******************** vim-lightline **************************

function! LanguageStatus(...) abort
    return &iminsert == 1 ? (a:0 == 1 ? a:1 : 'RU') : ''
endfunction

function! CapsLockStatus(...) abort
    return CapsLockStatusline('CAPS')
endfunction

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'lang', 'caps', 'paste' ],
      \             [ 'gitbranch', 'filename', 'readonly', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'lang': 'LanguageStatus',
      \   'caps': 'CapsLockStatus',
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" ******************** COLOR SCHEME ********************

colorscheme monochrome

" tweak color scheme
highlight CursorLine        guibg=#444444
highlight CursorColumn      guibg=#444444
highlight CursorLineNR      guifg=#ee3333
highlight LineNr            guifg=#999999
highlight MatchParen        guifg=#ffffff guibg=#ff0000
highlight ColorColumn       guibg=#111111
highlight IncSearch         guifg=#990000 guibg=#ffffff

" terminal colors

" 8 normal colors
let g:terminal_color_0 = '#000000' " black
let g:terminal_color_1 = '#d54e53' " red
let g:terminal_color_2 = '#b9ca4a' " green
let g:terminal_color_3 = '#e6c547' " yellow
let g:terminal_color_4 = '#7aa6da' " blue
let g:terminal_color_5 = '#c397d8' " magenta
let g:terminal_color_6 = '#70c0ba' " cyan
let g:terminal_color_7 = '#eaeaea' " white
" 8 bright colors
let g:terminal_color_8  = '#666666' " black
let g:terminal_color_9  = '#ff3334' " red
let g:terminal_color_10 = '#9ec400' " green
let g:terminal_color_11 = '#e7c547' " yellow
let g:terminal_color_12 = '#7aa6da' " blue
let g:terminal_color_13 = '#b77ee0' " magenta
let g:terminal_color_14 = '#54ced6' " cyan
let g:terminal_color_15 = '#ffffff' " white

" ******************** indentLine **************************

let g:indentLine_char = '·'
let g:indentLine_color_gui = '#888888'

" }}}
" syntax highlighting {{{

let g:semanticEnableFileTypes = ['c', 'cpp', 'java', 'javascript', 'python', 'vim']
let g:semanticPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-highlight-cache"

let g:semanticLispPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-lisp-highlight-cache"

" }}}
" interface enhancement {{{

" ********************* lf.vim **************************

let g:lf_replace_netrw = 1 " open lf when vim open a directory

" ********************* tagbar ******************************

nmap <F8> :TagbarToggle<CR>

" }}}
" tmux integration {{{

" ******************** vim-tmux navigator ********************

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-M-l> :TmuxNavigateRight<cr>

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" }}}
" s-expressions and Lisp {{{

" tweak syntax
autocmd FileType lisp syntax clear lispAtom
autocmd FileType lisp syntax clear lispEscapeSpecial
autocmd FileType lisp syntax clear lispAtomList
autocmd FileType lisp syntax clear lispBQList

" ******************** vim-sexp ****************************

let g:sexp_insert_after_wrap = 0

let g:sexp_mappings = {
            \ 'sexp_flow_to_prev_open':         'g?(',
            \ 'sexp_flow_to_next_close':        'g/)',
            \ 'sexp_flow_to_prev_close':        'g?)',
            \ 'sexp_flow_to_next_open':         'g/(',
            \ 'sexp_flow_to_prev_leaf_head':    'gH',
            \ 'sexp_flow_to_next_leaf_head':    'gh',
            \ 'sexp_flow_to_prev_leaf_tail':    'gL',
            \ 'sexp_flow_to_next_leaf_tail':    'gl',
            \
            \ 'sexp_round_head_wrap_list':      '<LocalLeader>ei',
            \ 'sexp_round_tail_wrap_list':      '<LocalLeader>eI',
            \ 'sexp_round_head_wrap_element':   '<LocalLeader>ew',
            \ 'sexp_round_tail_wrap_element':   '<LocalLeader>eW',
            \ 'sexp_splice_list':               '<LocalLeader>e@',
            \ 'sexp_convolute':                 '<LocalLeader>e?',
            \ 'sexp_raise_list':                '<LocalLeader>eo',
            \ 'sexp_raise_element':             '<LocalLeader>eO',
            \
            \ 'sexp_insert_at_list_head':       '<LocalLeader>eh',
            \ 'sexp_insert_at_list_tail':       '<LocalLeader>el',
            \
            \ 'sexp_square_head_wrap_list':     '<LocalLeader>e[',
            \ 'sexp_square_tail_wrap_list':     '<LocalLeader>e]',
            \ 'sexp_curly_head_wrap_list':      '<LocalLeader>e{',
            \ 'sexp_curly_tail_wrap_list':      '<LocalLeader>e}',
            \ 'sexp_square_head_wrap_element':  '<LocalLeader>ee[',
            \ 'sexp_square_tail_wrap_element':  '<LocalLeader>ee]',
            \ 'sexp_curly_head_wrap_element':   '<LocalLeader>ee{',
            \ 'sexp_curly_tail_wrap_element':   '<LocalLeader>ee}',
            \ }

" ******************** vlime *******************************

let g:vlime_leader = '<LocalLeader>'
let g:vlime_enable_autodoc = v:true
let g:vlime_window_settings = 
      \ {'repl':      {'pos': 'belowright', 'vertical': v:true},
       \ 'sldb':      {'pos': 'belowright', 'vertical': v:true}, 
       \ 'inspector': {'pos': 'belowright', 'vertical': v:true}, 
       \ 'preview':   {'pos': 'belowright', 'size': v:null, 'vertical': v:true}}

let g:vlime_force_default_keys = v:true
" let g:vlime_cl_use_terminal = v:true

function! VlimeEnableInteractionMode()
    let b:vlime_interaction_mode = v:true
    nnoremap <buffer> <silent> <cr> :call vlime#plugin#SendToREPL(vlime#ui#CurExprOrAtom())<cr>
    vnoremap <buffer> <silent> <cr> :<c-u>call vlime#plugin#SendToREPL(vlime#ui#CurSelection())<cr>
endfunction

autocmd FileType lisp call VlimeEnableInteractionMode()
autocmd BufNewFile,BufRead * if &ft=~?'lisp'|:call VlimeEnableInteractionMode()|endif

let g:vlime_cl_impl = "ros"
function! VlimeBuildServerCommandFor_ros(vlime_loader, vlime_eval)
    return ["ros", "run",
                \ "--load", a:vlime_loader,
                \ "--eval", a:vlime_eval]
endfunction

" }}}

" vim: foldmethod=marker:
