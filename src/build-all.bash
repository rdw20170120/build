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

$This/Gradle/build-all.bash "$1" "$2"
$This/Linux/build-all.bash  "$1" "$2"
$This/Python/build-all.bash "$1" "$2"

################################################################################
: <<'DisabledContent'
DisabledContent
