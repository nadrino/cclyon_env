#!/bin/bash

#=============================================================================#
#                                T2K SETUP                                    #
#=============================================================================#
# This bash script defines the functions related to the T2K env setup. To get #
# everything setup, run the command "set_t2k_env" which is defined here.      #
#=============================================================================#


function set_t2k_env(){

  # Env variables
  export T2K_SPS_DIR="/sps/t2k/ablanche/"

  export INSTALL_DIR="$T2K_SPS_DIR/install/"
  export BUILD_DIR="$T2K_SPS_DIR/build/"
  export WORK_DIR="$T2K_SPS_DIR/work/"
  export REPO_DIR="$T2K_SPS_DIR/repo/"
  export SCRATCH_DIR="$T2K_SPS_DIR/scratch/"

  export RESULTS_DIR="$WORK_DIR/results/"
  export DATA_DIR="$WORK_DIR/data/"
  export FIGURES_DIR="$WORK_DIR/figures/"
  export JOBS_DIR="$WORK_DIR/jobs/"

  export LOGS_DIR="$JOBS_DIR/logs/"

  # Aliases
  alias sps="cd $T2K_SPS_DIR"
  alias work="cd $WORK_DIR"
  alias repo="cd $REPO_DIR"
  alias res="cd $RESULTS_DIR"
  alias logs="cd $LOGS_DIR"
  alias fig="cd $FIGURES_DIR"

  # Python
  export PYTHONPATH="$REPO_DIR/cclyon_py_tools/library/:$PYTHONPATH"
  export PATH="$REPO_DIR/cclyon_py_tools/scripts/:$PATH"
  alias job="jobs.py"

  # Bash
  export PATH="$REPO_DIR/cclyon_bash_tools/bin/:$PATH"

  export T2K_ENV_IS_SETUP="1"

  link_t2k_soft
  set_t2k_irods
  # setup_brew
  # set_brew_root
  set_t2k_root

  cleanup_env

  echo "$(tput bold)$(tput setaf 3)NOTICE: T2K env has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}; export -f set_t2k_env


function set_t2k_root(){
  echo "├─ Setting up ROOT (Recompiled for T2K projects)..." >&2

  if [ -z ${T2K_ENV_IS_SETUP+x} ];
  then
    echo "T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  export PATH="$INSTALL_DIR/root/bin/:$PATH"
  source $INSTALL_DIR/root/bin/thisroot.sh

  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo -e "${LYELLOW}NOTICE: ROOT (T2K) has been setup.${RESTORE}" >&2
  return;
}; export -f set_t2k_root

function set_brew_root(){
  echo "├─ Setting up ROOT (Brew)..." >&2

  if [ -z ${BREW_ENV_IS_SETUP+x} ];
  then
    echo "BREW_ENV_IS_SETUP is not set. Please run setup_brew first.";
    return;
  fi

  . /sps/t2k/ablanche/linuxbrew/bin/thisroot.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo -e "${LYELLOW}NOTICE: ROOT (Brew) has been setup.${RESTORE}" >&2
  return;
}; export -f set_brew_root


function link_t2k_soft()
{
  current_path=${PWD}

  if [ -z ${T2K_ENV_IS_SETUP+x} ];
  then
    echo "$T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  echo "Linking libs in $INSTALL_DIR"
  for dir in $INSTALL_DIR/*/     # list directories in the form "/tmp/dirname/"
  do
      dir=${dir%*/}      # remove the trailing "/"
      sub_folder=${dir##*/} # print everything after the final "/"
      export PATH="$INSTALL_DIR/$sub_folder/bin:$PATH"
      export LD_LIBRARY_PATH="$INSTALL_DIR/$sub_folder/lib:$LD_LIBRARY_PATH"
      echo "   ├─ Adding : $sub_folder"
  done

  # custom setup files
  source $INSTALL_DIR/xsLLhFitter/setup.sh &> /dev/null
  # alias readlink="/usr/local/bin/greadlink" # fix readlink on mac
  source $REPO_DIR/xsLLhFitter/setup.sh &> /dev/null

  echo "$(tput bold)$(tput setaf 3)NOTICE: T2K libs have been setup.$(tput sgr 0)$(tput dim)" >&2

  builtin cd $current_path

}; export -f link_t2k_soft

function setup_brew(){
  cur_dir="$PWD"

  # Cleaning env
  export PATH="/usr/bin" # cd, ls...
  export PATH="/opt/sge/bin/lx-amd64/:$PATH" # for qsub
  export LD_LIBRARY_PATH=""

  # Set brew env
  eval $($HOME/.linuxbrew/bin/brew shellenv)
  export PATH="$HOME/.linuxbrew/opt/python/libexec/bin/:$PATH"

  # Debug options
  # export HOMEBREW_DEBUG=1
  # export HOMEBREW_DEBUG_INSTALL=1
  export HOMEBREW_VERBOSE=1

  # Parameters
  export HOMEBREW_BUILD_FROM_SOURCE=1
  export HOMEBREW_MAKE_JOBS=4

  # Scratch
  export HOMEBREW_TEMP=$SCRATCH_DIR
  export HOMEBREW_CACHE=$SCRATCH_DIR
  export HOMEBREW_LOGS=$SCRATCH_DIR/logs

  export BREW_ENV_IS_SETUP=1

  # Reset the t2k env
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: Brew env has been setup.${RESTORE}"
  return;
}; export -f setup_brew

function set_t2k_irods(){
  cur_dir="$PWD"
  builtin cd $REPO_DIR/irods-legacy/iRODS
  source ./add-clients.sh &> /dev/null
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: T2K iRODS has been setup.${RESTORE}"
  return;
}; export -f set_t2k_irods

function set_t2k_cvs(){
  cur_dir="$PWD"
  export CVSROOT=":ext:anoncvs@repo.nd280.org:/home/trt2kmgr/ND280Repository"
  source $REPO_DIR/nd280-cvs/CMT/v*/mgr/setup.sh
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: T2K CVS has been setup.${RESTORE}"
  return;
}; export -f set_t2k_cvs

function set_t2k_psyche(){
  cur_dir="$PWD"
  set_t2k_cvs
  export CMTPATH="$REPO_DIR/nd280-cvs/Highland2_HEAD"
  source $CMTPATH/nd280Psyche/v*/cmt/setup.sh
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: T2K Psyche has been setup.${RESTORE}"
  return;
}; export -f set_t2k_psyche

function set_t2k_highland2(){
  cur_dir="$PWD"
  set_t2k_cvs
  export CMTPATH="$REPO_DIR/nd280-cvs/Highland2_HEAD"
  source $CMTPATH/nd280Highland2/v*/cmt/setup.sh
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: T2K Highland2 has been setup.${RESTORE}"
  return;
}; export -f set_t2k_highland2

function set_t2k_neut(){
  cur_dir="$PWD"
  # source $INSTALL_DIR/neut/setup.sh
  export NEUT=$INSTALL_DIR/neut
  export PATH=$NEUT/bin:$PATH
  export LD_LIBRARY_PATH=$NEUT/lib:$LD_LIBRARY_PATH
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: T2K NEUT has been setup.${RESTORE}"
  return;
}; export -f set_t2k_neut

function set_t2k_CERNLIB(){
  cur_dir="$PWD"
  set_t2k_cvs
  export CERN="/sps/t2k/ablanche/repo/nd280-cvs/Highland2_HEAD/CERNLIB/v2005r6/Linux-x86_64"
  export CERN_LEVEL=2005
  export CERN_ROOT=$CERN/$CERN_LEVEL
  export CERNLIB=$CERN_ROOT/lib
  export CERNLIBDIR=$CERNLIB
  export CERNPATH=$CERNLIB
  export PATH=$CERN_ROOT/bin:$PATH
  export LD_LIBRARY_PATH=$CERNLIB:$LD_LIBRARY_PATH
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: T2K CERNLIB has been setup.${RESTORE}"
  return;
}; export -f set_t2k_CERNLIB

function set_t2k_T2KReWeight(){
  cur_dir="$PWD"
  setup_old_gcc
  # For analysis tools
  set_t2k_highland2
  # For enabling psyche
  set_t2k_psyche
  # For enabling CERNLIB
  set_t2k_CERNLIB
  # For enabling NEUT
  set_t2k_neut

  # NIWG
  export NIWG=$REPO_DIR/NIWGReWeight/
  export LD_LIBRARY_PATH=${NIWG}:$LD_LIBRARY_PATH;
  export NIWGREWEIGHT_INPUTS=${NIWG}/inputs

  export T2KREWEIGHT=$REPO_DIR/T2KReWeight
  export PATH=$T2KREWEIGHT/bin:$PATH:$T2KREWEIGHT/app:$ROOTSYS/bin:$PATH;
  export LD_LIBRARY_PATH=$T2KREWEIGHT/lib:$LD_LIBRARY_PATH;

  # For JReweight
  export JNUBEAM=$REPO_DIR/t2k-cvs/GlobalAnalysisTools/JReWeight
  export LD_LIBRARY_PATH=$JNUBEAM:$LD_LIBRARY_PATH;
  cleanup_env
  builtin cd $cur_dir
  echo -e "${LYELLOW}NOTICE: T2K T2KReWeight has been setup.${RESTORE}"
  return;
}; export -f set_t2k_T2KReWeight


function pull_xsllhFitter()
{
  current_path=${PWD}
  builtin cd $REPO_DIR/xsllhFitter
  git pull
  builtin cd $current_path
  echo -e "${LYELLOW}xsllhFitter has been pulled.${RESTORE}"
  return;
}; export -f pull_xsllhFitter
