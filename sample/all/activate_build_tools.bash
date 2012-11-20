#!/bin/bash

_Url='ssh://hg@bitbucket.org/robwilliams/build'

echo "INFO: Configure build tools from ${_Url}"

[[   -z "$ParentBuildTools" ]] && \
  echo 'FATAL: Missing value for $ParentBuildTools' && exit 1
[[ ! -e "$ParentBuildTools" ]] && \
  mkdir -p "$ParentBuildTools"
[[ ! -d "$ParentBuildTools" ]] && \
  echo "FATAL: Missing directory $ParentBuildTools" && exit 1
[[   -z "$RevisionBuildTools" ]] && \
  echo 'FATAL: Missing value for $RevisionBuildTools' && exit 1
HomeBuildTools=$ParentBuildTools/$RevisionBuildTools
[[   -z "$HomeBuildTools" ]] && \
  echo 'FATAL: Missing value for $HomeBuildTools' && exit 1
[[ ! -e "$HomeBuildTools" ]] && \
  hg clone --rev "$RevisionBuildTools" "${_Url}" "$HomeBuildTools"
[[ ! -d "$HomeBuildTools" ]] && \
  echo "FATAL: Missing directory $HomeBuildTools" && exit 1

cd $HomeBuildTools
hg pull --update
cd $HomeProject
