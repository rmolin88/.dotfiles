" File:vim.vim
"	Description:	ftplugin for the vim filetype
" Author:Reinaldo Molina <rmolin88@gmail.com>
" Version:1.0.0
" Last Modified: Sat Jun 03 2017 19:11
" Created: Apr 28 2017 15:41

" Only do this when not done yet for this buffer
if exists("b:did_vim_ftplugin")
	finish
endif

" Don't load another plugin for this buffer
let b:did_vim_ftplugin = 1

setlocal ts=2
setlocal sw=2
setlocal sts=2
setlocal nospell

" Add mappings, unless the user didn't want this.
if !exists("no_plugin_maps") && !exists("no_vim_maps")
	" Quote text by inserting "> "
	nnoremap <buffer> <Plug>Make :so %<CR>
	nnoremap <buffer> <unique> <LocalLeader>h :h <c-r>=expand("<cword>")<CR><cr>
	call ftplugin#Align('/"')
	" Evaluate highlighted text
	vnoremap <buffer> <LocalLeader>e y:echomsg <c-r>"<cr>
	" Execute highlighted text
	vnoremap <buffer> <LocalLeader>E y:<c-r>"<cr>
endif

let b:undo_ftplugin = "setl spell< ts< sw< sts<" 
