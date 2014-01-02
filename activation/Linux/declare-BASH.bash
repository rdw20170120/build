#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

[[ -z "$BO_E_Config" ]] && echo 'FATAL: Missing $BO_E_Config' && return 64
[[ -z "$BO_E_Ok"     ]] && echo 'FATAL: Missing $BO_E_Ok'     && return "$BO_E_Config"
[[ -z "$BO_E_Usage"  ]] && echo 'FATAL: Missing $BO_E_Usage'  && return "$BO_E_Config"

requireParameter () {
  # Require parameter passed as $1, indexed as $2, and described as $3;
  # abort if missing
  requireParameters 3 "$#"
  # $1 = actual parameter value (may be null)
  requireValue "$2" 'parameter index'
  requireValue "$3" 'description'

  abortIfMissing "$1" "Missing parameter $2: $3!"
}
export -f requireParameter

requireParameters () {
  # Require exactly $1 parameters to calling function/script
  [[ "$#" -ne 2 ]] && Oops && exit "$BO_E_Usage"
  requireValue "$1" 'required parameter count'
  requireValue "$2" 'actual parameter count'

  [[ "$2" -eq "$1" ]] && return "$BO_E_Ok"
  abort "'$2' parameters were passed when exactly '$1' are required!"
}
export -f requireParameters

requireParametersAtLeast () {
  # Require at least $1 parameters to calling function/script
  requireParameters 2 "$#"
  requireValue "$1" 'required parameter count'
  requireValue "$2" 'actual parameter count'

  [[ "$2" -ge "$1" ]] && return "$BO_E_Ok"
  abort "'$2' parameters were passed when at least '$1' are required!"
}
export -f requireParametersAtLeast

requireValue () {
  # Require value $1 described as $2, abort if missing (resolves to null)
  [[ "$#" -ne 2 ]] && Oops && exit "$BO_E_Usage"
  # $1 = value that is required
  # $2 = description for value

  abortIfMissing "$1" "Value for '$2' is missing (non-null)!"
}
export -f requireValue

requireVariable () {
  # Require variable $1, abort if it is missing
  requireParameters 1 "$#"
  requireParameter  "$1" 1 'name of variable that is required'

  declare _Name=$1
  declare _Value="${!_Name}"
  [[ -n "${_Value}" ]] && return "$BO_E_Ok"
  abort "Variable '$1' is required (defined and non-null)!"
}
export -f requireVariable

# Return, but do NOT exit, with a success code
return "$BO_E_Ok"

: <<'DisabledContent'
DisabledContent

