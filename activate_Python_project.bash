#!/bin/bash

echo 'INFO:  Activating the Python project...'

requireVariable BO_Home
requireDirectory $BO_Home
_Dir=$BO_Home/bin/Python/helper
source ${_Dir}/configure_TMPDIR
source ${_Dir}/configure_pip
source ${_Dir}/configure_virtualenv
source ${_Dir}/configure_PATH
source ${_Dir}/configure_output

