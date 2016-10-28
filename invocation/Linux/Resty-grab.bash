#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"

###################################################################################################
# Grab the Resty tool for use in this project

# NOTE: Assumes that this project has been activated using the BriteOnyx framework.
###################################################################################################

requireVariable 'BO_Project'
requireDirectory "$BO_Project"

_Version=2.2

_Dir="$BO_Project/lib"
createDirectory "${_Dir}"

logInfo "Grabbing Resty ${_Version} into ${_Dir}..."

_Url=https://github.com/micha/resty/releases
logInfo "Note the available releases at ${_Url}, we are currently using version '${_Version}'"

_File="Resty-${_Version}.bash"
_Url=http://github.com/micha/resty/raw/master/resty
curl -L ${_Url} >"${_Dir}/${_File}"
abortOnFail $?
logInfo "Note that the version is not embedded into the downloaded script or its URL, so it might not actually be version '${_Version}'"

_File="Resty-${_Version}-source.tgz"
_Url=https://github.com/micha/resty/archive/${_Version}.tar.gz
curl -L ${_Url} >"${_Dir}/${_File}"
abortOnFail $?

###################################################################################################
: <<'DisabledContent'
DisabledContent

