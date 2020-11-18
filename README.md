# Microservicios & Spring

## Spring Boot & Kubernetes. Retos.

Migrar una aplicación monolítica a una arquitectura de microservicios tiene una serie de retos, que se deben abordar. Estos retos están muchas veces
presentes en las aplicaciones monolíticas y otros nacen de la nueva filosofía de orquestación de contenedores en entornos cloud. 

Desde el comienzo de la explosión del mundo de los microservicios, Spring ha crecido abordando los nuevos retos dentro del paquete Spring Cloud Netflix, si bien es cierto que no tiene
mucho sentido utilizar microservicios sin una plataforma de orquestación y las más populares (Kubernetes y OpenShift) ya implementan soluciones para los problemas cloud lo que hacen 
que muchas de las soluciones del paquete Spring Cloud no sean necesarias. 

Conscientes de esto, la gente de Spring ha creado [Spring Cloud Kubernetes](https://spring.io/projects/spring-cloud-kubernetes#learn) que nos permite delegar en PaaS elegida muchas de las 
funcionalidades requeridas cuando tratamos de orquestar servicios en la nube.

Este repositorio contiene un pequeño ejemplo de como desplegar una pequeña aplicación de registro de empleados basandonos en esta arquitectura.s

## Proyecto Ejemplo
En este repositorio tenemos unos servicios de ejemplo, cortesía de [Piotr Mińkowski](https://github.com/piomin/sample-spring-microservices-new) que nos valen para ilustar una arquitectura de Microservicios basada en el ecosistema Spring y Kubernetes.
En este ejemplo existen tres aplicaciones:
* Servicio de empleados (no comunica con otros servicios, pero si otros con él.)
* Servicio de organización (llama a servicio de empleados)
* Servicio de departamentos (llama a servicio de empleados) 

![Esquema](/readme-sources/diagram.png?raw=true "Esquema aplicación")

## Pasos para la configuración.
Aplicar en nuestro motor k8s de pruebas

1. Creación de los servicios.

    1.1 Construir y subir las imágenes. Editar al gusto el fichero `docker-build.sh`

    1.2 Creación del secreto para conectar al registro donde se hayan subido las imágenes. Un ejemplo para Docker Registry es:
    
    ```shell script
    kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>  --namespace=microservicios-vfnpoc
    ```
    
    1.3 Aplicar con `kubectl` los ficheros que tenemos en la carpeta `k8s` (orden)
 
## Retos conseguidos.

Como se comentaba, existen varios retos cuando utilizamos arquitecturas cloud. Cada día aparecen nuevas formas de solucionar estos problemas, 
aquí vamos a comentar algunos de los que nos podemos encontrar en una aplicación sencilla y como solucionarlos de forma también sencilla. Obviamente
no es la única forma y tal vez en el momento de consulta está forma ya esté obsoleta, pero puede servir como base para la investigación de 
nuevas formas. 

### Tráfico

Uno de los primeros retos que nos encontramos es cómo orquestaremos el tráfico de nuestra aplicación. Aplicaciones empresariales suelen utilizar
ApiGateways y herramientas de la nueva corriente que se ha denominado *Service Mesh*. Estas quedan fuera del alcande de nuestro mini-tutorial, en el que
"simplemente" usaremos el Ingress que la gente de ngix ha desarrollado para Kubernetes (que no debe ser despreciado, es una solución muy potente)

En la bibliografía existen otras soluciones que pueden mejorar esto.
   
    
### Configuración de entorno
El primero de los retos que se plantean, las diferentes configuraciones que dependan de un entorno, se pueden solucionar utilizando los [`ConfigMaps`](https://kubernetes.io/es/docs/concepts/configuration/configmap/) y los [`Secrets`](https://kubernetes.io/docs/concepts/configuration/secret/)
Una vez configurados `ConfigMaps` y `Secrets`; es necesario que Spring los consuma. Para ello utilizamos [Spring Cloud Kubernetes](https://spring.io/projects/spring-cloud-kubernetes#learn) que nos permite la carga dinámica de [`PropertySource`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/PropertySource.html) desde estos componentes de Kubernetes.

### Descubrimiento y comunicación entre microservicios
* Para que los servicios puedan encontrar otros servicios dentro del orquestador es necesario utilizar un servicio de descubrimiento. Para el stack Spring & K8S utilizaremos [`spring-cloud-kubernetes-ribbon`](https://cloud.spring.io/spring-cloud-static/spring-cloud-kubernetes/2.1.0.RC1/multi/multi__ribbon_discovery_in_kubernetes.html)
    * Ribbon es una librería que permite encontrar otros servicios. En nuestro caso, es capaz de detectar donde estan nuestros microservicios.
    * Ribbon ofrece balancedo de carga en el lado de cliente.
    * Ribbon detecta que servicios están caídos y cuales no.


* Para consumir otros clientes dentro de la red utilizaremos [Spring Cloud OpenFign](https://spring.io/projects/spring-cloud-openfeign)

### Documentación
Un punto importante es tener bien documentado todo nuestro ecosistema de microservicios. Todos estamos ya familiarizados con el uso de Swagger y OpenApi pero aquí el reto es otro: tener un 
punto centralizado con nuestra documentación.

En nuestro caso se ha creado una aplicación auxiliar, `documentation-service`, que _indexará_ todas las definiciones de los microservicios en un único punto, que
podrá ser accedido. Este servicio es opcional, podemos prescindir de él y acceder a la definición que presenta cada uno de los microservicios por sepado. 

Aunque existen mecanismos para detectar automáticamente los microservicios desplegados, la solucion elegida pasa por dar de alta cada uno de los microservicios
en la aplicación de documentación, este paso puede abordarse cada vez que un nuevo microservicio es añadidoa la arquitectura.

Antes de desplegar la aplicación, es necesario crear la configuración a partir del fichero `documentation-service/services.yml`, para ello:
```shell script
kubectl create configmap documentation-config -n microservicios-vfnpoc --from-file=documentation-service/src/main/resources/services.yml
```  

### Trazabilidad distrubida.
Uno de los retos de todo sistema distribuido es la trazabilidad de las peticiones y operaciones que se soliciten a nuestro sistema.

### Tolerancia a fallos y resiliencia.
TODO Hystryx +  Actuator




## Comandos útiles & Recetas Kubernetes
* Iniciar minikube: `minikube start && minikube dashboard`

* Crear *namespace*: `kubectl create namespace microservicios-vfnpoc`

* Ver servicios: `kubectl get services -n microservicios-vfnpoc`

* Ver pods: `kubectl get pods -n microservicios-vfnpoc`

* ver logs: `kubectl logs --namespace=microservicios-vfnpoc --follow  pod-nam3`

* Acceso a servicios:
    
    * `Service`:
        * `type: ClusterIP`: Sólo permite acceso desde dentro y hay que activar el Proxy (`kubectl proxy --port=8080`) para poder acceder a los servicios (`http://localhost:8080/api/v1/proxy/namespaces/<NAMESPACE>/services/<SERVICE-NAME>:<PORT-NAME>/`)
        * `type: NodePort`: Abre un puerto en cada nodo y el trafico es enviado a él. No recomendable producción.
        * `type: LoadBalancer`: Balancea carga entre servicios.
    
    * `Ingress`: Es simplemente un frontal que enruta hacia los diferentes servicios. Además puede hacer SSL Offload. Existen muchos tipos de Ingress, en este caso usamos NGINX
    
* Nodeport en minikube: `minikube tunnel` 

* Crear `ConfigMap` desde fichero: `kubectl create configmap {nombre} -n {namespace} --from-file={file}.yml`

## Bibliografía

* [https://dzone.com/articles/quick-guide-to-microservices-with-kubernetes-sprin](https://dzone.com/articles/quick-guide-to-microservices-with-kubernetes-sprin)
* [https://github.com/spring-cloud/spring-cloud-kubernetes](https://github.com/spring-cloud/spring-cloud-kubernetes)
* [https://www.baeldung.com/spring-cloud-openfeign](https://www.baeldung.com/spring-cloud-openfeign)
* [https://spring.io/projects/spring-cloud-openfeign](https://spring.io/projects/spring-cloud-openfeign)
* [https://matthewpalmer.net/kubernetes-app-developer/articles/service-kubernetes-example-tutorial.html#:~:text=What's%20the%20difference%20between%20a,running%20in%20the%20Kubernetes%20cluster.](https://matthewpalmer.net/kubernetes-app-developer/articles/service-kubernetes-example-tutorial.html#:~:text=What's%20the%20difference%20between%20a,running%20in%20the%20Kubernetes%20cluster.)
* [https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)
* [https://piotrminkowski.com/2020/02/20/microservices-api-documentation-with-springdoc-openapi/](https://piotrminkowski.com/2020/02/20/microservices-api-documentation-with-springdoc-openapi/)
* [https://www.baeldung.com/spring-cloud-kubernetes](https://www.baeldung.com/spring-cloud-kubernetes)
* [https://www.paradigmadigital.com/dev/microservicios-2-0-spring-cloud-netflix-vs-kubernetes-istio/](https://www.paradigmadigital.com/dev/microservicios-2-0-spring-cloud-netflix-vs-kubernetes-istio/)
* [https://learnk8s.io/kubernetes-ingress-api-gateway](https://learnk8s.io/kubernetes-ingress-api-gateway)
* [https://developers.redhat.com/blog/2017/10/03/configuring-spring-boot-kubernetes-configmap/](https://developers.redhat.com/blog/2017/10/03/configuring-spring-boot-kubernetes-configmap/)
* [https://github.com/varghgeorge/microservices-single-swagger](https://github.com/varghgeorge/microservices-single-swagger)
* [https://walkingtreetech.medium.com/logs-monitoring-in-microservices-using-elk-316bf9c049c4](https://walkingtreetech.medium.com/logs-monitoring-in-microservices-using-elk-316bf9c049c4)
