#!/bin/zsh
echo Inicio Zipkin
cd zipkin/
docker build -t jamataran/mvfn-zipkin:latest .
docker push jamataran/mvfn-zipkin
echo Fin Zipkin
