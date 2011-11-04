#!/bin/bash

echo 'INFO:  Configure project (specific)'

export BO_Version=0.1

# Configure project home package (parent package of all project source)
# NOTE:  All project source should be contained in
#        ${BO_Project}/src/${HomePackage}
export HomePackage=example

# Configure PIP download cache
[[   -z "$TMPDIR" ]] && \
  echo 'FATAL: Missing value for $TMPDIR' && exit 1
export PIP_DOWNLOAD_CACHE=$TMPDIR/pip
