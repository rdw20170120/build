#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Assumes this project has been activated using the BriteOnyx framework.
################################################################################
# Reference our script context
Self="$(getPathAbsolute $0)" ; abortOnFail $0 $LINENO $?
This="$(dirname $Self)"      ; abortOnFail $0 $LINENO $?

################################################################################
[[ -z "$1" ]] && abort $0 $LINENO 1 'A regular expression pattern is required as the first positional parameter'
logInfo "Search for regex pattern '$1' in source text"

Dir=$PWD
variableRequire   Dir
directoryRequire $Dir
cd $Dir ; abortOnFail $0 $LINENO $?

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

logInfo "Searching directory '$Dir' for regex '$1'"
for File in $(grep -Elr $1 $Dir \
  --include='*.bash' --include='*.md'  --include='*.py' \
  --include='*.rst'  --include='*.src' --include='*.txt' \
  | sort) ; do
  logInfo "Searching for '$1' in '$File'"
  sed -n "/$1/ {p}" $File
done

################################################################################
: <<'DisabledContent'
DisabledContent

