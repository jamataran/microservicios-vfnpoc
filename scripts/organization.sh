#!/bin/zsh

echo Inicio organization
cd organization-service/
mvn clean package -T16.0C -q
docker build -t jamataran/mvfn-organization:latest .
docker push jamataran/mvfn-organization
echo Fin organization
