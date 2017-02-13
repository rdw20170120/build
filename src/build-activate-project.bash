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

echo "Build project activate script"

Dir=$DirTgt/sample_project
[[ ! -e "$Dir" ]] && echo "Creating directory '$Dir'" && mkdir -p "$Dir"

File=$Dir/activate.src

echo "Creating file '$File'"

cat  >"$File" <"$DirSrc/piece/header.src"
cat >>"$File" <"$DirSrc/piece/header-executing.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/comment-no_exit.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/comment-debugging.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/comment.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/startup.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/set-BO_Project.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/source-declare-BriteOnyx.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/reset-BO_Project.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/source-bootstrap.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/source-activate-Linux.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/cd-BO_Project.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/call-fix_permissions.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/source-declare-project.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/logging.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/shutdown.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/footer-return.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/activate/footer-disabled_content.bash"

################################################################################
: <<'DisabledContent'
DisabledContent
