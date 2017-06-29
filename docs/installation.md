


```
https://dl.k8s.io/v1.6.6/kubernetes-client-darwin-amd64.tar.gz
```

```
https://dl.k8s.io/v1.6.6/kubernetes-server-linux-amd64.tar.gz
```

```
https://dl.k8s.io/v1.6.6/kubernetes-node-linux-amd64.tar.gz
```
W pierwszej koleności należy zweryfikować czy mamy wyłączonego firewalla:
```
# systemctl stop firewalld; \
systemctl disable firewalld; \
reboot
```
oraz `selinux`-a

```
$ getenforce
Disabled
```
jeżeli jest włączony to w pliku konfiguracyjnym `/etc/selinux/config` wyłaczamy:
```
SELINUX=disabled
```
i rstartujemy maszyne


### isntalacja etcd

Poniższe polecenia wykonujemy na hoście etcd.

```
[root@etcd ~]# yum install etcd-2.3.7-4.el7.x86_64
```

edytujemy plik `vim /etc/etcd/etcd.conf`, w którym zmieniamy adres na którym binduje się etcd:
```
ETCD_LISTEN_CLIENT_URLS="http://192.168.56.101:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.56.101:2379"
```

edytujemy plik `/usr/lib/systemd/system/etcd.service`, w którym zmieniamy adres na którym binduje się etcd:

```
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
User=etcd
# set GOMAXPROCS to number of processors
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /usr/bin/etcd --name=\"${ETCD_NAME}\" --data-dir=\"${ETCD_DATA_DIR}\" --listen-client-urls=\"http://0.0.0.0:2379\""
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

uruchamiamy usługę:

```
systemctl start etcd
```

i sprawdzamy czy baza uruchomiła się prawidłowo

```
[root@etcd init.d]# etcdctl cluster-health
member ce2a822cea30bfca is healthy: got healthy result from http://localhost:2379
cluster is healthy
```

```
[root@etcd init.d]# etcdctl member list
ce2a822cea30bfca: name=default peerURLs=http://localhost:2380,http://localhost:7001 clientURLs=http://localhost:2379 isLeader=true
```

na sam koniec dodajemy konfigurację sieci dla kontenerów, która będzie wykorzystywana przez `flannel`-a
```
etcdctl mk /atomic.io/network/config '{"Network":"172.17.0.0/16"}'
```

### instalacja master node-a

```
yum install docker kubernetes kubernetes-master docker-logrotate flannel
```

zainstalowane paczki:
```
# yum info kubernetes-master
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.icm.edu.pl
 * extras: centos2.hti.pl
 * updates: centos2.hti.pl
Installed Packages
Name        : kubernetes-master
Arch        : x86_64
Version     : 1.5.2
Release     : 0.6.gitd33fd89.el7
Size        : 146 M
Repo        : installed
From repo   : extras
Summary     : Kubernetes services for master host
URL         : k8s.io/kubernetes
License     : ASL 2.0
Description : Kubernetes services for master host
```

```
# yum info docker
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.icm.edu.pl
 * extras: centos2.hti.pl
 * updates: centos2.hti.pl
Installed Packages
Name        : docker
Arch        : x86_64
Epoch       : 2
Version     : 1.12.6
Release     : 28.git1398f24.el7.centos
Size        : 50 M
Repo        : installed
From repo   : extras
Summary     : Automates deployment of containerized applications
URL         : https://github.com/docker/docker
License     : ASL 2.0
Description : Docker is an open-source engine that automates the deployment of any
            : application as a lightweight, portable, self-sufficient container that will
            : run virtually anywhere.
            :
            : Docker containers can encapsulate any payload, and will run consistently on
            : and between virtually any server. The same container that a developer builds
            : and tests on a laptop will run at scale, in production*, on VMs, bare-metal
            : servers, OpenStack clusters, public instances, or combinations of the above.
```

```
# yum info flannel
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.icm.edu.pl
 * extras: centos2.hti.pl
 * updates: centos2.hti.pl
Installed Packages
Name        : flannel
Arch        : x86_64
Version     : 0.7.0
Release     : 1.el7
Size        : 29 M
Repo        : installed
From repo   : extras
Summary     : Etcd address management agent for overlay networks
URL         : https://github.com/coreos/flannel
License     : ASL 2.0
Description : Flannel is an etcd driven address management agent. Most commonly it is used to
            : manage the ip addresses of overlay networks between systems running containers
            : that need to communicate with one another.
```

konfiguracja api serwera:
default:
```
###
# kubernetes system config
#
# The following values are used to configure the kube-apiserver
#

# The address on the local server to listen to.
KUBE_API_ADDRESS="--insecure-bind-address=127.0.0.1"

# The port on the local server to listen on.
# KUBE_API_PORT="--port=8080"

# Port minions listen on
# KUBELET_PORT="--kubelet-port=10250"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=http://127.0.0.1:2379"

# Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"

# default admission control policies
KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"

# Add your own!
KUBE_API_ARGS=""
```

po zmianach:
```
###
# kubernetes system config
#
# The following values are used to configure the kube-apiserver
#

# The address on the local server to listen to.
KUBE_API_ADDRESS="--address=0.0.0.0"

# The port on the local server to listen on.
KUBE_API_PORT="--port=8080"

# Port minions listen on
# KUBELET_PORT="--kubelet-port=10250"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=http://192.168.56.101:2379"

# Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"

# default admission control policies
KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"

# Add your own!
KUBE_API_ARGS=""
```
następnie restartujemy wszystkie usługi
```
$ for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet docker flanneld; do \
    systemctl restart $SERVICES \
    systemctl enable $SERVICES \
    systemctl status $SERVICES \
done
```







for SERVICES in kube-proxy kubelet docker flanneld; do \
    systemctl restart $SERVICES \
    systemctl enable $SERVICES \
    systemctl status $SERVICES \
done