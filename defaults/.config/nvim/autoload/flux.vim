" File:           flux.vim
" Description:    Automatically set colorscheme and background depending on time
" Author:		    Reinaldo Molina
" Email:          rmolin88 at gmail dot com
" Revision:	    1.0.0
" Created:        Tue Aug 27 2019 23:20
" Last Modified:  Tue Aug 27 2019 23:20

" TODO 
"  check for filereadable(s:api_res_path) every time flux() is called
let s:api_response_file_name = 'api_response_' . strftime('%m%d%Y') . '.json'
let s:api_res_path = g:std_cache_path . '/' . s:api_response_file_name
let s:api_url = 'https://api.sunrise-sunset.org/json?lat={}&lng={}'
let s:flux_times = {}

" Change vim colorscheme depending on time of the day
function! flux#Flux() abort
	if get(g:, 'flux_enabled', 0) == 0
		return
	endif

	if empty(s:flux_times)
		let s:flux_times = s:get_api_response_file()

		if empty(s:flux_times)
			let s:flux_times = { 'day':  g:flux_day_time, 'night' : g:flux_night_time}
		endif
	endif

	if !exists('g:flux_day_colorscheme') || !exists('g:flux_night_colorscheme')
		if &verbose > 1
			echoerr 'Variables not set properly'
		endif
		return
	endif

	if strftime("%H%M") >= s:flux_times['night'] ||
				\ strftime("%H%M") < s:flux_times['day']
		" Its night time
		if	&background !=# 'dark' ||
					\ !exists('g:colors_name') ||
					\ g:colors_name !=# g:flux_night_colorscheme
			call <sid>change_colors(g:flux_night_colorscheme, 'dark')
		endif
	else
		" Its day time
		if !exists('g:colors_name')
			let g:colors_name = g:flux_day_colorscheme
		endif
		if &background !=# 'light' ||
					\ !exists('g:colors_name') ||
					\ g:colors_name !=# g:flux_day_colorscheme
			call <sid>change_colors(g:flux_day_colorscheme, 'light')
		endif
	endif
endfunction

function! s:change_colors(scheme, background) abort
	if !exists('g:black')
		if &verbose > 1
			echoerr 'Colors do not exist'
		endif
	endif

	if a:background ==# 'dark'
		let color = g:black
	elseif a:background ==# 'light'
		let color = g:white
	else
		echoerr 'Only possible backgrounds are dark and light'
		return
	endif

	try
		execute "colorscheme " . a:scheme
	catch
		if &verbose > 1
			echoerr 'Failed to set colorscheme'
		endif
		return
	endtry

	let &background=a:background
	" Restoring these after colorscheme. Because some of them affect by the colorscheme
	" call highlight#SetAll('IncSearch',	{ 'bg': color })
	" call highlight#SetAll('IncSearch',	{ 'fg': 0, 'bg' : 9,  })
	" call highlight#SetAll('Search', { 'fg' : g:yellow, 'deco' : 'bold', 'bg' : g:turquoise4 })
	" Tue Jun 26 2018 14:00: Italics fonts on neovim-qt on windows look bad
	if has('unix') || has('gui_running')
		call highlight#Set('Comment', { 'deco' : 'italic' })
	endif

	" If using the lightline plugin then update that as well
	" this could cause trouble if lightline does not that colorscheme
	call status_line#UpdateColorscheme()
endfunction

" Returns dictionary:
"		day: strftime('%H%M')
"		night: strftime('%H%M')
function! s:get_api_response_file() abort
	let l:url = substitute(s:api_url, '{}', string(g:flux_api_lat), '')
	" echomsg 'url = ' l:url
	let l:url = substitute(l:url, '{}', string(g:flux_api_lon), '')
	" echomsg 'url = ' l:url

	if !filereadable(s:api_res_path)
		if s:api_request(s:api_res_path, l:url) < 1
			if &verbose > 0
				echoerr 'Filed to make api request'
			endif
			return
		endif
	endif

	if !filereadable(s:api_res_path)
		if &verbose > 0
			echoerr 'Filed to make api request'
		endif
		return
	endif

	let l:sunrise = s:get_sunrise_times('sunrise')
	if l:sunrise < 1
		return
	endif

	let l:sunset = s:get_sunset_times('sunset')
	if l:sunset < 1
		return
	endif

	return { 'day': l:sunrise, 'night': l:sunset }
endfunction

function! s:get_sunset_times(time) abort
	let l:content = readfile(s:api_res_path, '', 1)[0]
	" echomsg 'content = ' l:content
	let l:sunrise_idx = stridx(l:content, a:time)
	if (l:sunrise_idx < 0)
		if &verbose > 0
			echoerr 'Failed to find ' . a:time  . ' time in api response'
		endif
		return -1
	endif

	" Time is given in UTC. Subs 4 to get ETC plus 12 to convert to military
	let l:t = strpart(l:content, l:sunrise_idx + 9, 2)
	" echomsg 't = ' l:t
	let l:time = (str2nr(l:t) + 12 - 4) * 100
	" echomsg 'time = ' l:time
	let l:t = strpart(l:content, l:sunrise_idx + 12, 2)
	" echomsg 't = ' l:t
	let l:time += str2nr(l:t)
	" echomsg 'time = ' l:time

	return l:time
endfunction

function! s:get_sunrise_times(time) abort
	let l:content = readfile(s:api_res_path, '', 1)[0]
	" echomsg 'content = ' l:content
	let l:sunrise_idx = stridx(l:content, a:time)
	if (l:sunrise_idx < 0)
		if &verbose > 0
			echoerr 'Failed to find ' . a:time  . ' time in api response'
		endif
		return -1
	endif

	" Time is given in UTC. Subs 4 to get ETC
	let l:t = strpart(l:content, l:sunrise_idx + 10, 2)
	" echomsg 't = ' l:t
	let l:time = (str2nr(l:t) - 4) * 100
	" echomsg 'time = ' l:time
	let l:t = strpart(l:content, l:sunrise_idx + 13, 2)
	" echomsg 't = ' l:t
	let l:time += str2nr(l:t)
	" echomsg 'time = ' l:time
	
	return l:time
endfunction

function! s:api_request(file_name, link) abort
	if !executable('curl')
		if &verbose > 0
			echoerr 'Curl is not installed. Cannot proceed'
		endif
		return -1
	endif

	if empty(a:file_name) || empty(a:link)
		if &verbose > 0
			echoerr 'Please specify a path and link to download'
		endif
		return -2
	endif

	execute "!curl -kfLo " . a:file_name . " --create-dirs \"" . a:link . "\""
	return 1
endfunction

function! flux#GetTimes() abort
	echomsg string(s:flux_times)
endfunction