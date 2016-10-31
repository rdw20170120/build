#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Assumes this project has been activated using the BriteOnyx framework.
################################################################################
# Reference our script context
Self="$(getPathAbsolute $BASH_SOURCE)" ; abortOnFail $?
This="$(dirname $Self)"                ; abortOnFail $?

################################################################################
[[ -z "$1" ]] && abort 1 'A regular expression pattern is required as the first positional parameter'
[[ -z "$2" ]] && abort 1 'Replacement text is required as the second positional parameter'
logInfo "Replace regex pattern '$1' with text '$2' in BASH scripts"

Dir=$PWD
variableRequire   Dir
directoryRequire $Dir
cd $Dir ; abortOnFail $?

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

logInfo "Searching directory '$Dir' for regex '$1'"
for File in $(grep -Elr $1 $Dir --include='*.bash' --include='*.src' | sort) ; do
  logInfo "Replace '$1' with '$2' in '$File'"
  sed -i "/$1/ { s/$1/$2/ }" $File
done

################################################################################
: <<'DisabledContent'
DisabledContent
