"Vim plugin for aligning text
"Version:						1.2
"Last Change:					Nov 21, 2010
"Author:						Daniel Schemala
"Report bugs and wishes to:		sehrpositiv@web.de
"Usage:
"		- :Tabbi for aligning the whole buffer, or use a range before the command or visual mode
"		- :call Tabb(pattern [, trim [, sep]]) for formatting the selected lines
"
"		'pattern' is a string that is the pattern for the new line. The following are special characters:
"			- §n	- where n is a Number: this is replaced by the string of
"						the n'th column in the original line
"			- §n-m	- if n<m, then this is replaced by the columns n to m
"						(without trimming)
"			- §-	- to align the following section (like the Tabbi command)
"			- §§n	- is replaced by $n -- like 'escaping' the §
"
"		'trim' is a boolean and makes the parts be trimmed or not. Default is 0.
"
"		'sep' is the string, by which the line is separated into parts.
"				Default is tabs and/or two or more whitespaces
"
"		Example: before:
"				part one, part two  ,part three , part four, rest
"				one  , two , three
"
"			:call Tabb("§2: §1§-§3-4", 1, ',')
"
"				part two: part one	- part three , part four
"				two: one			- three

if exists("loaded_tabbi") || &cp
	finish
endif
let loaded_tabbi=1

command! -range Tabbi call s:TabbiAUF(<line1>, <line2>)

function! Tabb(muster, ...) range
	let l:schn = a:0>0 ? a:1 : 0
	let l:tr = a:0>1 ? a:2 : '\S\zs\(\(\s*\t\+\s*\)\|\(\s\s\+\)\)'
	let s:ERSTEZ = a:firstline
	let s:LETZTEZ = a:lastline
	let l:muli = []
	let l:we=-1
	"let l:muli = split(a:muster, '\(\ze§\d\+\)\|\(§\d\+\zs\)', 1) "was cool,
	"but does not work
	while 1
		let l:wa = match(a:muster, '\(\(^\|[^§]\)\zs§\d\+\(-\d\+\)\?\)\|$', l:we)
		let l:muli += [substitute(strpart(a:muster, l:we+1, l:wa-l:we-1), "§§", "§", "g")]
		let l:we = match(a:muster, '\d\+\(-\d\+\)\?\zs\(\D\|$\)', l:wa) -1
		if l:we<0
			break
		endif
		let l:muli += [strpart(a:muster, l:wa+2, l:we-l:wa-1)]
	endwhile
	let l:tabbil = []
	let s:PUFFERLISTE = []
	for l:zn in range(s:ERSTEZ, s:LETZTEZ)
		let l:zeile = getline(l:zn)
		let l:neuzei = ""
		let l:li = s:Spalten(l:zeile, l:tr)
		let l:i = 0
		while l:i < len(l:muli)-1
			let l:neuzei .= l:muli[l:i]
			if l:muli[l:i+1] =~ '\d\+-\d\+'
				let l:za = matchstr(l:muli[l:i+1], '\d\+', 0, 1)
				let l:ze = matchstr(l:muli[l:i+1], '\d\+', 0, 2)
				let l:st = join(l:li[2*l:za-2 : 2*l:ze-2], '')
			else
				let l:za = l:muli[l:i+1]
				if l:za > 0 && l:za <= len(l:li)/2+1
					let l:st=l:li[2*l:za-2]
				else
					let l:st = ""
				endif
			endif
			if l:schn
				let l:st = substitute(l:st, "^\\s\\+\\|\\s\\+$","","g")
			endif
			let l:neuzei .= l:st
			let l:i += 2
		endwhile
		let l:neuzei .= l:muli[len(l:muli)-1]
		let l:tabbilz = split(l:neuzei, "§-", 1)
		call add(s:PUFFERLISTE, l:tabbilz)
	endfor
	call s:TabbiL()
endfunction

function! s:Spalten(str, tr)
	let l:i = 1
	let l:li = []
	let l:me = 0
	while 1
		let l:ma = match(a:str, a:tr, l:me)
		if l:ma == -1
			break
		endif
		call add(l:li, strpart(a:str, l:me, l:ma-l:me))
		let l:me = matchend(a:str, a:tr, l:me)
		call add(l:li, strpart(a:str, l:ma, l:me-l:ma))
		let l:i += 1
	endwhile
	call add(l:li, strpart(a:str, l:me, strlen(a:str)))
	return l:li
endfunction


"reads the buffer in a matrix
function! s:TabbiAUF(erstez, letztez)
	let s:ERSTEZ = a:erstez
	let s:LETZTEZ = a:letztez
	if s:ERSTEZ >= s:LETZTEZ
		let s:ERSTEZ = 1
		let s:LETZTEZ = line("$")
	endif
	let s:PUFFERLISTE = []
	for l:i in range(s:ERSTEZ, s:LETZTEZ)
		"the regex matches every sequence of tabs or two or more whitespaces,
		"(and the combination of it), but not at the beginning of the line
		call add(s:PUFFERLISTE, split(getline(l:i), '\S\zs\(\(\s*\t\+\s*\)\|\(\s\s\+\)\)', 0))
	endfor
	call s:TabbiL()
endfunction

function! s:Str_Width(str)
	return len(substitute(substitute(a:str, "\t", repeat("d", &ts), "g"), ".", "d", "g"))
endfunction

"creates a list with the widest widths for each column
function! s:TabbiL()
	let s:LISTEMAX = []
	for l:zeile in range(len(s:PUFFERLISTE))
		for l:i in range(len(s:PUFFERLISTE[l:zeile]))
			let l:br = s:Str_Width(s:PUFFERLISTE[l:zeile][l:i])
			if l:i >= len(s:LISTEMAX)
				call add(s:LISTEMAX, l:br)
			else
				let s:LISTEMAX[l:i] = max([s:LISTEMAX[l:i], l:br])
			endif
		endfor
	endfor
	call s:TabbiT()
endfunction

function! s:Auf(som, so)
	if &expandtab
		let l:mb = (a:som % &ts)==&ts-1 ? a:som+&ts+1 : a:som+&ts-(a:som % &ts)
		let l:ov = (a:som - a:so)/&ts + &ts-(a:so % &ts)
		return repeat(" ", l:mb-a:so)
	else
   		let l:mb = (a:som % &ts)==&ts-1 ? a:som+&ts+1 : a:som+&ts-(a:som % &ts)
   		let l:at = ((a:so%&ts)==0 ? 0 : 1) + (l:mb-a:so)/&ts
		return repeat("\t", l:at)
	endif
endfunction

"creates the nice aligned buffer
function! s:TabbiT()
	for l:zn in range(len(s:PUFFERLISTE))
		let l:neuzei=""
		let l:zeilel=s:PUFFERLISTE[l:zn]
		for l:i in range(len(l:zeilel))
			let l:neuzei .=  l:zeilel[l:i]
			if l:i<len(l:zeilel)-1
				let l:neuzei .= s:Auf(s:LISTEMAX[l:i], s:Str_Width(l:zeilel[l:i]))
			endif
		endfor
		call setline(l:zn+s:ERSTEZ, l:neuzei)
	endfor
endfunction
