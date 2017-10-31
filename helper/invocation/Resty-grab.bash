#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"

###################################################################################################
# Grab the Resty tool for use in this project

# NOTE: Assumes that this project has been activated using the BriteOnyx framework.
###################################################################################################

variableRequire 'BO_Project'
directoryRequire "$BO_Project"

Version=2.2

Dir="$BO_Project/lib"
directoryCreate "${Dir}"

logInfo "Grabbing Resty ${Version} into ${Dir}..."

Url=https://github.com/micha/resty/releases
logInfo "Note the available releases at ${Url}, we are currently using version '${Version}'"

File="Resty-${Version}.bash"
Url=http://github.com/micha/resty/raw/master/resty
curl -L ${Url} >"${Dir}/${File}"
abortOnFail $0 $LINENO $?
logInfo "Note that the version is not embedded into the downloaded script or its URL, so it might not actually be version '${Version}'"

File="Resty-${Version}-source.tgz"
Url=https://github.com/micha/resty/archive/${Version}.tar.gz
curl -L ${Url} >"${Dir}/${File}"
abortOnFail $0 $LINENO $?

###################################################################################################
: <<'DisabledContent'
# Use Resty tool

variableRequire 'BO_Project'
export ScriptResty="$BO_Project/lib/Resty-2.2.src"
fileRequire "$ScriptResty"
chmod u+x   "$ScriptResty"
abortOnFail $0 $LINENO $?

# Do not 'source' Resty here, do it upon actual use
# source "$ScriptResty"
DisabledContent

