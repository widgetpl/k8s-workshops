# Kubernetes

### co to jest

Jest to open-source-owy system do automatyzacji wdrażania, skalowania i zarządzania skonteneryzowanych
aplikacji. Podstawowe zalety:

- **automatic binpacking** - automatycznie przydziela aplikacje(kontenery) na node-y klastra bazując
    na ich wymaganiach co do zasobów takich jak CPU, pamięć RAM oraz wielu innych.

- **self-healing** - samoczynnie restartuje kontenery/aplikacje, które znajdą ulegają "wykrzaczeniu" :),
    przenosi kontenery który znajdowały się na node-ie, który został nieoczekiwanie zrestartowany bądź
    w inny sposób nie jest operacyjny, ubija kontenery/aplikacje które nie odpowiadają na wcześniej zdefiniowane
    health checki.

- **horizontal scaling** - skaluje aplikacje horyzontalnie przy użyciu wiersza poleceń, graficznego interfejsu
    a nawet przy użyciu automatycznego autoscaler-a, który może bazować na zużyciu CPU, pamięci bądź
    ilości request-ów.

- **service discovery i load balancing** - za pomocą wbudowanego serwera DNS oraz komponentów takich jak
    `Service` z łątwością loadbalansuje ruch pomiędzy kontenerami.

- **automatyczne rollout-y i rollback-i** - Kubernetes umożliwia aktualizację aplikacji bez konieczności
    jej gaszenia, a jeżeli ta aktualizacja spowoduje jakieś nieprzewidywane problemy z uruchomieniem nowej
    wersji, Kubernetes automatycznie przywróci jej poprzedni stan.

- **zarządzanie store**
    umożliwia automatyczne montowanie zasobów systemowych bez względu czy to jest zasób sieciowy, lokalny
    czy cloud-owy ( np. GCP, AWS, NFS, Gluster itp.)


<a name="basic_architecture"></a>
### podstawowa architektura

![k8s basic architecture](../img/k8s_arch.png)

<a name="cluster_components"></a>
### komponenty klastra


<a name="master_components"></a>
#### master components


<a name="api_server"></a>
- **kube-apiserver**

<a name="etcd"></a>
- **etcd**

<a name="kube_controller_manager"></a>
- **kube-controller-manager**

<a name="kube_scheduler"></a>
- **kube-scheduler**

<a name="addons"></a>
- **addons**

    jakis przykladowy tekst


    - **DNS**<a name="dns_addon"></a>

        kolejny przykladowy tekst


    - **heapster**<a name="heapster"></a>


    - **dashboard**<a name="dashboards"></a>


<a name="node_components"></a>
#### node components

<a name="kubelet"></a>
- **kubelet**

<a name="kube_proxy"></a>
- **kube-proxy**

