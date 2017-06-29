# kubectl

Podstawowym narzędziem do zarządzania klastrem Kubernetes jest polecenie wiersza poleceń **kubectl**.
**kubectl** może być zainstalowany i skonfigurowany zarówno na samym klastrze
jak i na maszynie lokalnej użytkownika, jedyny wymóg to dostęp do serwera **API** klastra.
Narzędzie to pozwala na tworzenie, zarządzanie, usuwanie wszystkich zasobów Kubernetes-a takich jak
Pod-y, Deployment-y, Service-y.

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


### konfiguracja

W celu poprawnego działania `kubectl` niezbędny jest plik konfiguracyjny zwany `kubeconfig`,
domyślnie umieszczany w `~/.kube/config`. Przykładowy plik konfiguracyjny:
```

```

Częścią konfiguracji powinno być również włączenie autouzupełniania powłoki co znacznie ułatwia pracę
z `kubectl`:

```
echo "source <(kubectl completion bash)" >> ~/.bashrc
```