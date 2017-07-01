# Pod

Pod jest podstawowym i najmniejszym elementem Kubernetes. To w ramach poda odpalane są pożądane przez nas procesy (aplikacje).
W ramach poda mamy możliwość zdefiniowania kilku kontenerów z aplikacjami, które ściśle ze sobą powiązane i dzielą zasoby.
Pod enkapsuluje aplikacje, zasoby, unikatowy adres IP. 

Docker to najczęściej używany skonteneryzowany runtime w ramach Poda. Wspierane są też inne (np. rocket używany w CoreOS)

# Deployment

Deployment pozwala w sposób deklaratywny aktualizować Pody i Replika Sety.
Posiada mechanizm roolback'a. System Kubernetes przechowuje historię stanów deploymentów i w przypadku crash loopingu przywraca stabilną wersję.

# DeamonSet 

DaemonSet zapewnia obecność instancji poda na przypisanych node-ach. 
Używamy w przypadku potrzeby wyspecyfikowania dedykowanych node-ów pod konkretne zadania: logowanie, monitoring, storage.

Przykłady:
 - storage daemon -> glusterd
 - kolektor logów -> fluentd, logstash
 - monitoring -> Prometheus


# Service

Pody posiadaja unikalne adresy IP ale nie są stabilne w czasie. Na przykład rodczas rekreacji przez aktualizację pody otrzymują nowe adresy. W celu stabilnego skomunikowania pomiędzy pod'ami powstały Serwisy.


# Other objects

Jest wiele innych rodzajów obiektów, których omawianie wychodzi poza ramy szkolenia.