#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

################################################################################
# Reference our script context
Self="$BASH_SOURCE"
This="$(dirname $Self)"

################################################################################
[[ -z "$1" ]] && echo 'ABORT: Missing argument: Source directory' && exit 1
[[ -z "$2" ]] && echo 'ABORT: Missing argument: Target directory' && exit 2

echo "Build whole scripts in directory '$2' from script pieces in directory '$1'"

$This/build-activate-Gradle.bash  "$1" "$2"
$This/build-activate-Linux.bash   "$1" "$2"
$This/build-activate-Python.bash  "$1" "$2"
$This/build-activate-project.bash "$1" "$2"
$This/build-bootstrap.bash        "$1" "$2"

################################################################################
: <<'DisabledContent'
DisabledContent
