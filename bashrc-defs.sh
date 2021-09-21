# A set of useful aliases 
# Load this file from .bashrc via source <path>/bashutils-aliases

# ==============================
# bash main functionality
# ==============================

# for quick browsing
function cd() {
    if [ "$PS1" ]
    then
        if [ "$1" ]
        then builtin cd "$1" && ls
        else builtin cd && ls 
        fi
    else
        if [ "$1" ]
        then builtin cd "$1"
        else builtin cd
        fi
    fi
}

function d() {
    if [ "$1" ]
    then builtin cd "$1"
    else builtin cd
    fi
}

# was color=tty, changing to color=always
alias ls='/bin/ls'
unalias ls
eval `dircolors $HOME/.dircolors` # avoid ORPHAN check for symlinks.
if [ $(command uname -s) == "Mac" ] || [ $(command uname -s) == "Darwin" ]; then
    function ls() {
        # see notes for the linux case below
        # old: /bin/ls -G $*
        local args=("$@")  # preserves ".." groups
        eval /bin/ls -G "${args[@]}"
    }
else
    # Test with something like ls file1withspaces file2withspaces
    function ls() {
        #not good with spaces: /bin/ls --color=always -C --width=$COLUMNS $* | less -RFX # stalls on nfs failure due to color option.
        #not good with multiple files: /bin/ls --color=always -C --width=$COLUMNS "$*" | less -RFX # stalls on nfs failure due to color option.
        local args=("$@")  # preserves ".." groups
        /bin/ls --color=always -C --width=$COLUMNS "${args[@]}" | less -RFX # stalls on nfs failure due to color option.
    }
fi

# ls shortcuts
alias l='ls -alh'
alias lt='ls -alh -t' # sort by mod time
alias lT='ls -alh -tr' # sort by mod time (reverse order)
alias lst='ls -tr -1' # sort by mod time
alias ll='ls -lh'
alias lf="ls -l | egrep -v '^d'"
alias ldir="ls -l | egrep '^d'"
alias ln='ln -s'

# simple commands (define these early)
alias cp='cp -i'
alias mv='mv -i'
alias c='clear'
alias rm='rm -i'
alias tar='tar -k' # do not overwrite

# ==============================
# git
# ==============================

# git, also see home-config/bin
# add the prefix __ to keep bash autocomplete easy-to-use.
# In case of cryptic 'git pull' problems, it is a good idea to try 'git fetch' first.
alias __gitsync='(git reset && git add . && git-commit-silent && echo "git pull & push" && git pull && git push)' # pull and send
alias __gitsync-nomsg='(git reset && git add . && git-commit-silent-nomsg && echo "git-pull-nomsg & git push" && git-pull-nomsg && git push)' # pull and send
alias gitsyncroot='(command cd `git-print-root-path` && __gitsync)' 
alias gitsyncroot-nomsg='(command cd `git-print-root-path` && __gitsync-nomsg)' 
alias gitcom='(git add . && git commit)' # commit only
alias gitcom-nomsg='(git add . && git-commit-silent-nomsg)' # commit only
alias gitdot='(git add . && git commit && git push)' # commit & push only
alias gitdot-nomsg='(git add . && git-commit-silent-nomsg && git push)' # commit & push only
alias gitdotroot='(command cd `git-print-root-path` && git add . && git commit && git push)' # commit & push only 
alias git-ls-other='git ls-files --other' # list ignored/unknown/new files
alias git-ls-gitignore='git ls-files --ignored --exclude-standard' # list .gitignore files
alias git-revert-file='git checkout --'
alias git-config-filemodeoff='(git config --global core.filemode false && git config core.filemode false)'
alias git-config-vimdiff='(git config --global diff.tool vimdiff && git config --global merge.tool vimdiff && git config --global difftool.prompt false)'
alias git-config-mergetool='(git config merge.tool vimdiff && git config merge.conflictstyle diff3 && git config mergetool.prompt false)'
alias git-url='git remote -v'
alias git-difftool-prev='git difftool HEAD@{1}'
alias git-undo-previous-commit-without-changing-anything-else='git reset --soft HEAD^' # this remembers "git add" and similar commands. The working directory is untouched: http://stackoverflow.com/questions/2845731/how-to-uncommit-my-last-commit-in-git
alias git-undo-previous-commit-and-stage-file-without-changing-anything-else='git reset HEAD^' # the work directory is untouched: http://stackoverflow.com/questions/3528245/whats-the-difference-between-git-reset-mixed-soft-and-hard
alias git-unstage-and-rm-from-index-keep-local-files-asis='git rm --cached -r' # git rm --cached -r <dirname>, git rm --cached <filename>. Good for files being tracked due to a previous commit, and if you now want to git-ignore them.
alias git-commit-silent='git diff-index --quiet HEAD || git commit' # no error signal if there is nothing to commit
function git-commit-silent-nomsg() {
    d=`command date +%Y%m%d`
    t=`command date +%H.%M.%S` # hour.minute.seconds (dots are useful for time, otherwise very unreadible)
    #host=`command hostname`
    #msg_="$host-$d-$t" # -- host can be sensitive, avoid it --
    msg_="NoMessage-$d-$t" # -- host can be sensitive, avoid it --
    git diff-index --quiet HEAD || git commit -m "$msg_" # no error signal if there is nothing to commit
}
alias git-pull-nomsg='git pull --no-edit'
alias git-log-stat='git log --stat'
alias git-branch-ls-all='git branch --list -a -vv' # -vv is for local-remote tracking relations
alias git-branch-ls-commitdates="git for-each-ref --color=auto --sort=committerdate refs/ --format='%(color:red) %(refname:lstrip=2) %(committerdate:short) %(color:blue) ->[%(upstream)] %(color:yellow) \"%(contents:subject)\"'"
alias git-branch-create='git switch --create' # git switch --create <branch_name> 
alias git-print-root-path='git rev-parse --show-toplevel'
alias git-cd-root-path='command echo cd `git-print-root-path` && command cd `git-print-root-path`'
alias git-pushd-root-path='command echo pushd `git-print-root-path` && command pushd `git-print-root-path`'
alias git-du='(echo "* Calculating approximate .git directory size (after housekeeping)" && git-cd-root-path && git gc && du -sh .git)'

# ==============================
# GNU screen, tmux
# ==============================

alias screennew='/usr/bin/screen -S';
#alias screennew2='/usr/bin/screen -c $HOME/.screenrc2 -S';  # create a .screenrc with just a different "escape" (ctrl-A) to use "screen inside screen" easily.
alias screen='/usr/bin/screen -dr';

alias txnew='tmux new -s' # followed by new session name
function tx() {
    if [[ $# = 0 ]] 
    then
        tmux ls
        echo ""
        echo "- USAGE: \"tx [session-name]\" (attach a session) | \"tx\" (list sessions)"
    else
        tmux attach -t "$1"
    fi
}

function tx-detachothers() {
    if [[ $# = 0 ]] 
    then
        tmux ls
        echo ""
        echo "- USAGE: \"tx [session-name]\" (attach a session) | \"tx\" (list sessions)"
        echo "Detaches other clients"
    else
        tmux attach -d -t "$1"
    fi
}

function txcolours() {
    # https://superuser.com/questions/285381/how-does-the-tmux-color-palette-work/285400
    # for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"; done
    for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done
}

# ==============================
# ctags
# ==============================

alias ctags='ctags --tag-relative=yes'

# programming files (these variables affect many functions/aliases)
FILES_CPP=' *.c *.h *.cpp *.hpp *.cc *.hh *.cu '
FILES_WEB=' *.js *.html *.xhtml *.htm *.css *.json *.xml *.md *.yml '
FILES_SRC=' *.lua *.m *.bat *.sh *.txt *.proto *.prototxt *.java *.tex *.sty *.lyx *.nb *.bib *.py *.f README TODO CHANGELOG Makefile '$FILES_CPP$FILES_WEB

# Convert files to a form accepted by find()
function files_to_find()
{
    #trim left,trim right and replace
    local x=`echo "$1" | perl -pe "s/^ //;s/ $//;s/ /\" -print0 -o -name \"/g"`
    x=" -name \""$x"\" -print0 "
    echo "$x"
}

FINDF_CPP=`files_to_find "$FILES_CPP"`
FINDF_WEB=`files_to_find "$FILES_WEB"`
FINDF_CTAGS=`files_to_find "$FILES_CPP *.m *.js *.py"` # c++,matlab,jscript,python.
FINDF_SRC=`files_to_find "$FILES_SRC"`

# ctags
alias ct='find . '$FINDF_CTAGS' | xargs -0 ctags &' 

# ==============================
# vim
# ==============================

: "${VIM_DEFAULT:=vim}"
alias vim="$VIM_DEFAULT -p"
alias gvim='gvim -p'
alias vi="$VIM_DEFAULT -p"

# files with matching content under all subdirs with a particular name & content pattern.
# also see the script "vip".
function vifind() {
    if [ $# -ne 2 ]; then
        echo "Search all files under all subdirectories with a particular name pattern and a grep pattern"
        echo "Example: vmfind \"*.cpp\" mxGetData"
        return;
    fi
    vim `find . -iname "$1" -print0 | xargs -0 grep -sil $2`
}

# ==============================
# OS tools
# ==============================

# os tools. dont user $USERNAME, instead use $USER.
alias pstreeapp="pstree $USER -p | grep -iB2"
alias kill='kill -s KILL'
alias sigstop='/usr/bin/kill -s SIGSTOP' # pause process
alias sigcont='/usr/bin/kill -s SIGCONT' # continue process
alias sigkeyb='/usr/bin/kill -s SIGUSR1' # In matlab, this is catched by cinbis_sigkeyb()
alias numcpu='cat /proc/cpuinfo | grep proc | wc -l'
alias readrc='source ~/.bashrc'
alias uname='uname -a'
alias free='free -m'
alias lsdisplays="w -oush | grep -Eo ' :[0-9]+' | uniq | cut -d \  -f 2" # list all DISPLAY options. (https://unix.stackexchange.com/questions/17255/is-there-a-command-to-list-all-open-displays-on-a-machine)

# disk usage
alias df='df -h'
alias du='du -h'
alias quota='quota -s'
alias meminfo='more /proc/meminfo'

# environment variables
alias printpath='echo $PATH | sed "y/:/\n/"'
alias printldlibpath='echo $LD_LIBRARY_PATH | sed "y/:/\n/"'

# print various info about a process.
function procstatus() {
    cat "/proc/$1/status" | grep VmPeak # peak virtual memory size
    cat "/proc/$1/status" | grep VmSize # current virtual memory size
    cat "/proc/$1/status" | grep VmRSS  # resident set size
}

# print progress of dd operations without halting.
if [ $(command uname -s) == "Mac" ] || [ $(command uname -s) == "Darwin" ]; then
    alias print_dd_progress='sudo /bin/kill -INFO $(pgrep ^dd$)' 
elif [ $(command uname -s) == "Linux" ]; then
    alias print_dd_progress='/bin/kill -USR1 $(pgrep ^dd$)'
fi

export KMP_DUPLICATE_LIB_OK=true 

# ==============================
# files and directories
# ==============================

# find
alias find='find -L'
alias find_symlinks='find -P -type l'

# compare directories diffdir path1 path2
alias diffdir='diff --recursive --brief'
# alternatively:
# find <directory> -name "*.*" > xargs ls -al 

# archive
alias tarnow='tar -czf `date +%Y-%m-%d-%H-%M-%S`.tar.gz'
alias tarlistgz='tar -ztvf' # list contents
alias tarlist='tar -tvf' # list contents

# ==============================
# grep
# ==============================

alias grep='grep --color=auto'

# ==============================
# rsyncauto
# ==============================

# rsync <local> user@<host>:path
# rsync user@<host>:path <local>
# Beware:
#   rsync is sometimes slow with very large files.  Consider using "split & scp & md5sum" OR "split & httpd &
#   aria2c" to transfer with care. (scp is not that slow, but single-threaded and can't resume). aria2c can
#   resume failed downloads, which is a major advantage. bbcp looks promising as well.  
# Use these additional options when needed::
#   --partial   To keep temp files after transfer is interrupted.
#   --append    To resume an interrupted transfer. Safe to use.
#   --checksum  To update a few blocks of already-downloaded files. Inefficient when downloading a completely
#               new file. Can be used to verify equivalence. See:
#               http://unix.stackexchange.com/questions/48298/can-rsync-resume-after-being-interrupted
alias rsync-dry='rsync --progress --stats --dry-run -avzhe ssh' # for custom port: -avzhe "ssh -p PortNumber"
alias rsync-run='rsync --progress  --stats -avzhe ssh'
alias rsync-del-dry='rsync --progress --stats --dry-run --delete -avzhe ssh' # delete remote surplus files 
alias rsync-del-run='rsync --progress --stats --delete -avzhe ssh'
alias rsync-norecurse-run='rsync --progress --stats -a --no-r -vzhe ssh'
alias rsync-norecurse-dry='rsync --progress --stats --dry-run -a --no-r -vzhe ssh'
alias rsync-mv-dry='rsync --progress --stats --dry-run --remove-source-files -avzhe ssh'
alias rsync-mv-run='rsync --progress --stats --remove-source-files -avzhe ssh'

# ==============================
# job management 
# ==============================
# 
# alias jobs='jobs -l'
# 
# # kill the job with jobspec (like the job id)
# function killjob() {
#     kill `jobs -p "$*"` 
# }

# ==============================
# matlab
# ==============================

# matlab
export MATLABNOJVM="matlabwrapper -nodesktop -nosplash -nojvm"
alias matlabgui="matlabwrapper"  
alias matlabjvm="matlabwrapper -nodesktop -nosplash"
alias matlabnojvm="$MATLABNOJVM"
alias matlab=$MATLABNOJVM # set default matlab option
# alias findmfiles='find . -name "*.m" -print0 | xargs -0 grep' # usage: findmfiles merhaba

# ==============================
# LyX
# ==============================

alias lyx2pdf='lyx -e pdf2'
alias lyx2tex='lyx -e pdflatex'

# ==============================
# Networking & HTTP
# ==============================

alias localip='/sbin/ifconfig|grep addr'
alias myhtpasswd='htpasswd -c .htpasswd'
alias pyhttp='python -m SimpleHTTPServer 9914' # shares current directory

# ssh
alias sshprivate2public='ssh-keygen -y -e -f' # sshprivate2public <id_rsa_file>
#alias ssh='ssh -o PasswordAuthentication=yes'
#alias ssho='/usr/bin/ssh';
#alias sshx='ssh -c arcfour,blowfish-cbc -XC'

# ==============================
# ENCFS
# ==============================

function lsencfs() {
    if [ $(command uname -s) == "Mac" ] || [ $(command uname -s) == "Darwin" ]; then
        command mount | grep -i encfs
    elif [ $(command uname -s) == "Linux" ]; then
        # mount | grep -i encfs
        # findmnt | grep encfs
        # df -h --output=source,target | grep encfs
        cat /proc/mounts | grep encfs
    fi
}

# ==============================
# python, anaconda
# ==============================

alias jupyter2py='jupyter nbconvert --to script' # jupyter2py <file.ipynb>

function conda-custom-activate() {
    # adapted from the lines added by anaconda installer into .bashrc
    if [ $# -ne 1 ]; then
        echo Incorret number of arguments. Pass only the path to anaconda root.
        echo EXAMPLE: conda-custom-activate $HOME/anaconda3
        return;
    fi

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$("$1/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
    eval "$__conda_setup"
    else
    if [ -f "$1/etc/profile.d/conda.sh" ]; then
        . "$1/etc/profile.d/conda.sh"
    else
        export PATH="$1/bin:$PATH"
    fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}

# better debugging: install pdbpp


