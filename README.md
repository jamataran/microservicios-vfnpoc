# Microservicios


## Spring Boot & Kubernetes
Para afrontar los retos que suponen los microservicios existen soluciones tanto en la suite Spring Cloud como en Kubernetes.

## Proyecto Ejemplo
En este repositorio tenemos unos servicios de ejemplo, cortesía de [Piotr Mińkowski](https://github.com/piomin/sample-spring-microservices-new) que nos valen para ilustar una arquitectura de Microservicios basada en el ecosistema Spring y Kubernetes.
En este ejemplo existen tres aplicaciones:
* Servicio de empleados (no comunica con otros servicios, pero si otros con él.)
* Servicio de organización (llama a servicio de empleados)
* Servicio de departamentos (llama a servicio de empleados) 

### Pasos para la configuración.
Aplicar en nuestro motor k8s de pruebas
1. 

### Configuración de entorno
El primero de los retos que se plantean, las diferentes configuraciones que dependan de un entorno, se pueden solucionar utilizando los [`ConfigMaps`](https://kubernetes.io/es/docs/concepts/configuration/configmap/) y los [`Secrets`](https://kubernetes.io/docs/concepts/configuration/secret/)

### Descubrimiento y explotación de servicios
* Para que los servicios puedan encontrar otros servicios dentro del orquestador es necesario utilizar un servicio de descubrimiento. 
Para el stack Spring & K8S utilizaremos [`spring-cloud-kubernetes-ribbon`](https://cloud.spring.io/spring-cloud-static/spring-cloud-kubernetes/2.1.0.RC1/multi/multi__ribbon_discovery_in_kubernetes.html)

* Para consumir otros clientes dentro de la red utilizaremos [Spring Cloud OpenFign](https://spring.io/projects/spring-cloud-openfeign) 


## Comandos útiles
* Iniciar minikube: `minikube start && minikube dashboard`
* Crear *namespace*: `kubectl create namespace microservicios-vfnpoc`
* Ver servicios: `kubectl get services -n microservicios-vfnpoc`

## Documentación
* [https://github.com/spring-cloud/spring-cloud-kubernetes](https://github.com/spring-cloud/spring-cloud-kubernetes)
* [https://www.baeldung.com/spring-cloud-openfeign](https://www.baeldung.com/spring-cloud-openfeign)
* [https://spring.io/projects/spring-cloud-openfeign](https://spring.io/projects/spring-cloud-openfeign)