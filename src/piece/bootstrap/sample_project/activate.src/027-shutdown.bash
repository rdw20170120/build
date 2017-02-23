[[ -n "$BO_Sequence" ]] && echo 'Sequence 027 - shutdown'
# Shutdown

logInfo "Project '$BO_Project' is now activated, done."
env | sort > "./BO-env-outgoing.out"

