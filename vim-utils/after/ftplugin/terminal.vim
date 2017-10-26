" File:					terminal.vim
"	Description:	Set mappings and settings proper of nvim-terminal
" Author:				Reinaldo Molina <rmolin88@gmail.com>
" Version:				1.0.0
" Last Modified: Apr 29 2017 19:26
" Created: Apr 29 2017 19:26

" Only do this when not done yet for this buffer
if exists("b:did_terminal_ftplugin")
	finish
endif

" Don't load another plugin for this buffer
let b:did_terminal_ftplugin = 1

setlocal bufhidden=hide
setlocal nonumber

" If plugin neoterm was loaded and mappings accepted
if !exists("no_plugin_maps") && !exists("no_terminal_maps")
	if exists('*neoterm#close()')
		" hide/close terminal
		nnoremap <buffer> <silent> h :call neoterm#close()<cr>
		nnoremap <buffer> <silent> q :Tclose!<cr>
	endif
endif

if exists('+winhighlight')
	" Create a Terminal Highlight group
	highlight Terminal ctermbg=16 ctermfg=144
	" Overwrite ctermbg only for this window. Neovim exclusive option
	setlocal winhighlight=Normal:Terminal
endif

let b:undo_ftplugin = "setlocal bufhidden< number<"
