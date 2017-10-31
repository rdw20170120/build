#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$0'"
################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

################################################################################
# Reference our script context
Self="$0"
This="$(dirname $Self)"

################################################################################
[[ -z "$1" ]] && echo 'ABORT: Missing argument: Source directory' && exit 1
[[ -z "$2" ]] && echo 'ABORT: Missing argument: Target directory' && exit 2

DirSrc=$1
DirTgt=$2

echo "Build user environment script"

Dir=$DirTgt/sample_project/BriteOnyx/starter
[[ ! -e "$Dir" ]] && echo "Creating directory '$Dir'" && mkdir -p "$Dir"

File=$Dir/user-BriteOnyx.src

echo "Creating file '$File'"

cat  >"$File" <"$DirSrc/piece/header.src"
cat >>"$File" <"$DirSrc/piece/header-executing.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
# cat >>"$File" <"$DirSrc/piece/comment-no_exit.bash"
# cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
# cat >>"$File" <"$DirSrc/piece/comment-debugging.bash"
# cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/starter/user-BriteOnyx.src/comment.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/starter/user-BriteOnyx.src/013-TODO.bash"
# cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
# cat >>"$File" <"$DirSrc/piece/bootstrap/footer-return.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/bootstrap/sample_project/BriteOnyx/starter/user-BriteOnyx.src/footer-disabled_content.bash"

################################################################################
: <<'DisabledContent'
DisabledContent
