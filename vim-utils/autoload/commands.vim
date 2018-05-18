" File:					commands.vim
" Description:	Universal commands
" Author:				Reinaldo Molina <rmolin88@gmail.com>
" Version:				0.0.0
" Last Modified: Oct 18 2017 13:52
" Created: Oct 18 2017 13:52

" CUSTOM_COMMANDS
function! commands#Set() abort
	command! UtilsIndentWholeFile execute("normal! mzgg=G`z")
	command! UtilsFileFormat2Dos :e ++ff=dos<cr>
	command! UtilsFileFormat2Unix call s:convert_line_ending_to_unix()
	command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis

	if has('unix')
		" This mapping will load the journal from the most recent boot and highlight it for you
		command! UtilsLinuxReadJournal execute("read !journalctl -b<CR><bar>:setf messages<CR>")
		" Give execute permissions to current file
		command! UtilsLinuxExecReadPermissions execute("!chmod a+x %")
		" Save file with sudo permissions
		command! UtilsLinuxSudoPermissions execute("w !sudo tee % > /dev/null")
		command! UtilsLinuxExecuteCurrFile execute("silent !./%")
	endif

	if !exists('g:loaded_plugins')
		return
	endif

	" Convention: All commands names need to start with the autoload file name.
	" And use camel case. This way is easier to search
	command! -nargs=+ -complete=command UtilsCaptureCmdOutput call s:capture_cmd_out(<f-args>)
	command! UtilsProfile call s:profile_performance()
	command! UtilsDiffSet call s:set_diff()
	command! UtilsDiffOff call s:unset_diff()
	command! UtilsDiffReset call s:unset_diff()<bar>call s:set_diff()
	" Convert fileformat to dos
	command! UtilsNerdComAltDelims execute("normal \<Plug>NERDCommenterAltDelims")
	command! UtilsPdfSearch call s:search_pdf()
	command! UtilsTagLoadCurrFolder call ctags#LoadCscopeDatabse()
	command! UtilsTagUpdateCurrFolder call ctags#NvimSyncCtags()

	" These used to be ]F [F mappings but they are not so popular so moving them to
	" commands
	command! UtilsFontZoomIn call s:adjust_gui_font('+')
	command! UtilsFontZoomOut call s:adjust_gui_font('-')
endfunction

function! s:capture_cmd_out(...) abort
	" this function output the result of the Ex command into a split scratch buffer
	if a:0 == 0
		return
	endif
	let cmd = join(a:000, ' ')
	if cmd[0] == '!'
		vnew
		setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
		execute "read " . cmd
		return
	endif
	redir => output
	execute cmd
	redir END
	if empty(output)
		echoerr "No output from: " . cmd
	else
		vnew
		setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
		put! =output
	endif
endfunction

function! s:profile_performance() abort
	if exists('g:std_cache_path')
		execute 'profile start ' . g:std_cache_path . '/profile_' . strftime("%m%d%y-%H.%M.%S") . '.log'
	else
		" TODO.RM-Mon Apr 24 2017 12:17: Check why this function is not working
		" execute 'profile start ~/.cache/profile_' . strftime("%m%d%y-%T") . '.log'
		execute 'profile start ~/.cache/profile_' . strftime("%m%d%y-%H.%M.%S") . '.log'
	endif
	execute 'profile func *'
	execute 'profile file *'
endfunction

function! s:set_diff() abort
	" Make sure you run diffget and diffput from left window
	if !executable('diff')
		echoerr 'diff is not executable. Please install it'
		return
	endif

	try
		windo diffthis
	catch
		echoerr 'diff command failed. Make sure it is installed correctly'
		echoerr v:exception
		diffoff!
		return
	endtry
	nnoremap <C-j> ]c
	nnoremap <C-k> [c
	nnoremap <C-h> :diffget<CR>
	nnoremap <C-l> :diffput<CR>
endfunction

function! s:unset_diff() abort
	nnoremap <C-j> zj
	nnoremap <C-k> zk
	nnoremap <C-h> :noh<CR>
	nunmap <C-l>
	diffoff!
endfunction

function! s:search_pdf() abort
	if !executable('pdfgrep')
		echoe 'Please install "pdfgrep"'
		return
	endif

	if exists(':Grepper')
		execute ':Grepper -tool pdfgrep'
		return
	endif

	let grep_buf = &grepprg

	setlocal grepprg=pdfgrep\ --ignore-case\ --page-number\ --recursive\ --context\ 1
	return utils#FileTypeSearch(8, 8)

	let &l:grepprg = grep_buf
endfunction

function! s:adjust_gui_font(sOp) abort
	if has('nvim') && exists('g:GuiLoaded') && exists('g:GuiFont')
		" Substitute last number with a plus or minus value depending on input
		let new_cmd = substitute(g:GuiFont, ':h\zs\d\+','\=eval(submatch(0)'.a:sOp.'1)','')
		echomsg new_cmd
		call GuiFont(new_cmd, 1)
	else " gvim
		let sub = has('win32') ? ':h\zs\d\+' : '\ \zs\d\+'
		let &guifont = substitute(&guifont, sub,'\=eval(submatch(0)'.a:sOp.'1)','')
	endif
endfunction

function! s:convert_line_ending_to_unix() abort
	edit ++ff=dos
	setlocal fileformat=unix
	write
endfunction
