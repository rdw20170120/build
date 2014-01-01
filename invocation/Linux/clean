#!/bin/bash
logDebug 'Cleaning this project of all output and temporary files...'

requireVariable BO_Project

find ${BO_Project} \( -type f -a -name "*.out"         \) -exec rm {} \;
find ${BO_Project} \( -type f -a -name "sloccount.sc"  \) -exec rm {} \;

