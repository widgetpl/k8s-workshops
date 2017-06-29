# [minikube](https://github.com/kubernetes/minikube)

`minikube` jest bardzo prostym narzędziem do uruchomienia jedno-node-owego klastra k8s,
który w bardzo prosty i szybki sposób umożliwia rozpoczęcie zabawy z klastrem jak i zarówno
weryfikację aplikacji pod kątem kompatybilności z kubernetes-em na lokalnej maszynie.

### instalacja

Zanim uruchhomimy klaster za pomocą `minikube` należy [zainstalować `kubectl`](./docs/operations.md).

```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```

### uruchamianie

```
$ minikube start
Starting local Kubernetes v1.6.0 cluster...
Starting VM...
SSH-ing files into VM...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.

$ kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
deployment "hello-minikube" created
$ kubectl expose deployment hello-minikube --type=NodePort
service "hello-minikube" exposed

# We have now launched an echoserver pod but we have to wait until the pod is up before curling/accessing it
# via the exposed service.
# To check whether the pod is up and running we can use the following:
$ kubectl get pod
NAME                              READY     STATUS              RESTARTS   AGE
hello-minikube-3383150820-vctvh   1/1       ContainerCreating   0          3s
# We can see that the pod is still being created from the ContainerCreating status
$ kubectl get pod
NAME                              READY     STATUS    RESTARTS   AGE
hello-minikube-3383150820-vctvh   1/1       Running   0          13s
# We can see that the pod is now Running and we will now be able to curl it:
$ curl $(minikube service hello-minikube --url)
CLIENT VALUES:
client_address=192.168.99.1
command=GET
real path=/
...
$ minikube stop
Stopping local Kubernetes cluster...
Machine stopped.
```

### konfiguracja

Istnieje możliwość konfiuguracji klastra uruchomionego za pomocą `minikube`-a, więcej informacji na
ten temat można znaleźć w [repozytorium `minikube`-a](https://github.com/kubernetes/minikube/blob/master/docs/README.md).