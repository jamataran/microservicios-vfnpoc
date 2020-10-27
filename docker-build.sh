#!/bin/zsh

cd department-service/
mvn clean package -T8.0C
docker build -t jamataran/mvfn-department:latest .
docker push jamataran/mvfn-department
cd ..

cd employee-service/
mvn clean package -T8.0C
docker build -t jamataran/mvfn-employee:latest .
docker push jamataran/mvfn-employee
cd ..

cd organization-service/
mvn clean package -T8.0C
docker build -t jamataran/mvfn-organization:latest .
docker push jamataran/mvfn-organization
cd ..