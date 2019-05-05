" custom filetype files
if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.sexp,*.asd,*.lsp       setfiletype lisp
augroup END

