[[ -n "$BO_Sequence" ]] && echo 'Sequence 000 - startup'
# Startup

echo "INFO:  Activating the BriteOnyx framework for this project..."
echo "WARN:  This script MUST be executed as 'source activate.src', WAS IT?"
env | sort > "./BO-env-incoming.out"

