" File:					options.vim
" Description:	Most of set options are done here.
" Author:				Reinaldo Molina <rmolin88@gmail.com>
" Version:				0.0.0
" Last Modified: Sep 14 2017 14:47
" Created: Sep 14 2017 14:47

function! options#Set() abort
	" SET_OPTIONS
	" Regular stuff
	"set spell spelllang=en_us
	"omnicomplete menu
	" save marks

	let &path .='.,,..,../..,./*,./*/*,../*,~/,~/**,/usr/include/*' " Useful for the find command
	set shiftwidth=4 tabstop=4
	set viminfo='1024,%
	set showtabline=1 " always show tabs in gvim, but not vim"
	set backspace=indent,eol,start
	" allow backspacing over everything in insert mode
	" indents defaults. Custom values are changes in after/indent
	" When 'sts' is negative, the value of 'shiftwidth' is used.
	set softtabstop=-8
	set smarttab      " insert tabs on the start of a line according to
	" shiftwidth, not tabstop

	set showmatch     " set show matching parenthesis
	set showcmd				" Show partial commands in the last lines
	set smartcase     " ignore case if search pattern is all lowercase,
	"    case-sensitive otherwise
	set ignorecase
	set infercase
	set hlsearch      " highlight search terms
	set number
	set relativenumber
	set incsearch     " show search matches as you type
	set history=10000         " remember more commands and search history
	" ignore these files to for completion
	set completeopt=menuone,longest,preview,noselect,noinsert
	" set complete+=kspell " currently not working
	" set wildmenu " Sun Jul 16 2017 20:24. Dont like this way. Its weird
	set wildmode=list:longest
	set wildignore+=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn,.git
	set title                " change the terminal's title
	set nobackup " no backup files
	set nowritebackup
	set noswapfile
	"set autochdir " working directory is always the same as the file you are editing
	" Took out options from here. Makes the session script too long and annoying
	set sessionoptions=buffers,curdir,folds,tabpages
	set hidden
	" see :h timeout this was done to make use of ' faster and keep the other
	" timeout the same
	set notimeout
	set nottimeout
	" cant remember why I had a timeout len I think it was
	" in order to use <c-j> in cli vim for esc
	" removing it see what happens
	" set timeoutlen=1000
	" set ttimeoutlen=0
	set nowrap        " wrap lines
	set nowrapscan        " do not wrap search at EOF
	" will look in current directory for tags

	if has('cscope')
		set cscopetag cscopeverbose
		if has('quickfix')
			set cscopequickfix=s+,c+,d+,i+,t+,e+
		endif
	endif
	" set matchpairs+=<:>
	" Display tabs and trailing spaces visually
	"set list listchars=tab:\ \ ,trail:?
	set linebreak    "Wrap lines at convenient points
	" Open and close folds Automatically
	" global fold indent
	" set foldmethod=indent
	set foldmethod=indent
	set foldnestmax=18      "deepest fold is 18 levels
	set foldlevel=0
	set foldlevelstart=0
	" use this below option to set other markers
	"'foldmarker' 'fmr'	string (default: "{{{,}}}")
	set viewoptions=folds,options,cursor,unix,slash " better unix /
	" For conceal markers.
	if has('conceal')
		set conceallevel=2 concealcursor=nv
	endif

	if !has('nvim')
		set noesckeys " No mappings that start with <esc>
	else
		set inccommand = "nosplit"
		set scrollback=-1
	endif

	" no mouse enabled
	set mouse=
	set laststatus=2
	" Thu Oct 26 2017 05:13: On small split screens text goes outside of range
	set textwidth=88
	set nolist " Do not display extra characters
	set scroll=8
	set modeline
	set modelines=1
	" Set omni for all filetypes
	set omnifunc=syntaxcomplete#Complete
	" Mon Jun 05 2017 11:59: Suppose to Fix cd to relative paths in windows
	let &cdpath = ',' . substitute(substitute($CDPATH, '[, ]', '\\\0', 'g'), ':', ',', 'g')
	" Thu Sep 14 2017 14:45: Security concerns addressed by these options.
	set secure
	set noexrc
	" Wed Oct 18 2017 09:19: Stop annoying bell sound
	set belloff=all
	" Thu Dec 21 2017 09:56: Properly format comment strings
	if v:version > 703 || v:version == 703 && has('patch541')
		set formatoptions+=j
	endif

	" Status Line and Colorscheme
	" Set a default bogus colorscheme. If Plugins loaded it will be changed
	colorscheme desert
	if exists('g:plugins_loaded')
		let g:colorscheme_night_time = 18
		let g:colorscheme_day_time = 8
		let g:colorscheme_day = 'PaperColor'
		let g:colorscheme_night = 'PaperColor'
		" Set highliting for Search and Incsearch
		" Auto Flux (changing themes) is set in the augroup.vim file
		augroup FluxLike
			autocmd!
			autocmd VimEnter,BufEnter * call utils#Flux()
		augroup END
	else
		" If this not and android device and we have no plugins setup "ugly" status line
		set statusline =
		set statusline+=\ [%n]                                  "buffernr
		set statusline+=\ %<%F\ %m%r%w                         "File+path
		set statusline+=\ %y\                                  "FileType
		set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
		set statusline+=\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
		set statusline+=\ %{&ff}\                              "FileFormat (dos/unix..)
		set statusline+=\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
		set statusline+=\ col:%03c\                            "Colnr
		set statusline+=\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.
		" If you want to put color to status line needs to be after command
		" colorscheme. Otherwise this commands clears it the color
	endif

	" Performance Settings
	" see :h slow-terminal
	set scrolljump=5
	set sidescroll=15 " see help for sidescroll
	if !has('nvim') " this options were deleted in nvim
		set ttyscroll=3
		set ttyfast " Had to addit to speed up scrolling
	endif
	set lazyredraw " Had to addit to speed up scrolling
	" Mon May 01 2017 11:21: This breaks split window highliting
	" Tue Jun 13 2017 20:55: Giving it another try
	set synmaxcol=200 " Will not highlight passed this column #
	" Sat Oct 07 2017 00:35: Addind support
	set showtabline=2
	" Mon Oct 16 2017 15:22: This speed ups a lot of plugin. Those that have to
	" do with highliting.
	set regexpengine=1
	" Fri May 19 2017 11:38 Having a lot of hang ups with the function! s:Highlight_Matching_Pair()
	" on the file C:\Program Files\nvim\Neovim\share\nvim\runtime\plugin\matchparen.vim
	" This value is suppose to help with it. The default value is 300ms
	" DoMatchParen, and NoMatchParen are commands that enable and disable the command
	let g:matchparen_timeout = 80
	let g:matchparen_insert_timeout = 30

	" TODO-[RM]-(Tue Aug 22 2017 10:43): Move this function calls to init#vim or
	" options.vim
	" Grep
	" Fri Mar 23 2018 18:10: Substituted by vim-gprepper plugin
	" call s:set_grep()

	" Undofiles
	if exists("g:plugins_loaded") && exists("g:undofiles_path") && !empty(glob(g:undofiles_path))
		let &undodir= g:undofiles_path
		set undofile
		set undolevels=10000      " use many muchos levels of undo
	endif

	" Tags
	set tags=./.tags;,.tags;
	" if exists("g:plugins_loaded")
		" Load all tags and OneWings cscope database
		" call ctags#SetTags()
	" endif

	" Diff options
	let &diffopt='vertical'
endfunction

" CLI
function! options#SetCli() abort
	" Detect one of the many gui types
	if has('gui_running')
		" echomsg 'Detected Gvim GUI. Nothing to do here'
		return
	elseif exists('g:GuiLoaded') && g:GuiLoaded == 1
		" echomsg 'Detected Neovim-qt GUI. Nothing to do here'
		return
	elseif exists("g:gui_oni") && g:gui_oni == 1
		" In addition disable status bar
		set laststatus = 0
		" echomsg 'Detected Oni GUI. Nothing to do here'
		return
	elseif exists('g:eovim_running') && g:eovim_running == 1
		" echomsg 'Detected Eovim GUI. Nothing to do here'
		return
	endif

	" Comes from performance options.
	hi NonText cterm=NONE ctermfg=NONE
	if $TERM ==? 'linux'
		set t_Co=8
	else
		set t_Co=256
	endif

	" fixes colorscheme not filling entire backgroud
	set t_ut=

	if !has('nvim')
		" Trying to get termguicolors to work on vim
		let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
		let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
		set termguicolors

		" Tue Sep 12 2017 18:18: These are in order to map Alt in vim terminal
		" under linux. Obtained but going into insert mode, pressing <c-v> and
		" then some alt+key combination
		nnoremap <silent> l <C-w>l
		nnoremap <silent> h <C-w>h
		nnoremap <silent> k <C-w>k
		nnoremap <silent> j <C-w>j

		if !has('clipboard') && !has('xterm_clipboard')
			echomsg 'options#Set(): vim wasnt compiled with clipboard support. Remove vim and install gvim'
		else
			set clipboard=unnamedplus
		endif

		if exists('g:system_name') && g:system_name ==# 'cygwin'
			set term=$TERM
			" Fixes cursor shape in mintty/cygwin
			let &t_ti.="\e[1 q"
			let &t_SI.="\e[5 q"
			let &t_EI.="\e[1 q"
			let &t_te.="\e[0 q"
		endif
	endif

	" Set blinking cursor shape everywhere
	if exists('$TMUX')
		let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
		let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"

		" Fixes broken nmap <c-h> inside of tmux
		nnoremap <BS> :noh<CR>
	elseif has('unix') " Cursors settings for neo(vim) under linux
		" Start insert mode (bar cursor shape)
		let &t_SI = "\<Esc>[5 q"
		" End insert or replace mode (block cursor shape)
		let &t_EI = "\<Esc>[1 q"
	endif

	" Settings for cmder
	if has('win32')
		if !has('nvim')
			set term=xterm
		endif
		let &t_AB="\e[48;5;%dm"
		let &t_AF="\e[38;5;%dm"
	endif

	" Set a pretty title
	augroup TermTitle
		autocmd!
		autocmd BufEnter * let &titlestring = expand("%:t") . " - " . v:progname
	augroup END
	auto
endfunction

" Support here for rg, ucg, ag in that order
function! s:set_grep() abort
	if executable('rg')
		" use option --list-file-types if in doubt
		" rg = ripgrep
		"Use the -t option to search all text files; -a to search all files; and -u to search all,
		"including hidden files.
		if has('unix')
			set grepprg=rg\ $*\ --vimgrep\ --smart-case\ --follow\ --fixed-strings\ --hidden\ --iglob\ '!.{git,svn}'
		else
			set grepprg=rg\ $*\ --vimgrep\ --smart-case\ --follow\ --fixed-strings\ --hidden\ --iglob\ !.{git,svn}
		endif
		set grepformat=%f:%l:%c:%m
	elseif executable('ucg')
		" Add the --type-set=markdown:ext:md option to ucg for it to recognize
		" md files
		set grepprg=ucg\ --nocolor\ --noenv
	elseif executable('ag')
		" ctrlp with ag
		" see :Man ag for help
		" to specify a type of file just do `--cpp`
		set grepprg=ag\ --nogroup\ --nocolor\ --smart-case\ --vimgrep\ --glob\ !.{git,svn}\ $*
		set grepformat=%f:%l:%c:%m
	endif
endfunction


" vim:tw=78:ts=2:sts=2:sw=2:
