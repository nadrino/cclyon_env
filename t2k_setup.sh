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

  echo "$(tput bold)$(tput setaf 3)NOTICE: T2K env has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}; export -f set_t2k_env
