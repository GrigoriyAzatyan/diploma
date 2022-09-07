# Дипломная работа
## Азатян Г.Р.



## Этап 1. Создание облачной инфраструктуры.

### Ожидаемые результаты:

Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

### Что выполнено:
* [Подключен провайдер и backend в S3-хранилище](https://github.com/GrigoriyAzatyan/diploma/blob/master/terraform/provider.tf);
* [Добавлены две подсети в разных зонах доступности](https://github.com/GrigoriyAzatyan/diploma/blob/master/terraform/vpc.tf);
* [Развернуты виртуальные машины](https://github.com/GrigoriyAzatyan/diploma/blob/master/terraform/vms.tf):

|Имя ВМ | Кол-во vCPU | Объем ОЗУ, ГБ | Объем дисков, ГБ |  Внутренний IP | Внешний IP | Зона доступности |
-------------------|-------------|---------------|--------|---------|-------------|-----------------
kubespray | 2|4|30|192.168.10.5|---|ru-central1-a|
kubernetes-cp1 | 2|4|30|192.168.10.3|51.250.13.12|ru-central1-a|
kubernetes-node1 | 2|4|30|192.168.10.10|51.250.80.230|ru-central1-a|
kubernetes-node2 | 2|4|30|192.168.20.21|158.160.10.138|ru-central1-b|
jenkins | 2|4|30|192.168.10.19|62.84.126.220|ru-central1-b|

* Создание инфраструктуры в terraform выполнялось командой `terraform apply -auto-approve`, не требующей подтверждения.
* Бэкенд в S3-хранилище Яндекса функционирует:   

![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/S3_backend.png)


## Этап 2. Создание Kubernetes кластера.

### Что выполнено:   
* Развернут кластер из 1 управляющей и 2 рабочих нод с помощью Kubespray, см. [inventory](https://github.com/GrigoriyAzatyan/diploma/tree/master/kubespray/inventory/mycluster).

### Подтвержден ожидаемый результат:

* Работоспособный Kubernetes кластер:

```
# kubectl get nodes -o wide

NAME    STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
cp1     Ready    control-plane   28d   v1.24.3   192.168.10.3    <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.6
node1   Ready    <none>          28d   v1.24.3   192.168.10.10   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.6
node2   Ready    <none>          28d   v1.24.3   192.168.20.21   <none>        Ubuntu 20.04.4 LTS   5.4.0-122-generic   containerd://1.6.6
```

* В файле ~/.kube/config находятся данные для доступа к кластеру:
![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/kubeconfig.png)


* Команда kubectl get pods --all-namespaces отрабатывает без ошибок:

```
root@cp1:/home/ubuntu# kubectl get pods --all-namespaces

NAMESPACE     NAME                                   READY   STATUS    RESTARTS        AGE
atlantis      atlantis-0                             1/1     Running   9 (108m ago)    14d
atlantis      nfs-server-nfs-server-provisioner-0    1/1     Running   18 (109m ago)   14d
jenkins       static-page-64f8876745-8cm7g           1/1     Running   2 (109m ago)    29h
kube-system   calico-node-ktmh5                      1/1     Running   11 (108m ago)   28d
kube-system   calico-node-t6jl6                      1/1     Running   14 (108m ago)   28d
kube-system   calico-node-v86zf                      1/1     Running   11 (109m ago)   28d
kube-system   coredns-74d6c5659f-8qdsb               1/1     Running   11 (109m ago)   28d
kube-system   coredns-74d6c5659f-hb8b2               1/1     Running   14 (108m ago)   28d
kube-system   dns-autoscaler-59b8867c86-nghmh        1/1     Running   14 (108m ago)   28d
kube-system   kube-apiserver-cp1                     1/1     Running   15 (108m ago)   28d
kube-system   kube-controller-manager-cp1            1/1     Running   17 (108m ago)   28d
kube-system   kube-proxy-4q8ft                       1/1     Running   14 (108m ago)   28d
kube-system   kube-proxy-jp7q2                       1/1     Running   11 (108m ago)   28d
kube-system   kube-proxy-sk5w5                       1/1     Running   11 (109m ago)   28d
kube-system   kube-scheduler-cp1                     1/1     Running   17 (108m ago)   28d
kube-system   nginx-proxy-node1                      1/1     Running   11 (109m ago)   28d
kube-system   nginx-proxy-node2                      1/1     Running   11 (108m ago)   28d
kube-system   nodelocaldns-64z8p                     1/1     Running   11 (109m ago)   28d
kube-system   nodelocaldns-fc7z9                     1/1     Running   14 (108m ago)   28d
kube-system   nodelocaldns-ldx22                     1/1     Running   11 (108m ago)   28d
monitoring    alertmanager-main-0                    2/2     Running   22 (109m ago)   24d
monitoring    alertmanager-main-1                    2/2     Running   22 (108m ago)   24d
monitoring    alertmanager-main-2                    2/2     Running   22 (109m ago)   24d
monitoring    blackbox-exporter-69684688c9-8847s     3/3     Running   33 (108m ago)   24d
monitoring    grafana-6b49c6d9f9-9bmkf               1/1     Running   11 (108m ago)   24d
monitoring    kube-state-metrics-98bdf47b9-49rtl     3/3     Running   36 (109m ago)   24d
monitoring    node-exporter-6szjg                    2/2     Running   22 (109m ago)   24d
monitoring    node-exporter-mwvdf                    2/2     Running   28 (108m ago)   24d
monitoring    node-exporter-t9kxk                    2/2     Running   22 (108m ago)   24d
monitoring    prometheus-adapter-5f68766c85-xcwg4    1/1     Running   14 (108m ago)   24d
monitoring    prometheus-adapter-5f68766c85-xxvn7    1/1     Running   14 (109m ago)   24d
monitoring    prometheus-k8s-0                       2/2     Running   22 (108m ago)   24d
monitoring    prometheus-k8s-1                       2/2     Running   22 (109m ago)   24d
monitoring    prometheus-operator-58974d75dd-9bg4w   2/2     Running   22 (108m ago)   24d

```

## Этап 3. Создание тестового приложения.
Готовы: 
1. Git репозиторий с [тестовым приложением](https://github.com/GrigoriyAzatyan/diploma/blob/master/public-html/index.html) и [Dockerfile](https://github.com/GrigoriyAzatyan/diploma/blob/master/Dockerfile);
2. [Регистр с собранным docker image](https://hub.docker.com/repository/docker/gregory78/static-page).


## Этап 4. Подготовка cистемы мониторинга и деплой приложения

Готовы:

* Git репозиторий с конфигурационными файлами для настройки Kubernetes:
   * [Конфигурационные файлы](https://github.com/GrigoriyAzatyan/diploma/tree/master/kube-monitoring/manifests) сформированы из [jsonnet-шаблона](https://github.com/GrigoriyAzatyan/diploma/blob/master/kube-monitoring/diplom.jsonnet) 

* Http доступ к web интерфейсу grafana: http://51.250.13.12:3000

* Дашборды в grafana, отображающие состояние Kubernetes кластера: 

![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/grafana-cluster.png)

* Http доступ к тестовому приложению: http://51.250.80.230:30000/



