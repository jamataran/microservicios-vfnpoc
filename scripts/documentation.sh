#!/bin/zsh
# Documentacion
echo Inicio documentation
cd documentation-service/
mvn clean package -T16.0C -q
docker build -t jamataran/mvfn-documentation:latest .
docker push jamataran/mvfn-documentation
echo Fin documentation
