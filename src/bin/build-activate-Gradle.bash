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

echo "Build Gradle activate script"

Dir=$DirTgt/activation/Gradle
[[ ! -e "$Dir" ]] && echo "Creating directory '$Dir'" && mkdir -p "$Dir"

File=$Dir/activate.src

echo "Creating file '$File'"

cat  >"$File" <"$DirSrc/piece/header.src"
cat >>"$File" <"$DirSrc/piece/header-executing.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/comment-assumes.bash"
cat >>"$File" <"$DirSrc/piece/comment-no_exit.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/comment-debugging.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/activation/Gradle/verify-preconditions.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/activation/source-activate_Linux.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/activation/Gradle/verify-postconditions.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/activation/Gradle/set-PATH.src"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/activation/footer-return.bash"
cat >>"$File" <"$DirSrc/piece/comment-separator.bash"
cat >>"$File" <"$DirSrc/piece/footer-disabled_content.bash"

################################################################################
: <<'DisabledContent'
DisabledContent

