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


### 4.1. Если на первом этапе вы не воспользовались Terraform Cloud, то задеплойте в кластер atlantis для отслеживания изменений инфраструктуры.

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

- Выполняем `echo "<tr><td>Конфеты 'Мишка на сервере'</td><td>кг</td><td>600</td></tr>" >> ./public-html/index.html && git add * && git commit -m "added line to index.html" && git push`

- В Jenkins запустилась сборка "Docker":
 
![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/Jenkins_job1.png)

- Вывод консоли сборки:

```
Started by remote host 140.82.115.107
Started by GitHub push by GrigoriyAzatyan
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/Docker
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential c9ec4aaa-79f0-4472-939c-896b4aed958d
 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/Docker/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/GrigoriyAzatyan/diploma.git # timeout=10
Fetching upstream changes from https://github.com/GrigoriyAzatyan/diploma.git
 > git --version # timeout=10
 > git --version # 'git version 2.25.1'
using GIT_ASKPASS to set credentials Github credentials
 > git fetch --tags --force --progress -- https://github.com/GrigoriyAzatyan/diploma.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Seen branch in repository origin/25.08
Seen branch in repository origin/master
Seen branch in repository origin/new
Seen branch in repository origin/tags/v1.1
Seen branch in repository origin/tags/v1.11
Seen branch in repository origin/tags/v1.12
Seen branch in repository origin/tags/v1.13
Seen branch in repository origin/tags/v1.14
Seen branch in repository origin/tags/v1.15
Seen branch in repository origin/tags/v1.16
Seen branch in repository origin/tags/v1.17
Seen branch in repository origin/tags/v1.18
Seen branch in repository origin/tags/v1.19
Seen branch in repository origin/tags/v1.20
Seen branch in repository origin/test01
Seen 15 remote branches
 > git show-ref --tags -d # timeout=10
Checking out Revision 4b78cecf605dfb29b6379a68fa22adcbdfba10c2 (origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 4b78cecf605dfb29b6379a68fa22adcbdfba10c2 # timeout=10
Commit message: "added line to index.html"
 > git rev-list --no-walk 5691e6815b84f1545f9a96a3ff295213122b3632 # timeout=10
[Docker] $ docker build -t gregory78/static-page:90 --pull=true /var/lib/jenkins/workspace/Docker
Sending build context to Docker daemon  115.6MB

Step 1/3 : FROM bitnami/nginx:latest
latest: Pulling from bitnami/nginx
Digest: sha256:032cc09595592292d56b467ac258dba4756d93d23270b7d638ceab371be3d4ed
Status: Image is up to date for bitnami/nginx:latest
 ---> acb4a50224de
Step 2/3 : COPY ./public-html/ /app/
 ---> 361c717335db
Step 3/3 : EXPOSE 80
 ---> Running in 5ac946f01c7b
Removing intermediate container 5ac946f01c7b
 ---> dfd26ff452c6
Successfully built dfd26ff452c6
Successfully tagged gregory78/static-page:90
[Docker] $ docker tag dfd26ff452c6 gregory78/static-page:latest
[Docker] $ docker inspect dfd26ff452c6
[Docker] $ docker push gregory78/static-page:90
The push refers to repository [docker.io/gregory78/static-page]
d4bde4742a5c: Preparing
4d598999c236: Preparing
168fedea22a4: Preparing
6063d94b7061: Preparing
613531f6cdb8: Preparing
c1dee516ce06: Preparing
439947ec892c: Preparing
140b9320b6ea: Preparing
59ba95c6569a: Preparing
8add44fb46e5: Preparing
0bc7edffadbc: Preparing
18ba4d4ff37c: Preparing
d745f418fc70: Preparing
c1dee516ce06: Waiting
439947ec892c: Waiting
140b9320b6ea: Waiting
8add44fb46e5: Waiting
0bc7edffadbc: Waiting
18ba4d4ff37c: Waiting
d745f418fc70: Waiting
59ba95c6569a: Waiting
613531f6cdb8: Layer already exists
6063d94b7061: Layer already exists
4d598999c236: Layer already exists
168fedea22a4: Layer already exists
c1dee516ce06: Layer already exists
140b9320b6ea: Layer already exists
59ba95c6569a: Layer already exists
439947ec892c: Layer already exists
0bc7edffadbc: Layer already exists
18ba4d4ff37c: Layer already exists
d745f418fc70: Layer already exists
8add44fb46e5: Layer already exists
d4bde4742a5c: Pushed
90: digest: sha256:f5af99ab2b0a8c659933d63901e8aca278a6379a895b62d7bc2bc8a1bf551005 size: 3037
[Docker] $ docker push gregory78/static-page:latest
The push refers to repository [docker.io/gregory78/static-page]
d4bde4742a5c: Preparing
4d598999c236: Preparing
168fedea22a4: Preparing
6063d94b7061: Preparing
613531f6cdb8: Preparing
c1dee516ce06: Preparing
439947ec892c: Preparing
140b9320b6ea: Preparing
59ba95c6569a: Preparing
8add44fb46e5: Preparing
0bc7edffadbc: Preparing
18ba4d4ff37c: Preparing
d745f418fc70: Preparing
c1dee516ce06: Waiting
439947ec892c: Waiting
140b9320b6ea: Waiting
59ba95c6569a: Waiting
8add44fb46e5: Waiting
0bc7edffadbc: Waiting
18ba4d4ff37c: Waiting
d745f418fc70: Waiting
168fedea22a4: Layer already exists
d4bde4742a5c: Layer already exists
6063d94b7061: Layer already exists
613531f6cdb8: Layer already exists
4d598999c236: Layer already exists
439947ec892c: Layer already exists
140b9320b6ea: Layer already exists
c1dee516ce06: Layer already exists
59ba95c6569a: Layer already exists
8add44fb46e5: Layer already exists
0bc7edffadbc: Layer already exists
d745f418fc70: Layer already exists
18ba4d4ff37c: Layer already exists
latest: digest: sha256:f5af99ab2b0a8c659933d63901e8aca278a6379a895b62d7bc2bc8a1bf551005 size: 3037
Finished: SUCCESS
```
- в Docker Hub появилась версия с тегами "90" (номер сборки Jenkins) и "latest" образа static-page:

 ![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/Dockerhub_1.png)
  

### Условие 2. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.

#### Что выполнено:

* В Jenkins создано задание "Docker2", использующее плагины Git и Docker. В настройках задания задействован параметр "Trigger builds remotely (e.g., from scripts)", позволяющий вызывать вебхуком запуск конкретно данного задания с помощью Application Token;

* Для того, чтобы Jenkins в процессе сборки мог управлять кластером Kubernetes с помощью утилиты kubectl, написан [Ansible-playbook](https://github.com/GrigoriyAzatyan/diploma/blob/master/jenkins-ansible/setup_kubectl.yml) и ряд [ролей](https://github.com/GrigoriyAzatyan/diploma/tree/master/jenkins-ansible/roles), запускающихся последовательно на разных хостах:

|№| Имя роли | Хост назначения | Выполняемые действия|
|-|----------|----------|----------|
|1| kubectl_1_prepare |Jenkins |Устанавливает kubectl, генерирует закрытый ключ и запрос на сертификат (CSR)|
|2 |kubectl_2_create_kubeconfig |Kubernetes Control Plane|Копирует CSR на Control Plane, генерирует role, role binding, namespace, kubeconfig для jenkins|
|3 |kubectl_3_fix_ip |Локальная машина с запущенным Ansible|Исправляет "127.0.0.1" из kubeconfig на IP узла kubernetes-cp1, сохраненный из Terraform|
|4 |kubectl_4_config_to_jenkins |Jenkins |Копирует готовый kubeconfig на хост Jenkins в личную папку пользователя jenkins/.kube/config|
|5|kubectl_5_apply_config |Kubernetes Control Plane|Добавляет в kubeconfig закрытый ключ, демонстрирует результат|

* В Github настроен вебхук по шаблону `http://admin:<api_token>@62.84.126.220:8080/job/Docker2/build?token=<Application Token>`, вызывающий запуск сборки "Docker2". 
  
#### Проверяем работу:  
- Выполняем `git tag -a v1.4 -m "1.4" && git push origin v1.4`;

- В Jenkins запустилась сборка "Docker2":
 
![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/Jenkins_2.png)

- Вывод консоли сборки:

```
Started by remote host 140.82.115.117
Started by GitHub push by GrigoriyAzatyan
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/Docker2
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential c9ec4aaa-79f0-4472-939c-896b4aed958d
 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/Docker2/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/GrigoriyAzatyan/diploma.git # timeout=10
Fetching upstream changes from https://github.com/GrigoriyAzatyan/diploma.git
 > git --version # timeout=10
 > git --version # 'git version 2.25.1'
using GIT_ASKPASS to set credentials Github credentials
 > git fetch --tags --force --progress -- https://github.com/GrigoriyAzatyan/diploma.git +refs/tags/*:refs/remotes/origin/tags/* # timeout=10
Seen branch in repository origin/master
Seen branch in repository origin/new
Seen branch in repository origin/tags/v1.1
Seen branch in repository origin/tags/v1.11
Seen branch in repository origin/tags/v1.12
Seen branch in repository origin/tags/v1.13
Seen branch in repository origin/tags/v1.14
Seen branch in repository origin/tags/v1.15
Seen branch in repository origin/tags/v1.16
Seen branch in repository origin/tags/v1.17
Seen branch in repository origin/tags/v1.18
Seen branch in repository origin/tags/v1.19
Seen branch in repository origin/tags/v1.20
Seen branch in repository origin/tags/v1.21
Seen branch in repository origin/tags/v1.22
Seen branch in repository origin/tags/v1.23
Seen branch in repository origin/tags/v1.24
Seen branch in repository origin/tags/v1.25
Seen branch in repository origin/tags/v1.26
Seen branch in repository origin/tags/v1.27
Seen branch in repository origin/tags/v1.28
Seen branch in repository origin/tags/v1.29
Seen branch in repository origin/tags/v1.3
Seen branch in repository origin/tags/v1.31
Seen branch in repository origin/tags/v1.32
Seen branch in repository origin/tags/v1.33
Seen branch in repository origin/tags/v1.34
Seen branch in repository origin/tags/v1.35
Seen branch in repository origin/tags/v1.36
Seen branch in repository origin/tags/v1.4
Seen 30 remote branches
 > git show-ref --tags -d # timeout=10
Checking out Revision 12aa9cddf1d7819cf5a4d65cb5d9e18aefc90133 (origin/tags/v1.4)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 12aa9cddf1d7819cf5a4d65cb5d9e18aefc90133 # timeout=10
Commit message: "Update README.md"
First time build. Skipping changelog.
[Docker2] $ /bin/sh -xe /tmp/jenkins15288748039559498235.sh
+ chmod +x ./static-page-kube/docker-build.sh
+ /bin/bash -c ./static-page-kube/docker-build.sh
GIT_BRANCH: origin/tags/v1.4
TAG: v1.4
Sending build context to Docker daemon  96.05MB

Step 1/3 : FROM bitnami/nginx:latest
 ---> acb4a50224de
Step 2/3 : COPY ./public-html/ /app/
 ---> Using cache
 ---> 361c717335db
Step 3/3 : EXPOSE 80
 ---> Using cache
 ---> dfd26ff452c6
Successfully built dfd26ff452c6
Successfully tagged gregory78/static-page:v1.4
WARNING! Your password will be stored unencrypted in /var/lib/jenkins/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
The push refers to repository [docker.io/gregory78/static-page]
d4bde4742a5c: Preparing
4d598999c236: Preparing
168fedea22a4: Preparing
6063d94b7061: Preparing
613531f6cdb8: Preparing
c1dee516ce06: Preparing
439947ec892c: Preparing
140b9320b6ea: Preparing
59ba95c6569a: Preparing
8add44fb46e5: Preparing
0bc7edffadbc: Preparing
18ba4d4ff37c: Preparing
d745f418fc70: Preparing
c1dee516ce06: Waiting
439947ec892c: Waiting
140b9320b6ea: Waiting
59ba95c6569a: Waiting
8add44fb46e5: Waiting
0bc7edffadbc: Waiting
18ba4d4ff37c: Waiting
d745f418fc70: Waiting
6063d94b7061: Layer already exists
168fedea22a4: Layer already exists
613531f6cdb8: Layer already exists
d4bde4742a5c: Layer already exists
4d598999c236: Layer already exists
439947ec892c: Layer already exists
c1dee516ce06: Layer already exists
59ba95c6569a: Layer already exists
140b9320b6ea: Layer already exists
8add44fb46e5: Layer already exists
0bc7edffadbc: Layer already exists
18ba4d4ff37c: Layer already exists
d745f418fc70: Layer already exists
v1.4: digest: sha256:f5af99ab2b0a8c659933d63901e8aca278a6379a895b62d7bc2bc8a1bf551005 size: 3037
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] Total reclaimed space: 0B
deployment.apps/static-page configured
service/static-page unchanged
ingress.networking.k8s.io/static-page unchanged
Finished: SUCCESS
```
- в Docker Hub появилась версия с тегами "v1.4" (тег из Git) и "latest" образа ststic-page:

 ![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/Dockerhub_2.png)

- В Kubernetes обновилась версия Dployment "static-page":

```
# kubectl get deploy -n jenkins -o wide

NAME          READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS    IMAGES                       SELECTOR
static-page   1/1     1            1           31h   static-page   gregory78/static-page:v1.4   app=static-page

```

- Веб-приложение отображает теперь новую строчку в списке товаров:

![](https://github.com/GrigoriyAzatyan/devops-netology/blob/main/Result.png)



## Ссылки на необходимые материалы для сдачи задания

* Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля: https://github.com/GrigoriyAzatyan/diploma/tree/master/terraform
* Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud: см. раздел 4.1.
* Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible: https://github.com/GrigoriyAzatyan/diploma/tree/master/kubespray

* Репозиторий с Dockerfile тестового приложения: https://github.com/GrigoriyAzatyan/diploma/blob/master/Dockerfile
* Ссылка на собранный docker image: https://hub.docker.com/repository/docker/gregory78/static-page или `docker pull gregory78/static-page:latest`
* Репозиторий с конфигурацией Kubernetes кластера: https://github.com/GrigoriyAzatyan/diploma/tree/master/kubernetes-conf
* Ссылка на тестовое приложение: http://51.250.80.230:30000
* Ссылка на веб интерфейс Grafana с данными доступа: Grafana: http://51.250.13.12:3000
   * admin
   * GiKzF77a

