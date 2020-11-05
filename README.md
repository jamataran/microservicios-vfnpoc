# Microservicios


## Spring Boot & Kubernetes
Para afrontar los retos que suponen los microservicios existen soluciones tanto en la suite Spring Cloud como en Kubernetes.

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
    
    
## Retos de los microservicios

Migrar una aplicación monolítica a una arquitectura de microservicios tiene una serie de retos, que se deben abordar
        
### Configuración de entorno
El primero de los retos que se plantean, las diferentes configuraciones que dependan de un entorno, se pueden solucionar utilizando los [`ConfigMaps`](https://kubernetes.io/es/docs/concepts/configuration/configmap/) y los [`Secrets`](https://kubernetes.io/docs/concepts/configuration/secret/)

### Descubrimiento y comunicación entre microservicios
* Para que los servicios puedan encontrar otros servicios dentro del orquestador es necesario utilizar un servicio de descubrimiento. 
Para el stack Spring & K8S utilizaremos [`spring-cloud-kubernetes-ribbon`](https://cloud.spring.io/spring-cloud-static/spring-cloud-kubernetes/2.1.0.RC1/multi/multi__ribbon_discovery_in_kubernetes.html)

* Para consumir otros clientes dentro de la red utilizaremos [Spring Cloud OpenFign](https://spring.io/projects/spring-cloud-openfeign)

### Trazabilidad
Para aumentar la trazabilidad de los servicios, utilizamos...


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

## Documentación
* [https://dzone.com/articles/quick-guide-to-microservices-with-kubernetes-sprin](https://dzone.com/articles/quick-guide-to-microservices-with-kubernetes-sprin)
* [https://github.com/spring-cloud/spring-cloud-kubernetes](https://github.com/spring-cloud/spring-cloud-kubernetes)
* [https://www.baeldung.com/spring-cloud-openfeign](https://www.baeldung.com/spring-cloud-openfeign)
* [https://spring.io/projects/spring-cloud-openfeign](https://spring.io/projects/spring-cloud-openfeign)
* [https://matthewpalmer.net/kubernetes-app-developer/articles/service-kubernetes-example-tutorial.html#:~:text=What's%20the%20difference%20between%20a,running%20in%20the%20Kubernetes%20cluster.](https://matthewpalmer.net/kubernetes-app-developer/articles/service-kubernetes-example-tutorial.html#:~:text=What's%20the%20difference%20between%20a,running%20in%20the%20Kubernetes%20cluster.)
* [https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)