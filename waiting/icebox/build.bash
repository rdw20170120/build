#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Assumes this project has been activated using the BriteOnyx framework.
################################################################################
# Reference our script context
Self="$(getPathAbsolute $BASH_SOURCE)" ; abortOnFail $?
This="$(dirname $Self)"                ; abortOnFail $?

################################################################################
main () {
  parametersRequire 0 $#

  logInfo "Building exercises from source"

  # Configure for this subproject
  local Script
  Script=$This/env.src
  scriptRequire $Script ; source $Script ; abortOnFail $?

  # Reference root directory of source files
  local -rx CB_DirSrc=$This/src

  # Declare supporting functionality
  Script=$CB_DirSrc/helper/declare.src
  scriptRequire $Script ; source $Script ; abortOnFail $?

  # Recreate directory for generated scripts
  variableRequire    CB_DirGen
  directoryRecreate $CB_DirGen
  cp -R $CB_DirSrc/as-is/* $CB_DirGen/
  abortOnFail $?

  # Generate new scripts
  local -r Dir=$CB_DirSrc/exercise
  local -i Exercise=0

  (( Exercise++ )) ; scriptExecute $Dir/setup-cluster.bash           $Exercise
  (( Exercise++ )) ; scriptExecute $Dir/configure-buckets.bash       $Exercise
  (( Exercise++ )) ; scriptExecute $Dir/load-CM2.bash                $Exercise

  # Add BriteOnyx activation
  variableRequire BO_Home
  cd $CB_DirGen ; abortOnFail $?
  # TODO: FIX: Enhance BriteOnyx update script to avoid extra steps here
  touch activate.src
  mkdir BriteOnyx
  scriptExecute $BO_Home/invocation/Linux/BriteOnyx-update-here.bash
}

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

main

################################################################################
: <<'DisabledContent'
DisabledContent
