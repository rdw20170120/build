#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
###################################################################################################
# This script is intended to be an entry point, to be directly executed by a user or otherwise.

main () {
  parametersRequire 0 $#

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  variableRequire CB_ExamId

  logDebug "Writing exam agenda prologue"

  local -r Title="$CB_ExamId exam tasks"

  cat <<HERE
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8"></meta>
    <style>
      body {font-family: serif; font-size: 100%;}
    </style>
    <title class="task">$Title</title>
  </head>
  <body>
    <h1>$Title</h1>
    <ul>
HERE
}

###################################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  main $@
  abortOnFail $0 $LINENO $?
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent

