# instalacja minion node-a

```
yum install docker kubernetes docker-logrotate flannel
```
Po zainstalowaniu wymaganych paczek przechodzimy do ich konfiguracji:

- `flannel`

    Należy wyedytować plik konfiguracyjny `/etc/sysconfig/flanneld`:
    ```
    FLANNEL_ETCD_ENDPOINTS="http://192.168.56.101:2379"
    ```

- `kubelet`

    Należy wyedytować plik konfiguracyjny `/etc/kubernetes/kubelet`:
    ```
    KUBELET_ADDRESS="--address=0.0.0.0"
    KUBELET_PORT="--port=10250"
    KUBELET_HOSTNAME="--hostname-override=192.168.56.105"
    KUBELET_API_SERVER="--api-servers=http://192.168.56.105:8080"
    KUBELET_ARGS=""
    ```

- konfiguracja Kubernetes-a

    Należy wyedytować plik `/etc/kubernetes/config`:
    ```
    KUBE_MASTER="--master=http://192.168.56.105:8080"
    ```

następnie restartujemy wszystkie usługi:
```
$ for SERVICES in etcd kube-proxy kubelet docker flanneld; do systemctl restart $SERVICES; systemctl enable $SERVICES; systemctl status $SERVICES; done
```