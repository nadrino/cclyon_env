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
    export CC_DIR=$T2K_SPS_DIR
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

  export COMMON_DIR="/sps/t2k/common"
  alias common="cd $COMMON_DIR"

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
  export CC_ROOT_MACROS="$REPO_DIR/cclyon_root_macros/"
  export CC_BASH_TOOLS="$HOME_REPO_DIR/cclyon-common-bash-tools/"
  export CC_PY_TOOLS="$HOME_REPO_DIR/cclyon_py_tools/"

  export PYTHONPATH="$CC_PY_TOOLS/submodules/py-generic-toolbox/src:$PYTHONPATH"
  export PATH="$CC_PY_TOOLS/scripts:$PATH"
  export PATH="$HOME_REPO_DIR/cclyon-common-bash-tools/bin:$PATH"

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
    echo "T2K_ENV_IS_SETUP is not set. Please run set_t2k_env first.";
    return;
  fi

  if [[ $machineName =~ .in2p3.fr$ ]]; then
    echo -e "${WARNING} Loading common t2k software"
    # new common software
#    source $COMMON_DIR/software/env.sh

#    echo -e "${WARNING} Using our ROOT version..."
    # t2k_setup_root v6-34-02
#    t2k_setup_root v6-38-00
    # new common software
    source /pbs/throng/t2k/common/setup.sh
    common_soft_setup

    # my folder
    source $HOME/work/setup.sh
    common_soft_setup
    source /pbs/throng/t2k/common/setup.sh

    export MY_THRONG_DIR="/pbs/throng"
    alias throng="cd $MY_THRONG_DIR/t2k"
  elif [[ $machineName =~ .cern.ch$ ]]; then
    echo -e "${WARNING} Init CERN soft"

  elif [[ $machineName =~ .baobab$ ]]; then
    echo -e "${WARNING} Loading local ROOT lib..."
    source ${INSTALL_DIR}/root/bin/thisroot.sh
  elif [[ $machineName =~ .yggdrasil$ ]]; then
    echo -e "${WARNING} Loading local ROOT lib..."
    source ${INSTALL_DIR}/root/bin/thisroot.sh
  fi

  echo -e "${WARNING} Linking my libs in $INSTALL_DIR"
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

  builtin cd $current_path

  # PyGundam
  export PYTHONPATH="$INSTALL_DIR/gundam/lib:$PYTHONPATH"

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
  builtin cd $BUILD_DIR/$REPO_NAME

  if [ "" != "$1" ]
  then
    read -p "Rebuilding with $1 build type? Press enter to validate"
    rm $BUILD_DIR/$REPO_NAME/CMakeCache.txt

    CLUSTER_OPTIONS="-D USE_STATIC_LINKS=OFF"
    if [[ $machineName =~ .cern.ch$ ]]; then
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_CUDA_LIB=ON"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D CMAKE_CUDA_COMPILER=/cvmfs/sft.cern.ch/lcg/views/LCG_106_cuda/x86_64-el9-gcc11-opt/bin/nvcc"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D CMAKE_CUDA_ARCHITECTURES=all"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_GUNDAM_ROOT_APP=OFF"
    elif [[ $machineName =~ .in2p3.fr$ ]]; then
#      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D YAMLCPP_DIR=$COMMON_INSTALL_DIR/yaml-cpp"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_CACHE_MANAGER=OFF"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_PYTHON_INTERFACE=ON"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D pybind11_DIR=/pbs/home/a/ablanche/.local/lib/python3.12/site-packages/pybind11/share/cmake/pybind11"
#      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D CMAKE_CUDA_COMPILER=/sps/t2k/ablanche/install/cuda-12.4/bin/nvcc"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D CMAKE_CUDA_ARCHITECTURES=70"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_CUDA_LIB=ON"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_BACKENDS=ON"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_TESTS=ON"
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_GOOGLE_TEST=ON"
    else
      CLUSTER_OPTIONS="$CLUSTER_OPTIONS -D WITH_CACHE_MANAGER=OFF"
    fi

    CMAKE_COMMAND="cmake"
    CMAKE_COMMAND="${CMAKE_COMMAND} -D CMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/${REPO_NAME}"
    CMAKE_COMMAND="${CMAKE_COMMAND} -D CMAKE_BUILD_TYPE=$1"
    CMAKE_COMMAND="${CMAKE_COMMAND} $CLUSTER_OPTIONS"
    CMAKE_COMMAND="${CMAKE_COMMAND} $REPO_DIR/$REPO_NAME/."

    echo $CMAKE_COMMAND
    $CMAKE_COMMAND

#    cmake \
#      -D CMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/${REPO_NAME} \
#      -D CMAKE_BUILD_TYPE=$1 \
#      $CLUSTER_OPTIONS \
#      $REPO_DIR/${REPO_NAME}/.
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

syncNextCloud() {
    local source="${1%/}"
    local dest="cchpss0:/hpss/in2p3.fr/group/t2k/webdav/nextcloud/kcl/ASGReader"

    case "$source" in
        ""|/*|.|./*|*/./*|*/.|..|../*|*/../*|*/..) echo "ERROR: Expected a relative Nextcloud path without '.' or '..' components" >&2; return 1 ;;
    esac

    if [[ -d /scratch_ssd/hyperk/temp && -w /scratch_ssd/hyperk/temp ]]; then
        local scratch="/scratch_ssd/hyperk/temp"
    else
        local scratch="/scratch/t2k/temp"
        mkdir -p -- "$scratch" || return 1
    fi

    local tmp
    tmp="$scratch"

    # List Nextcloud metadata before downloading any file.
    command -v python3 >/dev/null || { echo "ERROR: python3 is required to read Nextcloud metadata" >&2; return 1; }
    local metadata is_dir listing files
    metadata=$(set -x; rclone lsjson "nextcloud:${source}" --stat) || return 1
    is_dir=$(python3 -c 'import json, sys; print("yes" if json.load(sys.stdin)["IsDir"] else "no")' <<< "$metadata") || return 1
    if [[ "$is_dir" == yes ]]; then
        listing=$(set -x; rclone lsjson "nextcloud:${source}" --recursive --files-only) || return 1
        files=$(python3 -c '
import json, sys
source = sys.argv[1]
for entry in json.load(sys.stdin):
    if entry["IsDir"]:
        continue
    path = source + "/" + entry["Path"]
    if "\n" in path or "\r" in path or any(p in (".", "..", "") for p in path.split("/")):
        sys.exit("ERROR: Unsupported Nextcloud path: " + repr(path))
    print(path)
' "$source" <<< "$listing") || return 1
    else
        files="$source"
    fi

    local file dir component remote_dir
    local -a components
    while IFS= read -r file; do
        [[ -z "$file" ]] && continue
        if (set -x; rfdir "${dest}/${file}" >/dev/null); then
            echo "Already on HPSS, skipping: ${file}"
            continue
        fi

        if ! (set -x; rclone copyto "nextcloud:${file}" "${tmp}/${file}" --progress); then
            echo "ERROR: Nextcloud download failed. Files kept in ${tmp}" >&2
            return 1
        fi

        dir=${file%/*}
        [[ "$dir" == "$file" ]] && dir=.

        remote_dir="$dest"
        IFS='/' read -r -a components <<< "$dir"
        for component in "${components[@]}"; do
            [[ -z "$component" || "$component" == "." ]] && continue
            remote_dir="${remote_dir}/${component}"
            if ! (set -x; rfdir "${remote_dir}/." >/dev/null); then
                if ! (set -x; rfmkdir "$remote_dir"); then
                    # Another transfer may have created the directory meanwhile.
                    if ! (set -x; rfdir "${remote_dir}/." >/dev/null); then
                        echo "ERROR: Cannot create HPSS directory ${remote_dir}" >&2
                        return 1
                    fi
                fi
            fi
        done

        echo "Uploading: ${file}"
        if ! (set -x; rfcp "${tmp}/${file}" "${dest}/${file}"); then
            echo "ERROR: HPSS transfer failed for ${file}" >&2
            return 1
        fi
        rm -f -- "${tmp}/${file}"
    done <<< "$files"
    echo "Sync completed: ${source}"
    (
        set -x
        rfdir "${dest}/${source}"
    )
}; export -f syncNextCloud
