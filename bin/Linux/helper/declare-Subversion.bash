#!/bin/bash
# Declare BASH functionality for Subversion
# TODO: Integrate with latest framework

checkoutSubversion () {
  # Checkout repository $1 to directory $2, but not if $2 exists
  requireParameters "$FUNCNAME" "$LINENO" 2 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'target directory'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'Subversion URL'

  if directoryExists "$1" ; then
    logWarn "$FUNCNAME" "$LINENO" "Directory '$1' exists, skipping checkout of '$2'!"
    return 1
  else
    logInfo "$FUNCNAME" "$LINENO" "Checking out '$1' from '$2'..."
    svn checkout "$2" "$1"
    abortOnFail "$FUNCNAME" "$LINENO" "$?"
    requireDirectory "$1"
  fi
}

