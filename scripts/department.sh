#!/bin/zsh
echo Inicio department
cd department-service/
mvn clean package -T16.0C -q
docker build -t jamataran/mvfn-department:latest . -q
docker push jamataran/mvfn-department -q
echo Fin department
