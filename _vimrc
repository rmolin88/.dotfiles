" Improvements:
" - [ ] insertion and mark complete
" REQ AND LEADER
	set nocompatible
	" moving these lines here fixes losing 
	" syntax whith split screen actually it doesnt
	syntax on
	filetype on
	filetype plugin on
	filetype indent on
	" moved here otherwise conditional mappings get / instead ; as leader 
	let mapleader="\<Space>"
	let maplocalleader="\<Space>"

" WINDOWS_SETTINGS 
if has('win32')
	" Path variables
	let s:personal_path= $HOME . '\vimfiles\personal\'
	let s:plugged_path=  $HOME . '\vimfiles\plugged\'
	let s:vimfile_path=  $HOME . '\vimfiles\'
	let s:custom_font =  'consolas:h8'
	" always start in the home dir

	if !has('gui_running')
		set term=xterm
		let &t_AB="\e[48;5;%dm"
		let &t_AF="\e[38;5;%dm"
	endif

	" update cscope and ctags
	noremap <Leader>tu :cs kill -1<CR>
	\:silent !del /F cscope.files cscope.in.out cscope.po.out cscope.out<CR>
	\:silent !dir /b /s *.cpp *.h *.hpp *.c *.cc > cscope.files<CR> 
	\:!cscope -b -q -i cscope.files<CR>
	\:silent !ctags -R -L cscope.files -f ./.svn/tags<CR>
	\:cs add cscope.out<CR>

	noremap <Leader>mr :!%<CR>
	" Copy and paste into system wide clipboard
	noremap <Leader><Space>v "*p
	noremap <Leader><Space>y "*yy
	nnoremap <Leader><Space>= :silent! let &guifont = substitute(
	\ &guifont,
	\ ':h\zs\d\+',
	\ '\=eval(submatch(0)+1)',
	\ '')<CR>
	nnoremap <Leader><Space>- :silent! let &guifont = substitute(
	\ &guifont,
	\ ':h\zs\d\+',
	\ '\=eval(submatch(0)-1)',
	\ '')<CR>

	nnoremap  o<Esc>
	" Mappings to execute programs
	" Do not make a ew1 mapping. reserved for when issues get to #11, 12, etc
	nnoremap <Leader>ewd :silent !start cmd /k "WINGS.exe 3 . default.ini" & exit<CR>
	nnoremap <Leader>ewc :silent !start cmd /k "WINGS.exe 3 . %" & exit<CR>
	nnoremap <Leader>ews :exe("!start cmd /k \"WINGS.exe 3 . " . input("Config file:", "", "file") . "\" & exit")<CR>
	nnoremap <Leader>ewl :silent !del default.ini<CR>
						\:!mklink default.ini 
	" e1 reserved for vimrc
	nnoremap <Leader>e21 :silent e ~/Documents/1.MyDocuments/2.WINGS/NeoOneWINGS/
	nnoremap <Leader>e22 :silent e ~/Documents/1.MyDocuments/2.WINGS/
	nnoremap <Leader>e3 :silent e ~/vimfiles/personal/wiki/
	nnoremap <Leader>e4 :silent e ~/Desktop/daily\ check/
	nnoremap <Leader>e5 :silent e ~/Documents/1.MyDocuments/Forms/Weekly_Reports/
	nnoremap <Leader>e6 :silent e ~/Documents/1.MyDocuments/3.Training/2.NI_Testand/
	nnoremap <Leader>ed :silent e default.ini<CR>

	nnoremap <Leader>es1 :silent e D:/Reinaldo/NeoOneWINGS/
	" Time runtime of a specific program
	nnoremap <Leader>mt :!powershell -command "& {&'Measure-Command' {.\sep_calc.exe seprc}}"<CR>

	" Windows specific plugins options 
		" Plugin 'ctrlpvim/ctrlp.vim' " quick file searchh"
			set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*  " Windows ('noshellslash')
			let g:ctrlp_custom_ignore = {
				\ 'dir':  '\v[\/]\.(git|hg|svn)$',
				\ 'file': '\v\.(tlog|log|db|obj|o|exe|so|dll|dfm)$',
				\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
				\ }
		
		" Vim-Clang " not being used currently but this below fixes 
		" clang using mscv for target instead of mingw64
			let g:clang_cpp_options = '-target x86_64-pc-windows-gnu -std=c++17 -pedantic -Wall'
			let g:clang_c_options = '-target x86_64-pc-windows-gnu -std=gnu11 -pedantic -Wall'

		" MaxT Path
			if isdirectory('C:\maxapi')
				set path+=C:\maxapi
			endif

" UNIX_SETTINGS 
elseif has('unix')
	" Path variables
	if has('nvim')
		let s:personal_path= $HOME . '/.config/nvim/personal/'
		let s:plugged_path=  $HOME . '/.config/nvim/plugged/'
		let s:vimfile_path=  $HOME . '/.config/nvim/'
	else
		let s:personal_path= $HOME . '/.vim/personal/'
		let s:plugged_path=  $HOME . '/.vim/plugged/'
		let s:vimfile_path=  $HOME . '/.vim/'
	endif

	let s:custom_font = 'Andale Mono 8'

	" this one below DOES WORK in linux just make sure is ran at root folder
	noremap <Leader>tu :cs kill -1<CR>
	\:!rm cscope.files cscope.out cscope.po.out cscope.in.out<CR>
	\:!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.cc'  -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
	\:!cscope -b -q -i cscope.files<CR>
	\:cs add cscope.out<CR>
	\:silent !ctags -R -L cscope.files<CR>

	noremap <Leader>mr :!./%<CR>
	noremap <Leader><Space>v "+p
	noremap <Leader><Space>y "+yy

	nnoremap <Leader>el :silent e ~/
	" edit odroid
	nnoremap <Leader>eo :silent e ~/truck-server/Documents/NewBot_v3/
	" edit here
	nnoremap <Leader>eh :silent e ~/Documents/NewBot_v3/

	nnoremap <Leader><Space>= :silent! let &guifont = substitute(
	\ &guifont,
	\ '\ \zs\d\+',
	\ '\=eval(submatch(0)+1)',
	\ '')<CR>
	nnoremap <Leader><Space>- :silent! let &guifont = substitute(
	\ &guifont,
	\ '\ \zs\d\+',
	\ '\=eval(submatch(0)-1)',
	\ '')<CR>

	nnoremap <CR> o<ESC>

	" Unix Specific Plugin Options
		"Plugin 'ctrlpvim/ctrlp.vim' " quick file searchh" 
			set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
			let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

		" VIM_PATH includes 
			" With this you can use gf to go to the #include <avr/io.h>
			" also this path below are what go into the .syntastic_avrgcc_config
			" i.e: -I/opt.....
			" TODO: create tags to be loaded for all these paths
			if isdirectory('/opt/avr8-gnu-toolchain-linux_x86_64/avr/include')
				set path+=/opt/avr8-gnu-toolchain-linux_x86_64/avr/include
			endif
			if isdirectory('/opt/avr8-gnu-toolchain-linux_x86_64/include')
				set path+=/opt/avr8-gnu-toolchain-linux_x86_64/include
			endif
			if isdirectory('/usr/local/include')
				set path+=/usr/local/include
			endif
			if isdirectory('/usr/include')
				set path+=/usr/include
			endif
			" these are avr tags created by vimrc/scripts/maketags.sh
			let &tags= s:personal_path . 'ctags/tags'

		" Syntastic
			let g:syntastic_c_config_file = s:personal_path . '.syntastic_avrgcc_config'
endif

" FUNCTIONS 
	" Only works in vimwiki filetypes
	" Input: empty- It will ask you what type of file you want to search
	" 		 String- "1", "2", or specify files in which you want to search
	function! s:GlobalSearch(type) abort 
		try
			"echomsg string(a:type)  " Debugging purposes
			if a:type == "0" 
				echo "Search Filetypes:\n\t1.Any\n\t2.Cpp\n\t3.Wiki" 
				let l:file = nr2char(getchar())
			else
				let l:file = a:type
			endif
			if !executable('ag') " use ag if possible 
				if l:file == 1
					let l:file = "**/*"
				elseif l:file == 2
					let l:file = "**/*.cpp **/*.h **/*.c **/*.hpp **/*.cc"
				elseif l:file == 3
					let l:file = "**/*.wiki"
				endif
				exe "vimgrep /" . input("Search in \"" . getcwd() . "\" for:") . "/ " . l:file
			else
				if l:file == 1
					let l:file = ""
				elseif l:file == 2
					let l:file = "--cpp"
				endif " relays on set grepprg=ag 
				exe "grep " . l:file . " " . input("Search in \"" . getcwd() . "\" for:")
			endif
			copen 20
		catch
			echohl ErrorMsg
			redraw " prevents the msg from misteriously dissapearing 
			echomsg "GlobalSearch(): " . matchstr(v:exception, ':\zs.*')
			echohl None
		endtry
	endfunction

	" Commits current buffer
	function! s:GitCommit() abort
		if <SID>CheckFileOrDir(1, ".git") > 0
			silent !git add .
			exe "silent !git commit -m \"" . input("Commit comment:") . "\""
			!git push origin master 
		else
			echo "No .git directory was found"
		endif
	endfunction

	" Should be performed on root .svn folder
	function! s:SvnCommit() abort
		exe "!svn commit -m \"" . input("Commit comment:") . "\" ."
	endfunction

	" Special comment function {{{
	function! s:FindIf() abort
		while 1
			" jump to matching {
			normal %
			" check to see if there is another else
			if match(getline(line(".")-1, line(".")), "else") > -1
				" search curr and previous 2 lines for }
				if match(getline(line(".")-2, line(".")), "}") > -1
					" jump to it
					exe "normal ?}\<CR>"
					" if there is no } could be no braces else if
				else
					" go up to lines and see what happens
					normal kk
				endif
			else
				" if original if was found copy it to @7 and jump back to origin
				exe "normal k^\"7y$`m"
				break
			endif
		endwhile
	endfunction

	function! s:TruncComment(comment) abort
		" brute trunc at 46
		let l:strip = a:comment
		if strchars(l:strip) > 46
			let l:strip = strpart(l:strip,0,46)
			let l:strip .= "..."
		endif
		" if theres a comment get rid of it
		let l:com = match(l:strip, "/")
		if l:com > -1
			let l:strip = strpart(l:strip,0,l:com-1)
		endif
		return l:strip
	endfunction

	" Gotchas: Start from the bottom up commenting
	function! s:EndOfIfComment() abort
		" TDOD: Eliminate comments on lines very important
		" is there a } in this line?
		"let g:testa = 0  " Debugging variable
		let l:ref_col = match(getline("."), "}")
		if  l:ref_col > -1 " if it exists
			" Determine what kind of statement is this i.e: for, while, if, else if
			" jump to matchin {, mark it with m, copy previous line to @8, and jump back down to original }
			"exe "normal mm" . l:ref_col . "|%k^\"8y$j%"
			exe "normal mm" . l:ref_col . "|%"
			let l:upper_line = line(".")
			exe "normal k^\"8y$j%"
			" if original closing brace it is and else if || else
			if match(getline(line(".")-1, line(".")), "else") > -1
				let g:testa = 1
				" if { already contains closing if put it
				" TODO:fix this to make search for else not only in @8 line
				if match(getline(l:upper_line-1,l:upper_line), "else") > -1
					" search upwards until you find initial if and copy it to @7
					call <SID>FindIf()
					" truncate comment line in case too long
					let @7 = <SID>TruncComment(@7)
					" append // "initial if..." : "
					let l:end = "  // \""
					execute "normal a" . l:end . @7 . "\" : \"\<Esc>"
				else
					let l:end = "  // \""
					execute "normal a" . l:end . "\<Esc>"
				endif
				" search openning brace for else
			elseif match(getline(l:upper_line-1,l:upper_line), "else") > -1
				let g:testa = 2
				" search upwards until you find initial if and copy it to @7
				call <SID>FindIf()
				" truncate comment line in case too long
				let @7 = <SID>TruncComment(@7)
				" append // "initial if..." : "
				let l:end = "  // End of \""
				execute "normal a" . l:end . @7 . "\" : \"\<Esc>"
				" if not very easy
			else 
				" Append // End of "..."
				let l:end = "  // End of \""
				execute "normal a" . l:end . "\<Esc>"
			endif
			" truncate comment line in case too long
			let @8 = <SID>TruncComment(@8)
			execute "normal a" . @8 . "\""
		else
			echo "EndOfIfComment(): Closing brace } needs to be present at the line"
		endif
	endfunction
	nnoremap <Leader>ce :call <SID>EndOfIfComment()<CR>
	" End of Special Comment function }}}

	function! s:CheckDirwPrompt(name) abort
		if !has('file_in_path')  " sanity check 
			echo "CheckFileOrDir(): This vim install has no support for +find_in_path"
			return -10
		endif
		if a:type == 0  " use 0 for file, 1 for dir
			let l:func = findfile(a:name,",,")  " see :h cd for ,, 
		else
			let l:func = finddir(a:name,",,") 
		endif
		if !empty(l:func)
			return 1
		else
			exe "echo \"Folder " . escape(a:name, '\') . "does not exists.\n\""
			exe "echo \"Do you want to create it (y)es or (n)o\""
			let l:decision = nr2char(getchar())
			if l:decision == "y"
				if exists("*mkdir") 
					if has('win32') " on win prepare name by escaping '\' 
						let l:esc_name = escape(a:name, '\')
						exe "call mkdir(\"". l:esc_name . "\", \"p\")"
					else  " have to test check works fine on linux 
						exe "call mkdir(\"". a:name . "\", \"p\")"
					endif
					return 1
				else
					return -1
				endif
			endif
			return -1
		endif
	endfunction

	function! s:CheckDirwoPrompt(name) abort
		if !has('file_in_path')  " sanity check 
			echo "CheckFileOrDir(): This vim install has no support for +find_in_path"
			return -10
		else
			if !empty(finddir(a:name,",,"))
				return 1
			else
				if exists("*mkdir") 
					if has('win32') " on win prepare name by escaping '\' 
						exe "call mkdir(\"". escape(a:name, '\') . "\", \"p\")"
					else  " have to test check works fine on linux 
						exe "call mkdir(\"". a:name . "\", \"p\")"
					endif
					return 1
				else
					echomsg string("No +mkdir support. Can't create dir")
					return -1
				endif
			endif
		endif
	endfunction

	function! s:YankFrom() abort
		exe "normal :" . input("Yank From Line:") . "y\<CR>"
	endfunction
	nnoremap yl :call <SID>YankFrom()<CR>

	function! s:DeleteLine() abort
		exe "normal :" . input("Delete Line:") . "d\<CR>``"
	endfunction
	nnoremap dl :call <SID>DeleteLine()<CR>

	function! s:CommentLine() abort
		if exists("*NERDComment")
			exe "normal mm:" . input("Comment Line:") . "\<CR>"
			exe "normal :call NERDComment(\"n\", \"Toggle\")\<CR>`m"
		else
			echo "Please install NERDCommenter"
		endif
	endfunction
	nnoremap cl :call <SID>CommentLine()<CR>

	" TODO: substitute this for a custom neosnippet see :h neosnippet
	function! s:ListsNavigation(cmd) abort
		try
			let l:list = 0
			if !empty(getloclist(0)) " if location list is not empty
				let l:list = 1
				exe "silent l" . a:cmd
			elseif !empty(getqflist()) " if quickfix list is not empty
				exe "silent c" . a:cmd
			else
				echohl ErrorMsg
				redraw " always use it to prevent msg from dissapearing
				echomsg "ListsNavigation(): Lists quickfix and location are empty"
				echohl None
			endif
		catch /:E553:/ " catch no more items error 
			if l:list == 1
				silent .ll
			else
				silent .cc
			endif
		endtry
	endfunction

	function! s:SetDiff() abort
		nnoremap <C-Down> ]c
		nnoremap <C-Up> [c
		nnoremap <C-Left> :diffget<CR>
		nnoremap <C-Right> :diffput<CR>
		windo diffthis
	endfunction

	function! s:UnsetDiff() abort
		nunmap <C-Down>
		nunmap <C-Up>
		nunmap <C-Left>
		nunmap <C-Right>
		diffoff!
	endfunction

	function! s:CheckVimPlug() abort
		if empty(glob(s:vimfile_path . 'autoload/plug.vim'))
			if executable('curl')
				echomsg "Master I am going to install all plugings for you"
				exe "silent !curl -fLo " s:vimfile_path . "autoload/plug.vim --create-dirs"
					\" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
				autocmd VimEnter * PlugInstall | source $MYVIMRC
			else
				echomsg "Master I cant install plugins for you because you"
							\" do not have curl. Please fix this"
			endif
		endif
	endfunction

	function! s:CommentDelete() abort
		exe "normal Bf/D"
	endfunction
	nnoremap <Leader>cD :call <SID>CommentDelete()<CR>

	function! s:CommentIndent() abort
		exe "normal Bf/i\<Tab>\<Tab>\<Esc>"
	endfunction
	nnoremap <Leader>ci :call <SID>CommentIndent()<CR>

	function! s:CommentReduceIndent() abort
		exe "normal Bf/hxhx"
	endfunction
	nnoremap <Leader>cI :call <SID>CommentReduceIndent()<CR>

	function! s:TodoCreate() abort
		exe "normal Bi\<Space>[ ]\<Esc>"
	endfunction
	nnoremap <Leader>td :call <SID>TodoCreate()<CR>

	function! s:TodoMark() abort
		exe "normal Bf[lrX\<Esc>"
	endfunction
	nnoremap <Leader>tm :call <SID>TodoMark()<CR>

	function! s:TodoClearMark() abort
		exe "normal Bf[lr\<Space>\<Esc>"
	endfunction
	nnoremap <Leader>tM :call <SID>TodoClearMark()<CR>

" PLUGINS_FOR_BOTH_SYSTEMS 
	" Install vim-plug and all plugins in case of first use
	call <SID>CheckVimPlug()

	" Call Vim-Plug Plugins should be from here below
	call plug#begin(s:plugged_path)
	if has('nvim')
		Plug 'Shougo/deoplete.nvim'
	else
		Plug 'Shougo/neocomplete'
	endif
	" misc
	Plug 'chrisbra/vim-diff-enhanced'
	Plug 'scrooloose/nerdtree'
	Plug 'scrooloose/nerdcommenter'
	Plug 'tpope/vim-surround'
	Plug 'ctrlpvim/ctrlp.vim'
	" cpp
	Plug 'Tagbar'
	Plug 'justmao945/vim-clang'
	Plug 'scrooloose/syntastic'
	" autocomplete
	Plug 'Shougo/neosnippet'
	Plug 'Shougo/neosnippet-snippets'
	Plug 'honza/vim-snippets'
	" version control
	Plug 'tpope/vim-fugitive'
	" aesthetic
	Plug 'octol/vim-cpp-enhanced-highlight'
	Plug 'NLKNguyen/papercolor-theme'
	Plug 'junegunn/rainbow_parentheses.vim'
	Plug 'morhetz/gruvbox' " colorscheme gruvbox 

	" All of your Plugins must be added before the following line
	call plug#end()            " required

" GUI_SETTINGS 
	if has('gui_running')
		let &guifont = s:custom_font " OS dependent font 
		set guioptions-=T  " no toolbar
		set guioptions-=m  " no menu bar
		set guioptions-=r  " no right scroll bar
		set guioptions-=l  " no left scroll bar
		set guioptions-=L  " no side scroll bar
		nnoremap <S-CR> O<Esc>
	else " common cli options to both systems 
		set t_Co=256
		" fixes colorscheme not filling entire backgroud
		set t_ut=
	endif

" PERFORMANCE_SETTINGS
	" see :h slow-terminal
	hi NonText cterm=NONE ctermfg=NONE
	set showcmd " use noshowcmd if things are really slow 
	set scrolljump=5
	set sidescroll=5
	if !has('nvim') " this option was deleted in nvim
		set ttyscroll=3
	endif
	set lazyredraw " Had to addit to speed up scrolling 
	set ttyfast " Had to addit to speed up scrolling 
	set fsync " see :h fsync, maybe dangerous but no problems so far
	set nocursorline
	" let g:tex_fast= "" " on super slow activate this, price: no syntax
	" highlight
	" already had problems with it. lost an entire file. dont use it

" MISCELANEOUS_SETINGS 
	" OmniCpp
	let OmniCpp_NamespaceSearch = 1
	let OmniCpp_GlobalScopeSearch = 1
	let OmniCpp_ShowAccess = 1
	let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
	let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

	" TMP folder
	if <SID>CheckDirwoPrompt(s:personal_path . "tmp")
		let $TMP= s:personal_path . "tmp"
	else
		echomsg string("Failed to create tmp dir")
	endif

" TODO: step here to go and check/create all the required folders:
"	- sessions
"	- tmp
"	- undofiles
"	- ctrlp
"	- neocomplete
"	- neosnippets


" SET_OPTIONS 
	"set spell spelllang=en_us
	"omnicomplete menu
	set nospell
	set diffexpr=
	" save marks 
	set viminfo='1000,f1,<800,%1024
	set showtabline=1 " always show tabs in gvim, but not vim"
	set backspace=indent,eol,start
						" allow backspacing over everything in insert mode
	" indents
	set smartindent " these 2 make search case smarter
	set autoindent    " always set autoindenting on
	set copyindent    " copy the previous indentation on autoindenting
	" tabs
	set tabstop=4     " a tab is four spaces
	set softtabstop=4
	set shiftwidth=4  " number of spaces to use for autoindenting
	set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'

	set showmatch     " set show matching parenthesis
	set smartcase     " ignore case if search pattern is all lowercase,
						"    case-sensitive otherwise
	set ignorecase
	set smarttab      " insert tabs on the start of a line according to
						"    shiftwidth, not tabstop
	set hlsearch      " highlight search terms
	set number
	set relativenumber
	set incsearch     " show search matches as you type
	set history=1000         " remember more commands and search history
	" ignore these files to for completion
	set wildignore+=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn,.git
	set completeopt=menuone,menu,longest,preview
	set wildmenu
	set wildmode=list:longest
	set title                " change the terminal's title
	set visualbell           " don't beep
	set noerrorbells         " don't beep
	set nobackup " no backup files 
	set noswapfile
	"set autochdir " working directory is always the same as the file you are editing
	set sessionoptions=buffers,curdir,folds,localoptions,options
	set hidden
	" wont open a currently open buffer
	"set switchbuf=useopen
	set switchbuf=
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
	" THE BEST FEATURE I'VE ENCOUNTERED SO FAR OF VIM
	" CAN BELIEVE I DIDNT DO THIS BEFORE
	set tags+=.\tags;\

	if has('cscope')
		set cscopetag cscopeverbose
		if has('quickfix')
			set cscopequickfix=s+,c+,d+,i+,t+,e+
		endif
	endif
	set matchpairs+=<:>
	set autoread " autoload files written outside of vim
	" Display tabs and trailing spaces visually
	"set list listchars=tab:\ \ ,trail:?
	set linebreak    "Wrap lines at convenient points
	"set scrolloff=8         "Start scrolling when we're 8 lines away from margins

	" Open and close folds Automatically
	set foldenable
	" global fold indent
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

	if has('persistent_undo')
		if <SID>CheckDirwoPrompt(s:personal_path . '/undofiles')
			let &undodir= s:personal_path . '/undofiles'
			set undofile
			set undolevels=1000      " use many muchos levels of undo
		endif
	endif

	set noesckeys " No mappings that start with <esc>
	set showmode
	" no mouse enabled 
	set mouse=""
	" significantly improves ctrlp speed. requires installation of ag
	if executable('ag')
		set grepprg=ag\ --nogroup\ --nocolor
	else
		echomsg string("You should install silversearcher-ag. Makes ctrlp much faster")
		set grepprg&
	endif
	set laststatus=2
	set formatoptions=croqt " this is textwidth actually breaks the lines 
	set textwidth=80
	set com+=b:-,b:* " makes vim autocomplete - bullets

" ALL_AUTOGROUP_STUFF 
	augroup Filetypes
		autocmd!
		" C/Cpp
		autocmd VimEnter :cd $HOME<CR>
		autocmd FileType c setlocal omnifunc=omni#c#complete#Main
		autocmd FileType cpp setlocal omnifunc=omni#cpp#complete#Main
		autocmd FileType c,cpp setlocal cindent
		" enforce "t" in formatoptions on cpp files
		autocmd FileType c,cpp setlocal formatoptions=croqt
		" rainbow cannot be enabled for help file. It breaks syntax highlight
		autocmd FileType c,cpp RainbowParentheses
		" Nerdtree Fix
		autocmd FileType nerdtree setlocal relativenumber
		autocmd FileType nerdtree setlocal encoding=utf-8 " fixes little arrows
		" Set omnifunc for all others 									" not showing
		autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
		autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
		autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
		autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
		autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
		autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
		" Latex
		autocmd FileType tex setlocal spell spelllang=en_us
		autocmd FileType tex setlocal fdm=indent
		" Display help vertical window not split
		autocmd FileType help wincmd L
		" Arduino
		autocmd BufNewFile,BufReadPost *.ino,*.pde setlocal ft=arduino
		" automatic syntax for *.scp
		autocmd BufNewFile,BufReadPost *.scp setlocal syntax=asm
	augroup END

" CUSTOM MAPPINGS
	" List of super useful mappings
	" ga " prints ascii of char under cursor
	
	" Quickfix and Location stuff 
		" Description:
		" C-Arrow forces movement on quickfix window
		" Arrow moves on whichever window open (qf || ll)
		" if both opened favors location window

		" Quickfix only mappings
		nnoremap <C-Down> :cn<CR>
		nnoremap <C-Up> :cp<CR>
		nnoremap <C-Right> :cnf<CR>
		nnoremap <C-Left> :cpf<CR>
		noremap <Leader>qo :copen 20<CR>
		noremap <Leader>qc :.cc<CR>

		nnoremap <Down> :call <SID>ListsNavigation("next")<CR>
		nnoremap <Up> :call <SID>ListsNavigation("previous")<CR>
		nnoremap <Right> :call <SID>ListsNavigation("nfile")<CR>
		nnoremap <Left> :call <SID>ListsNavigation("pfile")<CR>

		noremap <Leader>ql :ccl<CR>
					\:lcl<CR>

	" Miscelaneous Mappings
		" edit vimrc on a new tab
		noremap <Leader>mv :e $MYVIMRC<CR>
		noremap <Leader>ms :so %<CR>
		nnoremap <C-s> :wa<CR>
		nnoremap <C-h> :noh<CR>
		nnoremap <C-Space> i<Space><Esc>
		" move current line up
		nnoremap <Leader>K ddkk""p
		" move current line down
		noremap <Leader>J dd""p
		" These are only for command line
		" insert in the middle of whole word search
		cnoremap <C-w> \<\><Left><Left>
		" insert visual selection search
		cnoremap <C-u> <c-r>=expand("<cword>")<cr>
		cnoremap <C-s> %s/
		" refactor
		nnoremap <Leader>r :%s/\<<c-r>=expand("<cword>")<cr>\>//gc<Left><Left><Left>
		vnoremap <Leader>r "hy:%s/<C-r>h//gc<left><left><left>
		"vnoremap <Leader>r :%s///gc<Left><Left><Left>
		cnoremap <C-p> <c-r>0
		cnoremap <C-o> <Up>
		cnoremap <C-k> <Down>
		cnoremap <C-j> <Left>
		cnoremap <C-l> <Right>
		"noremap <Leader>mn :noh<CR>
		" duplicate current char
		nnoremap <Leader>mp ylp
		vnoremap <Leader>mp ylp
		"noremap <Leader>mt :set relativenumber!<CR>
		noremap <Leader>md :Dox<CR>
		" not paste the deleted word
		nnoremap <Leader>p "0p
		vnoremap <Leader>p "0p
		" Switch back and forth between header file
		nnoremap <Leader>moh :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>"
		" SyntasticCheck toggle
		noremap <Leader>so :SyntasticToggleMode<CR>
		noremap <S-q> yyp
		" move to the beggning of line
		noremap <S-w> $
		" move to the end of line
		noremap <S-b> ^
		" jump to corresponding item<Leader> ending {,(, etc..
		nnoremap <S-t> %
		vnoremap <S-t> %
		" Automatically insert date
		nnoremap <F5> a///////////////<Esc>"=strftime("%c")<CR>Pa///////////////<Esc>
		inoremap <F5> ///////////////<Esc>"=strftime("%c")<CR>Pa///////////////

		" cd into current dir path and into dir above current path
		nnoremap <Leader>e1 :e ~/vimrc/
		" nnoremap <Leader>e :e  " timeout enabled dependant 
		nnoremap <Leader>cd :cd %:p:h<CR>
					\:pwd<CR>
		nnoremap <Leader>cu :cd %:p:h<CR>
					\:cd ..<CR>
					\:pwd<CR>
		nnoremap <Leader>cc :pwd<CR>
		nnoremap <Leader>ch :cd ~<CR>
					\pwd<CR>
		" Auto indent pasted text
		nnoremap p p=`]<C-o>
		nnoremap P P=`]<C-o>
		" Visual shifting (does not exit Visual mode)
		vnoremap < <gv
		vnoremap > >gv

		" see :h <c-r>
		nnoremap <Leader>nl :bro old<CR>
		" decrease number
		nnoremap <Leader>A <c-x>
		inoremap <c-l> <c-o>x

	" Folding 
		" Folding select text then S-f to fold or just S-f to toggle folding
		nnoremap <Leader>ff za
		onoremap <Leader>ff <C-C>za
		nnoremap <Leader>ff zf
		nnoremap <C-j> zj
		nnoremap <C-k> zk
		nnoremap <C-z> zz
		nnoremap <C-c> zM
		nnoremap <C-n> zR
		nnoremap <C-x> za
		" dont use <C-a> it conflicts with tmux prefix

	" Window movement 
		" move between windows
		nnoremap <Leader>h <C-w>h
		nnoremap <Leader>j <C-w>j
		nnoremap <Leader>k <C-w>k
		nnoremap <Leader>l <C-w>l

	" Diff Sutff 
		noremap <Leader>do :call <SID>SetDiff()<CR>
		nnoremap <Leader>dl :call <SID>UnsetDiff()<CR>

	" Spell Check 
		" search forward
		noremap <Leader>sn ]s
		" search backwards
		noremap <Leader>sp [s
		" suggestion
		noremap <Leader>sC z=1<CR><CR>
		noremap <Leader>sc z=
		" toggle spelling
		noremap <Leader>st :setlocal spell! spelllang=en_us<CR>

		noremap <Leader>sf :call FixPreviousWord()<CR>
		function! FixPreviousWord() abort
			normal mm[s1z=`m
		endfunction
		" add to dictionary
		noremap <Leader>sa zg
		" mark wrong
		noremap <Leader>sw zw
		" repeat last spell correction
		noremap <Leader>sr :spellr<CR>

	" Search
		" search all type of files
		nnoremap <Leader>Sa :call <SID>GlobalSearch(1)<CR>
		" search cpp files
		nnoremap <Leader>Sc :call <SID>GlobalSearch(2)<CR>
		nnoremap <Leader>w /\<<c-r>=expand("<cword>")<cr>\>
		nnoremap <Leader>W :%s/\<<c-r>=expand("<cword>")<cr>\>/
		" This is a very good to show and search all current but a much better is 
		" remaped search to f
		noremap <S-s> #<C-o>
		vnoremap // y/<C-R>"<CR>

	" Substitute for ESC
		" Not remapping esc anymore. going to get used to <c-[> its default doesnt require mapping
		inoremap <C-j> <Esc>
		vnoremap <C-j> <Esc>
		" cnoremap <C-j> <Esc>

	" Tab Stuff 
		noremap <S-j> :b#<CR>
		noremap <Leader>bo :CtrlPBuffer<CR>
		noremap <Leader>bd :bd %<CR>
		" deletes all buffers
		noremap <Leader>bD :%bd<CR>
		noremap <Leader>bs :buffers<CR>:buffer<Space>
		noremap <Leader>bS :bufdo 
		" move tab to the left
		nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
		" move tab to the right
		noremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
		noremap <Leader>be :enew<CR>
		" open new to tab to explorer
		nnoremap <S-Tab> gT
		nnoremap <S-e> :tab split<CR>
		nnoremap <S-x> :tabclose<CR>

	" make 
		nnoremap <Leader>ma :make clean<CR>
					\:make all<CR>
					\:
		nnoremap <Leader>mc :make clean<CR>
		nnoremap <Leader>mf ::!sudo dfu-programmer atxmega128a4u erase<CR>
					\:!sudo dfu-programmer atxmega128a4u flash atxmega.hex<CR>
					\:!sudo dfu-programmer atxmega128a4u start<CR>
		" super custom compile and run command
		nnoremap <Leader>mu :make all<CR>
					\:!sep_calc.exe seprc<CR>
					" \:!sep_calc.exe test.csv WINGS_EGI_GCORE_S3.mod.ini<CR>
		nnoremap <Leader>mi :make all<CR>
					\:!sep_calc.exe some.csv<CR>
		nnoremap <Leader>mo :make all<CR>
					\:!sep_calc.exe nada.csv<CR>

	" sessions
		nnoremap <Leader>sS :call <SID>SaveSession()<CR>
		function! s:SaveSession() abort
			exe "wall"
			exe "cd ". s:personal_path ."sessions/"
			exe "normal :mksession! " . s:personal_path . "sessions/". input("Enter 
						\save session name:", "", "file") . "\<CR>"
			exe "cd -"
		endfunction

		nnoremap <Leader>sL :call <SID>LoadSession()<CR>
		function! s:LoadSession() abort
			" save all work
			" TODO: before deleting buffers ask if to save them
			exe "wall"
			" close out all buffers
			exe "normal :%bdelete\<CR>"
			exe "cd ". s:personal_path ."sessions/"
			exe "normal :so " . s:personal_path . "sessions/". input("Enter 
						\load session name:", "", "file") . "\<CR>"
			exe "cd -"
		endfunction
	
	" Version Control 
		" For all this commands you should be in the svn root folder
		" Add all files
		nnoremap <Leader>vA :!svn add * --force<CR>
		" Add specific files
		nnoremap <Leader>va :!svn add --force 
		" Commit using typed message
		nnoremap <Leader>vc :call <SID>SvnCommit()<CR>
		" Commit using File for commit content
		nnoremap <Leader>vC :!svn commit --force-log -F %<CR>
		nnoremap <Leader>vdl :!svn rm --force Log\*<CR>
		nnoremap <Leader>vda :!svn rm --force 
		" revert previous commit
		" dangerous key TODO: warn before
		"noremap <Leader>vr :!svn revert -R .<CR>
		nnoremap <Leader>vl :!svn cleanup .<CR>
		" use this command line to delete unrevisioned or "?" svn files
		"noremap <Leader>vL :!for /f "tokens=2*" %i in ('svn status ^| find "?"') do del %i<CR>
		nnoremap <Leader>vs :!svn status .<CR>
		nnoremap <Leader>vu :!svn update .<CR>
		nnoremap <Leader>vo :!svn log .<CR>
		nnoremap <Leader>vi :!svn info<CR>
		" fugitive
			nnoremap <Leader>gs :Gstatus<CR>
			nnoremap <Leader>gp :Gpush<CR>
			nnoremap <Leader>gu :Gpull<CR>
			nnoremap <Leader>ga :!git add 
			nnoremap <Leader>gl :silent Glog<CR>
							\:copen 20<CR>

" STATUS_LINE
	set statusline =
	set statusline+=\[%n]                                  "buffernr
	set statusline+=\ %<%F\ %m%r%w                         "File+path
	set statusline+=\ %y\                                  "FileType
	set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
	set statusline+=\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
	set statusline+=\ %{&ff}\                              "FileFormat (dos/unix..) 
	set statusline+=\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
	set statusline+=\ col:%03c\                            "Colnr
	set statusline+=\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.
	" if you want to put color to status line needs to be after command
	" colorscheme. Otherwise this commands clears it the color

" PLUGIN_OPTIONS/MAPPINGS 
	"Plugin 'VundleVim/Vundle.vim' 
		noremap <Leader>Pl :PlugList<CR>
		" lists configured plugins
		noremap <Leader>Pi :PlugInstall<CR>
		noremap <Leader>Pu :PlugUpdate<CR>
							\:PlugUpgrade<CR>
		" installs plugins; append `!` to update or just :PluginUpdate
		noremap <Leader>Ps :PlugSearch<CR>
		" searches for foo; append `!` to refresh local cache
		noremap <Leader>Pc :PlugClean<CR>      
		" confirms removal of unused plugins; append `!` to auto-approve removal
		" see :h vundle for more details or wiki for FAQ

	"Plugin 'scrooloose/nerdcommenter'" 
		let NERDUsePlaceHolders=0 " avoid commenter doing weird stuff
		let NERDCommentWholeLinesInVMode=2
		let NERDCreateDefaultMappings=0 " Eliminate default mappings
		let NERDRemoveAltComs=1 " Remove /* comments
		let NERD_c_alt_style=0 " Do not use /* on C nor C++ 
		let NERD_cpp_alt_style=0
		let NERDMenuMode=0 " no menu
		let g:NERDCustomDelimiters = {
			\ 'vim': { 'left': '"', 'right': '' },
			\ 'vimwiki': { 'left': '%%', 'right': '' }}
			"\ 'vim': { 'left': '"', 'right': '' }
			"\ 'grondle': { 'left': '{{', 'right': '}}' }
		"\ }
		let NERDSpaceDelims=1  " space around comments

		nmap - <plug>NERDCommenterToggle
		nmap <Leader>ct <plug>NERDCommenterAltDelims
		vmap - <plug>NERDCommenterToggle
		imap <C-c> <plug>NERDCommenterInsert
		nmap <Leader>ca <plug>NERDCommenterAppend
		nmap <Leader>cw <plug>NERDCommenterToEOL
		vmap <Leader>cs <plug>NERDCommenterSexy
		
	"Plugin 'scrooloose/NERDTree' 
		noremap <Leader>nb :Bookmark 
		let NERDTreeShowBookmarks=1  " B key to toggle
		noremap <Leader>no :NERDTree<CR>
		" enable line numbers
		let NERDTreeShowLineNumbers=1
		" make sure relative line numbers are used
		let NERDTreeShowHidden=1 " i key to toggle
		let NERDTreeMapJumpLastChild=',j' 
		let NERDTreeMapJumpFirstChild=',k' 
		let NERDTreeMapOpenExpl=',e' 
		let NERDTreeMapOpenVSplit=',s'
		let NERDTreeQuitOnOpen=1 " AutoClose after openning file

	" Plugin 'lervag/vimtex' " Latex support 
		let g:vimtex_view_enabled = 0
		" latexmk
		let g:vimtex_latexmk_continuous=1
		let g:vimtex_latexmk_callback=1
		" AutoComplete 
		let g:vimtex_complete_close_braces=1
		let g:vimtex_complete_recursive_bib=1
		let g:vimtex_complete_img_use_tail=1
		" ToC
		let g:vimtex_toc_enabled=1
		let g:vimtex_index_show_help=1

	" Plugin 'Tagbar' {{{
        let g:tagbar_autofocus = 1
        let g:tagbar_show_linenumbers = 2
        let g:tagbar_map_togglesort = "r"
		noremap <Leader>tt :TagbarToggle<CR>
		noremap <Leader>tk :cs kill -1<CR>
		noremap <silent> <Leader>tj <C-]>
		noremap <Leader>tr <C-t>
		noremap <Leader>tn :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
		" ReLoad cscope database
		noremap <Leader>tl :cs add cscope.out<CR>
		" Find functions calling this function
		noremap <Leader>tc :cs find c <C-R>=expand("<cword>")<CR><CR>
		" Find functions definition
		noremap <Leader>tg :cs find g <C-R>=expand("<cword>")<CR><CR>
		" Find functions called by this function not being used
		" noremap <Leader>td :cs find d <C-R>=expand("<cword>")<CR><CR>
		noremap <Leader>ts :cs show<CR>

	" Plugin 'ctrlpvim/ctrlp.vim' " quick file searchh 
		nnoremap <Leader>aO :CtrlP<CR>
		nnoremap <S-k> :CtrlPBuffer<CR>
		nnoremap <C-v> :vs<CR>:CtrlPBuffer<CR>
		nnoremap <Leader>ao :CtrlPMixed<CR>
		nnoremap <Leader>at :tabnew<CR>:CtrlPMRU<CR>
		nnoremap <Leader>av :vs<CR>:CtrlPMRU<CR>
		nnoremap <Leader>as :sp<CR>:CtrlPMRU<CR>
		nnoremap <Leader>al :CtrlPClearCache<CR>
		let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
		let g:ctrlp_cache_dir = s:personal_path . 'ctrlp'
		let g:ctrlp_working_path_mode = 'c'
		let g:ctrlp_max_history = &history
		let g:ctrlp_clear_cache_on_exit = 0

	" Doxygen.vim 
		let g:DoxygenToolkit_briefTag_pre="@Description:  " 
		let g:DoxygenToolkit_paramTag_pre="@Var: " 
		let g:DoxygenToolkit_returnTag="@Returns:   " 
		let g:DoxygenToolkit_blockHeader="//////////////////////////////////////////////////////////////////////////" 
		let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------" 
		let g:DoxygenToolkit_authorName="Reinaldo Molina" 
		let g:DoxygenToolkit_licenseTag=""

	" Plugin 'scrooloose/syntastic' 
		nnoremap <Leader>ss :SyntasticCheck<CR>
		set statusline+=%#warningmsg#
		set statusline+=%{SyntasticStatuslineFlag()}
		set statusline+=%*
		let g:syntastic_always_populate_loc_list = 1
		let g:syntastic_auto_loc_list = 1
		let g:syntastic_check_on_open = 0
		let g:syntastic_check_on_wq = 0
		let g:syntastic_cpp_compiler_options = '-std=c++17 -pedantic -Wall'
		let g:syntastic_c_compiler_options = '-std=c11 -pedantic -Wall'
		
	"/Plug 'octol/vim-cpp-enhanced-highlight' 
		let g:cpp_class_scope_highlight = 1	
		" turning this option breaks comments
		"let g:cpp_experimental_template_highlight = 1	
		
	" Plugin 'morhetz/gruvbox' " colorscheme gruvbox  
		colorscheme gruvbox
		set background=dark    " Setting dark mode
		"set background=light
		"colorscheme PaperColor

	" Plug Neocomplete
		if !has('nvim')
			if has('lua')
				" All new stuff 
				" Vim-clang
				let g:clang_c_completeopt = 'menuone,preview,noinsert,noselect'
				let g:clang_cpp_completeopt = 'menuone,preview,noinsert,noselect'

				let g:neocomplete#enable_cursor_hold_i=1
				let g:neocomplete#skip_auto_completion_time="1"
				let g:neocomplete#sources#buffer#cache_limit_size=5000000000
				let g:neocomplete#max_list=8
				let g:neocomplete#auto_completion_start_length=2
				" TODO: need to fix this i dont like the way he does it need my own for now is good I guess
				let g:neocomplete#enable_auto_close_preview=1

				let g:neocomplete#enable_at_startup = 1
				let g:neocomplete#enable_smart_case = 1
				let g:neocomplete#data_directory = s:personal_path . 'neocomplete'
				" Define keyword.
				if !exists('g:neocomplete#keyword_patterns')
					let g:neocomplete#keyword_patterns = {}
				endif
				let g:neocomplete#keyword_patterns['default'] = '\h\w*'
				" Recommended key-mappings.
				" <CR>: close popup and save indent.
				inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
				function! s:my_cr_function()
					return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
				endfunction
				" <TAB>: completion.
				inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
				" <C-h>, <BS>: close popup and delete backword char.
				inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
				" Enable heavy omni completion.
				if !exists('g:neocomplete#sources#omni#input_patterns')
					let g:neocomplete#sources#omni#input_patterns = {}
				endif
				let g:neocomplete#sources#omni#input_patterns.tex =
					\ '\v\\%('
					\ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
					\ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
					\ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
					\ . '|%(include%(only)?|input)\s*\{[^}]*'
					\ . ')'
				let g:neocomplete#sources#omni#input_patterns.php =
				\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
				let g:neocomplete#sources#omni#input_patterns.perl =
				\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

				if !exists('g:neocomplete#force_omni_input_patterns')
					let g:neocomplete#force_omni_input_patterns = {}
				endif
				let g:neocomplete#force_omni_input_patterns.c =
							\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
				let g:neocomplete#force_omni_input_patterns.cpp =
							\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
				let g:neocomplete#force_omni_input_patterns.objc =
							\ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
				let g:neocomplete#force_omni_input_patterns.objcpp =
							\ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

				" all new stuff
				if !exists('g:neocomplete#delimiter_patterns')
					let g:neocomplete#delimiter_patterns= {}
				endif
				let g:neocomplete#delimiter_patterns.vim = ['#']
				let g:neocomplete#delimiter_patterns.cpp = ['::']

				let g:clang_auto = 0
			else
				let g:clang_auto = 1
			endif
		elseif has('python3')
			" if it is nvim deoplete requires python3 to work
			let g:clang_auto = 0
			let g:deoplete#enable_at_startup = 1
		else
			" so if it doesnt have it activate clang instaed
			let g:deoplete#enable_at_startup = 0
			let g:clang_auto = 1
		endif

			" NeoSnippets
		" Plugin key-mappings.
		imap <C-k>     <Plug>(neosnippet_expand_or_jump)
		smap <C-k>     <Plug>(neosnippet_expand_or_jump)
		xmap <C-k>     <Plug>(neosnippet_expand_target)
		smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
		\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
		" Tell Neosnippet about the other snippets
		let g:neosnippet#snippets_directory= s:plugged_path . '/vim-snippets/snippets'
		let g:neosnippet#data_directory = s:personal_path . 'neosnippets'
	
	" Plug Vim-R-plugin {{{
		let vimrplugin_r_path = 'C:\\Program Files\\R\\R-3.2.3\\bin\\i386'

	" Vim-Clang " syntastic is much better that is why is not 
		" clan clang_auto option which enables autocomplete after . -> and ::
		" is being handled along with neocompl and deocompl options to be
		" activated in case non of those 2 are present
		let g:clang_diagsopt = '' " no syntax check 
