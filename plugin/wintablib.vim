if exists('g:loaded_wintablib')
    finish
endif
let g:loaded_wintablib = 1

if get(g:, 'wintablib_debug', v:false)
    augroup wintablib_dev
        autocmd!
        execute 'autocmd BufWritePost' expand('<sfile>:p:h:h') .. '/*' 'lua require("wintablib/lib/cleanup")()'
    augroup END
endif
