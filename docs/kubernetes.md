# Kubernetes

### co to jest

Jest to open-source-owy system do automatyzacji wdrażania, skalowania i zarządzania skonteneryzowanych
aplikacji. Podstawowe zalety:

- **automatic binpacking** - automatycznie przydziela aplikacje(kontenery) na node-y klastra bazując
    na ich wymaganiach co do zasobów takich jak CPU, pamięć RAM oraz wielu innych.

- **self-healing** - samoczynnie restartuje kontenery/aplikacje, które znajdą ulegają "wykrzaczeniu" :),
    przenosi kontenery który znajdowały się na node-ie, który został nieoczekiwanie zrestartowany bądź
    w inny sposób nie jest operacyjny, ubija kontenery/aplikacje które nie odpowiadają na wcześniej zdefiniowane
    health checki

-

<a name="basic_architecture"></a>
### podstawowa architektura


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

<a name="dns_addon"></a>
    - **DNS**




<a name="node_components"></a>
#### node components

<a name="kubelet"></a>
- **kubelet**

<a name="kube_proxy"></a>
- **kube-proxy**