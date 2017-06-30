# instalacja master node-a

```
yum install docker kubernetes docker-logrotate flannel
```
Po zainstalowaniu wymaganych paczek przechodzimy do ich konfiguracji:

- `kube-apiserver`

    Należy wyedytować plik konfiguracyjny `/etc/kubernetes/apiserver`:
    ```
    KUBE_API_ADDRESS="--address=0.0.0.0"
    KUBE_API_PORT="--port=8080"
    KUBELET_PORT="--kubelet-port=10250"
    KUBE_ETCD_SERVERS="--etcd-servers=http://192.168.56.101:2379"
    KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
    KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"
    KUBE_API_ARGS=""
    ```

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

następnie restartujemy wszystkie usługi:
```
$ for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet docker flanneld; do systemctl restart $SERVICES; systemctl enable $SERVICES; systemctl status $SERVICES; done
```