#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# Update (install) BriteOnyx content in current directory, so that this directory becomes the root
# of a BriteOnyx-enabled project.  BriteOnyx content is taken from $BO_Home, if configured.  Use
# first argument as $BO_Home, if provided.  Project must be re-activated to apply the new content.
####################################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

####################################################################################################
main () {
  # Optional parameter 1 is source directory to be used as BO_Home
  [[ -n "$1" ]] && BO_Home=$1
  [[ -z "$BO_Home" ]] && echo 'FATAL: source directory was not provided' && exit 1

  local -r DirHere=$PWD
  local -r DirSrc=$BO_Home/sample_project/BriteOnyx
  local -r DirTgt=$DirHere/BriteOnyx

  echo "Updating/installing BriteOnyx content here in directory '$DirHere', from directory '$BO_Home'"
  [[ -d "$DirTgt" ]] && rm -r $DirTgt
  cp $BO_Home/sample_project/activate.src $DirHere/activate.src

  # Handle new content
  mkdir                         $DirTgt
  cp $DirSrc/declare.src        $DirTgt
  cp $DirSrc/env.src            $DirTgt
  cp $DirSrc/maybeActivate.src  $DirTgt
  mkdir                                           $DirTgt/starter
  cp $DirSrc/starter/project.hgignore             $DirTgt/starter
  cp $DirSrc/starter/project-fix-permissions.bash $DirTgt/starter
  cp $DirSrc/starter/project-env.src              $DirTgt/starter
  cp $DirSrc/starter/user-BriteOnyx.src           $DirTgt/starter
}

main $@

####################################################################################################
: <<'DisabledContent'
  # Handle old content
  cp -R $DirSrc  $DirTgt
DisabledContent
