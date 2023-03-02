#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Assumes this project has been activated using the BriteOnyx framework.
################################################################################
[[ -z "$1" ]] && abort $0 $LINENO 1 'A regular expression pattern is required as the first positional parameter'
[[ -z "$2" ]] && abort $0 $LINENO 1 'Replacement text is required as the second positional parameter'
logInfo "Attempt (show but do NOT save) replacement of regex pattern '$1' with text '$2' in source text"

Dir=$PWD
variableRequire Dir
directoryRequire $Dir
cd $Dir ; abortOnFail $0 $LINENO $?
logInfo "Searching directory '$Dir' for regex '$1'"
for File in $(grep -Elr $1 $Dir \
  --include='*.bash' --include='*.md'  --include='*.py' \
  --include='*.rst'  --include='*.src' --include='*.txt' \
  | sort) ; do
  logInfo "Attempt replacing '$1' with '$2' in '$File'"
  sed -n "/$1/ { s/$1/$2/ ; p }" $File
done

################################################################################
: <<'DisabledContent'
DisabledContent

