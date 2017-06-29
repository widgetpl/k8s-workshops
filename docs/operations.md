# kubectl

Podstawowym narzędziem do zarządzania klastrem Kubernetes jest polecenie wiersza poleceń **kubectl**.
**kubectl** może być zainstalowany i skonfigurowany zarówno na samym klastrze
jak i na maszynie lokalnej użytkownika, jedyny wymóg to dostęp do serwera **API** klastra.
Narzędzie to pozwala na tworzenie, zarządzanie, usuwanie wszystkich zasobów Kubernetes-a takich jak
Pod-y, Deployment-y, Service-y.

<a name="instalacja"></a>
### instalacja

Najłatwiejszym sposobem jest pobranie gotowej binarki bezpośrednio z zasobów Googla
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.6.3/bin/linux/amd64/kubectl
```
następnie nadajemy parametr wykonawczy
```
chmod +x ./kubectl
```
i ostatecznie możemy przenieść binarkę do katalogu znajdującego się w zmiennej środowiskowej `PATH`
```
sudo mv ./kubectl /usr/local/bin/kubectl
```

<a name="konfiguracja"></a>
### konfiguracja

W celu poprawnego działania `kubectl` niezbędny jest plik konfiguracyjny zwany `kubeconfig`,
domyślnie umieszczany w `~/.kube/config`. Przykładowy plik konfiguracyjny:
```
apiVersion: v1
clusters:
- cluster:
    api-version: v1
    certificate-authority: ./certs/cluster1/ca.pem
    server: https://192.168.0.10:443
  name: mconnect-cluster
- cluster:
    api-version: v1
    certificate-authority: ./certs/cluster2/ca.pem
    server: https://192.168.1.10:443
  name: payments-cluster
- cluster:
    api-version: v1
    certificate-authority: ./certs/cluster3/ca.pem
    server: https://192.168.2.10:443
  name: poc-cluster
contexts:
- context:
    cluster: cluster1
    namespace: kube-system
    user: cluster1-admin
  name: cluster1
- context:
    cluster: cluster2
    namespace: kube-system
    user: cluster2-admin
  name: cluster2
- context:
    cluster: cluster3
    namespace: kube-system
    user: cluster3-admin
  name: cluster3
current-context: cluster1
kind: Config
preferences:
  colors: true
users:
- name: cluster1-admin
  user:
    client-certificate: ./certs/cluster1/apiserver.pem
    client-key: ./certs/cluster1/apiserver-key.pem
- name: cluster2-admin
  user:
    client-certificate: ./certs/cluster2/apiserver.pem
    client-key: ./certs/cluster2/apiserver-key.pem
- name: cluster3-admin
  user:
    client-certificate: ./certs/cluster3/apiserver.pem
    client-key: ./certs/cluster3/apiserver-key.pem
```

Częścią konfiguracji powinno być również włączenie autouzupełniania powłoki co znacznie ułatwia pracę
z `kubectl`:

```
echo "source <(kubectl completion bash)" >> ~/.bashrc
```