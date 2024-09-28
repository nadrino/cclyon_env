#! /bin/bash

###############################################################################
#                                                                             #
#                        CENTRE DE CALCUL DE L'IN2P3                          #
#                 Copyright (c) 2000 - All rights reserved.                   #
#                                                                             #
#                             ---------------                                 #
#                                                                             #
#     Please report problems, comments and remarks to the CCIN2P3 user        #
#            support team at http://cctools.in2p3.fr/usersupport              #
#                                                                             #
#                          .profile template file                             #
###############################################################################

#=============================================================================#
# This file is called at the begining of your Korn shell session. Please      #
# modify only the USER SESSION to customize your shell environment.           #
#=============================================================================#

#=============================================================================#
#                              SYSTEM SECTION                                 #
#=============================================================================#
# This section contains system profile calls. They are mandatory to set the   #
# environment needed for CCIN2P3 tools such as the Batch Queueing System      #
# (BQS) and data access services. DO NOT DISABLE OR MODIFY THIS SECTION.      #
#=============================================================================#

export ENV_SETUP_DIR="$HOME/work/repo/cclyon_env/"


machineName="$(hostname --fqdn)"
if [[ $machineName =~ .baobab$ || $machineName =~ .yggdrasil$ ]];
then
  export ENV_SETUP_DIR="$HOME/repo/cclyon_env/"
  export T2K_SPS_DIR="$HOME"
elif [[ $machineName =~ .cern.ch$ ]];
then
  export EOS_PATH="/eos/home-a/adblanch"
  echo "EOS_PATH=$EOS_PATH"
  export ENV_SETUP_DIR="${EOS_PATH}/software/repo/cclyon_env"
  # export T2K_SPS_DIR="$HOME/private/software"
  export T2K_SPS_DIR="${EOS_PATH}/software"
else
  if [ -r /afs/in2p3.fr/common/uss/system_profile ];then
     . /afs/in2p3.fr/common/uss/system_profile
  fi

  if [ -n "$THRONG_DIR" ];then
     if [ -r $THRONG_DIR/group_profile ];then
        . $THRONG_DIR/group_profile
     fi
  fi
fi



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


export COMMON_PROFILE="$ENV_SETUP_DIR/common_profile.sh"
if [ -f $COMMON_PROFILE ];
then
  # source $COMMON_PROFILE
  . $COMMON_PROFILE
  echo -e "${INFO} common_profile has been loaded."
else
  echo "Can't find common_profile.sh : $COMMON_PROFILE";
fi


export T2K_PROFILE="$ENV_SETUP_DIR/t2k_setup.sh"
if [ -f $T2K_PROFILE ];
then
  # source $T2K_PROFILE
  . $T2K_PROFILE
  echo -e "${INFO} t2k_setup has been loaded."
else
  echo "Can't find T2K_PROFILE : $T2K_PROFILE";
fi

function pull_cc_env(){
  local savedpath=${PWD}
  builtin cd $ENV_SETUP_DIR
  echo "-> Pulling updates on git repository..."
  git pull > /dev/null
  echo "-> Copying .profile to HOME."
  cp $ENV_SETUP_DIR/profile $HOME/.profile
  echo "-> Resourcing .profile."
  source $HOME/.profile
  # /bin/bash $HOME/.profile
  cd $savedpath
  echo "-> Env upgraded."
}; export -f pull_cc_env

echo -e "${INFO} .profile is loaded."

# By default the T2K env is setup
link_local_libs
# setup_brew
res # go to t2k sps directory

function cd{
    builtin cd "$@" && ls -rt
}
# export -f cd
# DO NOT EXPORT THIS FUNCTION. -> for example, make (cmake) will
# use this cd and printout each time its called
