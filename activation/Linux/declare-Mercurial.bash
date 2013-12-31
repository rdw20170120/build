#!/bin/bash
# Declare BASH functionality for Mercurial
# TODO: Integrate with latest framework

cloneMercurial () {
  # Clone repository $1 to directory $2, but not if $2 exists
  requireParameters "$FUNCNAME" "$LINENO" 2 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'target clone directory'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'Mercurial repository URL'

  if directoryExists "$1" ; then
    logWarn "$FUNCNAME" "$LINENO" "Directory '$1' exists, skipping clone of '$2'!"
    return 1
  else
    logInfo "$FUNCNAME" "$LINENO" "Creating Mercurial clone '$1' from repository '$2'..."
    hg clone "$2" "$1"
    abortOnFail "$FUNCNAME" "$LINENO" "$?"
    requireDirectory "$1"
  fi
}

updateMercurial () {
  # Update Mercurial clone $1 to branch $2
  requireParameters "$FUNCNAME" "$LINENO" 2 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'target clone directory'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'Mercurial branch name'

  requireDirectory "$1"
  logInfo "$FUNCNAME" "$LINENO" "Updating Mercurial clone '$1' to branch '$2'..."
  cd "$1"
  hg update "$2"
  abortOnFail "$FUNCNAME" "$LINENO" "$?"
}

