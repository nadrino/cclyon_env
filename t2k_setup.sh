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

  echo "$(tput bold)$(tput setaf 3)NOTICE: T2K env has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}; export -f set_t2k_env


function setup_root_t2k(){
  echo "├─ Setting up ROOT (Recompiled for T2K projects)..." >&2

  if [ -z ${T2K_ENV_IS_SETUP+x} ];
  then
    echo "$T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  export PATH="$INSTALL_DIR/root/bin/:$PATH"
  source $INSTALL_DIR/root/bin/thisroot.sh

  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "NOTICE: ROOT (T2K) has been setup." >&2
  return;
}; export -f setup_root_t2k

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
  source $INSTALL_DIR/xsLLhFitter/setup.sh
  alias readlink="/usr/local/bin/greadlink" # fix readlink on mac
  source $REPO_DIR/xsLLhFitter/setup.sh

  echo "$(tput bold)$(tput setaf 3)NOTICE: T2K libs have been setup.$(tput sgr 0)$(tput dim)" >&2

  builtin cd $current_path

  cleanup_path

}; export -f link_t2k_soft

function set_t2k_irods(){
  cur_dir="$PWD"
  builtin cd $REPO_DIR/irods-legacy/iRODS
  source ./add-clients.sh
  builtin cd $cur_dir
  echo "${LYELLOW}T2K iRODS has been setup.${RESTORE}"
  return;
}; export -f set_t2k_irods

function set_t2k_highland2(){
  cur_dir="$PWD"
  export CVSROOT=":ext:anoncvs@repo.nd280.org:/home/trt2kmgr/ND280Repository"
  source $REPO_DIR/nd280-cvs/CMT/v*/mgr/setup.sh
  export CMTPATH="$REPO_DIR/nd280-cvs/Highland2_HEAD"
  source $CMTPATH/nd280Highland2/v*/cmt/setup.sh
  builtin cd $cur_dir
  echo "${LYELLOW}T2K Highland2 has been setup.${RESTORE}"
  return;
}; export -f set_t2k_highland2
