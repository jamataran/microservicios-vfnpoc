#!/bin/zsh
echo 'docker-build.sh'
./docker-build.sh
./reload-services.sh
echo 'Finalizado'
