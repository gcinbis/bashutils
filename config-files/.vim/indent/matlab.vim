" Matlab indent file
" Language:	Matlab
" Maintainer:	Fabrice Guy <fabrice.guy at gmail dot com>
" Last Change:	2008 Oct 15 

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1
let s:onlySubfunctionExists = 0

setlocal indentexpr=GetMatlabIndent()
setlocal indentkeys=!,o,O=end,=case,=else,=elseif,=otherwise,=catch

" Only define the function once.
if exists("*GetMatlabIndent")
  finish
endif

function! s:IsMatlabContinuationLine(lnum)
  let continuationLine = 0
  if a:lnum > 0
    let pnbline = getline(prevnonblank(a:lnum))
    " if we have the line continuation operator (... at the end of a line or
    " ... followed by a comment) it may be a line continuation
    if pnbline =~ '\.\.\.\s*$' || pnbline =~ '\.\.\.\s*%.*$'
      let continuationLine = 1
      " but if the ... are part of a string or a comment, it is not a
      " continuation line
      let col = match(pnbline, '\.\.\.\s*$')
      if col == -1
	let col = match(pnbline, '\.\.\.\s*%.*$')
      endif
      if has('syntax_items')
	if synIDattr(synID(prevnonblank(a:lnum), col + 1, 1), "name") =~ "matlabString" ||
	      \ synIDattr(synID(prevnonblank(a:lnum), col + 1, 1), "name") =~ "matlabComment" 
	  let continuationLine = 0
	endif
      endif
    endif
  endif
  return continuationLine
endfunction

function GetMatlabIndent()
  " Find a non-blank line above the current line.
  let plnum = prevnonblank(v:lnum - 1)

  " If the previous line is a continuation line, get the beginning of the block to 
  " use the indent of that line
  if s:IsMatlabContinuationLine(plnum - 1)
    while s:IsMatlabContinuationLine(plnum - 1)
      let plnum = plnum - 1
    endwhile
  endif

  " At the start of the file use zero indent.
  if plnum == 0
    return 0
  endif

  let curind = indent(plnum)
  if s:IsMatlabContinuationLine(v:lnum - 1) 
    let curind = curind + &sw
  endif

  " GOKBERK plnum means parent-line or previous-line. we get its indent
  " and assign our indentation with respect to it. lnum is our own line.

  " Add a 'shiftwidth' after classdef, properties, switch, methods, events,
  " function, if, while, for, otherwise, case, tic, try, catch, else, elseif
  " if getline(plnum) =~ '^\s*\(classdef\|properties\|switch\|methods\|events\|function\|if\|while\|for\|parfor\|otherwise\|case\|tic\|try\|catch\|else\|elseif\)\>'
  if getline(plnum) =~ '^\s*\(classdef\|properties\|switch\|methods\|events\|function\|while\|for\|parfor\|otherwise\|case\|try\|catch\|else\|elseif\)\>'
    let curind = curind + &sw
    " In Matlab we have different kind of functions
    " - the main function (the function with the same name than the filename)
    " - the nested functions
    " - the functions defined in methods (for classes)
    " - subfunctions
    " For the moment the main function (located line 1) doesn't produce any indentation in the
    " code (default behavior in the Matlab editor) and the other kind of
    " functions indent the code
    if getline(plnum)  =~ '^\s*\function\>'
      " If it is the main function
      if plnum == 1
	" look for a matching end : 
	" - if we find a matching end everything is fine
	" - if not, then all other functions are subfunctions
	normal %
	if getline(line('.')) =~ '^\s*end'
	  let s:onlySubfunctionExists = 0
	else
	  let s:onlySubfunctionExists = 1
	endif
	normal %
	let curind = curind - &sw
      else
	" it is a subfunction without matching end : dedent
	if s:onlySubfunctionExists
	  let curind = curind - &sw
	endif
      endif
    endif

    " GOKBERK TODO Indent function only if there is a matching for the current function and there is
    " a function above with a matching end after me

  endif

  " gokberk: handle possible 1-liners
  " gokberk: if it also contains an 'end' then dont indent. this isnt super good but should be ok.
  if getline(plnum) =~ '^\s*\(if\)\>'
    if getline(plnum) =~ '\s*\(end\)\>'
    else
      let curind = curind + &sw
    endif
  endif


  " Subtract a 'shiftwidth' on a else, elseif, end, catch, otherwise, case,
  " toc
  " if getline(v:lnum) =~ '^\s*\(else\|elseif\|end\|catch\|otherwise\|case\|toc\)\>'
  if getline(v:lnum) =~ '^\s*\(else\|elseif\|end\|catch\|otherwise\|case\)\>'
    let curind = curind - &sw
  endif
  " No indentation in a subfunction
  if getline(v:lnum)  =~ '^\s*\function\>' && s:onlySubfunctionExists
    let curind = curind - &sw
  endif

  " First case after a switch : indent
  if getline(v:lnum) =~ '^\s*case'
    while plnum > 0 && (getline(plnum) =~ '^\s*%' || getline(plnum) =~ '^\s*$')
      let plnum = plnum - 1
    endwhile
    if getline(plnum) =~ '^\s*switch'
      let curind = indent(plnum) + &sw
    endif
  endif

  " end in a switch / end block : dedent twice
  " we use the matchit script to know if this end is the end of a switch block
  if exists("b:match_words")
    if getline(v:lnum) =~ '^\s*end'
      normal %
      if getline(line('.')) =~ "switch"
	let curind = curind - &sw
      endif
      normal %
    end
  end
  return curind
endfunction

" vim:sw=2
