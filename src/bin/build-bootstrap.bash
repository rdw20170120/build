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

DirSrc=$1
DirTgt=$2

echo "Build bootstrap script"

Dir=$DirTgt/sample_project/BriteOnyx
[[ ! -e "$Dir" ]] && echo "Creating directory '$Dir'" && mkdir -p "$Dir"

File=$Dir/bootstrap.src

echo "Creating file '$File'"

cat  >"$File" <"$DirSrc/piece/header.src"
cat >>"$File" <"$DirSrc/piece/header-executing.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/comment-no_exit.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/comment-debugging.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/comment.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/005-verify-preconditions.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/006-copy_starter_files.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/007-source-env-BriteOnyx.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/010-source-env-project.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/012-source-env-user.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/014-verify-bootstrap.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src/015-grab-source.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/footer-return.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/footer-disabled_content.bash"

################################################################################
: <<'DisabledContent'
DisabledContent
