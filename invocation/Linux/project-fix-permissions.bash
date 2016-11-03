#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
# NOTE: Assumes that this project has been activated using the BriteOnyx framework.
# NOTE: Apple Mac OSX BASH find does not support -perm with "/" syntax
# TODO: SOMEDAY FIX: Make this work on OSX (unrecognized syntax)
# TODO: SOMEDAY Refactor individual commands into BASH functions
# TODO: SOMEDAY Make this work against contents of BO_Project, safely
###################################################################################################

variableRequire   BO_Project
directoryRequire $BO_Project

fixPermissions () {
  logInfo "Fixing POSIX permissions within path '$1'"
  parametersRequire 1 "$#"
  valueRequire "$1" 'path'

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

fixPermissions $1

###################################################################################################
: <<'DisabledContent'
DisabledContent
