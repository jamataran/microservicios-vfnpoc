#!/bin/zsh
# NUNCA HACER ESTO!, siempre una version concreta!!

# Departamentos
echo Inicio department
cd department-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-department:latest .
docker push jamataran/mvfn-department
echo Fin department
cd ..

# Empleados
echo Inicio employee
cd employee-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-employee:latest .
docker push jamataran/mvfn-employee
echo Fin employee
cd ..

# Organizacion
echo Inicio organization
cd organization-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-organization:latest .
docker push jamataran/mvfn-organization
echo Fin organization
cd ..

# Organizacion
echo Inicio documentation
cd documentation-service/
mvn clean package -T8.0C -q
docker build -t jamataran/mvfn-documentation:latest .
docker push jamataran/mvfn-documentation
echo Fin documentation
cd ..

echo ===============
echo FIN DEL PROCESO
echo ===============