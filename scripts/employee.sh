#!/bin/zsh
echo Inicio employee
cd employee-service/
mvn clean package -T16.0C -q
docker build -t jamataran/mvfn-employee:latest .
docker push jamataran/mvfn-employee
echo Fin employee
