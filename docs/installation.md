# Proces instalacji

### Wstępne wymagania

#### firewalld i selinux
Należy się upewnić że na wszystkich maszynach mamy wyłączonego firewall-a oraz selinux-a:

```
$ systemctl status firewalld
```
jeżeli usługa jest włączona to ją wyłączamy:
```
$ systemctl stop firewalld
$ systemctl disable firewalld
```
następnie weryfikujemy status selinux-a:
```
$ getenforce
```
jeżeli jest włączony to go wyłączamy, w tym celu należy wyedytować plik `/etc/selinux/config`:
```
SELINUX=disabled
```
na sam koniec restartujemy maszyny.

Kolejnym etapy instalacji:
- [instalacja bazy `etcd`](./etcd_installation.md)
- [instalacja master/admin node-a](./master_installation.md)
- [instalacja minion node-ów](./minion_installation.md)


```
https://dl.k8s.io/v1.6.6/kubernetes-client-darwin-amd64.tar.gz
```

```
https://dl.k8s.io/v1.6.6/kubernetes-server-linux-amd64.tar.gz
```

```
https://dl.k8s.io/v1.6.6/kubernetes-node-linux-amd64.tar.gz
```



