#!/bin/bash
# Declare BASH functionality for the Jenkins continuous integration server
# TODO: Integrate with latest framework

Jenkins_findBuild() {
  # Return whether found Jenkins build for job $2, and save to file $1 if found
  requireParameters "$FUNCNAME" "$LINENO" 2 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'build number file'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'Jenkins URL'

  logInfo "$FUNCNAME" "$LINENO" "Getting build number from '$2'..."
  _Number=$(Jenkins_getBuildNumber "$2")
  Jenkins_saveBuildNumber "$1" "${_Number}"
}

Jenkins_getArtifact () {
  # Get the Jenkins build artifact from URL $1 as file $2
  requireParameters "$FUNCNAME" "$LINENO" 2 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'artifact target file'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'artifact URL'

  if fileExists "$1"; then
    logWarn "$FUNCNAME" "$LINENO" "Artifact $1 already exists, skipping get!"
  else
    logInfo "$FUNCNAME" "$LINENO" "Getting artifact file '$1' from '$2'..."
    curl -L# "$2" > "$1"
    abortOnFail "$FUNCNAME" "$LINENO" "$?"
    requireFile "$1"
  fi
}

Jenkins_getBuildNumber () {
  # Return the Jenkins build number for job $1
  # NOTE:  Designed to return result via standard output
  requireParameters "$FUNCNAME" "$LINENO" 1 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'Jenkins job'

  declare -r _Number=$(curl -Ls "$1")
  abortOnFail "$FUNCNAME" "$LINENO" "$?"
  echo "${_Number}"
}

Jenkins_saveBuildNumber() {
  # Save Jenkins build number $2 to file $1
  requireParameters "$FUNCNAME" "$LINENO" 2 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'target file'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'build number'

  logInfo "$FUNCNAME" "$LINENO" "Saving build number '$2' in file '$1'..."
  echo "$2" > "$1"
  requireFile "$1"
}
