
- [Docker - podstawy](./docs/docker.md)
- [kubernetes](./docs/kubernetes.md)
    - [podstawowa architektura](./docs/kubernetes.md#basic_architecture)
    - [komponenty klastra](./docs/kubernetes.md#cluster_components)
        - [master components](./docs/kubernetes.md#master_components)
            - [kube-apiserver](./docs/kubernetes.md#api_server)
            - [etcd](./docs/kubernetes.md#etcd)
            - [kube-controller-manager](./docs/kubernetes.md#kube_controller_manager)
            - [kube-scheduler](./docs/kubernetes.md#kube_scheduler)
            - [addons](./docs/kubernetes.md#addons)
                - [DNS](./docs/kubernetes.md#dns_addon)
                - [heapster](./docs/kubernetes.md#heapster)
                - [dashboard](./docs/kubernetes.md#dashboard)
        - [node componenets](./docs/kubernetes.md#node_components)
            - [kubelet](./docs/kubernetes.md#kubelet)
            - [kube-proxy](./docs/kubernetes.md#kube_proxy)
    - [obiekty k8s](./docs/objects.md)
- [instalacja](./docs/installation.md)
    - [minikube](./docs/minikube.md)
- [operacje na klastrze](./docs/operations.md)
    - [`kubectl` instalacja](./docs/operations.md#instalacja)
    - [`kubectl` konfiguracja](./docs/operations.md#konfiguracja)






vmki

user/haslo - root/workshops

interfejsy sieciowe

enp0s3 - host-only, adres z dns-a
enp0s8 - NAT

config dla enp0s3:
```
# cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=no
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATA=no
NAME=enp0s3
DEVICE=enp0s3
ONBOOT=yes
IPADDR=192.168.56.101
NETWORK=192.168.56.0
NETMASK=255.255.255.0
GATEWAY=192.168.56.1
```



config dla enp0s8:
```
# cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
TYPE="Ethernet"
BOOTPROTO="dhcp"
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_PEERDNS="yes"
IPV6_PEERROUTES="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp0s3"
UUID="d842ded7-33af-4614-be09-adbccaf382b1"
DEVICE="enp0s3"
ONBOOT="yes"
```

jeżeli nie ma dostępu do internetu sprawdzić i ewentualnie usunąć trase defaultową przez interface host-only
```
# ip route del default via 192.168.56.1
```

```
yum update
```


https://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services