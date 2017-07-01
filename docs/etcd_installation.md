# isntalacja etcd

Poniższe polecenia wykonujemy na hoście etcd.

```
$ yum install etcd-2.3.7-4.el7.x86_64
```

edytujemy plik `vim /etc/etcd/etcd.conf`, w którym zmieniamy adres na którym binduje się etcd:
```
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://localhost:2379"
```

Unit systemd dla etcd znajduje się tutaj `/usr/lib/systemd/system/etcd.service`.
Ostatecznie aktywujemy i uruchamiamy usługę:

```
$ systemctl start etcd
$ systemctl enable etcd
```

i sprawdzamy czy baza uruchomiła się prawidłowo

```
$ etcdctl cluster-health
member ce2a822cea30bfca is healthy: got healthy result from http://localhost:2379
cluster is healthy
```

```
$ etcdctl member list
ce2a822cea30bfca: name=default peerURLs=http://localhost:2380,http://localhost:7001 clientURLs=http://localhost:2379 isLeader=true
```