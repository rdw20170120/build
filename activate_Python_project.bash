#!/bin/bash

echo 'INFO:  Activating the Python project...'

requireVariable BO_Home
requireDirectory $BO_Home
_Dir=$BO_Home/bin/Python/helper
source ${Dir}/configure_TMPDIR
source ${Dir}/configure_pip
source ${Dir}/configure_virtualenv
source ${Dir}/configure_PATH
source ${Dir}/configure_output

