" Vim plugin for visual rcsdiff
" Last Change: $Date: 2012/01/20 10:43:17 $
" Maintainer:  Brian Nelson <nelsonbc@gmail.com>
" Requires:    Vim 6.x w/ +diff feature
" Documentation:
" Integrates Vim's diffsplit functionality with RCS (Revision Control System).
" Compare the difference between the current workfile and its RCS revisions.
" Commands:
" :Rcsdiff [rev]
"        Includes an optional revision argument. If argument is ommitted,
"        the latest revision will be used.
" Mappings:
" <Plug>Rcsdiff
"        Show difference between current workfile and latest revision.
" Instructions:
" * Copy this file to your global plugin directory: i.e. ~/.vim/plugin
" * The RCS checkout utility, 'co', must be on your path. 
" * Optionally, create your own mapping in ~/.vimrc.
"   ex.    "map <F9> <Plug>Rcsdiff"
" See Also:
" Vim's diff documentation ":help diff.txt"
" RCS manpages "man rcs", "man rcsintro"
" Note:
" Use ":set nodiff" to return to normal editing mode.
" Use ":!rlog %" for a quick listing of the revision history. 

if exists("loaded_rcsdiff")
	finish
endif
let loaded_rcsdiff = 1

noremap <unique> <script> <Plug>Rcsdiff :call <SID>RcsDiff()<CR>

if !exists(":Rcsdiff")
	command -nargs=? Rcsdiff :call s:RcsDiff(<f-args>)
endif

" optional argument to set revision number
function! s:RcsDiff(...)
	let rev = ''
	if a:0 > 0
		let rev = a:1
	endif

	let ftype = &filetype
	let tmpfile = tempname()

	let cmd = "co -p" . rev . " " . bufname("%") . " > " . tmpfile
	let cmd_output = system(cmd)

	if v:shell_error 
		if cmd_output != ""
			echohl WarningMsg | echon cmd_output | echohl None
		else
			echohl ErrorMsg | echon "Rcsdiff: command failed" | echohl None
		endif

		return
	endif

	exe "vert diffsplit" . tmpfile
	exe "set filetype=" . ftype
	set nomodifiable
endfunction
