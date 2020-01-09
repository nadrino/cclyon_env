#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

COMMON_PROFILE="/sps/t2k/ablanche/env/common_profile.sh"
if [ -f $MAC_PROFILE ];
then
  source $COMMON_PROFILE
else
  echo "Can't find common_profile.sh : $COMMON_PROFILE";
fi

function update_bashrc(){
  # Copying this file to the place where the default .bashrc is red
  cp /sps/t2k/ablanche/env/bashrc $HOME/.bashrc
  echo ".bashrc has been updated."
}
