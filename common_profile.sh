#!/bin/bash

#=============================================================================#
#                               USER SECTION                                  #
#=============================================================================#
# Modify this section to customize your shell environment. If you have        #
# ENVIRONMENT specific settings (batch/interactive), put your definitions in  #
# the proper section as described below.                                      #
#=============================================================================#

#=============================================================================#
#                              GLOBAL SETTINGS                                #
#=============================================================================#

# Set up the search path variable.
PATH=$PATH:.
PATH=/usr/local/bin/:$PATH # for cmake newer version
export PATH

# Set up the environment file (edit this file to add aliases and more...).
ENV=$HOME/.kshrc
export ENV

FULLNAME='Adrien Blanchet'
export FULLNAME
ORGANIZATION='LPNHE'
export ORGANIZATION

#=============================================================================#
#                        ENVIRONMENT DEPENDENT SETTINGS                       #
#=============================================================================#

case $ENVIRONMENT in
   BATCH)		# Settings only defined in a batch session.

	# Put here your commands to be run only in a batch session.

	;;

   INTERACTIVE|ACCESS)		# Interactive/Login settings only.

	# Put here your commands to be run only in a login session.

	# Set up the prompt pattern.
	PS1='${PWD}(${?})>'
	export PS1

	# LPD_SERVER and PRINTER are to be used with the "slpr" command to
	# send print jobs on a remote print server. Uncomment the 4 next
	# lines and set proper values.
	#LPD_SERVER=myprinterhost
	#export LPD_SERVER
	#PRINTER=myprinter
	#export PRINTER

	# If you want to modify system default settings for your interactive
	# sessions, this is a good place to do it.
	#PAGER=more
	#MAIL=somewhere
	#EDITOR=vi
	#VISUAL=vi

	;;
esac

#=============================================================================#
#                        CUSTOM USER SETTINGS                                 #
#=============================================================================#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# Prompt Colors
NORMAL='\[\033[00m\]'

LIGHTBLUE='\[\033[1;34m\]'
LIGHTRED='\[\033[1;31m\]'
LIGHTGREEN='\[\033[1;32m\]'

LIGHTGOLD='\[\033[1;33m\]'

BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
RED='\[\033[0;31m\]'
BLUE='\[\033[0;34m\]'

RED_COLOR="$(tput bold)$(tput setaf 1)"
GOLD_COLOR="$(tput bold)$(tput setaf 3)"
GREEN_COLOR="$(tput bold)$(tput setaf 2)"
RESET_COLOR="$(tput sgr 0)$(tput dim)"

export RESTORE='\033[0m'

export RED='\033[00;31m'
export GREEN='\033[00;32m'
export YELLOW='\033[00;33m'
export BLUE='\033[00;34m'
export PURPLE='\033[00;35m'
export CYAN='\033[00;36m'
export LIGHTGRAY='\033[00;37m'

export LRED='\033[01;31m'
export LGREEN='\033[01;32m'
export LYELLOW='\033[01;33m'
export LBLUE='\033[01;34m'
export LPURPLE='\033[01;35m'
export LCYAN='\033[01;36m'
export WHITE='\033[01;37m'

function test_colors(){

  echo -e "${RED}RED ${GREEN}GREEN ${YELLOW}YELLOW ${BLUE}BLUE ${PURPLE}PURPLE ${CYAN}CYAN ${LIGHTGRAY}LIGHTGRAY ${RESTORE}RESTORE"
  echo -e "${LRED}LRED ${LGREEN}LGREEN ${LYELLOW}LYELLOW ${LBLUE}LBLUE ${LPURPLE}LPURPLE ${LCYAN}LCYAN ${WHITE}WHITE ${RESTORE}RESTORE"

}; export -f test_colors

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

################################## PROMPT DISPLAY #################################
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="${LIGHTBLUE}\A ${LIGHTGREEN}\h ${LIGHTGOLD}[\w]\$ ${NORMAL}\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]"
    ;;
*)
    ;;
esac

##PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#${LIGHTBLUE}\t ${LIGHTGREEN}${LIGHTGOLD}${NORMAL}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # Enable colors
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxBxegedabagacad
    alias ls='ls --color=auto'
    alias less='less -r -f'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias l='ls -rt'
alias lll='ls -lrth'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

function cd
{
    builtin cd "$@" && ls -rt
}
# export -f cd
# DO NOT EXPORT THIS FUNCTION. -> for example, make (cmake) will
# use this cd and printout each time its called

################################## Extract function ##################################

# Functions
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xjf $1		;;
			*.tar.gz)	tar xvf $1		;;
			*.bz2)		bunzip2 $1		;;
			*.rar)		rar x $1		;;
			*.gz)		gunzip $1		;;
			*.tar)		tar xf $1		;;
			*.tbz2)		tar xjf $1		;;
			*.tgz)		tar xzf $1		;;
			*.zip)		unzip $1		;;
			*.Z)		uncompress $1	;;
			*)		echo "Please give a valid archive file, for example : extract anything.tar" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}; export -f extract

function rackdel(){

    qdel `seq -f "%.0f" $1 $2`
    return;
}; export -f rackdel

# Setting up programs
function setup_programs(){
  echo "├─ Setting up Programs..." >&2
  ccenv cmake
  echo "   ├─ CMake Version : $(cmake --version | head -n 1)"
  ccenv git
  echo "   ├─ Git Version : $(git --version)"
  ccenv python 3.6.7
  echo "   ├─ Python Version : $(python --version)"
  ccenv gcc 7.3.0
  # ccenv gcc 5.5.0
  source /opt/rh/devtoolset-7/enable
  export CC="$(which gcc)"
  export CXX="$(which g++)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_programs

function setup_old_gcc(){
  ccenv gcc 5.2.0
  # source /opt/rh/devtoolset-6/enable
  export CC="$(which gcc)"
  export CXX="$(which g++)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_old_gcc

function setup_very_old_gcc(){
  ccenv gcc 3.4.6
  # source /opt/rh/devtoolset-3/enable
  export CC="$(which gcc)"
  export CXX="$(which g++)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_old_gcc

function setup_root()
{
  echo "├─ Setting up ROOT..." >&2
  # https://doc.cc.in2p3.fr/soft_liste_des_logiciels_disponibles_au_centre_de_calcul
  # ccenv --list root -> pour récupérer les versions valides
  ccenv root
  # Next line can be mandatory... Check python
  # export PYTHONPATH="$ROOTSYS/lib:$ROOTSYS/lib/python"
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "NOTICE: ROOT has been setup." >&2
  return;
}; export -f setup_root

function setup_geant4()
{
  echo "├─ Setting up Geant4..." >&2
  # https://doc.cc.in2p3.fr/soft_liste_des_logiciels_disponibles_au_centre_de_calcul
  # ccenv --list geant4 -> pour récupérer les versions valides
  ccenv geant4
  echo "   ├─ Geant4 Prefix : $(geant4-config --prefix)"
  echo "   ├─ Geant4 Version : $(geant4-config --version)"

  echo "NOTICE: Geant4 has been setup." >&2
  return;
}; export -f setup_geant4

function cleanup_path()
{
    # echo "Cleaning PATH..." >&2
    # export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
    # echo "Cleaning LD_LIBRARY_PATH..." >&2
    # export LD_LIBRARY_PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{LD_LIBRARY_PATH}))')"
    echo -e "${LYELLOW}Cleaning up PATH...${RESTORE}"
    $(python $REPO_DIR/cclyon_py_tools/scripts/cleanup_path.py PATH)
    echo -e "${LYELLOW}Cleaning up LD_LIBRARY_PATH...${RESTORE}"
    $(python $REPO_DIR/cclyon_py_tools/scripts/cleanup_path.py LD_LIBRARY_PATH)
    return;
}; export -f cleanup_path

function pull_py_tools()
{
  current_path=${PWD}
  builtin cd $REPO_DIR/cclyon_py_tools
  git pull
  builtin cd $current_path
  echo -e "${LYELLOW}CCLyon py tools have been pushed.${RESTORE}"
  return;
}; export -f pull_py_tools

function pull_bash_tools()
{
  current_path=${PWD}
  builtin cd $REPO_DIR/cclyon_bash_tools
  git pull
  builtin cd $current_path
  echo -e "${LYELLOW}CCLyon bash tools have been pushed.${RESTORE}"
  return;
}; export -f pull_bash_tools

# Default software setup
setup_programs
setup_root
setup_geant4

export CC_REPO_DIR="$HOME/work/repo/"

# Seting up python paths for CCLyon
export PATH="$CC_REPO_DIR/cclyon_py_tools/scripts/:$PATH"
export PYTHONPATH="$CC_REPO_DIR/cclyon_py_tools/library/:$PYTHONPATH"

# Aliases
alias root='root -l'
alias quota='fs lq ${HOME}'
alias sizeof='du -h --max-depth=1 | sort -hr'
alias cpu='mpstat -P ALL'
alias repo_cc="cd $CC_REPO_DIR"
