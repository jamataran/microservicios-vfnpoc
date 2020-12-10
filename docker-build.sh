#!/bin/zsh
./scripts/department.sh &
./scripts/employee.sh &
./scripts/organization.sh &
echo "Cuando termine todo lanzar ./reload-services.sh"
