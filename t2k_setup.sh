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

  if [ -z ${CC_DIR+x} ];
  then
    export CC_DIR="/sps/t2k/ablanche"
  fi
  echo "CC_DIR = '$CC_DIR'";

  export INSTALL_DIR="$CC_DIR/install"
  export BUILD_DIR="$CC_DIR/build"
  export WORK_DIR="$CC_DIR/work"
  export REPO_DIR="$CC_DIR/repo"
  export RESOURCES_DIR="$CC_DIR/resources"
  export DOWNLOAD_DIR="$CC_DIR/download"
  export SCRATCH_DIR="$CC_DIR/scratch"

  export RESULTS_DIR="$WORK_DIR/results"
  export DATA_DIR="$WORK_DIR/data"
  export FIGURES_DIR="$WORK_DIR/figures"

  export JOBS_DIR="$WORK_DIR/jobs"
  export LOGS_DIR="$JOBS_DIR/logs"

  alias logs="cd $LOGS_DIR"
  alias job='jobSlurm.py'

  if [[ $machineName =~ .cern.ch$ ]]; then
    # HTC condor don't accept inputs from /eos/
    # export INSTALL_DIR="/afs/cern.ch/user/a/adblanch/private/install"
    # export WORK_DIR="/afs/cern.ch/user/a/adblanch/private/work"

    export JOBS_DIR="/afs/cern.ch/user/a/adblanch/private/jobs"
    export LOGS_DIR="${JOBS_DIR}/logs"

    alias job='condor_q'
    alias logs='cd /eos/home-a/adblanch/logs'

    export COMMON_INSTALL_DIR=$INSTALL_DIR
    export COMMON_BUILD_DIR=$BUILD_DIR
    export COMMON_SOURCE_DIR=$REPO_DIR
  else
    echo "Setting up common libraries..."
  fi

  # Detect the OS and version
  if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS_NAME=$ID
      OS_VERSION=$VERSION_ID
  else
      echo "Cannot determine the OS version."
  fi

  # Execute routines based on the OS and version
  if [ "$OS_NAME" == "centos" ] && [[ "$OS_VERSION" == 7* ]]; then
      echo "Running routine for CentOS 7..."
      # Add your CentOS 7 specific commands here
  elif [ "$OS_NAME" == "rhel" ] && [[ "$OS_VERSION" == 9* ]]; then
      echo "Running routine for Red Hat 9..."

      # export INSTALL_DIR="$CC_DIR/install"
      # export BUILD_DIR="$CC_DIR/build"
      # Add your Red Hat 9 specific commands here
  else
      echo "Unsupported OS or version."
  fi


  # Aliases
  alias repo="cd $REPO_DIR"
  alias res="cd $RESULTS_DIR"

  # Python
  export PYTHONPATH="$REPO_DIR/cclyon_py_tools/submodules/py-generic-toolbox/src:$PYTHONPATH"
  export PATH="$REPO_DIR/cclyon_py_tools/scripts:$PATH"
  export PATH="$REPO_DIR/cclyon_bash_tools/bin:$PATH"

  export CC_ROOT_MACROS="$REPO_DIR/cclyon_root_macros/"
  export CC_BASH_TOOLS="$REPO_DIR/cclyon_bash_tools/"
  export CC_PY_TOOLS="$REPO_DIR/cclyon_py_tools/"

  export T2K_ENV_IS_SETUP="1"

  link_local_libs
  cleanup_env

  export NIWG=$REPO_DIR/NIWGReWeight_ROOT6

  echo -e "${INFO} T2K env has been setup."
  return;
}; export -f set_t2k_env


function link_local_libs(){
  echo -e "${WARNING} Setting up local libs..."

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
    if [[ "$sub_folder" == *_off ]]; then
      echo "   ├─ $sub_folder ends with _off. Skipping..."
    elif [[ "$sub_folder" == '*' ]]; then
      echo "   ├─ $sub_folder isn't valid. Skipping..."
    else
      export PATH="$INSTALL_DIR/$sub_folder/bin:$PATH"
      export LD_LIBRARY_PATH="$INSTALL_DIR/$sub_folder/lib:$LD_LIBRARY_PATH"
      echo "   ├─ Adding : $sub_folder"
    fi
  done

  if [[ $machineName =~ .in2p3.fr$ ]]; then
    echo -e "${WARNING} Loading common t2k software"
    source /sps/t2k/common/software/env.sh

    echo -e "${WARNING} Using dev ROOT version..."
    source /sps/t2k/common/software/install/root-v6-32-04/bin/thisroot.sh
    echo "   ├─ ROOT Prefix : $(root-config --prefix)"
    echo "   ├─ ROOT Version : $(root-config --version)"
  elif [[ $machineName =~ .cern.ch$ ]]; then
    echo -e "${WARNING} Init CERN soft"
    # source /cvmfs/sft.cern.ch/lcg/contrib/gcc/11/x86_64-centos7/setup.sh

    # echo -e "${WARNING} Initializing clang 15.0.7"
    # source /cvmfs/sft.cern.ch/lcg/releases/clang/15.0.7-27d6b/x86_64-centos7-gcc11-opt/setup.sh

    # echo -e "${WARNING} Initializing Python 3.9.12"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/Python/3.9.12-9a1bc/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing XROOTD 5.5.0"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/xrootd/5.5.0-21deb/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing LZ4 1.9.2"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/lz4/1.9.2-9bdfe/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing Zlib 1.2.11"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/zlib/1.2.11-8af4c/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing FFTW3 3.3.10"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/fftw3/3.3.10-33229/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing cfitsio 3.48"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/cfitsio/3.48-e4bb8/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing openssl 1.0.2"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/openssl/1.0.2o-96de1/x86_64-centos7-gcc7-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    #
    # # echo -e "${WARNING} Initializing ROOT 6.28.00"
    # # source /cvmfs/sft.cern.ch/lcg/latest/ROOT/6.28.00-fd53a/x86_64-ubuntu2204-gcc11-opt/bin/thisroot.sh
    #
    # # echo -e "${WARNING} Initializing ZLib 1.2.11"
    # # source /cvmfs/sft.cern.ch/lcg/releases/zlib/1.2.11-8af4c/x86_64-centos7-gcc11-opt/zlib-env.sh
    #
    # # echo -e "${WARNING} Initializing LZ4 1.9.2"
    # # source /cvmfs/sft.cern.ch/lcg/releases/lz4/1.9.2-9bdfe/x86_64-centos7-gcc11-opt/lz4-env.sh
    #
    # # echo -e "${WARNING} Initializing CUDA 12.1"
    # # source /cvmfs/sft.cern.ch/lcg/contrib/cuda/12.1/x86_64-centos7/setup.sh
    #
    # echo -e "${WARNING} Initializing CMake"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/contrib/CMake/latest/Linux-x86_64"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing Git 2.28.0"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/contrib/git/2.28.0/x86_64-centos7"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing yamlcpp 0.6.3"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/yamlcpp/0.6.3-d05b2/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing yamlcpp 0.6.3"
    # LIB_PATH="/cvmfs/sft.cern.ch/lcg/releases/yamlcpp/0.6.3-d05b2/x86_64-centos7-gcc11-opt"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"
    #
    # echo -e "${WARNING} Initializing ROOT v6.26.10"
    # LIB_PATH="/afs/cern.ch/user/a/adblanch/public/software/install/root/6.26.10_x86_64_el7_gcc11_cxx17"
    # export PATH="$LIB_PATH/bin:$PATH"
    # export LD_LIBRARY_PATH="$LIB_PATH/lib:$LD_LIBRARY_PATH"


  elif [[ $machineName =~ .baobab$ ]]; then
    echo -e "${WARNING} Loading local ROOT lib..."
    source ${INSTALL_DIR}/root/bin/thisroot.sh
  elif [[ $machineName =~ .yggdrasil$ ]]; then
    echo -e "${WARNING} Loading local ROOT lib..."
    source ${INSTALL_DIR}/root/bin/thisroot.sh
  fi

  builtin cd $current_path

  echo -e "${INFO} T2K libs have been setup."

}; export -f link_local_libs

function setup_brew(){
  cur_dir="$PWD"

  # Cleaning env
  # export PATH="/usr/bin" # cd, ls...
  # export PATH="/opt/sge/bin/lx-amd64:$PATH" # for qsub
  # export LD_LIBRARY_PATH=""

  # Set brew env
  eval $($HOME/.linuxbrew/bin/brew shellenv)
  export PATH="$HOME/.linuxbrew/opt/python/libexec/bin:$PATH"

  export HOMEBREW_DEVELOPER=1
  export HOMEBREW_GIT_PATH="/pbs/software/centos-7-x86_64/git/2.30.1/bin/git"
  export HOMEBREW_CURL_PATH="/pbs/software/centos-7-x86_64/curl/7.60.0/bin/curl"

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

function installSoft(){
  if [ "" != "$1" ]
  then
    echo -e "${ALERT} Installing $1..."
    PROJECT_NAME="$1"
    mkdir $BUILD_DIR/$PROJECT_NAME    # Creating build directory
    mkdir $INSTALL_DIR/$PROJECT_NAME  # Creating install directory
    cd $BUILD_DIR/$PROJECT_NAME
    cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/$PROJECT_NAME \
      $REPO_DIR/$PROJECT_NAME/.
    make install -j 8
    cd -;
  fi
}

function build_gundam(){
  echo -e "${ALERT} Building GUNDAM..."
  REPO_NAME="gundam"
  builtin cd $BUILD_DIR/${REPO_NAME}

  if [ "" != "$1" ]
  then
    read -p "Rebuilding with $1 build type? Press enter to validate"
    rm $BUILD_DIR/gundam/CMakeCache.txt

    CLUSTER_OPTIONS="-D USE_STATIC_LINKS=ON"
    if [[ $machineName =~ .cern.ch$ ]]; then
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_CUDA_LIB=ON"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D CMAKE_CUDA_COMPILER=/cvmfs/sft.cern.ch/lcg/views/LCG_106_cuda/x86_64-el9-gcc11-opt/bin/nvcc"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D CMAKE_CUDA_ARCHITECTURES=all"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_GUNDAM_ROOT_APP=OFF"
    elif [[ $machineName =~ .in2p3.fr$ ]]; then
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D YAMLCPP_DIR=$COMMON_INSTALL_DIR/yaml-cpp"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_CACHE_MANAGER=OFF"
    else
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_CACHE_MANAGER=OFF"
    fi

    cmake \
      -D CMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/${REPO_NAME} \
      -D CMAKE_BUILD_TYPE=$1 \
      $CLUSTER_OPTIONS \
      $REPO_DIR/${REPO_NAME}/.
    make clean
  fi

  make -j 4 install
  builtin cd -
  echo -e "${INFO} GUNDAM has been built."
  return;
}; export -f build_gundam


function build_tofreco(){
  echo -e "${ALERT} Building tof-reco..."
  REPO_NAME="tof-reco"
  builtin cd $BUILD_DIR/${REPO_NAME}

  if [ "" != "$1" ]
  then
    read -p "Rebuilding with $1 build type? Press enter to validate"
    rm $BUILD_DIR/gundam/CMakeCache.txt
    cmake \
      -D CMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/${REPO_NAME} \
      -D CMAKE_BUILD_TYPE=$1 \
      $REPO_DIR/${REPO_NAME}/.
    make clean
  fi

  make -j 4 install
  builtin cd -
  echo -e "${INFO} tof-reco has been built."
  return;
}; export -f build_tofreco


function pull_tofreco(){
  echo -e "${ALERT} Updating tof-reco..."
  builtin cd $REPO_DIR/tof-reco
  git pull
  git submodule update --remote
  builtin cd -
  echo -e "${INFO} tof-reco code has been updated. Calling build..."

  build_tofreco "$@"
  return;
}; export -f pull_tofreco

function pull_gundam(){
  echo -e "${ALERT} Updating GUNDAM..."
  builtin cd $REPO_DIR/gundam
  git pull
  git submodule update --remote
  builtin cd -
  echo -e "${INFO} GUNDAM code has been updated. Calling build..."

  build_gundam "$@"
  return;
}; export -f pull_gundam
