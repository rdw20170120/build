#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: Assumes this project has been activated using the BriteOnyx framework.

# Update BriteOnyx activation content embedded here (in current directory) within active project.
# BriteOnyx content is taken from $BO_Home, based on the project's configured BriteOnyx version.
# Project must be re-activated to apply the new content.

####################################################################################################
# Reference our script context
Self="$(getPathAbsolute $BASH_SOURCE)" ; abortOnFail $?
This="$(dirname $Self)"                ; abortOnFail $?

main () {
  parametersRequire 0 $#
  # TODO: SOMEDAY accept target directory as parameter

  local -r DirHere=$PWD
  variableRequire   DirHere
  directoryRequire $DirHere
  variableRequire   BO_Home
  directoryRequire $BO_Home

  local -r DirSrc=$BO_Home/sample_project/BriteOnyx
  local -r DirTgt=$DirHere/BriteOnyx
  local -r FileSrc=$BO_Home/sample_project/activate.src
  local -r FileTgt=$DirHere/activate.src

  logInfo "Updating BriteOnyx activation content here in directory '$DirHere', from '$BO_Home'"
  directoryRequire $DirSrc
  fileRequire      $FileSrc
  directoryRequire $DirTgt
  fileRequire      $FileTgt
  rm -r          $DirTgt  ; abortOnFail $?
  cp -R $DirSrc  $DirTgt  ; abortOnFail $?
  cp    $FileSrc $FileTgt ; abortOnFail $?
}

####################################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

main

####################################################################################################
: <<'DisabledContent'
DisabledContent
