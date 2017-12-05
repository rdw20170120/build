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

  logInfo "Assemble content from curriculum development"

  # Configure for this subproject
  local Script
  Script=$This/env.src
  scriptRequire $Script ; source $Script ; abortOnFail $?

  # Reset assembly directory
  variableRequire    CB_DirAssembly
  directoryRecreate $CB_DirAssembly

  # Assemble solution
  directoryCreate $CB_DirAssembly/solution
  cp -pR $This/expect/CB-4.5/* $CB_DirAssembly/solution/
  cp -pR $This/tgt/exercise/*  $CB_DirAssembly/solution/
  rm -f  $CB_DirAssembly/solution/activate
  rm -f  $CB_DirAssembly/solution/BO-env-*.out
  rm -f  $CB_DirAssembly/solution/*.bash
  rm -fr $CB_DirAssembly/solution/bin
  rm -fr $CB_DirAssembly/solution/BriteOnyx
  find $CB_DirAssembly/solution -name '*.bash' -type f -exec rm -f {} \;
  find $CB_DirAssembly/solution -name '*.txt'  -type f -exec rm -f {} \;

  # Assemble test suite
  directoryCreate    $CB_DirAssembly/test-suite
  cp -pR $This/tgt/* $CB_DirAssembly/test-suite/

  # Assemble workbook
  directoryCreate $CB_DirAssembly/workbook
  find $This/tgt/exercise -name '*.txt' -type f -exec cp {} $CB_DirAssembly/workbook/ \;
}

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

main

################################################################################
: <<'DisabledContent'

  # TODO: Remove work-in-progress content from final release
  #       by refactoring adjacent to build.bash
  rm -fr $Dir/solution/99-wip
  rm -f  $Dir/workbook/99-wip.txt
DisabledContent
