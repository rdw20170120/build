#!/bin/bash
# Declare all BASH functionality for BriteOnyx

requireVariable BO_Home
requireDirectory $BO_Home

# Configure the Linux environment
_Dir=$BO_Home/bin/Linux/helper
requireDirectory ${_Dir}
# TODO:  Temporarily disabled for debugging...
# source ${_Dir}/declare-logging.bash
# source ${_Dir}/declare-BASH.bash
# source ${_Dir}/declare-POSIX.bash
# source ${_Dir}/declare-Hudson.bash
# source ${_Dir}/declare-Mercurial.bash
# source ${_Dir}/declare-Subversion.bash

