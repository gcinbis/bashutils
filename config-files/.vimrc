" MYNOTES
"
" -- misc commands --
" set list  : Show hidden characters.
" <Ctrl+R>+": paste default buffer. See :help c__
"
" -- aligning lines --
" * Select a number lines and write "!alignassign" to align assignment operations.
" * Select a number lines and write "!alignanchors <sub>" to align all anchor substrings <sub>.
" * Select a number lines and write "!aligntable" to automatically generate a table based on spacings.
"
" -- insert mode default registers --
" * See :help <C-R>
" * For example, to insert file name <C-R>%
" 
" -- regexp capture --
" * :s/\(.*\)/\1\1/g         " Like this: repmat(line,[1 2])
"
" -- gvim --
" Copy all text into clipboard :%y+.
" 
" -- export syntax highlighting to html --
" :TOhtml
" 
"
" -- for detailed comparisons in vimdiff --
" https://github.com/rickhowe/diffchar.vim
" https://vi.stackexchange.com/questions/499/more-detailed-comparison-within-a-line
" --> To change colours: let g:DiffColors=100
"
" Gokberk Cinbis' vimrc, which is mostly a compilation over many posts from several forums.

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

" avoid plaintex & tex variants
let g:tex_flavor = "latex"

" set default clipboard as the system clipboard (works fine on MacOS)
" disable via clipboard=
" set clipboard=unnamed ->
" set clipboard=unnamedplus
" set clipboard^=unnamed,unnamedplus  ---> works fine on gvim (or you need x11-enabled vim
"                                          compilation)
set clipboard^=unnamed,unnamedplus

" wrap settings
set nowrap               " don't wrap by default
set linebreak            " don't break words.
au FileType tex,text set wrap " wrap for latex

" easy cursor movement when wrap is enabled.
" use "set filetype?" to see the current filetype.
"
" can use CursorMoved/CursorMovedI or
" CursorHold/CursorHoldI events and a custom
" function to check "wrap" status to make this dynamic.
"
" we can use the following ones:
" au FileType tex,text noremap <buffer> j gj
" au FileType tex,text noremap <buffer> k gk
" au FileType tex,text noremap <buffer> $ g$
" au FileType tex,text noremap <buffer> ^ g^
"
" but I prefer make this consistent everywhere:
nnoremap j gj
nnoremap k gk
" NO. RISKY. nnoremap $ g$
" NO. RISKY. nnoremap ^ g^
vnoremap j gj
vnoremap k gk
" NO. RISKY. vnoremap $ g$
" NO. RISKY. vnoremap ^ g^

" misc
set nohidden            " hidden buffers don't work well with tabs
set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
"set backup		" keep a backup file
"set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set viminfo='20,\"100 
set history=100		" keep .. lines of command line history
set ruler		" show the cursor position all the time
"set complete=.,w,b,u,t,i " can be slow
set complete=.,w,b,u,t " faster

" save buffer list on exit
set viminfo+=%
" :au BufAdd,BufNewFile * nested tab sball " buggy
" :bufdo tab split " buggy

" open all buffers in tabs
command! Buff :tab sball

" align latex table. todo: support visual selections.
command! AlignLatexTable        :%!aligntable --tex
command! AlignLatexTableBoldMax :%!aligntable --texboldmax --nomaxif "\#NOMAX\#" 
" -> Ignore lines containing #NOMAX#.
" command-range=%! AlignMatrix     !aligntable -s " [^ ]"

" compile each time a file is saved. very useful with latex files. see ":silent".
" autocmd BufWritePost *.tex silent! make &> /dev/null 

" git
autocmd Filetype gitcommit setlocal spell textwidth=72

" ctrl+space sends null, which causes vim to write weird stuff in insert mode.
" http://shallowsky.com/blog/linux/editors/vim-ctrl-space.html
map <Nul> <Space>
" "For good measure, I also mapped the character to no-op in all the other modes as well:"
map  <Nul> <Nop>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to <n> characters
  " gokberk disabled: autocmd BufRead *.txt set tw=112
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

if has("cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

set tabstop=8
set softtabstop=4 " a very nice behaviour
set shiftwidth=4
set expandtab
set autoindent
set mouse=a

" tab settings
" use -- :tabdo %s/from/to/g  -- to apply a command over tabs.
set tabpagemax=100 " max number of tabs

" OR operator (ie. alternation operator) in regexps is \|.
" eg, :g/[ ^\t]if\|[ ^\t]fi/print
" eg, %v/\(if\|else\|fi\)/d
" See :help pattern for other operators like \&.

" textwidth settings
" see 'help fo-table'
set textwidth=100 " 100 or 112 
" au FileType tex set textwidth=120 " 58 (half-screen on laptop) 120 (half-screen on 258B)

" automatic line break settings
" set formatoptions=tcq --> to enable auto-wrap. 
" set formatoptions=cq --> to enable auto-wrap only on comments.
set formatoptions=q
set wrapmargin=0

" related:
"set wrap
"set linebreak
"set nolist  " list disables linebreak


"set tags=tags;/ " --> vim searches tags recursively upwards
set tags=tags;/,$HOME/proj/myutils/tags

" ... to change directory to whatever file I'm currently
" editing. :n .<Enter> does what's expected. It also allows the recursive tag searching
" (just mentioned above) to work properly if you edit multiple projects - just put the tags
" file at the top of each project. 
"autocmd BufEnter * lcd %:p:h 

" to quickly go to the dir of the current file
command! LCD lcd %:p:h

" to quickly switch between paste states via ":P"
command! P set invpaste|set paste?

" to quickly switch between line wrap states via ":W"
" command! W set invwrap|set wrap? --> single split (window)
command! W windo set invwrap

" ignore case when typed in lower case
set ignorecase
set smartcase

" text width'e bir benzer de writemargin
:ab #b /************************************************
:ab #e ************************************************/

" matlab+vim
filetype plugin on
if filereadable("SpecificFile")
    source $HOME/.vim/plugin/matchit.vim
end
" XXX autocmd BufEnter *.m  compiler mlint
filetype indent on

" mouse support in screen
" set ttymouse=xterm2 -> Removed on 2024 April due to problems in MacOS.

" gokberk : example for ATS 
" augroup filetype
"    au!
"    au! BufRead,BufNewFile *.dats set filetype=ats
"    au! BufRead,BufNewFile *.sats set filetype=ats
" augroup END

" gokberk tab edit shortcuts
" :tabedit % will open the current buffer in a new tab
" :tabclose when finished and return to your finely tuned set of splits.
" nmap t% :tabedit %<CR> -- tt is better.
nmap tt :tabedit %<CR>
nmap td :tabclose<CR>
nmap te :tabedit 
nmap t. :tabedit .<CR>
nmap qq :quit<CR>
" bd closes all instances of a file

" to easily select a buffer
" unused in practice: nmap <C-F10> :buffers<CR>:buffer<Space>
nmap <B> :buffers<CR>:buffer<Space>


" gokberk: change tabs C-d, C-g (US keyboard)
imap <C-d> <ESC>:tabp<CR>
imap <C-g> <ESC>:tabn<CR>
nmap <C-d> :tabp<CR>
nmap <C-g> :tabn<CR>

" old mappings:
"       gokberk: change tabs F2-F3
"       imap <F2> <ESC>:tabp<CR>
"       imap <F3> <ESC>:tabn<CR>
"       nmap <F2> :tabp<CR>
"       nmap <F3> :tabn<CR>
"       map [12~ <F2> " backwards compability for terminals
"       map [13~ <f3> " backwards compability for terminals
"       --> Jan 2020: changed to mappings above.
"
" gokberk: change tabs C-j, C-i (US keyboard)
"       imap <C-j> <ESC>:tabp<CR>
"       imap <C-k> <ESC>:tabn<CR>
"       nmap <C-j> :tabp<CR>
"       nmap <C-k> :tabn<CR>
"       --> works fine but not practical.

" gokberk: :S or "s" in command mode to shape the current paragraph
" in keyboard, { and } is used to go beginning/end of the paragraph
" {gw} or {gq} to format it. Alternatively, "vip" selects the paragraph,
" and gw formats it.
command! S :normal vipgw 
nmap s :S<CR>

" gokberk: :T or shift+T (capital T) --> turkish deasciify the current paragraph
command! T :normal vip!turkish-deasciify<CR>
nmap T :T<CR>

" gokberk: highlight non-ascii characters 
command! Nonascii /[^\x00-\x7F]

" gokberk: use ctrl-p to select paragraph 
nmap <C-p> vip<CR>

" doesnt work-- :imap <S-Space> <Esc>
   
" nice menus
set wildmenu
set wildmode=list:longest,full

" omnifunc: instead of ctrl-x,o (emacs like), I use ctrl-o
" note that omnifunc operates in insert mode only.
" for usual search, I still use ctrl-p. and for tags ctrl-].
" imap <C-o> <C-X><C-O>
" Jan 2020: C-o is now mapped to tab change. I don't really use omnifunc anyways.

" to see the TODO,etc summary.. needs a plugin
" map T :TaskList<CR>

" MiniBufExplorer settings
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1

" to make simple tables:
" select visually and type :!column -t
" alternatively, for whole text: :%!column...

" add matlab support to taglist. see vim-taglist.sourceforge.net/manual.html#taglist-using
" my old command before taglist: 'com! Mfun :g/^ *function/print' 
let tlist_matlab_settings = 'matlab;f:function'

" taglist shortcut
map O :TlistOpen<CR>
map P :TlistToggle<CR>
map U :TlistUpdate<CR>
let Tlist_Use_Horiz_Window=0    " 0: vertical, 1: horizontal
let Tlist_WinWidth=35           " window width

" taglist to work on javascrip
let g:tlist_javascript_settings = 'javascript;s:string;a:array;o:object;f:function'

" write frequently, so that tag list is renewed frequently
set updatetime=1

" python completion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" C++11 syntax
au BufNewFile,BufRead *.cpp set syntax=cpp11

" Makefile shortcuts
" ** If make may produce errors:
" nmap <C-D>      :w<CR>:silent !make<CR>:redraw!<CR>  --> Jan'20: works fine but now conflicts with tab navigation.
" imap <C-D> <ESC>:w<CR>:silent !make<CR>:redraw!<CR>i
nmap <C-S>      :w<CR>:silent !make<CR>:redraw!<CR>   
imap <C-S> <ESC>:w<CR>:silent !make<CR>:redraw!<CR>i

" obtain Turkish characters via <Ctrl>c/g/i/o/s/u
" enable via :call TurkishMode()
function! TurkishMode()
    " imap is not case senstive unfortunately
    imap <C-c> ç
    imap <C-g> ğ
    imap <C-i> ı
    imap <C-s> ş
    imap <C-o> ö
    imap <C-u> ü
endfunction



" ** If make cannot produce errors (eg, latex batch mode): 
" nmap <C-D>      :w<CR>:silent execute "!make &> /dev/null &"<CR>:redraw!<CR>
" imap <C-D> <ESC>:w<CR>:silent execute "!make &> /dev/null &"<CR>:redraw!<CR>i
"
" ESC alternatives
" imap jj <Esc>
"  to enter a new line in insert mode use S-Enter,C-Enter
" not very convenient: inoremap <CR> <ESC>
" could be good but putty does not send shift+enter for multiline
"
" ------------------------------------------------------

" Comment/Uncomment
" ,c comments out a region
" ,u uncomments a region
au FileType haskell,vhdl,ada let b:comment_leader = '-- '
au FileType vim let b:comment_leader = '" '
au FileType matlab let b:comment_leader = '% '
au FileType c,cpp,java let b:comment_leader = '// '
au FileType sh,make let b:comment_leader = '# '
au FileType tex let b:comment_leader = '% '
noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>

" ------------------------------------------------------

" Format paragraph 
" vip (or vap): Select paragraph.
" gw: Format current selection.
function! FormatParagraph()
    normal vipgw
endfunction

" ------------------------------------------------------

function! DeleteFile(...)
  if(exists('a:1'))
    let theFile=a:1
  elseif ( &ft == 'help' )
    echohl Error
    echo "Cannot delete a help buffer!"
    echohl None
    return -1
  else
    let theFile=expand('%:p')
  endif
  let delStatus=delete(theFile)
  if(delStatus == 0)
    echo "Deleted " . theFile
  else
    echohl WarningMsg
    echo "Failed to delete " . theFile
    echohl None
  endif
  return delStatus
endfunction
"delete the current file
com! Rm call DeleteFile()
"delete the file and quit the buffer (quits vim if this was the last file)
com! RM call DeleteFile() <Bar> q!


" use "set diffopt+=iwhite" to ignore whitespace completely.
" this function sets the commandline options to pass to the "diff" utility.
"set diffexpr=DiffW()
function! DiffW() " ! to override DiffW if already defined.
    let opt = ""
    if &diffopt =~ "icase"
        let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
        let opt = opt . "-w " " standard vim sets -b in this case which doesnt ignore indentation differences.
    endif
    silent execute "!diff -a --binary " . opt .
                \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction

" Avoid dark-blue 
" set background=dark
"hi comment ctermfg=blue
hi comment ctermfg=darkcyan

" close all inactive buffers
function! Wipeout()
    " list of *all* buffer numbers
    let l:buffers = range(1, bufnr('$'))

    " what tab page are we in?
    let l:currentTab = tabpagenr()
    try
        " go through all tab pages
        let l:tab = 0
        while l:tab < tabpagenr('$')
            let l:tab += 1

            " go through all windows
            let l:win = 0
            while l:win < winnr('$')
                let l:win += 1
                " whatever buffer is in this window in this tab, remove it from
                " l:buffers list
                let l:thisbuf = winbufnr(l:win)
                call remove(l:buffers, index(l:buffers, l:thisbuf))
            endwhile
        endwhile

        " if there are any buffers left, delete them
        if len(l:buffers)
            execute 'bwipeout' join(l:buffers)
        endif
    finally
        " go back to our original tab page
        execute 'tabnext' l:currentTab
    endtry
endfunction

" Press Enter to highlight on/off the current word without searching
" Reference: http://vim.wikia.com/wiki/Highlight_all_search_pattern_matches#Highlight_matches_without_moving
let g:highlighting = 0
function! Highlighting()
  if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
    let g:highlighting = 0
    return ":silent nohlsearch\<CR>"
  endif
  let @/ = '\<'.expand('<cword>').'\>'
  let g:highlighting = 1
  return ":silent set hlsearch\<CR>"
endfunction
nnoremap <silent> <expr> <CR> Highlighting()

" https://superuser.com/questions/200423/join-lines-inside-paragraphs-in-vim
" :call RemoveNewlinesKeepParagraphs
command! RemoveNewlinesKeepParagraphs G:a <bar> <bar> . <bar> :g/^./ .,/^$/-1 join

