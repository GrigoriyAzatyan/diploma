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

### Если на первом этапе вы не воспользовались Terraform Cloud, то задеплойте в кластер atlantis для отслеживания изменений инфраструктуры.

Что сделано:
* В кластере развернут Atlantis с помощью Helm, на основе [конфигурационного файла](https://github.com/GrigoriyAzatyan/diploma/blob/master/atlantis.yaml) и [манифестов](https://github.com/GrigoriyAzatyan/diploma/tree/master/atlantis-helm). Интерфейс Atlantis опубликован по URL http://51.250.13.12;
* В Github-репозитории настроен вебхук на URL http://51.250.13.12/events, реагирующий на любые события.

Пример работы:
- Создаем новую ветку test01 и Pull-request;
- редактируем один из файлов .tf в папке terraform;
- Видим, что Github успешно отправил вебхук:
![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/atlantis_webhook.png)

- Видим новые комментарии в Pull-request-е. Результат неудачный, но к выводу стоит присмотреться:

![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/atlantis_403.png)

См. также вывод `kubectl logs -f atlantis-0 -n atlantis`:

```
{"level":"info","ts":"2022-09-07T16:56:39.290Z","caller":"events/working_dir.go:208","msg":"creating dir \"/atlantis-data/repos/GrigoriyAzatyan/diploma/9/default\"","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"}}

{"level":"info","ts":"2022-09-07T16:57:03.991Z","caller":"events/project_command_builder.go:279","msg":"successfully parsed atlantis.yaml file","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"}}

{"level":"info","ts":"2022-09-07T16:57:03.992Z","caller":"events/project_command_builder.go:284","msg":"1 projects are to be planned based on their when_modified config","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"}}

{"level":"info","ts":"2022-09-07T16:57:04.430Z","caller":"events/plan_command_runner.go:112","msg":"Running plans in parallel","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"}}

{"level":"info","ts":"2022-09-07T16:57:04.881Z","caller":"events/project_locker.go:80","msg":"acquired lock with id \"GrigoriyAzatyan/diploma/terraform/default\"","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"}}

{"level":"error","ts":"2022-09-07T16:57:09.539Z","caller":"models/shell_command_runner.go:153","msg":"running \"/usr/local/bin/terraform init -input=false -upgrade\" in \"/atlantis-data/repos/GrigoriyAzatyan/diploma/9/default/terraform\": exit status 1","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"},"stacktrace":"github.com/runatlantis/atlantis/server/core/runtime/models.(*ShellCommandRunner).RunCommandAsync.func1\n\tgithub.com/runatlantis/atlantis/server/core/runtime/models/shell_command_runner.go:153"}

{"level":"error","ts":"2022-09-07T16:57:09.935Z","caller":"events/instrumented_project_command_runner.go:43","msg":"Error running plan operation: running \"/usr/local/bin/terraform init -input=false -upgrade\" in \"/atlantis-data/repos/GrigoriyAzatyan/diploma/9/default/terraform\": exit status 1\n\nInitializing the backend...\n\nInitializing provider plugins...\n- Finding yandex-cloud/yandex versions matching \"0.76.0\"...\n- Finding latest version of hashicorp/local...\n╷\n│ Error: Failed to query available provider packages\n│ \n│ Could not retrieve the list of available versions for provider\n│ yandex-cloud/yandex: could not connect to registry.terraform.io: Failed to\n│ request discovery document: 403 Forbidden\n╵\n\n╷\n│ Error: Failed to query available provider packages\n│ \n│ Could not retrieve the list of available versions for provider\n│ hashicorp/local: could not connect to registry.terraform.io: Failed to\n│ request discovery document: 403 Forbidden\n╵\n\n","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"},"stacktrace":"github.com/runatlantis/atlantis/server/events.RunAndEmitStats\n\tgithub.com/runatlantis/atlantis/server/events/instrumented_project_command_runner.go:43\ngithub.com/runatlantis/atlantis/server/events.(*InstrumentedProjectCommandRunner).Plan\n\tgithub.com/runatlantis/atlantis/server/events/instrumented_project_command_runner.go:13\ngithub.com/runatlantis/atlantis/server/events.runProjectCmdsParallel.func1\n\tgithub.com/runatlantis/atlantis/server/events/project_command_pool_executor.go:28"}

{"level":"info","ts":"2022-09-07T16:57:09.935Z","caller":"events/plan_command_runner.go:119","msg":"deleting plans because there were errors and automerge requires all plans succeed","json":{"repo":"GrigoriyAzatyan/diploma","pull":"9"}}
```

То есть, ключевая проблема здесь следующая: terraform пытается постучаться на registry.terraform.io и получает 403 Forbidden, что видимо является следствием антироссийских санкций:

**Could not retrieve the list of available versions for provider\n│ yandex-cloud/yandex: could not connect to registry.terraform.io: Failed to\n│ request discovery document: 403 Forbidden**

Пробуем открыть https://registry.terraform.io/ в браузере - догадка подтверждается:
![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/hashicorp.png)


## Этап 4. Установка и настройка CI/CD

* Интерфейс ci/cd сервиса (Jenkins) доступен по http: http://62.84.126.220:8080/

### Условие 1. При любом коммите в репозиторий с тестовым приложением происходит сборка и отправка в регистр Docker образа.

#### Что выполнено:

* На предварительно созданной с помощью Terraform машине развернуты Jenkins и Docker с помощью:
    *  [Ansible-playbook](https://github.com/GrigoriyAzatyan/diploma/blob/master/jenkins-ansible/install_jenkins.yml);
    *  Самостоятельно написанных ролей [jenkins](https://github.com/GrigoriyAzatyan/diploma/tree/master/jenkins-ansible/roles/jenkins) и [docker](https://github.com/GrigoriyAzatyan/diploma/blob/master/jenkins-ansible/roles/docker/tasks/main.yml)

* В развернутом Jenkins создано задание "Docker", использующее плагины Git и Docker. В настройках задания задействован параметр "Trigger builds remotely (e.g., from scripts)", позволяющий вызывать вебхуком запуск конкретно данного задания с помощью Application Token;

* В Github настроен вебхук по шаблону `http://admin:<api_token>@62.84.126.220:8080/job/Docker/build?token=<Application Token>`, вызывающий запуск сборки. 
  
#### Проверяем работу:   

  
  
  

### Условие 2. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.

