#!/bin/bash
# Activate this project using the BriteOnyx framework

echo 'WARN: Should be executed as "source activate", was it?'

# Dump incoming environment for troubleshooting
env | sort > ./env.out

# Remember the current directory as our project home
export HomeProject=${PWD}

source $HomeProject/project-env.bash
source $HomeProject/activate_build_tools.bash
source $HomeBuildTools/activate_Python_project.bash

