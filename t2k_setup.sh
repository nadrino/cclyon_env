#! /bin/bash

#=============================================================================#
#                                T2K SETUP                                    #
#=============================================================================#
# This bash script defines the functions related to the T2K env setup. To get #
# everything setup, run the command "set_t2k_env" which is defined here.      #
#=============================================================================#


function set_t2k_env(){

  echo -e "${WARNING} Setting up T2K env..."

  # Env variables
  export T2K_SPS_DIR="/sps/t2k/ablanche"

  export INSTALL_DIR="$T2K_SPS_DIR/install"
  export BUILD_DIR="$T2K_SPS_DIR/build"
  export WORK_DIR="$T2K_SPS_DIR/work"
  export REPO_DIR="$T2K_SPS_DIR/repo"
  export RESOURCES_DIR="$T2K_SPS_DIR/resources"
  export DOWNLOAD_DIR="$T2K_SPS_DIR/download"
  export SCRATCH_DIR="$T2K_SPS_DIR/scratch"

  export RESULTS_DIR="$WORK_DIR/results"
  export DATA_DIR="$WORK_DIR/data"
  export FIGURES_DIR="$WORK_DIR/figures"
  export JOBS_DIR="$WORK_DIR/jobs"

  export LOGS_DIR="$JOBS_DIR/logs"

  # Aliases
  alias sps="cd $T2K_SPS_DIR"
  alias work="cd $WORK_DIR"
  alias repo="cd $REPO_DIR"
  alias res="cd $RESULTS_DIR"
  alias logs="cd $LOGS_DIR"
  alias fig="cd $FIGURES_DIR"

  # Python
  export PYTHONPATH="$REPO_DIR/cclyon_py_tools/library:$PYTHONPATH"
  export PATH="$REPO_DIR/cclyon_py_tools/scripts:$PATH"
  export PATH="$REPO_DIR/cclyon_bash_tools/bin:$PATH"
  alias job="jobs.py"

  export CC_ROOT_MACROS="$REPO_DIR/cclyon_root_macros/"
  export CC_BASH_TOOLS="$REPO_DIR/cclyon_bash_tools/"
  export CC_PY_TOOLS="$REPO_DIR/cclyon_py_tools/"

  export T2K_ENV_IS_SETUP="1"

  # can't run this with sh: > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
  # sh (which in most (Debian-derived) systems is linked to dash) doesn't allow process substitution
  link_t2k_soft # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
  set_t2k_irods # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
  # setup_brew
  # set_brew_root
  set_t2k_root # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
  # set_t2k_root_62004
  cleanup_env # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)

  echo -e "${INFO} T2K env has been setup."
  return;
}; export -f set_t2k_env


function set_t2k_root_62004(){
  echo "├─ Setting up ROOT (Recompiled for T2K projects)..."

  if [ -z ${T2K_ENV_IS_SETUP+x} ];
  then
    echo "T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  export PATH="$INSTALL_DIR/root-v6-20-04/bin:$PATH"
  source $INSTALL_DIR/root-v6-20-04/bin/thisroot.sh
  # ccenv root 6.18.04_gcc73

  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo -e "${INFO} ROOT (T2K) has been setup."
  return;
}; export -f set_t2k_root_62004

function set_t2k_root(){
  echo "├─ Setting up ROOT (Recompiled for T2K projects)..."

  if [ -z ${T2K_ENV_IS_SETUP+x} ];
  then
    echo "T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  export PATH="$INSTALL_DIR/root/bin:$PATH"
  source $INSTALL_DIR/root/bin/thisroot.sh
  # ccenv root 6.18.04_gcc73

  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo -e "${INFO} ROOT (T2K) has been setup."
  return;
}; export -f set_t2k_root

function set_brew_root(){
  echo "├─ Setting up ROOT (Brew)..."

  if [ -z ${BREW_ENV_IS_SETUP+x} ];
  then
    echo "BREW_ENV_IS_SETUP is not set. Please run setup_brew first.";
    return;
  fi

  . /sps/t2k/ablanche/linuxbrew/bin/thisroot.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo -e "${INFO} ROOT (Brew) has been setup."
  return;
}; export -f set_brew_root


function link_t2k_soft()
{
  echo -e "${WARNING} Setting up T2K libs..."

  local current_path=${PWD}

  if [ -z ${T2K_ENV_IS_SETUP+x} ];
  then
    echo "$T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  echo -e "${WARNING} Linking libs in $INSTALL_DIR"
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

  builtin cd $current_path

  echo -e "${INFO} T2K libs have been setup."

}; export -f link_t2k_soft

function setup_brew(){
  cur_dir="$PWD"

  # Cleaning env
  # export PATH="/usr/bin" # cd, ls...
  # export PATH="/opt/sge/bin/lx-amd64:$PATH" # for qsub
  # export LD_LIBRARY_PATH=""

  # Set brew env
  eval $($HOME/.linuxbrew/bin/brew shellenv)
  export PATH="$HOME/.linuxbrew/opt/python/libexec/bin:$PATH"

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
  if [ -z ${T2K_IRODS_IS_SET+x} ];
  then
    cur_dir="$PWD"
    builtin cd $REPO_DIR/irods-legacy/iRODS
    source ./add-clients.sh &> /dev/null
    builtin cd $cur_dir
    export T2K_IRODS_IS_SET=1
    echo -e "${INFO} T2K iRODS has been setup."
  else
    echo -e "${ALERT} T2K iRODS is already setup."
  fi
  return;
}; export -f set_t2k_irods

function set_t2k_cvs(){
  if [ -z ${T2K_CVS_IS_SET+x} ];
  then
    cvs_version="v1r20p20081118"
    cur_dir="$PWD"
    export CVSROOT=":ext:anoncvs@repo.nd280.org:/home/trt2kmgr/ND280Repository"
    source $REPO_DIR/nd280-cvs/CMT/${cvs_version}/mgr/setup.sh
    builtin cd $cur_dir
    export T2K_CVS_IS_SET=1
    echo -e "${INFO} T2K CVS ${cvs_version} has been setup."
  else
    echo -e "${ALERT} T2K CVS is already setup."
  fi
  return;
}; export -f set_t2k_cvs

function set_t2k_psyche(){
  if [ -z ${T2K_PSYCHE_IS_SET+x} ];
  then
    psyche_version="v3r49"
    cur_dir="$PWD"
    set_t2k_cvs # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    export CMTPATH="$REPO_DIR/nd280-cvs/Highland2_HEAD"
    source $CMTPATH/nd280Psyche/${psyche_version}/cmt/setup.sh
    builtin cd $cur_dir
    export T2K_PSYCHE_IS_SET=1
    echo -e "${INFO} T2K Psyche ${psyche_version} has been setup."
  else
    echo -e "${ALERT} T2K Psyche is already setup."
  fi
  return;
}; export -f set_t2k_psyche

function set_t2k_oaAnalysisReader(){
  if [ -z ${T2K_OAANALYSISREADER_IS_SET+x} ];
  then
    oaAnalysisReader_version="v2r19"
    cur_dir="$PWD"
    setup_old_gcc # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    set_t2k_cvs # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    export CMTPATH="$REPO_DIR/nd280-cvs/Highland2_HEAD"
    source $CMTPATH/highland2/oaAnalysisReader/${oaAnalysisReader_version}/cmt/setup.sh
    builtin cd $cur_dir
    export T2K_OAANALYSISREADER_IS_SET=1
    echo -e "${INFO} T2K oaAnalysisReader ${oaAnalysisReader_version} has been setup."
  else
    echo -e "${ALERT} T2K oaAnalysisReader is already setup."
  fi
  return;
}; export -f set_t2k_oaAnalysisReader

function set_t2k_highland2(){
  if [ -z ${T2K_HIGHLAND2_IS_SET+x} ];
  then
    highland2_version="v2r45"
    cur_dir="$PWD"
    setup_old_gcc # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    set_t2k_cvs # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    export CMTPATH="$REPO_DIR/nd280-cvs/Highland2_HEAD"
    source $CMTPATH/nd280Highland2/${highland2_version}/cmt/setup.sh
    builtin cd $cur_dir
    export T2K_HIGHLAND2_IS_SET=1
    echo -e "${INFO} T2K Highland2 ${highland2_version} has been setup."
  else
    echo -e "${ALERT} T2K Highland2 is already setup."
  fi
  return;
}; export -f set_t2k_highland2

function set_t2k_neut(){
  if [ -z ${T2K_NEUT_IS_SET+x} ];
  then
    cur_dir="$PWD"
    # source $INSTALL_DIR/neut/setup.sh
    export NEUT=$INSTALL_DIR/neut
    export PATH=$NEUT/bin:$PATH
    export LD_LIBRARY_PATH=$NEUT/lib:$LD_LIBRARY_PATH
    builtin cd $cur_dir
    export T2K_NEUT_IS_SET=1
    echo -e "${INFO} T2K NEUT has been setup."
  else
    echo -e "${ALERT} T2K NEUT is already setup."
  fi
  return;
}; export -f set_t2k_neut

function set_t2k_CERNLIB(){
  if [ -z ${T2K_CERNLIB_IS_SET+x} ];
  then
    cur_dir="$PWD"
    set_t2k_cvs # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    export CERN="/sps/t2k/ablanche/repo/nd280-cvs/Highland2_HEAD/CERNLIB/v2005r6/Linux-x86_64"
    export CERN_LEVEL=2005
    export CERN_ROOT=$CERN/$CERN_LEVEL
    export CERNLIB=$CERN_ROOT/lib
    export CERNLIBDIR=$CERNLIB
    export CERNPATH=$CERNLIB
    export PATH=$CERN_ROOT/bin:$PATH
    export LD_LIBRARY_PATH=$CERNLIB:$LD_LIBRARY_PATH
    builtin cd $cur_dir
    export T2K_CERNLIB_IS_SET=1
    echo -e "${INFO} T2K CERNLIB has been setup."
  else
    echo -e "${ALERT} T2K CERNLIB is already setup."
  fi
  return;
}; export -f set_t2k_CERNLIB

function set_t2k_T2KReWeight(){
  if [ -z ${T2K_T2KREWEIGHT_IS_SET+x} ];
  then
    cur_dir="$PWD"
    setup_old_gcc # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    # For analysis tools
    set_t2k_highland2 # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    # For enabling psyche
    set_t2k_psyche # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    # For enabling CERNLIB
    set_t2k_CERNLIB # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    # For enabling NEUT
    set_t2k_neut # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)

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
    cleanup_env # > >(while read; do echo "${INDENT_SPACES}$REPLY"; done)
    builtin cd $cur_dir

    export T2K_T2KREWEIGHT_IS_SET=1
    echo -e "${INFO} T2K T2KReWeight has been setup."
  else
    echo -e "${ALERT} T2K T2KReWeight is already setup."
  fi
  return;
}; export -f set_t2k_T2KReWeight


function pull_xsLLhFitter(){
  echo -e "${ALERT} Pulling xsllhFitter..."
  local current_path=${PWD}
  builtin cd $REPO_DIR/xsLLhFitter
  git pull
  builtin cd $BUILD_DIR/xsLLhFitter

  if [ "" != "$1" ]
  then
    cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/xsLLhFitter \
      -D CMAKE_BUILD_TYPE=$1 \
      $REPO_DIR/xsLLhFitter/.
    make clean
  fi

  # cmake \
  #   -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/xsLLhFitter \
  #   $REPO_DIR/xsLLhFitter/.
  make -j 4 install
  builtin cd $current_path
  echo -e "${INFO} xsllhFitter has been pulled."
  return;
}; export -f pull_xsLLhFitter

function pull_p_theta_dev(){
  echo -e "${ALERT} Pulling P-theta-dev..."
  local current_path=${PWD}
  builtin cd $REPO_DIR/P-theta-dev
  git pull
  builtin cd $BUILD_DIR/P-theta-dev

  if [ "" != "$1" ]
  then
    cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/P-theta-dev \
      -D CMAKE_BUILD_TYPE=$1 \
      $REPO_DIR/P-theta-dev/Minimal/.
    make clean
  fi

  make -j 4 install
  builtin cd $current_path
  echo -e "${INFO} P-theta-dev has been pulled."
  return;
}; export -f pull_p_theta_dev
