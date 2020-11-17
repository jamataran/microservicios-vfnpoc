#!/bin/zsh
# NUNCA HACER ESTO!, siempre una version concreta!!

# Departamentos
cd department-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-department:latest .
docker push jamataran/mvfn-department
cd ..

# Empleados
cd employee-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-employee:latest .
docker push jamataran/mvfn-employee
cd ..

# Organizacion
cd organization-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-organization:latest .
docker push jamataran/mvfn-organization
cd ..

# Organizacion
cd documentation-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-documentation:latest .
docker push jamataran/mvfn-documentation
cd ..
