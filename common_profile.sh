#! /bin/bash

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

export FULLNAME='Adrien Blanchet'
export ORGANIZATION='LPNHE'

export INDENT_SPACES="  "

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

export INFO="$LGREEN<Info>$RESTORE"
export WARNING="$LYELLOW<Warning>$RESTORE"
export ERROR="$LRED<Error>$RESTORE"
export ALERT="$LPURPLE<Alert>$RESTORE"

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

  if [[ $machineName =~ "login2.baobab" ]];
  then
    #https://doc.eresearch.unige.ch/hpc/applications_and_libraries
    # module load GCC # ROOT HANDLED

    echo "Loading ROOT module"
    ml load GCC/11.2.0
    ml load OpenMPI/4.1.1
    module load ROOT

    echo "Loading yaml-cpp module"
    ml load GCCcore/11.3.0
    module load yaml-cpp/0.7.0

    echo "Loading other modules..."
    module load nlohmann_json

    module load Python
    module load CMake
    module load git
    module load CUDA
    ml load Geant4
  else
    ccenv cmake 3.20.2
    ccenv git
    ccenv curl
    ccenv python
    ccenv geant4 10.03.p03
    setup_gcc7
    # setup_gcc10
    # ccenv gcc 7.3.0
    # ccenv gcc 5.5.0
    # source /opt/rh/devtoolset-7/enable
    # export CC="$(which gcc)"
    # export CXX="$(which g++)"
    # echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
  fi

  echo "   ├─ CMake Version : $(cmake --version | head -n 1)"
  echo "   ├─ Git Version : $(git --version)"
  echo "   ├─ curl Version : $(curl --version)"
  echo "   ├─ Python Version : $(python --version)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_programs


function setup_gcc10(){
  ccenv gcc 10.3.0
  # source /opt/rh/devtoolset-7/enable
  export CC="$(which gcc)"
  export CXX="$(which g++)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_gcc10

function setup_gcc7(){
  ccenv gcc 7.3.0
  source /opt/rh/devtoolset-7/enable
  export CC="$(which gcc)"
  export CXX="$(which g++)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_gcc7

function setup_old_gcc(){
  ccenv gcc 5.2.0
  # source /opt/rh/devtoolset-6/enable
  export CC="$(which gcc)"
  export CXX="$(which g++)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_old_gcc

function setup_brew_gcc(){
  # ccenv gcc 5.2.0
  # source /opt/rh/devtoolset-6/enable
  export CC="$(brew --prefix gcc)/bin/gcc"
  export CXX="$(brew --prefix gcc)/bin/g++"
  echo "   ├─ GCC Version : $("$(brew --prefix gcc)/bin/gcc" --version | head -n 1)"
}; export -f setup_brew_gcc

function setup_brew_gcc7(){
  # ccenv gcc 5.2.0
  # source /opt/rh/devtoolset-6/enable
  export CC="$(which gcc-7)"
  export CXX="$(which g++-7)"
  echo "   ├─ GCC Version : $(gcc-7 --version | head -n 1)"
}; export -f setup_brew_gcc7

function setup_brew_gcc8(){
  # ccenv gcc 5.2.0
  # source /opt/rh/devtoolset-6/enable
  export CC="$(which gcc-8)"
  export CXX="$(which g++-8)"
  echo "   ├─ GCC Version : $(gcc-8 --version | head -n 1)"
}; export -f setup_brew_gcc8

function setup_very_old_gcc(){
  ccenv gcc 3.4.6
  # source /opt/rh/devtoolset-3/enable
  export CC="$(which gcc)"
  export CXX="$(which g++)"
  echo "   ├─ GCC Version : $(gcc --version | head -n 1)"
}; export -f setup_old_gcc


function setup_root_gcc7()
{
  echo "├─ Setting up ROOT gcc7..." >&2
  # https://doc.cc.in2p3.fr/soft_liste_des_logiciels_disponibles_au_centre_de_calcul
  # ccenv --list root -> pour récupérer les versions valides
  ccenv root 6.18.04_gcc73
  . $(root-config --prefix)/bin/thisroot.sh

  # Next line can be mandatory... Check python
  # export PYTHONPATH="$ROOTSYS/lib:$ROOTSYS/lib/python"
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo -e "${INFO} ROOT gcc7 has been setup."
  return;
}; export -f setup_root_gcc7

function setup_root()
{
  echo "├─ Setting up ROOT..." >&2

  setup_gcc7 # | (while read; do echo "${INDENT_SPACES}$REPLY"; done)
  # https://doc.cc.in2p3.fr/soft_liste_des_logiciels_disponibles_au_centre_de_calcul
  # ccenv --list root -> pour récupérer les versions valides
  ccenv root
  . $(root-config --prefix)/bin/thisroot.sh

  # Next line can be mandatory... Check python
  # export PYTHONPATH="$ROOTSYS/lib:$ROOTSYS/lib/python"
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo -e "${INFO} ROOT has been setup."
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

  echo -e "${INFO} Geant4 has been setup."
  return;
}; export -f setup_geant4

function cleanup_env()
{
    # echo "Cleaning PATH..." >&2
    # export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
    # echo "Cleaning LD_LIBRARY_PATH..." >&2
    # export LD_LIBRARY_PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{LD_LIBRARY_PATH}))')"
    echo -e "${WARNING} Cleaning up PATH..."
    $(python $REPO_DIR/cclyon_py_tools/scripts/cleanup_env.py PATH)
    echo -e "${WARNING} Cleaning up LD_LIBRARY_PATH..."
    $(python $REPO_DIR/cclyon_py_tools/scripts/cleanup_env.py LD_LIBRARY_PATH)
    return;
}; export -f cleanup_env

function pull_cc_root_macros()
{
  echo -e "${ALERT} Pulling CCLyon root macros..."
  local current_path=${PWD}
  builtin cd $CC_ROOT_MACROS
  git pull
  git submodule update --recursive --remote
  # ln -s $REPO_DIR/cclyon_root_macros/logon/rootrc $HOME/.rootrc
  builtin cd $current_path
  echo -e "${INFO} CCLyon root macros have been pulled."
  return;
}; export -f pull_cc_root_macros

function pull_cc_py_tools()
{
  echo -e "${ALERT} Pulling CCLyon py tools..."
  local current_path=${PWD}
  builtin cd $CC_PY_TOOLS
  git pull
  git submodule update --recursive --remote
  builtin cd $current_path
  echo -e "${INFO} CCLyon py tools have been pulled."
  return;
}; export -f pull_cc_py_tools

function pull_cc_bash_tools()
{
  echo -e "${ALERT} Pulling CCLyon bash tools..."
  builtin cd $CC_BASH_TOOLS
  git pull
  git submodule update --recursive --remote
  builtin cd $current_path
  echo -e "${INFO} CCLyon bash tools have been pulled."
  return;
}; export -f pull_cc_bash_tools

function qLogin(){
  echo -e "${ALERT} Connecting to worker..."
  if [ -z ${1+x} ];
  then
    echo "nb_cores is unset -> Single core";
    set -x
    srun -p htc_interactive -L sps --pty bash -i
    set +x
  else
    echo "nb_cores is set to '$1'";
    set -x
    srun -p htc_interactive -L sps -c $1 --pty bash -i
    set +x
  fi
}

function qLoginGpu(){
  echo -e "${ALERT} Connecting to GPU worker..."
  if [ -z ${1+x} ];
  then
    echo "nb_cores is unset -> Single core";
    set -x
    srun -p gpu_interactive -L sps --gres=gpu:v100:1 --pty bash -i
    set +x
  else
    echo "nb_cores is set to '$1'";
    set -x
    srun -p gpu_interactive -L sps -c $1 --gres=gpu:v100:1 --pty bash -i
    set +x
  fi
}

function nd280Env(){
  source /etc/profile.d/modules.sh

  # module add Compilers/gcc/9.3.1
  # source /opt/rh/devtoolset-9/enable  # module add gcc
  module add Compilers/gcc/4.9.1
  source /opt/rh/devtoolset-3/enable # yes it is the version 4
  export CC="$(which gcc)"
  export CXX="$(which g++)"

  module unload Programming_Languages/python && module add Programming_Languages/python/2.7.15

  ccenv root 5.34.38
  source $ROOTSYS/bin/thisroot.sh
  unset CMAKE_PREFIX_PATH
}

function nd280Env2(){
  nd280Env

  export NDSOFT="/sps/t2k/ablanche/repo/nd280"
  export ND280_NJOBS=4

  cd $NDSOFT/
  git clone https://git.t2k.org/nd280/pilot/nd280SoftwarePilot.git
  cd $NDSOFT/nd280SoftwarePilot
  ./configure.sh
  source nd280SoftwarePilot.profile

  cd $NDSOFT/
  git clone https://git.t2k.org/nd280/highland2Software/highland2SoftwarePilot.git
  cd $NDSOFT/highland2SoftwarePilot
  source highland2SoftwarePilot.profile

  highland-install -c -r 2.67
  # ccenv root 5.34.38
  # source $ROOTSYS/bin/thisroot.sh

  cd $NDSOFT
  highland_set_use_psycheROOT -r psycheROOT

  cd $NDSOFT/psycheMaster_3.69/
  module add cmake
  mkdir Linux-CentOS_7-gcc_4.9-x86_64
  cd Linux-CentOS_7-gcc_4.9-x86_64

  cmake ../cmake
  source ../bin/makeAll.sh
}

function setPsyche(){
  source /sps/t2k/ablanche/repo/nd280/psycheMaster_3.69/bin/setup.sh
}

function logPrint(){
  if [[ $1 == *.sh ]]
  then
   logTempFile="${1%.sh}.log"
   logFile="${logTempFile/Script_/log_}"
   tail -n +1 -f $LOGS_DIR/*/$logFile
  else
    tail -n +1 -f $LOGS_DIR/*/$1
  fi
}

alias nextcloud='cadaver https://nextcloud.nms.kcl.ac.uk/remote.php/dav/files/ASGReader'

# Default software setup
setup_programs
# setup_root
# setup_geant4

# Aliases
alias root='root -l'
alias quota='fs lq ${HOME}'
alias sizeof='du -h --max-depth=1 | sort -hr'
alias cpu='mpstat -P ALL'
alias monitoring='watch -c -n 0.5 jobSlurm.py'
alias ccat='pygmentize -g'

shopt -s direxpand # fixes tab while env variable
