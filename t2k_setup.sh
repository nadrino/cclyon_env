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
  export LOGS_DIR="$WORK_DIR/logs/"
  export FIGURES_DIR="$WORK_DIR/figures/"

  # Aliases
  alias sps="builtin cd $T2K_SPS_DIR"
  alias repo="builtin cd $REPO_DIR"
  alias res="builtin cd $RESULTS_DIR"
  alias logs="builtin cd $LOGS_DIR"
  alias fig="builtin cd $FIGURES_DIR"

  export T2K_ENV_IS_SETUP="1"

  echo "$(tput bold)$(tput setaf 3)NOTICE: T2K env has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}; export -f set_t2k_env


function setup_root_t2k()
{
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

function setup_p_theta_t2k()
{
  echo "├─ Setting up P-theta..." >&2

  if [ -z ${T2K_ENV_IS_SETUP+x} ];
  then
    echo "$T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  export PATH="$INSTALL_DIR/P-theta-dev/bin/:$PATH"

  echo "   ├─ P-theta-dev Prefix : $INSTALL_DIR/P-theta-dev/"

  echo "NOTICE: P-theta-dev has been setup." >&2
  return;
}; export -f setup_p_theta_t2k
