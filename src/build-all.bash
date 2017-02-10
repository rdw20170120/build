#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

################################################################################
[[ -z "$1" ]] && abort 1 'Source directory'
[[ -z "$2" ]] && abort 1 'Target directory'

echo "Build whole scripts in directory '$2' from script pieces in directory '$1'"

# TODO: Implement

################################################################################
: <<'DisabledContent'
DisabledContent
