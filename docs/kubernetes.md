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

Komponenty mastera dostarczają elementy zarządzające całym klastrem, schedule-owanie, wykrywanie i odpowiadanie
 na zdarzenia pojawiające się w klastrze ( uruchamianie pod-ów kiedy ilość replik nie jest zgodna z definicją
zawartą w manifeście ).

<a name="api_server"></a>
- [**kube-apiserver**](https://kubernetes.io/docs/admin/kube-apiserver/) - dostarcza API klastra.
    Jest front-endem dla większości komponentów klastra jak i innych plugin-ów. Dostarcza informacje
    na temat wszystkich obiektów znajdujących się w klastrze.


<a name="etcd"></a>
- [**etcd**](https://kubernetes.io/docs/concepts/overview/components/#etcd) - jest to baza danych
    Kubernetes-a gdzie są przetrzymywane dane na temat aktualne stanu całego klastra

<a name="kube_controller_manager"></a>
- [**kube-controller-manager**]() - jest to zbiór procesów kontrolujących podstawowe elementy klastra:
    - node controller - sprawdza status node-ów i informuje o jego zmianach apiserver
    - replication controller - jest odpowiedzialny za utrzymywanie odpowiedniej ilości replik każdego
    replication controller-a w klastrze
    - endpoint controller - jest odpowiedzialny za prawidłowe łączenie ze sobą service-ów z podami
    bazując na labelk-ach
    - service account i token controllers - tworzy standardowe konta i tokeny dostępu do serwera API dla
    namespace-ów

<a name="kube_scheduler"></a>
- [**kube-scheduler**](https://kubernetes.io/docs/concepts/overview/components/#kube-scheduler) - jest
    odpowiedzialny za przypisywanie nowo utworzonych pod-ów do node-ów klastra

<a name="addons"></a>
- **addons**

    - [**DNS**](https://kubernetes.io/docs/concepts/overview/components/#dns)<a name="dns_addon"></a> - umożliwia komunikację po nazwach FQDN wewnątrz klastra

    - [**heapster**]()<a name="heapster"></a> - zbiera metryki na temat kontenerów

    - [**dashboard**](https://github.com/kubernetes/dashboard)<a name="dashboards"></a> - graficzcny interfejs do zarządzania klastrem

<a name="node_components"></a>
#### node components

<a name="kubelet"></a>
- [**kubelet**](https://kubernetes.io/docs/concepts/overview/components/#kubelet) - jest procesem działającym na każdym nodzie klastra i oczekuje informacji od schedulera
    na temat nowych podów. Do jego zadań należy:

    - montowanie volumen-ów do poda
    - pobieranie secret-ów poda
    - uruchomienia kontenera za pomocą zdefiniowanego środowiska uruchomieniowego dla kontenerów
    - wykonywanie tzw. livenessprobe-ów kontenerów
    - zwracanie informacji na temat statusu pod-ów oraz node-ów do klastra

<a name="kube_proxy"></a>
- **kube-proxy** - zapewnia łączność sieciową wewnątrz klastra. W przypadku korzystania z iptables-ów
    generuje odpowiednie wpisy w systemowych ipteblsach.

