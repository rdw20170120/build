#!/bin/bash
echo 'INFO: Bootstrapping the BriteOnyx framework to support this project...'
# TODO: Selectively use a clone (for 'tip') or an archive (all others) from
#       Mercurial based on version stability

# NOTE: This script should be sourced into the shell environment

_Url='ssh://hg@bitbucket.org/robwilliams/build'

echo "INFO: Bootstrapping BriteOnyx from '${_Url}'"

[[   -z "$BO_Parent"  ]] && echo 'FATAL: Missing $BO_Parent'                   && return 1
[[   -z "$BO_Version" ]] && echo 'FATAL: Missing $BO_Version'                  && return 1
export BO_Home="$BO_Parent/$BO_Version"
[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                     && return 1
[[ ! -e "$BO_Parent"  ]] && mkdir -p "$BO_Parent"
[[ ! -d "$BO_Parent"  ]] && echo "FATAL: Missing directory '$BO_Parent'"       && return 1
[[ ! -e "$BO_Home"    ]] && hg clone --rev "$BO_Version" "${_Url}" "$BO_Home"
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Mercurial clone failed in '$BO_Home'" && return 1

cd $BO_Home
if [[ "$BO_Version" == "tip" ]]; then
    echo "WARN: Updating Mercurial clone of '$BO_Version'"
    hg pull --update
else
    echo "INFO: NOT updating Mercurial clone of '$BO_Version' since it should be stable"
fi

cd $BO_Project

: <<'DisabledContent'
DisabledContent

# Return, but do NOT exit, with a success code
return 0

