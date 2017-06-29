


```
https://dl.k8s.io/v1.6.6/kubernetes-client-darwin-amd64.tar.gz
```

```
https://dl.k8s.io/v1.6.6/kubernetes-server-linux-amd64.tar.gz
```

```
https://dl.k8s.io/v1.6.6/kubernetes-node-linux-amd64.tar.gz
```


### isntalacja etcd

Poniższe polecenia wykonujemy na hoście etcd.

```
[root@etcd ~]# yum install etcd-2.3.7-4.el7.x86_64
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


### instalacja master node-a

