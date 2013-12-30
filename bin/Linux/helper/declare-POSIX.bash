#!/bin/bash
# Declare functionality for POSIX (mostly directory and file handling)

changeFileGroup () {
  # Change ownership of file $2 to group $1
  requireParameters 2 "$#"
  requireParameter "$1" 1 'group'
  requireParameter "$2" 2 'target file'

  # TODO:  Test existence of group $1
  requireFile "$2"
  logInfo "Changing owner of file '$2' to group '$1'..."
  chgrp "$1" "$2"
  abortOnFail "$?"
}
export -f changeFileGroup

copyFile () {
  # Copy source file $1 to target file $2, but not if it exists
  requireParameters 2 "$#"
  requireParameter "$1" 1 'source file'
  requireParameter "$2" 2 'target file'

  requireFile "$1"
  if fileExists "$2" ; then
    logDebug "File '$2' exists, skipping copy of file '$1'!"
  else
    logInfo "Copying file '$2' from file '$1'..."
    cp "$1" "$2"
    abortOnFail "$?"
  fi
  requireFile "$2"
}
export -f copyFile

copyFileForce () {
  # Copy source file $1 to target file $2, EVEN if it exists
  requireParameters 2 "$#"
  requireParameter "$1" 1 'source file'
  requireParameter "$2" 2 'target file'

  requireFile "$1"
  if fileExists "$2" ; then
    logWarn "File '$2' exists, overwriting!"
  fi
  logInfo "Copying file '$2' from file '$1'..."
  cp "$1" "$2"
  abortOnFail "$?"
  requireFile "$2"
}
export -f copyFileForce

copyFiles () {
  # Copy all files in source directory $1 to target directory $2
  requireParameters 2 "$#"
  requireParameter "$1" 1 'source directory'
  requireParameter "$2" 2 'target directory'

  requireDirectory "$1"
  # if directoryExists "$2" ; then
    logInfo "Copying directory '$2' from directory '$1'..."
    cp -R $1/* $2/
    abortOnFail "$?"
  # fi
  requireDirectory "$2"
}
export -f copyFiles

createDirectory () {
  # Create directory $1, but not if it exists
  requireParameters 1 "$#"
  requireParameter "$1" 1 'target directory'

  if directoryExists "$1" ; then
    logDebug "Directory '$1' exists, skipping creation!"
  else
    logInfo "Creating directory '$1'..."
    mkdir -p "$1"
    abortOnFail "$?"
  fi
  requireDirectory "$1"
}
export -f createDirectory

directoryExists () {
  # Return whether directory $1 exists, abort if it is not creatable
  requireParameters 1 "$#"
  requireParameter "$1" 1 'target directory'

  [[   -d "$1" ]] && \
    logDebug "Found directory '$1'" && return 0
  [[   -e "$1" ]] && \
    abort "Found non-directory '$1'"
  return 1 # $1 does not exist, but appears to be creatable
}
export -f directoryExists

fileExists () {
  # Return whether file $1 exists, abort if it is not creatable
  requireParameters 1 "$#"
  requireParameter "$1" 1 'target file'

  [[   -f "$1" ]] && \
    logDebug "Found file '$1'" && return 0
  [[   -e "$1" ]] && \
    abort "Found non-file '$1'"
  return 1 # $1 does not exist, but appears to be creatable
}
export -f fileExists

makeFilesExecutable () {
  # Make the files executable within directory $1
  requireParameters 1 "$#"
  requireParameter "$1" 1 'target directory'

  requireDirectory "$1"
  logInfo "Making files executable in directory '$1'..."
  chmod -R u+x "$1"
  abortOnFail "$?"
}
export -f makeFilesExecutable

moveFile () {
  # Move source file $1 to target file $2, but not if it exists
  requireParameters 2 "$#"
  requireParameter "$1" 1 'source file'
  requireParameter "$2" 2 'target file'

  requireFile "$1"
  if fileExists "$2" ; then
    logError "File '$2' exists, skipping move of file '$1'!"
  else
    logInfo "Moving file '$2' from file '$1'..."
    mv "$1" "$2"
    abortOnFail "$?"
  fi
  # TODO:  Check that file $1 is gone?
  requireFile "$2"
}
export -f moveFile

requireDirectory () {
  # Require that directory $1 exists, abort if not
  requireParameters 1 "$#"
  requireParameter "$1" 1 'target directory'

  directoryExists "$1" && return 0
  abort "Required directory '$1' must exist!"
}
export -f requireDirectory

requireFile () {
  # Require that file $1 exists, abort if not
  requireParameters 1 "$#"
  requireParameter "$1" 1 'target file'

  fileExists "$1" && return 0
  abort "Required file '$1' must exist!"
}
export -f requireFile

: <<'DisabledContent'
  # TODO:  Refactor & redesign

directoryExists () {
  # Verify that directory $1 exists
  # $1 = pathname that should exist and be a directory
  [[   -d "$1" ]] && logInfo  "Found directory $1"         && return 0
  [[ ! -e "$1" ]] && logError "Pathname $1 does not exist" && return 1
  [[   -e "$1" ]] && logError "Found non-directory $1"     && return 2
  return 3
}

fileExists () {
  # Verify that file $1 exists
  # $1 = pathname that should exist and be a file
  [[   -f "$1" ]] && logInfo  "Found file $1"              && return 0
  [[ ! -e "$1" ]] && logError "Pathname $1 does not exist" && return 1
  [[   -e "$1" ]] && logError "Found non-file $1"          && return 2
  return 3
}

maybeCopyFile () {
  # Copy file $1 to directory $2 as $3, but not if it exists
  # $1 = pathname of source file
  # $2 = name of target directory
  # $3 = name of target file
  [[   -f "$2/$3" ]] && logInfo  "Found file $2/$3"           && return 0
  [[ ! -e "$1"    ]] && logError "Pathname $1 does not exist" && return 1
  [[ ! -f "$1"    ]] && logError "Found non-file $1"          && return 2
  maybeCreateDirectory "$2"
  directoryExists "$2" && cp "$1" "$2/$3" && logInfo "Created $2/$3"
}

maybeCreateDirectory () {
  # Create directory $1, but not if it exists
  # $1 = pathname of directory to create
  maybeDirectoryExists "$1" && return 0
  pathnameNotExists "$1" && mkdir -p "$1" && logInfo "Created $1"
  directoryExists "$1"
}

maybeDirectoryExists () {
  # Return pathname $1 does not exist or is a directory
  # $1 = pathname that could be a directory or not exist
  [[ -d "$1" ]] && logInfo  "Found directory $1"     && return 0
  [[ -e "$1" ]] && logError "Found non-directory $1" && return 2
  logInfo "Pathname $1 does not exist"               && return 1
}

pathnameNotExists () {
  # Verify that pathname $1 does not exist
  # $1 = pathname that should not exist
  [[ -e "$1" ]] && logError "Pathname $1 should not exist" && return 1
  return 0
}
DisabledContent

