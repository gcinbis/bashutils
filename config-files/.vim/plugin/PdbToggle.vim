" Should work OK on both Python2 and Python3 (Gokberk)
" REFERENE: https://vi.stackexchange.com/questions/10913/elegant-way-to-support-both-python-and-python3-in-vim-plugin

let script_path = expand('<sfile>:p:h') . '/PdbToggle.py'

"if !has('python') and !has('python3')
"   finish
"endif

"execute (has('python3') ? 'py3file' : 'pyfile') script_path

if has('python3') 
   execute 'py3file' script_path
   map <f6> :py3 toggle_breakpoint()<cr>
elseif has('python')
   execute 'pyfile' script_path
   map <f6> :py toggle_breakpoint()<cr>
endif



