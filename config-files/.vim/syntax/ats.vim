" Gokberk note: Vim syntax file for ATS language based on ats file.
"
" Vim syntax file
" Language:     SML
" Filenames:    *.ats *.sig
" Maintainers:  Markus Mottl            <markus.mottl@gmail.com>
"               Fabrizio Zeno Cornelli  <zeno@filibusta.crema.unimi.it>
" URL:          http://www.ocaml.info/vim/syntax/ats.vim
" Last Change:  2006 Oct 23 - Fixed character highlighting bug (MM)
"               2002 Jun 02 - Fixed small typo  (MM)
"               2001 Nov 20 - Fixed small highlighting bug with modules (MM)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" SML is case sensitive.
syn case match

" lowercase identifier - the standard way to match
syn match    atsLCIdentifier /\<\(\l\|_\)\(\w\|'\)*\>/

syn match    atsKeyChar    "|"

" Errors
syn match    atsBraceErr   "}"
syn match    atsBrackErr   "\]"
syn match    atsParenErr   ")"
syn match    atsCommentErr "\*)"
syn match    atsThenErr    "\<then\>"

" Error-highlighting of "end" without synchronization:
" as keyword or as error (default)
if exists("ats_noend_error")
  syn match    atsKeyword    "\<end\>"
else
  syn match    atsEndErr     "\<end\>"
endif

" Some convenient clusters
syn cluster  atsAllErrs contains=atsBraceErr,atsBrackErr,atsParenErr,atsCommentErr,atsEndErr,atsThenErr

syn cluster  atsAENoParen contains=atsBraceErr,atsBrackErr,atsCommentErr,atsEndErr,atsThenErr

syn cluster  atsContained contains=atsTodo,atsPreDef,atsModParam,atsModParam1,atsPreMPRestr,atsMPRestr,atsMPRestr1,atsMPRestr2,atsMPRestr3,atsModRHS,atsFuncWith,atsFuncStruct,atsModTypeRestr,atsModTRWith,atsWith,atsWithRest,atsModType,atsFullMod


" Enclosing delimiters
syn region   atsEncl transparent matchgroup=atsKeyword start="(" matchgroup=atsKeyword end=")" contains=ALLBUT,@atsContained,atsParenErr
syn region   atsEncl transparent matchgroup=atsKeyword start="{" matchgroup=atsKeyword end="}"  contains=ALLBUT,@atsContained,atsBraceErr
syn region   atsEncl transparent matchgroup=atsKeyword start="\[" matchgroup=atsKeyword end="\]" contains=ALLBUT,@atsContained,atsBrackErr
syn region   atsEncl transparent matchgroup=atsKeyword start="#\[" matchgroup=atsKeyword end="\]" contains=ALLBUT,@atsContained,atsBrackErr


" Comments
syn region   atsComment start="(\*" end="\*)" contains=atsComment,atsTodo
syn region   atsCommentL start="//" end="$" contains=atsComment,atsTodo
syn keyword  atsTodo contained TODO FIXME XXX


" let
syn region   atsEnd matchgroup=atsKeyword start="\<let\>" matchgroup=atsKeyword end="\<end\>" contains=ALLBUT,@atsContained,atsEndErr

" local
syn region   atsEnd matchgroup=atsKeyword start="\<local\>" matchgroup=atsKeyword end="\<end\>" contains=ALLBUT,@atsContained,atsEndErr

" abstype
syn region   atsNone matchgroup=atsKeyword start="\<abstype\>" matchgroup=atsKeyword end="\<end\>" contains=ALLBUT,@atsContained,atsEndErr

" begin
syn region   atsEnd matchgroup=atsKeyword start="\<begin\>" matchgroup=atsKeyword end="\<end\>" contains=ALLBUT,@atsContained,atsEndErr

" if
syn region   atsNone matchgroup=atsKeyword start="\<if\>" matchgroup=atsKeyword end="\<then\>" contains=ALLBUT,@atsContained,atsThenErr


"" Modules

" "struct"
syn region   atsStruct matchgroup=atsModule start="\<struct\>" matchgroup=atsModule end="\<end\>" contains=ALLBUT,@atsContained,atsEndErr

" "sig"
syn region   atsSig matchgroup=atsModule start="\<sig\>" matchgroup=atsModule end="\<end\>" contains=ALLBUT,@atsContained,atsEndErr,atsModule
syn region   atsModSpec matchgroup=atsKeyword start="\<structure\>" matchgroup=atsModule end="\<\u\(\w\|'\)*\>" contained contains=@atsAllErrs,atsComment skipwhite skipempty nextgroup=atsModTRWith,atsMPRestr

" "open"
syn region   atsNone matchgroup=atsKeyword start="\<open\>" matchgroup=atsModule end="\<\u\(\w\|'\)*\(\.\u\(\w\|'\)*\)*\>" contains=@atsAllErrs,atsComment

" "structure" - somewhat complicated stuff ;-)
syn region   atsModule matchgroup=atsKeyword start="\<\(structure\|functor\)\>" matchgroup=atsModule end="\<\u\(\w\|'\)*\>" contains=@atsAllErrs,atsComment skipwhite skipempty nextgroup=atsPreDef
syn region   atsPreDef start="."me=e-1 matchgroup=atsKeyword end="\l\|="me=e-1 contained contains=@atsAllErrs,atsComment,atsModParam,atsModTypeRestr,atsModTRWith nextgroup=atsModPreRHS
syn region   atsModParam start="([^*]" end=")" contained contains=@atsAENoParen,atsModParam1
syn match    atsModParam1 "\<\u\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=atsPreMPRestr

syn region   atsPreMPRestr start="."me=e-1 end=")"me=e-1 contained contains=@atsAllErrs,atsComment,atsMPRestr,atsModTypeRestr

syn region   atsMPRestr start=":" end="."me=e-1 contained contains=@atsComment skipwhite skipempty nextgroup=atsMPRestr1,atsMPRestr2,atsMPRestr3
syn region   atsMPRestr1 matchgroup=atsModule start="\ssig\s\=" matchgroup=atsModule end="\<end\>" contained contains=ALLBUT,@atsContained,atsEndErr,atsModule
syn region   atsMPRestr2 start="\sfunctor\(\s\|(\)\="me=e-1 matchgroup=atsKeyword end="->" contained contains=@atsAllErrs,atsComment,atsModParam skipwhite skipempty nextgroup=atsFuncWith
syn match    atsMPRestr3 "\w\(\w\|'\)*\(\.\w\(\w\|'\)*\)*" contained
syn match    atsModPreRHS "=" contained skipwhite skipempty nextgroup=atsModParam,atsFullMod
syn region   atsModRHS start="." end=".\w\|([^*]"me=e-2 contained contains=atsComment skipwhite skipempty nextgroup=atsModParam,atsFullMod
syn match    atsFullMod "\<\u\(\w\|'\)*\(\.\u\(\w\|'\)*\)*" contained skipwhite skipempty nextgroup=atsFuncWith

syn region   atsFuncWith start="([^*]"me=e-1 end=")" contained contains=atsComment,atsWith,atsFuncStruct
syn region   atsFuncStruct matchgroup=atsModule start="[^a-zA-Z]struct\>"hs=s+1 matchgroup=atsModule end="\<end\>" contains=ALLBUT,@atsContained,atsEndErr

syn match    atsModTypeRestr "\<\w\(\w\|'\)*\(\.\w\(\w\|'\)*\)*\>" contained
syn region   atsModTRWith start=":\s*("hs=s+1 end=")" contained contains=@atsAENoParen,atsWith
syn match    atsWith "\<\(\u\(\w\|'\)*\.\)*\w\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=atsWithRest
syn region   atsWithRest start="[^)]" end=")"me=e-1 contained contains=ALLBUT,@atsContained

" "signature"
syn region   atsKeyword start="\<signature\>" matchgroup=atsModule end="\<\w\(\w\|'\)*\>" contains=atsComment skipwhite skipempty nextgroup=atsMTDef
syn match    atsMTDef "=\s*\w\(\w\|'\)*\>"hs=s+1,me=s

syn keyword  atsKeyword  and andalso case
syn keyword  atsKeyword  datatype else eqtype
syn keyword  atsKeyword  exception fn fun handle
syn keyword  atsKeyword  in infix infixl infixr
syn keyword  atsKeyword  match nonfix of orelse
syn keyword  atsKeyword  raise handle type
syn keyword  atsKeyword  val where while with withtype

syn keyword  atsType     bool char exn int list option
syn keyword  atsType     real string unit

syn keyword  atsOperator div mod not or quot rem

syn keyword  atsBoolean      true false
syn match    atsConstructor  "(\s*)"
syn match    atsConstructor  "\[\s*\]"
syn match    atsConstructor  "#\[\s*\]"
syn match    atsConstructor  "\u\(\w\|'\)*\>"

" Module prefix
syn match    atsModPath      "\u\(\w\|'\)*\."he=e-1

syn match    atsCharacter    +#"\\""\|#"."\|#"\\\d\d\d"+
syn match    atsCharErr      +#"\\\d\d"\|#"\\\d"+
syn region   atsString       start=+"+ skip=+\\\\\|\\"+ end=+"+

syn match    atsFunDef       "=>"
syn match    atsRefAssign    ":="
syn match    atsTopStop      ";;"
syn match    atsOperator     "\^"
syn match    atsOperator     "::"
syn match    atsAnyVar       "\<_\>"
syn match    atsKeyChar      "!"
syn match    atsKeyChar      ";"
syn match    atsKeyChar      "\*"
syn match    atsKeyChar      "="

syn match    atsNumber	      "\<-\=\d\+\>"
syn match    atsNumber	      "\<-\=0[x|X]\x\+\>"
syn match    atsReal	      "\<-\=\d\+\.\d*\([eE][-+]\=\d\+\)\=[fl]\=\>"

" Synchronization
syn sync minlines=20
syn sync maxlines=500

syn sync match atsEndSync     grouphere  atsEnd     "\<begin\>"
syn sync match atsEndSync     groupthere atsEnd     "\<end\>"
syn sync match atsStructSync  grouphere  atsStruct  "\<struct\>"
syn sync match atsStructSync  groupthere atsStruct  "\<end\>"
syn sync match atsSigSync     grouphere  atsSig     "\<sig\>"
syn sync match atsSigSync     groupthere atsSig     "\<end\>"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ats_syntax_inits")
  if version < 508
    let did_ats_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink atsBraceErr	 Error
  HiLink atsBrackErr	 Error
  HiLink atsParenErr	 Error

  HiLink atsCommentErr	 Error

  HiLink atsEndErr	 Error
  HiLink atsThenErr	 Error

  HiLink atsCharErr	 Error

  HiLink atsComment	 Comment
  HiLink atsCommentL	 Comment

  HiLink atsModPath	 Include
  HiLink atsModule	 Include
  HiLink atsModParam1	 Include
  HiLink atsModType	 Include
  HiLink atsMPRestr3	 Include
  HiLink atsFullMod	 Include
  HiLink atsModTypeRestr Include
  HiLink atsWith	 Include
  HiLink atsMTDef	 Include

  HiLink atsConstructor  Constant

  HiLink atsModPreRHS	 Keyword
  HiLink atsMPRestr2	 Keyword
  HiLink atsKeyword	 Keyword
  HiLink atsFunDef	 Keyword
  HiLink atsRefAssign	 Keyword
  HiLink atsKeyChar	 Keyword
  HiLink atsAnyVar	 Keyword
  HiLink atsTopStop	 Keyword
  HiLink atsOperator	 Keyword

  HiLink atsBoolean	 Boolean
  HiLink atsCharacter	 Character
  HiLink atsNumber	 Number
  HiLink atsReal	 Float
  HiLink atsString	 String
  HiLink atsType	 Type
  HiLink atsTodo	 Todo
  HiLink atsEncl	 Keyword

  delcommand HiLink
endif

let b:current_syntax = "ats"

" vim: ts=8
