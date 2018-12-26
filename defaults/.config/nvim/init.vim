" File:					init.vim
" Description:  Vim/Neovim configuration file
" Author:				Reinaldo Molina
" Version:			0.2.0
"								- Properly distribute files so they are autoloaded
"								- Fully modularize config files
"								- Dein plugin
"								- Python functions files
" Date:					Sun Aug 20 2017 05:13
" Created:			Aug 2015
" Vimfiles:
" Make symbolic link from dotfiles/defaults/.config/nvim to:
" - unix (vim)  : ~/.vim
" - unix (nvim) : ~/.config/nvim
" - win (vim)  : ~/vimfiles
" - win (nvim) : ~/AppData/Local/nvim
"		vim:
"			unix: ~/.vim
"			unix: ~/.vim/vimrc
"			win: ~/vimfiles
"			win: ~/vimfiles/vimrc
"		nvim:
"			unix: ~/.config/nvim
"			unix: ~/.config/nvim/init.vim
"			unix (data): ~/.local/share/nvim
"
"			win: ~/AppData/Local/nvim
"			win (data): ~/AppData/Local/nvim-data

if !has('nvim')
	" Required settings for vim
	set nocompatible
	" Thu Sep 28 2017 15:07: This order matters.
	filetype plugin indent on
	syntax on
endif

" You can a pass a list of files to the function and those and only those files will be sourced
function! s:find_vim_config_file(...) abort
	" If source files were provided source only those and exit
	if a:0 > 0
		for item in a:000
			let l:files = glob(item, 0, 1)
			if empty(l:files)
				continue
			endif
			for fil in l:files
				execute "source " . fil
			endfor
		endfor
		return
	endif

	call s:set_stdpaths()

	let l:root_folder_portable_vim = getcwd() . (has('nvim') ?  '/../../../' : '/../../')
	let g:dotfiles = has('win32') ? $LOCALAPPDATA . "\\dotfiles" : expand('~/.config/dotfiles')

	if !empty(glob(l:root_folder_portable_vim . 'nvim'))
		" If found portable vim. Redifine std_path
		" You need 3 folders in root
		" nvim: copy dotfiles/defaults/.config/nvim
		" nvim-data: copy nvim-data (win) or .local/share/nvim (unix) from some computer
		" tmp: create empty folder
		let g:std_config_path = l:root_folder_portable_vim . 'nvim'
		let g:std_data_path = l:root_folder_portable_vim . 'nvim-data'
		let g:std_cache_path = l:root_folder_portable_vim . 'tmp'
		let g:portable_vim = 1
		let g:dotfiles = ''

		" Add them to the path so that they can be found
		set rtp +=g:std_config_path
		let &rtp .= ',' . g:std_data_path . '/site'
	endif

	" Define plugins locations
	let g:plug_path = g:std_data_path . '/site/autoload/plug.vim'
	let g:vim_plugins_path = g:std_data_path . '/vim_plugins'

	" Configure
	call init#vim()
endfunction

function! s:set_stdpaths() abort
	if has('nvim')
		return s:set_nvim_stdpaths()
	endif

	" Fix here. These should be vim std paths. Like vimfiles
	if has('win32')
		let g:std_config_path = expand("~\\vimfiles")
		let g:std_data_path = (exists('$LOCALAPPDATA')) ? $LOCALAPPDATA . "\\nvim-data" : expand("~\\AppData\\Local\\nvim-data")
		let g:std_cache_path = (exists('$TEMP')) ? $TEMP : expand("~\\AppData\\Local\\Temp")
	else
		let g:std_config_path = expand("~/.vim")
		let g:std_data_path = (exists('$XDG_DATA_HOME')) ? $XDG_DATA_HOME . '/nvim' : expand("~/.local/share/nvim")
		let g:std_cache_path = (exists('$XDG_CACHE_HOME')) ? $XDG_CACHE_HOME . '/nvim' : expand("~/.cache/nvim")
	endif

	" Tue Dec 25 2018 20:49 
	" vim doesnt have a std_data_path therefore just add it to its rtp
	" so that plug.vim can be loaded properly
	let &rtp .= ',' . g:std_data_path . '/site'
endfunction

function! s:set_nvim_stdpaths()
	let g:std_config_path = stdpath('config')
	let g:std_data_path = stdpath('data')
	let g:std_cache_path = stdpath('cache')
endfunction

call s:find_vim_config_file()

" call s:set_stdpaths()
" execute "source " . g:std_data_path . '/vim-plug/plug.vim'
" call plug#begin(g:std_data_path . '/vim_plugins')
" Plug 'francoiscabrol/ranger.vim'
" Plug 'c0r73x/neotags.nvim' " Depends on pip3 install --user psutil
" let g:neotags_enabled = 1
" call plug#end()
