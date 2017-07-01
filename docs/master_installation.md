# instalacja master node-a

Dodajemy oficjalne repozytorium Kubernetes-a:

```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

```
yum install docker bash-completion kubelet-1.5.4-0.x86_64 kubectl-1.5.4-0.x86_64
```
Po zainstalowaniu wymaganych paczek przechodzimy do ich konfiguracji:

- `Docker`:

    Zanim jeszcze uruchomimy usługę, edytujemy plik `/etc/docker/daemon.json`:
    ```
    {
      "storage-driver": "overlay2",
      "storage-opts": [
        "overlay2.override_kernel_check=true"
      ]
    }
    ```
    Teram możemy uruchomić usługę:
    ```
    $ systemctl start docker
    $ systemctl enable docker
    ```

- `kubelet`:

    W tym celu należy wyedytować `Unit` `systemd` - `/etc/systemd/system/kubelet.service`:
    ```
    [Unit]
    Description=kubelet: The Kubernetes Node Agent
    Documentation=http://kubernetes.io/docs/

    [Service]
    ExecStart=/usr/bin/kubelet \
        --address=0.0.0.0 \
        --hostname-override=192.168.56.102 \
        --api-servers=http://192.168.56.105:8080 \
        --config=/etc/kubernetes/manifests \
        --allow-privileged=true \
        --cluster-dns=10.254.0.10 \
        --cluster-domain=cluster.local \
        --network-plugin=cni \
        --network-plugin-dir=/etc/cni/net.d \
        --cni-bin-dir=/opt/cni/bin \
        --v=4
    Restart=always
    StartLimitInterval=0
    RestartSec=10

    [Install]
    WantedBy=multi-user.target
    ```

Poniższe komponenty klastra są konfigurowane jako kontenery i wszystkie manifesty umieszczamy
w katalogu `/etc/kubernetes/manifests` ze względu na konfigurację `kubeleta`.

- `kube-apiserver`:

    Tworzymy plik `apiserver.yaml`:
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: kube-apiserver
      namespace: kube-system
    spec:
      hostNetwork: true
      containers:
      - name: kube-apiserver
        image: gcr.io/google-containers/hyperkube-amd64:v1.5.4
        command:
        - /hyperkube
        - apiserver
        - --bind-address=0.0.0.0
        - --etcd-servers=http://192.168.56.101:2379
        - --allow-privileged=true
        - --service-cluster-ip-range=10.254.0.0/16
        - --insecure-bind-address=0.0.0.0
        - --insecure-port=8080
        - --secure-port=443
        - --advertise-address=192.168.56.105
        - --admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota
        - --tls-cert-file=/etc/kubernetes/ssl/apiserver.pem
        - --tls-private-key-file=/etc/kubernetes/ssl/apiserver-key.pem
        - --client-ca-file=/etc/kubernetes/ssl/ca.pem
        - --service-account-key-file=/etc/kubernetes/ssl/apiserver-key.pem
        - --etcd-quorum-read=true
        - --v=4
        ports:
        - containerPort: 443
          hostPort: 443
          name: https
        - containerPort: 8080
          hostPort: 8080
          name: local
        volumeMounts:
        - mountPath: /etc/kubernetes/ssl
          name: ssl-certs-kubernetes
          readOnly: true
        - mountPath: /etc/ssl/certs
          name: ssl-certs-host
          readOnly: true
      volumes:
      - hostPath:
          path: /etc/kubernetes/ssl
        name: ssl-certs-kubernetes
      - hostPath:
          path: /usr/share/ca-certificates
        name: ssl-certs-host
    ```

- `kube-controller-manager`:

    Tworzymy plik `controller.yaml`:
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: kube-controller-manager
      namespace: kube-system
    spec:
      hostNetwork: true
      containers:
      - name: kube-controller-manager
        image: quay.io/coreos/hyperkube:v1.5.6_coreos.0
        command:
        - /hyperkube
        - controller-manager
        - --master=http://127.0.0.1:8080
        - --leader-elect=true
        - --service-account-private-key-file=/etc/kubernetes/ssl/apiserver-key.pem
        - --root-ca-file=/etc/kubernetes/ssl/ca.pem
        - --allocate-node-cidrs=true
        - --cluster-cidr=172.17.0.0/16
        livenessProbe:
          httpGet:
            host: 127.0.0.1
            path: /healthz
            port: 10252
          initialDelaySeconds: 15
          timeoutSeconds: 1
        volumeMounts:
        - mountPath: /etc/kubernetes/ssl
          name: ssl-certs-kubernetes
          readOnly: true
        - mountPath: /etc/ssl/certs
          name: ssl-certs-host
          readOnly: true
      volumes:
      - hostPath:
          path: /etc/kubernetes/ssl
        name: ssl-certs-kubernetes
      - hostPath:
          path: /usr/share/ca-certificates
        name: ssl-certs-host
    ```

- `kube-proxy`:

    Tworzymy plik `proxy.yaml`:
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: kube-proxy
      namespace: kube-system
    spec:
      hostNetwork: true
      containers:
      - name: kube-proxy
        image: quay.io/coreos/hyperkube:v1.5.6_coreos.0
        command:
        - /hyperkube
        - proxy
        - --master=http://127.0.0.1:8080
        - --proxy-mode=iptables
        securityContext:
          privileged: true
        volumeMounts:
        - mountPath: /etc/ssl/certs
          name: ssl-certs-host
          readOnly: true
      volumes:
      - hostPath:
          path: /usr/share/ca-certificates
        name: ssl-certs-host
    ```

- `kube-scheduler`:

    Tworzymy plik `scheduler.yaml`:

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: kube-scheduler
      namespace: kube-system
    spec:
      hostNetwork: true
      containers:
      - name: kube-scheduler
        image: quay.io/coreos/hyperkube:v1.5.6_coreos.0
        command:
        - /hyperkube
        - scheduler
        - --master=http://127.0.0.1:8080
        - --leader-elect=true
        livenessProbe:
          httpGet:
            host: 127.0.0.1
            path: /healthz
            port: 10251
          initialDelaySeconds: 15
          timeoutSeconds: 1
```





### generowanie certyfikatów

Musimy wygenerować CA i certyfikaty dla apiservera, w tym celu tworzymy plik konfiguracyjny `openssl`-a:

- `openssl.cnf`:
    ```
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = kubernetes
    DNS.2 = kubernetes.default
    DNS.3 = kubernetes.default.svc
    DNS.4 = kubernetes.default.svc.cluster.local
    IP.1 = 10.254.0.1
    IP.2 = 192.168.56.105
    ```

następnie generujemy CA:

```
$ openssl genrsa -out ca-key.pem 2048
$ openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
```

i certyfikat i klucz dla apiservera:

```
$ openssl genrsa -out apiserver-key.pem 2048
$ openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
$ openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf
```

Opis generowania certyfikatów można znaleźć na stronach [CoreOS-a](https://coreos.com/kubernetes/docs/latest/openssl.html)

Wygenerowane certyfikaty przenosimy do:

- `/etc/kubernetes/ssl`

    ```
    $ cp * /etc/kubernetes/ssl/
    ```

- `/etc/kubernetes/ca`

    ```
    $ cp ca.pem /etc/kubernetes/ssl/
    ```