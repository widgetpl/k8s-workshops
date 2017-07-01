# instalacja minion node-a

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
yum install docker bash-completion kubelet-1.5.4-0.x86_64
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
    Teraz możemy uruchomić usługę:
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
        image: gcr.io/google-containers/hyperkube-amd64:v1.5.4
        command:
        - /hyperkube
        - proxy
        - --master=http://192.168.56.105:8080
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