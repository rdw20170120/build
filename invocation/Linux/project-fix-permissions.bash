#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
# NOTE: Assumes that this project has been activated using the BriteOnyx framework.
# NOTE: Apple Mac OSX BASH find does not support -perm with "/" syntax
# TODO: FIX: Make this work on OSX as well as Linux
###################################################################################################

variableRequire 'BO_Project'
directoryRequire "$BO_Project"

fixPermissions () {
  logInfo "Fixing POSIX permissions within path '$1'"
  parametersRequire 1 "$#"
  valueRequire "$1" 'path'

  # TODO: SOMEDAY FIX does not work on OSX due to unrecognized syntax

  # Make all directories accessible by the owner
  find "$1" -type d \! -perm -u+rw -exec ls -al     '{}' \;
  find "$1" -type d \! -perm -u+rw -exec chmod u+rw '{}' \;

  # Make all files accessible by the owner
  find "$1" -type f \! -perm -u+rw -exec ls -al     '{}' \;
  find "$1" -type f \! -perm -u+rw -exec chmod u+rw '{}' \;

  # Make BASH scripts executable by the owner
  find "$1" -type f \! -perm -u+x -name '*.bash' -exec ls -al    '{}' \;
  find "$1" -type f \! -perm -u+x -name '*.bash' -exec chmod u+x '{}' \;

  # Make Sed scripts NOT executable by the owner
  find "$1" -type f    -perm -u+x -name '*.sed' -exec ls -al    '{}' \;
  find "$1" -type f    -perm -u+x -name '*.sed' -exec chmod u-x '{}' \;

  # Make BASH source files NOT executable by the owner
  find "$1" -type f    -perm -u+x -name '*.src' -exec ls -al    '{}' \;
  find "$1" -type f    -perm -u+x -name '*.src' -exec chmod u-x '{}' \;

  # Make all directories NOT accessible by the group or others
  find "$1" -type d -perm /g+rwx -exec ls -al   '{}' \;
  find "$1" -type d -perm /g+rwx -exec chmod g= '{}' \;
  find "$1" -type d -perm /o+rwx -exec ls -al   '{}' \;
  find "$1" -type d -perm /o+rwx -exec chmod o= '{}' \;

  # Make all files NOT accessible by the group or others
  find "$1" -type f -perm /g+rwx -exec ls -al   '{}' \;
  find "$1" -type f -perm /g+rwx -exec chmod g= '{}' \;
  find "$1" -type f -perm /o+rwx -exec ls -al   '{}' \;
  find "$1" -type f -perm /o+rwx -exec chmod o= '{}' \;

} && export -f fixPermissions

###################################################################################################
logInfo "Fixing POSIX permissions in project '$BO_Project'"

fixPermissions $BO_Project

###################################################################################################
: <<'DisabledContent'
DisabledContent
