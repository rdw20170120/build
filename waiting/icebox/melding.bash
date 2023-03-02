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

  logInfo "Start Meld for performing diffs of content"

  # Configure for this subproject
  local Script
  Script=$This/env.src
  scriptRequire $Script ; source $Script ; abortOnFail $?

  variableRequire CB_DirGen

  logInfo "meld $CB_DirGen $This/tgt"
  meld >/dev/null 2>&1 --newtab $CB_DirGen $This/tgt &
}

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

main

################################################################################
: <<'DisabledContent'
DisabledContent
