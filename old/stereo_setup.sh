#!/bin/bash

function setup_geant4101(){
  # Using Geant4
  echo "├─ Setting up Geant4.10.1 ..." >&2
  source /usr/local/geant4/geant4.10.1/bin/geant4.sh 2> ./trash.log
  source /usr/local/geant4/geant4.10.1/share/Geant4-10.1.0/geant4make/geant4make.sh
  source /usr/local/geant4/geant4.10.1/geant4.cc.sh
  echo "   ├─ Geant4 Prefix : $(geant4-config --prefix)"
  echo "   ├─ Geant4 Version : $(geant4-config --version)"

  # GEANT4 support (4.10.1)
  echo "├─ Setting up some environement variable about Geant4..." >&2
  export g4non_display=1
  export G4VERSIONCODE=41010
  export G4VERSION_NUMBER=1010
  unset  G4WORKDIR
  unset  G4ANALYSIS_USE
  export G4VIS_NONE=0
  export NeutronHPCrossSections=${G4NEUTRONHPDATA}

  echo "$(tput bold)$(tput setaf 3)NOTICE: Geant4 version 4.10.1.0 has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_geant4101

function setup_geant41003(){
  # Using Geant4
  echo "├─ Setting up Geant4..." >&2
  #. /usr/local/geant4/pro/env.sh
  source /usr/local/geant4/new/bin/geant4.sh
  source /usr/local/geant4/new/share/Geant4-10.2.2/geant4make/geant4make.sh
  source /usr/local/geant4/new/geant4.cc.sh
  # source /pbs/software/cl7/geant4/10.03.p01/env.sh
  # source /pbs/software/cl7/geant4/10.03.p01/bin/geant4.sh
  # source /pbs/software/cl7/geant4/10.03.p01/share/Geant4-10.3.1/geant4make/geant4make.sh
  echo "   ├─ Geant4 Prefix : $(geant4-config --prefix)"
  echo "   ├─ Geant4 Version : $(geant4-config --version)"

  echo "├─ Setting up some environement variable about Geant4..." >&2
  export g4non_display=1
  export G4VERSIONCODE=41003
  export G4VERSION_NUMBER=1003
  unset  G4WORKDIR
  unset  G4ANALYSIS_USE
  export G4VIS_NONE=0
  export NeutronHPCrossSections=${G4NEUTRONHPDATA}

  echo "$(tput bold)$(tput setaf 3)NOTICE: Geant4 version 4.10.3.1 has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_geant41003

function set_stereo_environement()
{
  # Stereo support
  echo "├─ Setting up environement variables..." >&2
  export G4DICHROICDATA=${STEREO_PATH}/simulation/data

  set EXE=${STWORKDIR}/bin/Stereo_sim

  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$STWORKDIR/lib:/usr/lib:/usr/local/lib:/usr/local/xerces/xerces-c-3.1.1/lib
  export PATH=$STWORKDIR/bin:${PATH}
  export STEREO_DATA=$STWORKDIR/data

  export STEREODBUSER="stereo"
  export STEREOBPASSWD="anNbt4d9EGaZ"

  #####################################################
  #       Personal variables
  #####################################################
  export STEREO_OUTPUT=/sps/hep/stereo/Adrien/Simulations
  export STEREO_RESOURCES_FILES=/sps/hep/stereo/Adrien/Simulations/Resources/
  export STEREO_FIGURES=/sps/hep/stereo/Adrien/Simulations/Figures/
  export STEREO_MACROS=/sps/hep/stereo/Adrien/Simulations/Macros/
  export STEREOPPDATA=${STEREO_OUTPUT}/Preprocessed
  export MVA=${STEREO_OUTPUT}/MVA
  export PYEXE=${STEREO_OUTPUT}/Stereo/stereo/python
  export STEREO_RESULTS=${HOME}/sps/Results/

  export PATH=${PYEXE}/library:${PATH}
  export PATH=${PYEXE}/job_laucher:${PATH}
  export PATH=${PYEXE}/event_generator:${PATH}
  export PATH=${PYEXE}/exe:${PATH}
  export PATH=${STEREO_OUTPUT}/Macros:${PATH}
  export PYTHONPATH="${PYTHONPATH}:${PYEXE}/library"

  return;
}
export -f set_stereo_environement



# function setup_stereo_sl6()
# {
#   echo "Seting up STEREO environement for SL6..." >&2
#
#   # needed at CCIN2P3 to enable the new compiler (compatible with C/C++11)
#   echo "├─ Enabling new compiler..." >&2
#   source /opt/rh/devtoolset-3/enable
#   source /usr/local/shared/bin/xrootd_env.sh
#
#   # Homebrew Setup
#   export PATH=/opt/rh/devtoolset-3/root/usr/bin/gcc:${PATH}:/afs/in2p3.fr/home/a/ablanche/.linuxbrew/bin
#   export XDG_DATA_DIRS="/afs/in2p3.fr/home/a/ablanche/.linuxbrew/share:$XDG_DATA_DIRS"
#
#   # Using ROOT
#   echo "├─ Setting up ROOT6..." >&2
#   . /usr/local/root/new/env.sh
#   # source /pbs/software/cl7/root/pro/env.sh # C7
#   #. /usr/local/root/v5.34.32/env.sh
#   echo "   ├─ ROOT Prefix : $(root-config --prefix)"
#   echo "   ├─ ROOT Version : $(root-config --version)"
#
#   setup_geant4101
#   setup_stereo_trunk
#
#   return;
#
# }
# export -f setup_stereo_sl6

function setup_original_stereo()
{
    #!/bin/bash
  # config file for geant4.9.10 and root6

  # needed at CCIN2P3 to enable the new compiler (compatible with C/C++11)
  # source /opt/rh/devtoolset-3/enable

  # ROOT support
  export ROOTSYS=/usr/local/root/pro
  export PATH=$PATH:$ROOTSYS/bin
  if [ ! $LD_LIBRARY_PATH ]
  then
  	export LD_LIBRARY_PATH=$ROOTSYS/lib
  else
  	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib:$ROOTSYS/lib/root
  fi

  export PYTHONPATH=$ROOTSYS/lib:$ROOTSYS/lib/python

  # GEANT4 support (4.10.1)
  export g4non_display=1

  source /usr/local/geant4/10.03.p01_woMT/env.sh
  #cd /usr/local/geant4/10.03.p01_woMT/bin ; source geant4.sh
  #cd /usr/local/geant4/10.03.p01_woMT/share/Geant4-10.3.1/geant4make; source geant4make.sh
  #source /usr/local/geant4/10.03.p01_woMT/geant4.cc.sh
  echo "Don't worry this is a generic message. Data Library paths are are set by another script"
  export G4VERSIONCODE=41003
  export G4VERSION_NUMBER=1003
  unset  G4WORKDIR
  unset  G4ANALYSIS_USE
  export G4VIS_NONE=0
  export NeutronHPCrossSections=$G4NEUTRONHPDATA

  # Stereo support
  export STEREO_PATH=${HOME}/sps/Stereo/stereo/trunk/
  export STWORKDIR=${HOME}/sps/Stereo/Install/trunk/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/trunk/
  export G4DICHROICDATA=${STWORKDIR}/install/data

  EXE=$STWORKDIR/install/bin/Stereo_sim

  cd $STEREO_PATH/..
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$STWORKDIR/install/lib
  export PATH=$PATH:$STWORKDIR/install/bin
  export STEREO_DATA=$STWORKDIR/install/data
  # # Debug options (if necessary)
  # unset  G4OPTIMIZE
  # export CPPVERBOSE=1
  # export G4DEBUG=1
  # export G4NO_OPTIMISE=1

}


################################################################################
# CL7 ENVIRONMENT
################################################################################
function setup_root_cl7_pro(){
  # Using Geant4
  echo "├─ Setting up ROOT CL7 production version..." >&2
  source /usr/local/root/pro/env.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "$(tput bold)$(tput setaf 3)NOTICE: CL7 ROOT production version has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_root_cl7_pro

function setup_root_cl7_oldpro(){
  # Using Geant4
  echo "├─ Setting up ROOT CL7 production version..." >&2
  source /usr/local/root/oldpro/env.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "$(tput bold)$(tput setaf 3)NOTICE: CL7 ROOT production version has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_root_cl7_oldpro

function setup_root_cl7_60604(){
  # Using Geant4
  echo "├─ Setting up ROOT CL7 version 6.06.04..." >&2
  source /usr/local/root/6.06.04/env.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "$(tput bold)$(tput setaf 3)NOTICE: CL7 ROOT version 6.06.04 has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_root_cl7_60604

function setup_root_cl7_61002(){
  # Using Geant4
  echo "├─ Setting up ROOT CL7 version 6.10.02..." >&2
  source /usr/local/root/6.10.02/env.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "$(tput bold)$(tput setaf 3)NOTICE: CL7 ROOT version 6.06.04 has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_root_cl7_61002

function setup_root_cl7_61302(){
  # Using Geant4
  echo "├─ Setting up ROOT CL7 version 6.13.02..." >&2
  source /usr/local/root/6.13.02/env.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "$(tput bold)$(tput setaf 3)NOTICE: CL7 ROOT version 6.06.04 has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_root_cl7_61302

function setup_geant_cl7_41003(){
  # Using Geant4
  echo "├─ Setting up Geant4 CL7 version 4.10.03.p03..." >&2
  source /usr/local/geant4/10.03.p03/env.sh
  echo "   ├─ Geant4 Prefix : $(geant4-config --prefix)"
  echo "   ├─ Geant4 Version : $(geant4-config --version)"

  # GEANT4 support (4.10.1)
  export g4non_display=1

  export G4VERSIONCODE=41003
  export G4VERSION_NUMBER=1003
  export G4VIS_NONE=0
  export NeutronHPCrossSections=$G4NEUTRONHPDATA

  echo "$(tput bold)$(tput setaf 3)NOTICE: Geant4 CL7 version 4.10.03.p01_woMT has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_geant_cl7_41003

function setup_geant_cl7_stereo(){
  # Using Geant4
  echo "├─ Setting up Stereo's Geant4 CL7 version 4.10.02.p03..." >&2
  source /sps/hep/stereo/stereo/geant4.10.02.p03/bin/geant4.sh
  echo "   ├─ Geant4 Prefix : $(geant4-config --prefix)"
  echo "   ├─ Geant4 Version : $(geant4-config --version)"

  # GEANT4 support (4.10.1)
  export g4non_display=1

  export G4VERSIONCODE=41002
  export G4VERSION_NUMBER=1002
  export G4VIS_NONE=0
  export NeutronHPCrossSections=$G4NEUTRONHPDATA

  echo "$(tput bold)$(tput setaf 3)NOTICE: Geant4 CL7 version 4.10.03.p01_woMT has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_geant_cl7_stereo

function setup_stereo_cl7_trunk(){

  echo "Seting up STEREO environement for CL7..." >&2

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/trunk/
  export STWORKDIR=${HOME}/sps/Stereo/Install/cl7/trunk/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/cl7/trunk/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO trunk environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_cl7_trunk

function setup_stereo_cl7_v1r0()
{
  echo "Seting up STEREO environement for CL7..." >&2

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v1r0/
  export STWORKDIR=${HOME}/sps/Stereo/Install/cl7/v1r0/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/cl7/v1r0/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v1r0 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_cl7_v1r0

function setup_stereo_cl7_v2r4()
{
  echo "Seting up STEREO environement for CL7..." >&2

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v2r4/
  export STWORKDIR=${HOME}/sps/Stereo/Install/cl7/v2r4/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/cl7/v2r4/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v2r4 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_cl7_v2r4

function setup_stereo_cl7_v2r3()
{
  echo "Seting up STEREO environement for CL7..." >&2

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v2r3/
  export STWORKDIR=${HOME}/sps/Stereo/Install/cl7/v2r3/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/cl7/v2r3/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v2r3 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_cl7_v2r3

function setup_stereo_cl7_v2r2()
{
  echo "Seting up STEREO environement for CL7..." >&2

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v2r2/
  export STWORKDIR=${HOME}/sps/Stereo/Install/cl7/v2r2/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/cl7/v2r2/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v2r2 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_cl7_v2r2

function setup_stereo_cl7_v2r1()
{
  echo "Seting up STEREO environement for CL7..." >&2

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v2r1/
  export STWORKDIR=${HOME}/sps/Stereo/Install/cl7/v2r1/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/cl7/v2r1/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v2r1 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_cl7_v2r1

function setup_stereo_cl7_v2r0()
{
  echo "Seting up STEREO environement for CL7..." >&2

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v2r0/
  export STWORKDIR=${HOME}/sps/Stereo/Install/cl7/v2r0/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/cl7/v2r0/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v2r0 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_cl7_v2r0


################################################################################
# SL6 ENVIRONMENT
################################################################################
function setup_root_sl6_pro(){
  # Using Geant4
  echo "├─ Setting up ROOT SL6 production version..." >&2
  source /usr/local/root/pro/env.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "$(tput bold)$(tput setaf 3)NOTICE: ROOT SL6 production version has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_root_sl6_pro

function setup_root_sl6_60502(){
  # Using Geant4
  echo "├─ Setting up ROOT SL6 version 6.05.02..." >&2
  source /usr/local/root/v6.05.02/env.sh
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "$(tput bold)$(tput setaf 3)NOTICE: ROOT SL6 version 6.05.02 has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_root_sl6_60502

function setup_geant_sl6_41001(){
  echo "├─ Setting up Geant4.10.1 ..." >&2
  source /usr/local/geant4/geant4.10.1/bin/geant4.sh 2> ./trash.log
  source /usr/local/geant4/geant4.10.1/share/Geant4-10.1.0/geant4make/geant4make.sh
  source /usr/local/geant4/geant4.10.1/geant4.cc.sh
  echo "   ├─ Geant4 Prefix : $(geant4-config --prefix)"
  echo "   ├─ Geant4 Version : $(geant4-config --version)"

  # GEANT4 support (4.10.1)
  echo "├─ Setting up some environement variable about Geant4..." >&2
  export g4non_display=1
  export G4VERSIONCODE=41010
  export G4VERSION_NUMBER=1010
  unset  G4WORKDIR
  unset  G4ANALYSIS_USE
  export G4VIS_NONE=0
  export NeutronHPCrossSections=${G4NEUTRONHPDATA}

  echo "$(tput bold)$(tput setaf 3)NOTICE: Geant4 SL6 version 4.10.1.0 has been setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_geant_sl6_41001

function setup_stereo_sl6_trunk(){

  echo "Seting up STEREO environement for SL6..." >&2
  echo "├─ Enabling new compiler..." >&2
  source /opt/rh/devtoolset-3/enable
  source /usr/local/shared/bin/xrootd_env.sh

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/trunk/
  export STWORKDIR=${HOME}/sps/Stereo/Install/sl6/trunk/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/sl6/trunk/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO trunk environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_sl6_trunk

function setup_stereo_sl6_v1r0()
{
  echo "Seting up STEREO environement for SL6..." >&2
  echo "├─ Enabling new compiler..." >&2
  source /opt/rh/devtoolset-3/enable
  source /usr/local/shared/bin/xrootd_env.sh

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v1r0/
  export STWORKDIR=${HOME}/sps/Stereo/Install/sl6/v1r0/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/sl6/v1r0/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v1r0 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_sl6_v1r0

function setup_stereo_sl6_v2r1()
{
  echo "Seting up STEREO environement for SL6..." >&2
  echo "├─ Enabling new compiler..." >&2
  source /opt/rh/devtoolset-3/enable
  source /usr/local/shared/bin/xrootd_env.sh

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v2r1/
  export STWORKDIR=${HOME}/sps/Stereo/Install/sl6/v2r1/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/sl6/v2r1/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v2r1 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_sl6_v2r1

function setup_stereo_sl6_v2r2()
{
  echo "Seting up STEREO environement for SL6..." >&2
  echo "├─ Enabling new compiler..." >&2
  source /opt/rh/devtoolset-3/enable
  source /usr/local/shared/bin/xrootd_env.sh

  export STEREO_PATH=${HOME}/sps/Stereo/stereo/tags/v2r2/
  export STWORKDIR=${HOME}/sps/Stereo/Install/sl6/v2r2/
  export STEREO_BUILD_DIR=${HOME}/sps/Stereo/Build/sl6/v2r2/
  set_stereo_environement

  echo "$(tput bold)$(tput setaf 3)NOTICE: STEREO v2r2 environement is now setup.$(tput sgr 0)$(tput dim)" >&2
  return;
}
export -f setup_stereo_sl6_v2r2

################################################################################
# STEREO ENVIRONMENT
################################################################################
function setup_root()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    # setup_root_cl7_60604
    # setup_root_cl7_61002
    # setup_root_cl7_pro
    # setup_root_cl7_oldpro
    setup_root_cl7
    # setup_root_cl7_61302
  else
    setup_root_sl6_60502
  fi

}
export -f setup_root

function setup_root_cl7()
{
  # Using Geant4
  echo "├─ Setting up ROOT for CL7..." >&2
  # https://doc.cc.in2p3.fr/soft_liste_des_logiciels_disponibles_au_centre_de_calcul
  # ccenv --list root -> pour récupérer les versions valides
  ccenv root
  echo "   ├─ ROOT Prefix : $(root-config --prefix)"
  echo "   ├─ ROOT Version : $(root-config --version)"

  echo "NOTICE: CL7 ROOT version 6.06.04 has been setup." >&2
  return;
}
export -f setup_root_cl7

function setup_geant()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    # setup_geant_cl7_41003
    # setup_geant_cl7_stereo
    setup_geant_cl7
  else
    setup_geant_sl6_41001
  fi

}
export -f setup_geant

function setup_geant_cl7()
{
  # Using Geant4
  echo "├─ Setting up Geant4 for CL7..." >&2
  # https://doc.cc.in2p3.fr/soft_liste_des_logiciels_disponibles_au_centre_de_calcul
  # ccenv --list geant4 -> pour récupérer les versions valides
  ccenv geant4
  echo "   ├─ Geant4 Prefix : $(geant4-config --prefix)"
  echo "   ├─ Geant4 Version : $(geant4-config --version)"

  echo "NOTICE: CL7 ROOT version 6.06.04 has been setup." >&2
  return;
}
export -f setup_geant_cl7

function setup_stereo_trunk()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    setup_stereo_cl7_trunk
  else
    setup_stereo_sl6_trunk
  fi

}
export -f setup_stereo_trunk


function setup_stereo_v1r0()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    setup_stereo_cl7_v1r0
  else
    setup_stereo_sl6_v1r0
  fi

}
export -f setup_stereo_v1r0

function setup_stereo_v2r2()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    setup_stereo_cl7_v2r2
  else
    setup_stereo_sl6_v2r2
  fi

}
export -f setup_stereo_v2r2

function setup_stereo_v2r3()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    setup_stereo_cl7_v2r3
  else
    setup_stereo_sl6_v2r3
  fi

}
export -f setup_stereo_v2r3


function setup_stereo_v2r4()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    setup_stereo_cl7_v2r4
  else
    setup_stereo_sl6_v2r4
  fi

}
export -f setup_stereo_v2r4


function setup_stereo_v2r1()
{

  if [ "$(lsb_release -si)" = "CentOS" ];
  then
    setup_stereo_cl7_v2r1
  else
    setup_stereo_sl6_v2r1
  fi

}
export -f setup_stereo_v2r1


function setup_stereo()
{

  setup_stereo_trunk

}
export -f setup_stereo
