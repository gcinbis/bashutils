# A nice-behaving bashrc header.

# If not running interactively, don't do anything, which is necessary for ssh-based utils like scp.
# If my custom definitions are necessary, use bash -i OR source ~/.bashrc FORCERC
#echo "$-" "$1" # debug
#read -p "dfsa" # debug
[[ ( "$-" != *i* ) && ( "$1" != "FORCERC" ) ]] && return
# echo "Reading .bashrc" # debug

set show-all-if-ambiguous on
#set -o vi
shopt -s cmdhist
shopt -s extglob
shopt -s hostcomplete
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.

# PS1:  
#   http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
#   UBUNTU default: ${debian_chroot:+($debian_chroot)}\u@\h:\w\$
#   FEDORA default: \s-\v\$
export PS1="\h$ "
export PS1="\[\033[G\]$PS1" # fix Ctrl-C annoyance after long commands

stty -ixon # so as not to be disturbed by Ctrl-S ctrl-Q in terminals (https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator)

case "$-" in
*i*)  
    bind 'set completion-ignore-case on' 
    #bind '\C-a:menu-complete'
    bind '\C-p:menu-complete' # just like vim
    #bind '"\M-[A":history-search-backward' # ctrl+A
    #bind '"\M-[B":history-search-forward'
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'
    #echo interactive shell
    ;;
*)   
    #echo not an interactive shell
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# history settings
HISTCONTROL=ignoreboth  # don't put duplicate lines or lines starting with space in the history.
shopt -s histappend     # append to the history file, don't overwrite it
HISTSIZE=1000
HISTFILESIZE=2000

# xterm ansi colors. vi is not 100% compatible.
# echo -e "\e]PcA0A0FF" # blue

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Makefile autocomplete 
# For alternatives: https://stackoverflow.com/questions/4188324/bash-completion-of-makefile-target
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make


