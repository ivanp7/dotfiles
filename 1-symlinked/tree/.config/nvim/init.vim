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

set wildmode    =longest,list,full

set synmaxcol   =400      " Only highlight the first 400 columns.

set mouse       =a

set termguicolors

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

set clipboard+=unnamedplus

set langmap=ЁФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;~ABCDEFGHIJKLMNOPQRSTUVWXYZ,ёфисвуапршолдьтщзйкыегмцчня;`abcdefghijklmnopqrstuvwxyz
set keymap=russian
set iminsert=0
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

noremap \ ,
noremap ,, ,
noremap ,; ,

let mapleader=","
let maplocalleader=" "

set cedit=\<C-Y>

" New buffers
nnoremap <silent> <leader>e :enew<CR>
nnoremap <silent> <leader>l :enew<CR>:set<Space>ft=lisp<CR>

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
noremap! <C-A>  <Home>
" back one character
noremap! <C-B>  <Left>
" delete character under cursor
noremap! <C-D>  <Del>
" end of line
noremap! <C-E>  <End>
" forward one character
noremap! <C-F>  <Right>

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
function! EscapeString (string, type)
    let string=a:string
    " Escape regex characters
    if !a:type
        let string = escape(string, '^$.*\/~[]')
    else
        let string = escape(string, '\/~&')
    endif
    " Escape the line endings
    let string = substitute(string, '\n', '\\n', 'g')
    return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual(type) range
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
    let escaped_selection = EscapeString(selection, a:type)

    return escaped_selection
endfunction

vmap <leader>v <Esc>/<c-r>=GetVisual(0)<cr>
vmap <leader>z <Esc>:%s/<c-r>=GetVisual(0)<cr>//gc<left><left><left>
vmap <leader>Z <Esc>:%s/<c-r>=GetVisual(0)<cr>/<c-r>=GetVisual(1)<cr>/gc<left><left><left>

" }}}
" user interface operations mappings {{{

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

nnoremap <silent> <C-N> :call SwitchToNextBuffer(1)<CR>
nnoremap <silent> <C-P> :call SwitchToNextBuffer(-1)<CR>

" Copy text to/from the system clipboard
command! CCI let @" = @+
command! CCO let @+ = @" | let @* = @"

" Color column
function! SwitchColorColumn()
    if &colorcolumn == ''
        let &colorcolumn="80,100,120,140,160"
    else
        let &colorcolumn=""
    endif
endfunction

nnoremap <silent> <leader>t :call SwitchColorColumn()<CR>

nnoremap <silent> <leader>n :set relativenumber!<CR>

" }}}
" complex user interface extensions {{{
" horizontal (column) ruler {{{

let g:column_ruler_auto = v:false

function! ShowColumnRuler(placement)
    let g:column_ruler_auto = v:true
    if !exists("w:column_ruler_window") && !exists("w:column_ruler")
        let l:win_id = win_getid()

        let l:win_view = winsaveview()

        setl scrollbind scrollopt+=hor cursorcolumn
        if a:placement == 'b'
            sp +enew
        else
            abo sp +enew
        endif
        call setline(1,'....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....|....+....|....+....|')
        let &l:statusline="%#Normal#".repeat(' ',winwidth(0))
        res 1
        setl scrollbind nomod buftype=nofile winfixheight nonumber nocursorline nocursorcolumn bufhidden=wipe nobuflisted

        let w:column_ruler_window = l:win_id
        let l:win_id = win_getid()
        call win_gotoid(w:column_ruler_window)
        let w:column_ruler = l:win_id

        call winrestview(l:win_view)
    endif
    let g:column_ruler_auto = v:false
endfunction

function! ForgetColumnRuler()
    if exists("w:column_ruler")
        setl scrollopt-=hor noscrollbind nocursorcolumn
        unlet w:column_ruler
    endif
endfunction

function! HideColumnRuler()
    let g:column_ruler_auto = v:true
    if exists("w:column_ruler")
        let l:column_ruler = v:true
        call win_gotoid(w:column_ruler)
    endif
    if exists("l:column_ruler") || exists("w:column_ruler_window")
        let l:win_id = w:column_ruler_window
        quit
        call win_gotoid(l:win_id)
        call ForgetColumnRuler()
    endif
    let g:column_ruler_auto = v:false
endfunction

let g:column_ruler_window_count = winnr('$')

function! AutoHideColumnRulerWinLeave()
    if g:column_ruler_auto
        return
    endif

    let g:column_ruler_window_count = winnr('$')
    if exists("w:column_ruler")
        let g:column_ruler_to_hide = w:column_ruler
        let g:column_ruler_to_hide_window_mode = v:false
    elseif exists("w:column_ruler_window")
        let g:column_ruler_to_hide = w:column_ruler_window
        let g:column_ruler_to_hide_window_mode = v:true
    endif
endfunction

function! AutoHideColumnRulerWinEnter()
    if g:column_ruler_auto
        return
    else
        let g:column_ruler_auto = v:true
    endif

    let l:wincount = winnr('$')
    if exists("g:column_ruler_to_hide")
        if (l:wincount < g:column_ruler_window_count)
            call win_gotoid(g:column_ruler_to_hide)
            if !g:column_ruler_to_hide_window_mode
                unlet w:column_ruler_window
                quit
            else
                call ForgetColumnRuler()
            endif
        endif

        unlet g:column_ruler_to_hide
        unlet g:column_ruler_to_hide_window_mode
    endif

    let g:column_ruler_auto = v:false
endfunction

autocmd WinLeave * call AutoHideColumnRulerWinLeave()
autocmd WinEnter * call AutoHideColumnRulerWinEnter()

function! SwitchColumnRuler(placement)
    if !exists("w:column_ruler") && !exists("w:column_ruler_window")
        call ShowColumnRuler(a:placement)
    else
        call HideColumnRuler()
    endif
endfunction

nnoremap <silent> <leader>r :call SwitchColumnRuler('t')<CR>
nnoremap <silent> <leader>R :call SwitchColumnRuler('b')<CR>

" }}}
" buffer difference {{{

let g:buffer_diff_auto = v:false

function! ShowBufferDiff(direction)
    let g:buffer_diff_auto = v:true
    if !exists("w:buffer_diff_window") && !exists("w:buffer_diff")
        let l:win_id = win_getid()

        if a:direction == 'h'
            lefta vsp +enew
        elseif a:direction == 'j'
            sp +enew
        elseif a:direction == 'k'
            abo sp +enew
        else
            vsp +enew
        endif
        silent r #
        0d_
        setl nomod buftype=nofile bufhidden=wipe nobuflisted
        diffthis

        let w:buffer_diff_window = l:win_id
        let l:win_id = win_getid()
        call win_gotoid(w:buffer_diff_window)
        let w:buffer_diff = l:win_id

        diffthis
    endif
    let g:buffer_diff_auto = v:false
endfunction

function! ForgetBufferDiff()
    if exists("w:buffer_diff")
        diffoff
        unlet w:buffer_diff
    endif
endfunction

function! HideBufferDiff()
    let g:buffer_diff_auto = v:true
    if exists("w:buffer_diff")
        let l:buffer_diff = v:true
        call win_gotoid(w:buffer_diff)
    endif
    if exists("l:buffer_diff") || exists("w:buffer_diff_window")
        let l:win_id = w:buffer_diff_window
        quit
        call win_gotoid(l:win_id)
        call ForgetBufferDiff()
    endif
    let g:buffer_diff_auto = v:false
endfunction

let g:buffer_diff_window_count = winnr('$')

function! AutoHideBufferDiffWinLeave()
    if g:buffer_diff_auto
        return
    endif

    let g:buffer_diff_window_count = winnr('$')
    if exists("w:buffer_diff")
        let g:buffer_diff_to_hide = w:buffer_diff
        let g:buffer_diff_to_hide_window_mode = v:false
    elseif exists("w:buffer_diff_window")
        let g:buffer_diff_to_hide = w:buffer_diff_window
        let g:buffer_diff_to_hide_window_mode = v:true
    endif
endfunction

function! AutoHideBufferDiffWinEnter()
    if g:buffer_diff_auto
        return
    else
        let g:buffer_diff_auto = v:true
    endif

    let l:wincount = winnr('$')
    if exists("g:buffer_diff_to_hide")
        if (l:wincount < g:buffer_diff_window_count)
            call win_gotoid(g:buffer_diff_to_hide)
            if !g:buffer_diff_to_hide_window_mode
                unlet w:buffer_diff_window
                quit
            else
                call ForgetBufferDiff()
            endif
        endif

        unlet g:buffer_diff_to_hide
        unlet g:buffer_diff_to_hide_window_mode
    endif

    let g:buffer_diff_auto = v:false
endfunction

function! UpdateBufferDiff()
    let g:buffer_diff_auto = v:true
    if exists("w:buffer_diff")
        call win_gotoid(w:buffer_diff)
        diffoff
        normal gg"_dG
        silent r #
        0d_
        diffthis
        call win_gotoid(w:buffer_diff_window)
    endif
    let g:buffer_diff_auto = v:false
endfunction

autocmd WinLeave * call AutoHideBufferDiffWinLeave()
autocmd WinEnter * call AutoHideBufferDiffWinEnter()
autocmd BufWritePost * silent call UpdateBufferDiff()

function! SwitchBufferDiff(direction)
    if !exists("w:buffer_diff") && !exists("w:buffer_diff_window")
        call ShowBufferDiff(a:direction)
    else
        call HideBufferDiff()
    endif
endfunction

nnoremap <silent> <leader>ih :call SwitchBufferDiff('h')<CR>
nnoremap <silent> <leader>ij :call SwitchBufferDiff('j')<CR>
nnoremap <silent> <leader>ik :call SwitchBufferDiff('k')<CR>
nnoremap <silent> <leader>il :call SwitchBufferDiff('l')<CR>

" }}}
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
Plug 'justinmk/vim-sneak'
Plug 'gagoar/StripWhiteSpaces'

" Appearance
Plug 'fxn/vim-monochrome'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'raymond-w-ko/vim-niji'
Plug 'Yggdroot/indentLine'
Plug 'machakann/vim-highlightedyank'

" Syntax highlighting
Plug 'jaxbot/semantic-highlight.vim'
Plug 'ivanp7/lisp-semantic-highlight.vim'

" Interface enhancement
Plug 'qpkorr/vim-bufkill'
Plug 'rbgrouleff/bclose.vim'

Plug 'junegunn/fzf.vim'
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
" basic things {{{

" ******************** vim-sneak **************************

let g:sneak#label = 1
let g:sneak#target_labels = ";sftunq/[]SFGHLTUNRMZ?0"
let g:sneak#s_next = 1

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

" ******************** vim-startify **************************

let g:startify_custom_header = map(split(system("fortune.sh"), '\n'), 'repeat(" ", 8) . v:val')

" ******************** indentLine **************************

let g:indentLine_char = '·'
let g:indentLine_color_gui = '#888888'

" ******************** vim-highlightedyank **************************

" set highlight for 1 second
let g:highlightedyank_highlight_duration = 1000

" }}}
" syntax highlighting {{{

let g:semanticEnableFileTypes = ['c', 'cpp', 'java', 'javascript', 'python', 'vim']
let g:semanticPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-highlight-cache"

let g:semanticLispPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-lisp-highlight-cache"

" }}}
" interface enhancement {{{

set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" ********************* fzf.vim *****************************

nnoremap <silent> <leader>u :Buffers<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>F :GFiles<CR>

nnoremap <silent> <leader>g :Rg<CR>
nnoremap <silent> <leader>G :Lines<CR>
nnoremap <silent> <leader>/ :BLines<CR>
nnoremap <silent> <leader>' :Marks<CR>
nnoremap <silent> <leader>a :Tags<CR>

nnoremap <silent> <leader>: :Commands<CR>

nnoremap <silent> <leader>hh :History<CR>
nnoremap <silent> <leader>h: :History:<CR>
nnoremap <silent> <leader>h/ :History/<CR>

nnoremap <silent> <leader>H :Helptags<CR>

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --glob '!.git' ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

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

autocmd FileType lisp imap <silent><buffer> <C-H> <Plug>(sexp_insert_backspace)

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
" plugins override {{{

" ******************** vim-sensible **************************

runtime! plugin/sensible.vim
set sidescrolloff=0

" }}}

" vim: foldmethod=marker:
