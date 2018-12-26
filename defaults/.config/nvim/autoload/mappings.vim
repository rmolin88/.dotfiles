" File:					mappings.vim
" Description:	Function that sets all the mappings that are not related to plugins
" Author:				Reinaldo Molina <rmolin88@gmail.com>
" Version:				0.0.0
" Last Modified: Aug 22 2017 12:33
" Created: Aug 22 2017 12:33

function! mappings#Set()
	" CUSTOM MAPPINGS
	if has('unix')
		" System paste
		nnoremap <Leader>p "+p=`]<C-o>
		vnoremap <Leader>p "+p=`]<C-o>

		nnoremap <Leader>y "+yy
		vnoremap <Leader>y "+y

		nnoremap 
	else
		" Copy and paste into system wide clipboard
		nnoremap <Leader>p "*p=`]<C-o>
		vnoremap <Leader>p "*p=`]<C-o>

		nnoremap <Leader>y "*yy
		vnoremap <Leader>y "*y

		nnoremap <CR> o<ESC>

		" On MS-Windows, this is mapped to cut Visual text
		" |dos-standard-mappings|.
		silent! vunmap <C-X>
	endif

	" Sun Dec 09 2018 17:15: 
	" This extends p in visual mode (note the noremap), so that if you paste from the
	" unnamed (ie. default) register, that register content is not replaced by the visual
	" selection you just pasted over–which is the default behavior. This enables the user to
	" yank some text and paste it over several places in a row, without using a named
	" Obtained from: https://vimways.org/2018/for-mappings-and-a-tutorial/
	xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>

	if exists('g:exists_vim_which_key')
		call s:set_which_key_map()
	endif
	" List of super useful mappings
	" = fixes indentantion
	" gq formats code
	" Free keys: <Leader>fnzxkiy;h
	" Taken keys: <Leader>qwertasdjcvgp<space>mbolu
	let g:esc = '<C-j>'

	" FileType Specific mappings use <Leader>l
	" Refer to ~/.dotfiles/vim-utils/after/ftplugin to find these

	" j and k
	" Display line movements unless preceded by a count and
	" Save movements larger than 5 lines to the jumplist. Use Ctrl-o/Ctrl-i.
	nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
	nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

	" Miscelaneous Mappings <Leader>j?
	" nnoremap <Leader>Ma :Man
	" Most used misc get jk, jj, jl, j;
	" TODO.RM-Fri Apr 28 2017 14:25: Go through mappings and figure out the
	" language specific ones so that you can move them into ftplugin
	" nnoremap <Leader>jk :call utils#Make()<cr>
	" ga " prints ascii of char under cursor
	" gA " prints radix of number under cursor
	" Untouchable g mappings:
	" - gd, gD, g;, gq, gs, gl, gA, gT, gg, G, gG, gh, gv, gn, gm, gx, gt, gr
	" Toggle mappings:
	" - tj, te, ta, tt, tf, ts, to, tn
	nmap <Leader>f <Plug>file_browser
	nmap <leader>tf <plug>focus_toggle

	nmap <s-k> <plug>buffer_browser
	nmap <c-p> <plug>mru_browser
	" terminal-emulator mappings
	if has('terminal') || has('nvim')
		nmap <Leader>te <Plug>terminal_toggle
		" See plugin.vim - neoterm
		nmap <leader>x <plug>terminal_send
		xmap <leader>x <plug>terminal_send
		nmap <leader>X <plug>terminal_send_line

		execute "tnoremap " . g:esc . " <C-\\><C-n>"
		tnoremap <A-h> <C-\><C-n><C-w>h
		tnoremap <A-j> <C-\><C-n><C-w>j
		tnoremap <A-k> <C-\><C-n><C-w>k
		tnoremap <A-l> <C-\><C-n><C-w>l

		tnoremap <a-]> <C-\><C-n>gt
		tnoremap <a-[> <C-\><C-n>gT
		for l:idx in [1,2,3,4,5,6,7,8,9]
			execute 'tnoremap <silent> <a-' . l:idx .
						\ '> <C-\><C-n>' . l:idx. 'gt'
		endfor

		" Sun Dec 23 2018 11:34 
		" Can confuse things since I set it up in inputrc as well
		" tnoremap <C-p> <Up>
	endif

	nnoremap <localleader>k <plug>make_project
	nmap <localleader>j <plug>make_file
	nmap <localleader>c <plug>make_check

	" Doesnt make sense in all file types
	" nmap <localleader>p <plug>preview
	" nmap <localleader>a <plug>switch_header_source
	" nmap <localleader>ii <plug>imports_insert
	" nmap <localleader>is <plug>imports_sort

	nmap <localleader>f <plug>format_code
	xmap <localleader>f <plug>format_code

	nmap <a-;> <plug>fuzzy_command_history
	nmap <a-e> <plug>fuzzy_vim_help

	" Refactor word under the cursor
	nmap <localleader>r <plug>refactor_code
	xmap <localleader>r <plug>refactor_code

	nnoremap <plug>refactor_code :%s/\<<c-r>=expand("<cword>")<cr>\>//gc<Left><Left><Left>
	xnoremap <plug>refactor_code "hy:%s/<C-r>h//gc<left><left><left>

	" Global settings for all ftplugins
	imap <c-k> <plug>snip_expand
	smap <c-k> <plug>snip_expand
	xmap <c-k> <plug>snip_expand

	nmap <leader>s <plug>search_grep
	xmap <leader>s <plug>search_grep

	nnoremap <silent> <plug>search_grep :Grip<cr>
	" xnoremap <silent> <plug>search_grep :call <SID>grep()<cr>

	nmap <leader>W <plug>get_passwd
	nnoremap <plug>get_passwd :silent call passwd#SelectPasswdFile()<cr>

	" TODO-[RM]-(Thu Nov 15 2018 16:58): These two could be combined 
	" nmap <localleader>h <plug>help_under_cursor
	nmap <leader>G <plug>search_internet
	xmap <leader>G <plug>search_internet

	nmap <leader>T <plug>generate_tags
	nnoremap <silent> <plug>generate_tags :call ctags#NvimSyncCtags()<cr>

	nnoremap <Leader>tt :TagbarToggle<cr>
	nnoremap <Leader>ts :setlocal spell!<cr>
	" duplicate current char
	nnoremap <Leader>d ylp
	" Reload syntax
	nnoremap <Leader>js <Esc>:syntax sync fromstart<cr>
	" Sessions
	nnoremap <Leader>jes :call mappings#SaveSession()<cr>
	nnoremap <Leader>jel :call <SID>load_session()<cr>
	nnoremap <Leader>jee :call <SID>load_session('default.vim')<cr>
	" Count occurrances of last search
	nnoremap <Leader>jc :%s///gn<cr>
	" Indenting
	nnoremap <Leader>j2 :setlocal ts=2 sw=2 sts=2<cr>
	nnoremap <Leader>j4 :setlocal ts=4 sw=4 sts=4<cr>
	nnoremap <Leader>j8 :setlocal ts=8 sw=8 sts=8<cr>
	" not paste the deleted word
	nnoremap P "0p
	vnoremap P "0p
	" Force wings_syntax on a file
	nnoremap <Leader>jw :set filetype=wings_syntax<cr>
	nnoremap <Leader>j. :call <SID>exec_last_command()<cr>
	" j mappings taken <swypl;bqruihHdma248eEonf>
	" nnoremap <Leader>Mc :call utils#ManFind()<cr>
	" Tue Dec 19 2017 14:34:
	"	- Removing the save all files. Not a good thing to do.
	"		- Main reason is specially with Neomake running make an multiple files at the same
	"   time
	" Wed Dec 12 2018 17:23:
	"	- Reenabling, because why not!
	"		- Tired of typing :wa<cr>
	nnoremap <c-s> :wall<cr>
	nnoremap <c-t> :tabnew<cr>
	" Thu Feb 22 2018 07:42: Mind buggling super good mapping from vim-galore
	" Tue Apr 24 2018 14:06: For some reason in large .cpp files syntax sync takes away
	" highlight
	" nnoremap <c-h> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
	nnoremap <c-h> :nohlsearch<cr>:diffupdate<cr><c-l>
	nnoremap <C-Space> i<Space><Esc>
	" These are only for command line
	" insert in the middle of whole word search
	cnoremap <C-w> \<\><Left><Left>
	" insert visual selection search
	cnoremap <C-u> <c-r>=expand("<cword>")<cr>
	cnoremap <C-s> %s/
	cnoremap <C-j> <cr>
	cnoremap <C-p> <Up>
	cnoremap <C-A> <Home>
	cnoremap <C-F> <Right>
	cnoremap <C-B> <Left>
	" Sun Sep 17 2017 14:21: this will not work in vim
	cnoremap <A-b> <S-Left>
	cnoremap <A-f> <S-Right>

	cnoremap <silent> <expr> <cr> <SID>center_search()
	" move to the beggning of line
	" Don't make this nnoremap. Breaks stuff
	nnoremap <S-w> $
	vnoremap <S-w> $
	" move to the end of line
	nnoremap <S-b> ^
	vnoremap <S-b> ^
	" jump to corresponding item<Leader> ending {,(, etc..
	nmap <S-t> %
	vmap <S-t> %
	" Automatically insert date
	nnoremap <F5> i<Space><ESC>"=strftime("%a %b %d %Y %H:%M")<cr>P
	" Designed this way to be used with snippet md header
	vnoremap <F5> s<Space><ESC>"=strftime("%a %b %d %Y %H:%M")<cr>Pa
	inoremap <F5> <Space><ESC>"=strftime("%a %b %d %Y %H:%M")<cr>Pa
	" Auto indent pasted text
	nnoremap p p=`]<C-o>
	nnoremap Y y$

	" Vim-unimpaired similar mappings
	" Do not overwrite [s, [c, [f
	" Overwitting [c to make it more useful
	nnoremap ]c ]czz
	nnoremap [c [czz

	nnoremap <silent> ]y :call <SID>yank_from('+')<cr>
	nnoremap <silent> [y :call <SID>yank_from('-')<cr>

	nnoremap <silent> ]d :call <SID>delete_line('+')<cr>
	nnoremap <silent> [d :call <SID>delete_line('-')<cr>

	nnoremap <silent> ]o :call <SID>comment_line('+')<cr>
	nnoremap <silent> [o :call <SID>comment_line('-')<cr>

	nnoremap <silent> ]m :m +1<cr>
	nnoremap <silent> [m :m -2<cr>

	" Quickfix and Location stuff
	nnoremap <silent> <s-q> :call quickfix#ToggleList("Quickfix List", 'c')<cr>
	nnoremap ]q :cnext<cr>
	nnoremap [q :cprevious<cr>

	nnoremap <silent> <s-u> :call quickfix#ToggleList("Location List", 'l')<cr>
	nnoremap ]l :lnext<cr>
	nnoremap [l :lprevious<cr>

	nnoremap ]t :exec 'tjump ' . expand('<cword>')<cr>
	nnoremap [t <c-t>
	" Split window and jump to tag
	" nnoremap ]T :exec 'ptag ' . expand('<cword>')<cr><c-w>R
	nnoremap ]T :call <SID>goto_tag_on_next_win('l')<cr>
	nnoremap [T :call <SID>goto_tag_on_next_win('h')<cr>

	" Capital F because [f is go to file and this is rarely used
	" ]f native go into file.
	" [f return from file
	nnoremap [f <c-o>
	nnoremap <silent> ]F :call <SID>goto_file_on_next_win('l')<cr>
	nnoremap <silent> [F :call <SID>goto_file_on_next_win('h')<cr>

	" Scroll to the sides z{l,h} and up and down
	nnoremap ]z 10zl
	nnoremap ]Z 10<c-e>
	nnoremap [z 10zh
	nnoremap [Z 10<c-y>

	" TODO-[RM]-(Fri Jun 29 2018 10:10): Make this work
	" xnoremap <silent> ]F :call <SID>goto_file_on_next_win('l')<cr>
	" xnoremap <silent> [F :call <SID>goto_file_on_next_win('h')<cr>
	nnoremap <a-]> gt
	nnoremap <a-[> gT
	for l:idx in [1,2,3,4,5,6,7,8,9]
		execute 'nnoremap <silent> <a-' . l:idx . '> :call <SID>switch_or_set_tab(' . l:idx. ')<cr>'
	endfor

	" Create an undo break point. Mark current possition. Go to word. Fix and come back.
	nnoremap ]S :normal! i<c-g>u<esc>mm]s1z=`m<cr>
	nnoremap [S :normal! i<c-g>u<esc>mm[s1z=`m<cr>

	" decrease number
	nnoremap <S-x> <c-x>
	vnoremap <S-x> <c-x>

	nnoremap <S-CR> O<Esc>

	" <Leader>n
	" Display highlighted numbers as ascii chars. Only works on highlighted text
	" Rarely works
	" vnoremap <Leader>ah :<c-u>s/<count>\x\x/\=nr2char(printf("%d", "0x".submatch(0)))/g<cr><c-l>`<
	vnoremap <Leader>nh :<c-u>s/\%V./\=printf("%x",char2nr(submatch(0)))/g<cr><c-l>`<
	nmap <leader>nr <plug>num_representation
	xmap <leader>nr <plug>num_representation


	nnoremap <expr> n 'Nn'[v:searchforward]
	nnoremap <expr> N 'nN'[v:searchforward]

	" Search forward/backwards but return
	nnoremap * *zz
	nnoremap # #zz

	" Insert Mode (Individual) mappings
	inoremap <c-f> <Right>
	inoremap <c-b> <Left>
	" Sun Sep 17 2017 14:21: this will not work in vim
	inoremap <a-b> <S-Left>
	inoremap <a-f> <S-Right>
	" inoremap <c-u> delete from beginning of line until cursor
	" inoremap <a-d> delete from cursor untils end of line
	" inoremap <c-t> shift entire line a shiftwidth
	inoremap <c-d> <c-g>u<del>
	inoremap <a-t> <c-d>
	" Mon Nov 19 2018 13:33: Sometimes needed. This rarely used 
	" inoremap <c-v> <c-o>:normal! "+p<cr>
	" inoremap <c-w> delete word up to the cursor
	" inoremap <c-k> used by neosnippet to expand snippet
	" inoremap <c-l> used by software caps to toggle caps
	" Sun Jun 10 2018 13:41: Get rid of annoying <c-space> 
	inoremap <c-space> <space>

	" Fri Sep 29 2017 14:20: Break up long text into smaller, better undo
	" chunks. See :undojoin
	" For normal text typing
	inoremap . .<c-g>u
	inoremap , ,<c-g>u
	inoremap ? ?<c-g>u
	inoremap ! !<c-g>u
	inoremap <C-H> <C-G>u<C-H>
	inoremap <CR> <C-]><C-G>u<CR>
	" For cpp
	inoremap ; ;<c-g>u
	inoremap = =<c-g>u

	" CD <Leader>c?
	nmap <Leader>cr <plug>cd_root

	nnoremap <Leader>cd :lcd %:h<cr>
				\:pwd<cr>
	nnoremap <Leader>cu :lcd ..<cr>
				\:pwd<cr>
	" cd into dir. press <Tab> after ci to see folders
	nnoremap <Leader>cc :pwd<cr>
	" TODO.RM-Thu Jun 01 2017 10:10: Create mappings like c21 and c22

	" Folding
	" Folding select text then S-f to fold or just S-f to toggle folding
	nnoremap <C-j> zj
	nnoremap <C-k> zk
	nnoremap <C-z> zzze
	nnoremap <C-c> zM
	nnoremap <C-n> zR
	nnoremap <C-x> za
	" dont use <C-a> it conflicts with tmux prefix

	" Window movement
	" move between windows
	if exists('*Focus') && executable('i3-vim-nav')
		" i3 integration
		nnoremap <A-l> :call Focus('right', 'l')<cr>
		nnoremap <A-h> :call Focus('left', 'h')<cr>
		nnoremap <A-k> :call Focus('up', 'k')<cr>
		nnoremap <A-j> :call Focus('down', 'j')<cr>
	elseif has('unix') && executable('tmux') && exists('$TMUX')
		nnoremap <A-h> :call <SID>tmux_move('h')<cr>
		nnoremap <A-j> :call <SID>tmux_move('j')<cr>
		nnoremap <A-k> :call <SID>tmux_move('k')<cr>
		nnoremap <A-l> :call <SID>tmux_move('l')<cr>
	else
		nnoremap <silent> <A-l> <C-w>l
		nnoremap <silent> <A-h> <C-w>h
		nnoremap <silent> <A-k> <C-w>k
		nnoremap <silent> <A-j> <C-w>j
		nnoremap <silent> <A-S-l> <C-w>>
		nnoremap <silent> <A-S-h> <C-w><
		nnoremap <silent> <A-S-k> <C-w>+
		nnoremap <silent> <A-S-j> <C-w>-
	endif

	inoremap <C-S> <c-r>=<SID>fix_previous_word()<cr>

	" Search <Leader>S
	" Tried ack.vim. Discovered that nothing is better than grep with ag.
	" search all type of files
	" Search visual selection text
	vnoremap // y/<C-R>"<cr>

	" Substitute for ESC
	execute "vnoremap " . g:esc . " <Esc>"
	execute "inoremap " . g:esc . " <Esc>"

	" Buffers Stuff <Leader>b?
	if !exists("g:loaded_plugins")
		nnoremap <S-k> :buffers<cr>:buffer<Space>
	else
		nnoremap <Leader>bs :buffers<cr>:buffer<Space>
	endif
	nnoremap <Leader>bd :bp\|bw #\|bd #<cr>
	nnoremap <S-j> :b#<cr>
	" deletes all buffers
	nnoremap <Leader>bl :%bd<cr>

	nmap <Leader>bt <Plug>BookmarkToggle
	nmap <Leader>bi <Plug>BookmarkAnnotate
	nmap <Leader>ba <Plug>BookmarkShowAll
	nmap <Leader>bn <Plug>BookmarkNext
	nmap <Leader>bp <Plug>BookmarkPrev
	nmap <Leader>bc <Plug>BookmarkClear
	nmap <Leader>bx <Plug>BookmarkClearAll
	nmap <Leader>bk <Plug>BookmarkMoveUp
	nmap <Leader>bj <Plug>BookmarkMoveDown
	nmap <Leader>bo <Plug>BookmarkLoad
	nmap <Leader>bs <Plug>BookmarkSave

	" Version Control <Leader>v?
	" For all this commands you should be in the svn root folder
	" Add all files
	nnoremap <silent> <leader>vs :call <SID>version_control_command('status')<CR>
	nnoremap <silent> <leader>vl :call <SID>version_control_command('log')<CR>
	nnoremap <silent> <leader>vc :call <SID>version_control_command('commit')<CR>
	nnoremap <silent> <leader>vp :call <SID>version_control_command('push')<CR>
	nnoremap <silent> <leader>vu :call <SID>version_control_command('pull')<CR>

	" nnoremap <Leader>vA :!svn add . --force<cr>
	" Add specific files
	" nnoremap <Leader>va :!svn add --force
	" Commit using typed message
	" nnoremap <Leader>vc :call <SID>svn_commit()<cr>
	" Commit using File for commit content
	" nnoremap <Leader>vC :!svn commit --force-log -F %<cr>
	" nnoremap <Leader>vd :!svn rm --force
	" revert previous commit
	"nnoremap <Leader>vr :!svn revert -R .<cr>
	" nnoremap <Leader>vl :!svn cleanup .<cr>
	" use this command line to delete unrevisioned or "?" svn files
	" nnoremap <Leader>vL :!for /f "tokens=2*" %i in ('svn status ^| find "?"') do del %i<cr>
	" nnoremap <Leader>vs :!svn status .<cr>
	" nnoremap <Leader>vu :!svn update .<cr>
	" Overwritten from plugin.vim
	" nnoremap <Leader>vo :!svn log .<cr>
	" nnoremap <Leader>vi :!svn info<cr>

	" Wiki mappings <Leader>w?
	" TODO.RM-Thu Dec 15 2016 16:00: Add support for wiki under SW-Testbed
	nnoremap <Leader>wo :call <SID>wiki_open()<cr>
	nnoremap <Leader>wa :call <SID>wiki_add()<cr>
	nnoremap <Leader>ws :call utils#WikiSearch()<cr>

	" Comments <Leader>o
	nmap - <plug>NERDCommenterToggle
	" nmap <Leader>ot <plug>NERDCommenterAltDelims
	vmap - <plug>NERDCommenterToggle
	imap <C-c> <plug>NERDCommenterInsert
	nnoremap <Leader>oI :call utils#CommentReduceIndent()<cr>
	nmap <Leader>to <plug>NERDCommenterAltDelims
	" mapping ol conflicts with mapping o to new line
	nnoremap <Leader>oe :call utils#EndOfIfComment()<cr>
	nnoremap <Leader>ou :call utils#UpdateHeader()<cr>
	nnoremap <Leader>ot :call utils#TodoAdd()<cr>
	nmap <Leader>oa <Plug>NERDCommenterAppend
	nnoremap <Leader>od :call utils#CommentDelete()<cr>
	" Comment Indent Increase/Reduce
	nnoremap <Leader>oi :call utils#CommentIndent()<cr>

	" Edit file at location <Leader>e?
	nnoremap <Leader>ed :call utils#DeniteRec(g:std_config_path . '/dotfiles')<cr>
	nnoremap <Leader>ec :call utils#DeniteRec(getcwd())<cr>
	nnoremap <Leader>el :call utils#DeniteRec(input('Folder to recurse: ', "", "file"))<cr>

	nmap <leader>et <plug>edit_todo
	if !hasmapto('<plug>edit_todo')
		nnoremap <silent> <plug>edit_todo :execute('edit ' . g:std_config_path . '/dotfiles/TODO.md')<cr>
	endif

	" Edit plugin
	nnoremap <Leader>ep :call utils#DeniteRec(g:vim_plugins_path)<cr>
	nnoremap <Leader>ei :e
	" Edit Vimruntime
	nnoremap <Leader>ev :call utils#DeniteRec(fnameescape($VIMRUNTIME))<cr>
endfunction

function! mappings#SaveSession(...) abort
	let session_path = g:std_data_path . '/sessions/'
	" if session name is not provided as function argument ask for it
	if a:0 < 1
		silent execute "wall"
		let dir = getcwd()
		silent execute "lcd ". session_path
		let session_name = input("Enter save session name:", "", "file")
		if match(session_name, '.vim', -4) < 0
			" Append extention if was not provided
			let session_name .= '.vim'
		endif
		silent! execute "lcd " . dir
		" Ensure session_name ends in .vim
	else
		" Get current folder as a name
		let session_name = utils#GetFullPathAsName(getcwd()) . '.vim'
		" Save a session with the name of the current folder
		silent! execute "mksession! " . session_path . session_name
		" Then save another session with the name default name
		let session_name = a:1
	endif
	silent! execute "mksession! " . session_path . session_name
endfunction

function! s:load_session(...) abort
	let session_path = g:std_data_path . '/sessions/'
	" Logic path when not called at startup
	if a:0 >= 1
		let session_name = session_path . a:1
		if !filereadable(session_name)
			echoerr '[s:load_session]: File ' . session_name . ' not readabale'
			return
		endif
		silent! execute "normal :%bdelete\<CR>"
		silent! execute "normal :so " . session_path . a:1 . "\<CR>"
		return
	endif

	execute "wall"
	if exists(':Denite')
		let session_name = utils#DeniteYank(session_path)
		if !filereadable(session_path . session_name)
			return
		endif
	else
		let dir = getcwd()
		execute "lcd ". session_path
		let session_name = input("Load session:", "", "file")
		silent! execute "lcd " . dir
	endif
	silent execute "source " . session_path . session_name
endfunction

" Tue May 15 2018 09:07: Forced to make it global. <expr> would not work with s: function
function! s:center_search() abort
	let cmdtype = getcmdtype()
	if cmdtype ==# '/' || cmdtype ==# '?'
		return "\<cr>zz"
	endif
	return "\<cr>"
endfunction

function! s:yank_from(sign) abort
	let in = s:parse_line_mod_input('Yank',  a:sign)
	execute "normal :" . in . "y\<CR>p"
endfunction

" msg - {Comment, Delete, Paste, Yank}
" sign - {+,-}
" Returns: Modified input
function! s:parse_line_mod_input(msg, sign) abort
	let in = a:sign . input(a:msg . " Line:")
	let comma = stridx(in, ',')
	if comma > -1
		return strcharpart(in, 0,comma+1) . a:sign . strcharpart(in, comma+1)
	endif

	return in
endfunction

function! s:delete_line(sign) abort
	let in = s:parse_line_mod_input('Delete',  a:sign)
	execute "normal :" . in . "d\<CR>``"
endfunction

function! s:comment_line(sign) abort
	if !exists("*NERDComment")
		echo "Please install NERDCommenter"
		return
	endif

	let in = s:parse_line_mod_input('Comment',  a:sign)
	execute "normal mm:" . in . "\<CR>"
	execute "normal :call NERDComment(\"n\", \"Toggle\")\<CR>`m"
endfunction

function! s:exec_last_command() abort
	execute "normal :\<Up>\<CR>"
endfunction

function! s:next_match_and_center() abort
	execute 'nN' . v:searchforward
	execute 'normal! zz'
endfunction

" Opens the tag on new split in the direction specified
" direction - {h,l}
function! s:goto_tag_on_next_win(direction) abort
	" echomsg '[goto_tag_on_next_win]: Got called!'
	let target = expand('<cword>')
	let wnr = winnr()
	exec 'wincmd ' . a:direction
	" If the winnr is still the same after we moved, it is the last pane
	if wnr == winnr()
		exec 'stjump ' . target
		exec 'wincmd ' . toupper(a:direction)
		return
	endif
	exec 'tjump ' . target
endfunction

" Opens the file on new split in the direction specified
" direction - {h,l}
" Note: This function depends on the 'splitright' option.
function! s:goto_file_on_next_win(direction) abort
	exec 'vsplit'
	if a:direction ==# 'h'
		exec 'wincmd ' . a:direction
	endif
	let wnr = winnr()
	exec 'wincmd ' . a:direction
	" If the winnr is still the same after we moved, it is the last pane
	if wnr != winnr()
		close
	endif
	exec 'normal! gf'
endfunction

function! s:tmux_move(direction)
	let wnr = winnr()
	silent! execute 'wincmd ' . a:direction
	" If the winnr is still the same after we moved, it is the last pane
	if wnr == winnr()
		call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
	endif
endfunction

function! s:fix_previous_word() abort
	normal mm[s1z=`m
	return ''
endfunction

" Should be performed on root .svn folder
function! s:svn_commit() abort
	execute "!svn commit -m \"" . input("Commit comment:") . "\""
endfunction

function! s:wiki_open(...) abort
	if !exists('g:wiki_path') || empty(glob(g:wiki_path))
		echoerr 'Variable g:wiki_path not set or path doesnt exist'
		return
	endif

	if a:0 > 0
		execute "vs " . g:wiki_path . '/'.  a:1
	else
		if exists(':Denite')
			call utils#DeniteRec(g:wiki_path)
		else
			let dir = getcwd()
			execute "cd " . g:wiki_path
			execute "vs " . fnameescape(g:wiki_path . '/' . input('Wiki Name: ', '', 'custom,CheatCompletion'))
			silent! execute "cd " . dir
		endif
	endif
endfunction

function! s:wiki_add() abort
	if !exists('g:wiki_path') || empty(glob(g:wiki_path))
		echoerr 'Variable g:wiki_path not set or path doesnt exist'
		return
	endif

	return s:add_file(g:wiki_path)
endfunction

" Use current 'grepprg' to search files for text
"		filteype - Possible values: 1 - Search only files of type 'filetype'. Any
"								other value search all types of values
"		word - Possible values: 1 - Search word under the cursor. Otherwise prompt
"		for search word
function! s:filetype_search(filetype, word) abort
	let grep_engine = &grepprg

	if a:word == 1
		let search = expand("<cword>")
	else
		let search = input("Please enter search word:")
	endif

	if grep_engine =~# 'rg'
		let file_type_search = '-t ' . ctags#VimFt2RgFt()
	elseif grep_engine =~# 'ag'
		let file_type_search = '--' . &filetype
	else
		" If it is not a recognized engine do not do file type search
		exe ":grep! " . search
		if &verbose > 0
			echomsg printf("grepprg = %s", grep_engine)
			echomsg printf("filetype search = %d", a:filetype)
			echomsg printf("file_type_search = %s", file_type_search)
			echomsg printf("search word = %s", search)
			echomsg printf("cwd = %s", getcwd())
		endif
		copen 20
		return
	endif

	if a:filetype == 1
		exe ":silent grep! " . file_type_search . ' ' . search
	else
		exe ":silent grep! " . search
	endif

	copen 20
	if &verbose > 0
		echomsg printf("grepprg = %s", grep_engine)
		echomsg printf("filetype search = %d", a:filetype)
		echomsg printf("file_type_search = %s", file_type_search)
		echomsg printf("search word = %s", search)
		echomsg printf("cwd = %s", getcwd())
	endif
endfunction

function! s:grep() abort
	let msg = 'Searching inside "' . getcwd() . '". Choose:'
	let choice = "&J<cword>/". &ft . "\n&K<any>/". &ft . "\n&L<cword>/all_files\n&;<any>/all_files"
	let c = confirm(msg, choice, 1)

	if c == 1
		" Search '&filetype' type of files, and word under the cursor
		call s:filetype_search(1, 1)
	elseif c == 2
		" Search '&filetype' type of files, and prompt for search word
		call s:filetype_search(1, 8)
	elseif c == 3
		" Search all type of files, and word under the cursor
		call s:filetype_search(8, 1)
	else
		" Search all type of files, and prompt for search word
		call s:filetype_search(8, 8)
	endif
endfunction

function! s:switch_or_set_tab(tab_num) abort
	let l:tabs_num = len(gettabinfo())

	if &verbose > 0
		echomsg string(l:tabs_num)
	endif

	if l:tabs_num < a:tab_num
		execute 'tabnew'
		return
	endif

	execute 'normal! ' . a:tab_num . 'gt'
endfunction

function! s:add_file(path) abort
	if empty(a:path) || empty(glob(a:path))
		echoerr 'Input path doesnt exist'
		return
	endif

	let l:cwd = getcwd()
	execute 'lcd ' . a:path
	let l:new_file = input('Please enter name for new wiki:', '', 'file')

	if empty(l:new_file)
		return
	endif

	let l:splitter = has('unix') ? '/' : '\'

	if l:new_file[0] !=# l:splitter
		let l:new_file = l:splitter . l:new_file
	endif

	let l:new_file = a:path . l:new_file
	if &verbose > 0
		echomsg printf('[add_file]: l:new_file = "%s"', l:new_file)
	endif

	" Find passed dir
	let l:last_folder = strridx(l:new_file, l:splitter)
	let l:new_folder = l:new_file[0:l:last_folder-1]
	if &verbose > 0
		echomsg printf('[wiki_add]: l:new_folder = "%s"', l:new_folder)
	endif

	if !isdirectory(l:new_folder)
		if &verbose > 0
			echomsg printf('[wiki_add]: Created new folder = "%s"', l:new_folder)
		endif
		call mkdir(l:new_folder, 'p')
	endif

	execute 'lcd ' . l:cwd
	execute 'edit ' . l:new_file
endfunction

function! s:set_which_key_map() abort
	" Define prefix dictionary
	let g:which_key_leader_map =  {}

	let g:which_key_leader_map.t = {
				\ 'name' : '+toggle',
				\ 'j' : 'file_browser',
				\ 'f' : 'focus_plugin',
				\ 'e' : 'terminal',
				\ 't' : 'tagbar',
				\ 's' : 'spelling',
				\ 'o' : 'alternative_commenter',
				\ }

	let g:which_key_leader_map.c = {
				\ 'name' : '+cd',
				\ 'r' : 'root',
				\ 'd' : 'current_file',
				\ 'u' : 'one_folder_up',
				\ 'c' : 'display_curr_work_dir',
				\ }

	let l:wings = {
				\ 'name' : '+wings',
				\ '1' : 'OneWins1',
				\ '2' : 'OneWins2',
				\ 'a' : 'wings-dev',
				\ 's' : 'SupportFiles',
				\ }

	let g:which_key_leader_map.e = {
				\ 'name' : '+edit',
				\ 'd' : 'dotfiles',
				\ 'c' : 'current_dir',
				\ 'l' : 'specific_location',
				\ 't' : 'todo',
				\ 'T' : ['UtilsEditTmpFile', 'temp'],
				\ 'p' : 'plugins_path',
				\ 'v' : 'vimruntime',
				\ 'w' : l:wings,
				\ }

	let l:sessions = {
				\ 'name' : '+sessions',
				\ 's' : 'save',
				\ 'l' : 'load',
				\ 'e' : 'load_default',
				\ }
	let g:which_key_leader_map.j = {
				\ 'name' : '+misc',
				\ '2' : '2_char_indent',
				\ '4' : '4_char_indent',
				\ '8' : '8_char_indent',
				\ 'w' : 'wings_syntax',
				\ '.' : 'repeat_last_command',
				\ 's' : 'sync_from_start',
				\ 'c' : 'count_last_search',
				\ '-' : ['UtilsFontZoomOut', 'font_decrease'],
				\ '=' : ['UtilsFontZoomIn', 'font_increase'],
				\ 'e' : l:sessions,
				\ }

	let g:which_key_leader_map.b = {
				\ 'name' : '+buffers/Bookmarks',
				\ 'd' : 'delete_current',
				\ 'l' : 'delete_all',
				\ }

	let g:which_key_leader_map.n = {
				\ 'name' : '+num_representation',
				\ 'h' : 'ascii_to_hex',
				\ 'r' : 'radix_viewer',
				\ }

	let g:which_key_leader_map.v = {
				\ 'name' : '+version_control',
				\ 's' : 'status',
				\ 'a' : 'add',
				\ 'c' : 'commit',
				\ 'p' : 'push',
				\ 'u' : 'pull/update',
				\ 'l' : 'log',
				\ 'S' : ['SignifyToggle' ,'signify_toggle'],
				\ 'd' : ['SignifyDiff' ,'signify_diff'],
				\ }

	let g:which_key_leader_map.w = {
				\ 'name' : '+wiki',
				\ 'o' : 'open',
				\ 'a' : 'add',
				\ 's' : 'search',
				\ }

	let g:which_key_leader_map.o = {
				\ 'name' : '+comments',
				\ 'I' : 'reduce_indent',
				\ 'i' : 'increase_indent',
				\ 'a' : 'append',
				\ 'u' : 'update_header_date',
				\ 'e' : 'end_of_if_comment',
				\ 't' : 'add_todo',
				\ 'd' : 'delete',
				\ }

	let g:which_key_leader_map.P = {
				\ 'name' : '+plugins',
				\ 'i' : ['so %<bar>call plugin#Config()<bar>PlugInstall<CR>', 'install'],
				\ 'u' : ['PlugUpdate', 'update'],
				\ 'r' : ['UpdateRemotePlugins', 'update_remote_plugins'],
				\ 'g' : ['PlugUpgrade', 'upgrade_vim_plug'],
				\ 's' : ['PlugSearch', 'search'],
				\ 'l' : ['PlugClean', 'clean'],
				\ }

	let g:which_key_leader_map.d = 'duplicate_char'
	let g:which_key_leader_map.p = 'paste_from_system'
	let g:which_key_leader_map.y = 'yank_to_system'
	let g:which_key_leader_map.C = ['Calendar', 'calendar']

	" This mappings are needed so that you can use it
	nnoremap gg gg
	nnoremap gd gd
	nnoremap gD gD
	nnoremap g; g;
	nnoremap gq gq
	nnoremap gv gv
	nnoremap g8 g8
	nnoremap g< g<
	nnoremap g? g?
	vnoremap g? g?

	" {Dec,Inc}rease list of number
	vnoremap gA g<c-a>
	vnoremap gX g<c-x>

	let g:which_key_localleader_map = {}
	let g:which_key_localleader_map.g = 'which_key_ignore'
	let g:which_key_localleader_map.d = 'which_key_ignore'
	let g:which_key_localleader_map.D = 'which_key_ignore'
	let g:which_key_localleader_map[';'] = 'which_key_ignore'
	let g:which_key_localleader_map.q = 'which_key_ignore'
	let g:which_key_localleader_map['%'] = 'which_key_ignore'
	let g:which_key_localleader_map.C = 'which_key_ignore'
	let g:which_key_localleader_map.v = 'which_key_ignore'
	let g:which_key_localleader_map['8'] = 'print_hex'
	let g:which_key_localleader_map['<'] = 'print_prev_command_output'
	let g:which_key_localleader_map['?'] = 'rot13_encode_motion'
	let g:which_key_localleader_map['q'] = 'format_motion'
	let g:which_key_localleader_map['~'] = 'swap_case_motion'

	" Note: Do not add localleader mappings to the which_key_localleader_map
	" As they will show up for all buffers. Unless they are global of course
	
	nnoremap ]] ]]
	nnoremap ]) ])
	nnoremap ]} ]}
	nnoremap [[ [[
	nnoremap [( [(
	nnoremap [{ [{
	nnoremap [/ [/
	nnoremap ]/ ]/
	nnoremap ]# ]#
	nnoremap [# [#
	nnoremap ]f ]f
	nnoremap ]i [<c-i>
	nnoremap [i [<c-i>
	nnoremap ]I <c-w>i<c-w>L
	nnoremap [I <c-w>i<c-w>H
	nnoremap ]e [<c-d>
	nnoremap [e [<c-d>
	nnoremap ]E <c-w>d<c-w>L
	nnoremap [E <c-w>d<c-w>H
	let g:which_key_right_bracket_map = {}
	let g:which_key_right_bracket_map.c = 'next_diff'
	let g:which_key_right_bracket_map.y = 'yank_from_next_lines'
	let g:which_key_right_bracket_map.d = 'delete_next_lines'
	let g:which_key_right_bracket_map.o = 'comment_next_lines'
	let g:which_key_right_bracket_map.m = 'move_line_below'
	let g:which_key_right_bracket_map.q = 'next_quickfix_item'
	let g:which_key_right_bracket_map.l = 'next_location_list_item'
	let g:which_key_right_bracket_map.t = 'goto_tag_under_cursor'
	let g:which_key_right_bracket_map.T = 'goto_tag_under_cursor_on_right_win'
	let g:which_key_right_bracket_map.f = 'goto_file_under_cursor'
	let g:which_key_right_bracket_map.F = 'goto_file_under_cursor_on_right_win'
	let g:which_key_right_bracket_map.i = 'goto_include_under_cursor'
	let g:which_key_right_bracket_map.I = 'goto_include_under_cursor_on_right_win'
	let g:which_key_right_bracket_map.e = 'goto_define_under_cursor'
	let g:which_key_right_bracket_map.E = 'goto_define_under_cursor_on_right_win'
	let g:which_key_right_bracket_map.z = 'scroll_right'
	let g:which_key_right_bracket_map.Z = 'scroll_up'
	let g:which_key_right_bracket_map.s = 'goto_next_spell_error'
	let g:which_key_right_bracket_map.S = 'fix_next_spell_error'
	let g:which_key_right_bracket_map[']'] = 'goto_next_function'
	let g:which_key_right_bracket_map[')'] = 'goto_next_unmatched_parenthesis'
	let g:which_key_right_bracket_map['}'] = 'goto_next_unmatched_brace'
	let g:which_key_right_bracket_map['/'] = 'goto_next_comment'
	let g:which_key_right_bracket_map['#'] = 'goto_next_unmatched_defined_if'
	let g:which_key_right_bracket_map['"'] = 'which_key_ignore'
	let g:which_key_right_bracket_map['['] = 'which_key_ignore'
	let g:which_key_right_bracket_map['%'] = 'which_key_ignore'

	let g:which_key_left_bracket_map = {}
	let g:which_key_left_bracket_map.c = 'prev_diff'
	let g:which_key_left_bracket_map.y = 'yank_from_prev_lines'
	let g:which_key_left_bracket_map.d = 'delete_prev_lines'
	let g:which_key_left_bracket_map.o = 'comment_prev_lines'
	let g:which_key_left_bracket_map.m = 'move_line_up'
	let g:which_key_left_bracket_map.q = 'prev_quickfix_item'
	let g:which_key_left_bracket_map.l = 'prev_location_list_item'
	let g:which_key_left_bracket_map.t = 'pop_tag_stack'
	let g:which_key_left_bracket_map.T = 'goto_tag_under_cursor_on_left_win'
	let g:which_key_left_bracket_map.f = 'go_back_one_file'
	let g:which_key_left_bracket_map.F = 'goto_file_under_cursor_on_left_win'
	let g:which_key_left_bracket_map.i = 'goto_include_under_cursor'
	let g:which_key_left_bracket_map.I = 'goto_include_under_cursor_on_left_win'
	let g:which_key_left_bracket_map.e = 'goto_define_under_cursor'
	let g:which_key_left_bracket_map.E = 'goto_define_under_cursor_on_left_win'
	let g:which_key_left_bracket_map.z = 'scroll_left'
	let g:which_key_left_bracket_map.Z = 'scroll_down'
	let g:which_key_left_bracket_map.s = 'goto_prev_spell_error'
	let g:which_key_left_bracket_map.S = 'fix_prev_spell_error'
	let g:which_key_left_bracket_map['['] = 'goto_prev_function'
	let g:which_key_left_bracket_map['('] = 'goto_prev_unmatched_parenthesis'
	let g:which_key_left_bracket_map['{'] = 'goto_prev_unmatched_brace'
	let g:which_key_left_bracket_map['#'] = 'goto_prev_unmatched_defined_if'
	let g:which_key_left_bracket_map['/'] = 'goto_prev_comment'
	let g:which_key_left_bracket_map['"'] = 'which_key_ignore'
	let g:which_key_left_bracket_map[']'] = 'which_key_ignore'
	let g:which_key_left_bracket_map['%'] = 'which_key_ignore'

	" TODO mappings for debuggers lldb
	" TODO mappings for searching files
	" TODO mappings for spells
	" TODO mappings for CCTree
	" TODO mappings for cscope
	" TODO mappings for surround (d,y,c)

	call which_key#register(g:mapleader, "g:which_key_leader_map")
	call which_key#register(g:maplocalleader, "g:which_key_localleader_map")
	call which_key#register(']', "g:which_key_right_bracket_map")
	call which_key#register('[', "g:which_key_left_bracket_map")
endfunction

function! s:version_control_command(cmd) abort
	if empty(a:cmd)
		echoerr '[version_control_command]: Please provide a command'
		return
	endif

	if a:cmd ==? 'status'
		if exists(':Gstatus')
			" nmap here is needed for the <C-n> to work. Otherwise it doesnt know what
			" it means. This below is if you want it horizontal
			" nmap <Leader>gs :Gstatus<CR><C-w>L<C-n>
			execute ':Gstatus'
		elseif exists(':SVNStatus')
			execute ':SVNStatus q'
		else
			echoerr '[version_control_command]: Please provide a command for status'
			return
		endif
	elseif a:cmd ==? 'log'
			if exists(':Glog')
				execute ':Glog'
			elseif exists(':SVNLog')
				execute ':SVNLog .'
			else
				echoerr '[version_control_command]: Please provide a command for log'
				return
			endif
		elseif a:cmd ==? 'commit'
			if exists(':Gcommit')
				execute ':Gcommit'
			elseif exists(':SVNCommit')
				execute ':SVNCommit .'
			else
				echoerr '[version_control_command]: Please provide a command for commit'
				return
			endif
		elseif a:cmd ==? 'push'
			if exists(':Gpush')
				execute ':Gpush'
			else
				echoerr '[version_control_command]: Please provide a command for commit'
				return
			endif
		elseif a:cmd ==? 'pull'
			if exists(':Gpull')
				execute ':Gpull'
			else
				echoerr '[version_control_command]: Please provide a command for pull'
				return
			endif
		else
			echoerr '[version_control_command]: Please provide support this command'
			return
	endif
endfunction