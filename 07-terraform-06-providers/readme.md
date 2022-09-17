# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

## Задача 1. 
_Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны._  


1. _Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе._

Здесь находится список ресурсов: https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L927

Здесь — источников данных: https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L416

2. _Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`._

    * _С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано._

    Согласно [исходному коду](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go) ([здесь](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L88) и [здесь](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L95)), он конфликтует с `name_prefix`.

    * _Какая максимальная длина имени?_

    Если я правильно понимаю код, то длина любой строковой переменной кроме `fifoQueue` (длина которого ограничена 75 символами), в том числе `name`, не может превышать 80 символов: https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L432

    * _Какому регулярному выражению должно подчиняться имя?_

    `[a-zA-Z0-9_-]`