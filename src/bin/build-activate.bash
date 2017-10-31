#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$0'"
################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

################################################################################
# Reference our script context
Self="$0[0]"
This="$(dirname $Self)"

################################################################################
[[ -z "$1" ]] && echo 'ABORT: Missing argument: Source directory' && exit 1
[[ -z "$2" ]] && echo 'ABORT: Missing argument: Target directory' && exit 2

DirSrc=$1
DirTgt=$2

echo 'Build new project activate script'

Dir=$DirTgt/sample_project
[[ ! -e "$Dir" ]] && echo "Creating directory '$Dir'" && mkdir -p $Dir

File=$Dir/activate.src

echo "Creating file '$File'"

Dir=$DirSrc/piece
cat  >$File <$Dir/header.src
cat >>$File <$Dir/header-executing.bash
cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/comment-no_exit.bash
cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/comment-debugging.bash

Dir=$DirSrc/piece/bootstrap/sample_project/activate.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/comment.bash

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/000-startup.bash

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/001-set-BO_Project.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/002-source-declare-BriteOnyx.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/003-reset-BO_Project.src

# NOTE: Separate script pulled into this one
# cat >>$File <$Dir/004-source-bootstrap.src

Dir=$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src

# TODO: REMOVE: 005 is redundant of 003
# cat >>$File <$DirSrc/piece/comment-separator.bash
# cat >>$File <$Dir/005-verify-preconditions.bash

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/006-new_copy_starter_files.bash

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/012-source-env-user.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/010-source-env-project.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/007-source-env-BriteOnyx.src

Dir=$DirSrc/piece/bootstrap/sample_project/BriteOnyx/bootstrap.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/014-new-verify-bootstrap.bash

# NOTE: NOT grabbing source anymore, require predeployment
# TODO: SOMEDAY: Reimplement deployment
# cat >>$File <$DirSrc/piece/comment-separator.bash
# cat >>$File <$Dir/015-grab-source.bash

Dir=$DirSrc/piece/bootstrap/sample_project/BriteOnyx/env.src

# TODO: REMOVE: 008 is redundant of 003
# cat >>$File <$DirSrc/piece/comment-separator.bash
# cat >>$File <$Dir/008-verify-preconditions.bash

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/009c-set-BO_PathSystem.src

Dir=$DirSrc/piece/bootstrap/sample_project/activate.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/016-source-activate-Linux.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/017-set-TMPDIR.src

# NOTE: Do NOT cd, since it unacceptably changes the caller's environment
# cat >>$File <$DirSrc/piece/comment-separator.bash
# cat >>$File <$Dir/023-cd-BO_Project.src

# cat >>$File <$DirSrc/piece/comment-separator.bash
# cat >>$File <$Dir/024-call-fix_permissions.bash

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/025-source-declare-project.src

Dir=$DirSrc/piece/bootstrap/sample_project/activate.src

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/026-logging.bash

cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/027-shutdown.bash

Dir=$DirSrc/piece/bootstrap
# cat >>$File <$DirSrc/piece/comment-separator.bash
# cat >>$File <$Dir/footer-return.bash

Dir=$DirSrc/piece
cat >>$File <$DirSrc/piece/comment-separator.bash
cat >>$File <$Dir/footer-disabled_content.bash

################################################################################
: <<'DisabledContent'
DisabledContent
