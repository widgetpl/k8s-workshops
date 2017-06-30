# instalacja master node-a

```
yum install docker kubernetes docker-logrotate flannel
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