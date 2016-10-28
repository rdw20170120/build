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
logInfo "Search for regex pattern $1 in BASH scripts"

Dir=$PWD
requireVariable   Dir
requireDirectory $Dir
cd $Dir ; abortOnFail $?

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

logInfo "Searching directory '$Dir' for regex $1"
for File in $(grep -Elr $1 $Dir --include='*.bash' | sort) ; do
  logInfo "Searching for $1 in '$File'"
  sed -n "/$1/ {p}" $File
done

################################################################################
: <<'DisabledContent'
DisabledContent

