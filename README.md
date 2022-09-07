# Дипломная работа
## Азатян Г.Р.

## Этап 1. Создание облачной инфраструктуры

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

