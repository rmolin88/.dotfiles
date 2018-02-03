" File:win32.vim
" Description:Settings exclusive for Windows
" Author:Reinaldo Molina <rmolin88@gmail.com>
" Version:1.0.0
" Last modified:Nov 29 2016 23:21

function win32#Config()
	" Copy and paste into system wide clipboard
	nnoremap <Leader>p "*p=`]<C-o>
	vnoremap <Leader>p "*p=`]<C-o>

	nnoremap <Leader>y "*yy
	vnoremap <Leader>y "*y

	nnoremap <CR> o<ESC>

	" On MS-Windows, this is mapped to cut Visual text
	" |dos-standard-mappings|.
	silent! vunmap <C-X>

	let languagetool_jar = findfile('languagetool-commandline.jar', $ChocolateyInstall . '\lib\languagetool\tools\**2')
	if !empty('languagetool_jar')
		let g:languagetool_jar = 'c:' . languagetool_jar
	endif

	if filereadable('C:\Program Files\LLVM\share\clang\clang-format.py')
				\ && has('python') && executable('clang-format')
		let g:clang_format_py = 'C:\Program Files\LLVM\share\clang\clang-format.py'
	endif

	" Set wiki_path
	let wikis = ['D:\Seafile\KnowledgeIsPower\wiki', 'D:/wiki']
	for wiki in wikis
		if !empty(glob(wiki))
			let g:wiki_path =  wiki
		endif
	endfor

	if !empty(glob('D:/wings-dev/'))
		let g:wings_path =  'D:/wings-dev/'
		call utils#SetWingsPath(g:wings_path)
	endif

	" Fri Jan 05 2018 16:40: Many plugins use this now. Making these variables available
	" all the time.
	let pyt2 = "C:\\Python27\\python.exe"
	let pyt3 = [$LOCALAPPDATA . "\\Programs\\Python\\Python36\\python.exe", "C:\\Python36\\python.exe"]

	if filereadable(pyt2)
		let g:python_host_prog= pyt2
	endif

	for loc in pyt3
		if filereadable(loc)
			let g:python3_host_prog= loc
			break
		endif
	endfor

	let browsers = [ 'chrome.exe', 'launcher.exe', 'firefox.exe' ]
	let g:browser_cmd = ''
	for brow in browsers
		if executable(brow)
			let g:browser_cmd = brow
			break
		endif
	endfor
endfunction
