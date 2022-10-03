# Дипломное задание по курсу «DevOps-инженер»

## Дипломный практикум в YandexCloud

### 1. Регистрация доменного имени

Зарегистрируем домен `sergey-belov.ru` на reg.ru. При покупке добавим дополнительную бесплатную услугу DomainSSL.

Изменим дефолтные DNS-серверы на серверы Яндекса `ns1.yandexcloud.net` и `ns2.yandexcloud.net`.

![yandex-dns-servers](images/yandex-dns-servers.png)

### 2. Создание инфраструктуры

Создадим сервисный аккаунт в Yandex Cloud с ролью `editor`.

![yc-service-account](images/yc-service-account.png)

Создадим CLI-driven workspace в Terraform Cloud, который будем в дальнейшем использовать в качестве backend'а. Создать workspace с именем `stage` невозможно — оно уже занято.

![terraform-cloud](images/terraform-cloud.png)

Всего нам понадобится 8 виртуальных машин. Для сборки будем использовать один из стандартных образов Yandex Cloud, список которых мы можем получить с помощью этой команды:
```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro ~ % yc compute image list --folder-id standard-images >> /Users/sergey.belov/Downloads/yс-images.txt
```

Инфраструктура доступна в директории [terraform](terraform/).

Запустим `terraform init`:
```shell
sergey.belov@Try-Goose-Grass-MacBook-Pro terraform % terraform init

Initializing Terraform Cloud...

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching "0.80.0"...
- Installing yandex-cloud/yandex v0.80.0...
- Installed yandex-cloud/yandex v0.80.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform Cloud has been successfully initialized!

You may now begin working with Terraform Cloud. Try running "terraform plan" to
see any changes that are required for your infrastructure.

If you ever set or change modules or Terraform Settings, run "terraform init"
again to reinitialize your working directory.
```

Проверим конфигурацию при помощи `terraform validate`:
```shell
sergey.belov@Try-Goose-Grass-MacBook-Pro terraform % terraform validate
Success! The configuration is valid.
```

При первом запуске `terraform plan` получим сообщение о том, что переменные не настроены:
```shell
sergey.belov@Try-Goose-Grass-MacBook-Pro terraform % terraform plan
Running plan in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will stop streaming the logs, but will not stop the plan running remotely.

Preparing the remote plan...

To view this run in a browser, visit:
https://app.terraform.io/app/netology-dvpspdc-3-graduate/dvpspdc-3-graduate/runs/run-RoGBwDBWyTXbHcmC

Waiting for the plan to start...

Terraform v1.3.1
on linux_amd64
Initializing plugins and modules...
╷
│ Error: No value for required variable
│
│   on variables.tf line 1:
│    1: variable "yc_token" {}
│
│ The root module input variable "yc_token" is not set, and has no default
│ value. Use a -var or -var-file command line argument to provide a value for
│ this variable.
╵
╷
│ Error: No value for required variable
│
│   on variables.tf line 11:
│   11: variable "SSH_ID_RSA_PUB" {}
│
│ The root module input variable "SSH_ID_RSA_PUB" is not set, and has no
│ default value. Use a -var or -var-file command line argument to provide a
│ value for this variable.
╵
Operation failed: failed running terraform plan (exit 1)
```

Добавим в Terraform Cloud две переменные окружения, отметив, что их значения — Sensitive:

![tc-variables](images/tc-variables.png)

Запустим `terraform plan` еще раз:
```shell
sergey.belov@Try-Goose-Grass-MacBook-Pro terraform % terraform plan
Running plan in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will stop streaming the logs, but will not stop the plan running remotely.

Preparing the remote plan...

To view this run in a browser, visit:
https://app.terraform.io/app/netology-dvpspdc-3-graduate/dvpspdc-3-graduate/runs/run-TgQGWZ5Yj8o55j4W

Waiting for the plan to start...

Terraform v1.3.1
on linux_amd64
Initializing plugins and modules...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.app will be created
  + resource "yandex_compute_instance" "app" {
    
<...>

Plan: 18 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + app_internal_ip_address           = (known after apply)
  + db01_internal_ip_address          = (known after apply)
  + db02_internal_ip_address          = (known after apply)
  + gitlab_internal_ip_address        = (known after apply)
  + main_instance_external_ip_address = (known after apply)
  + monitoring_internal_ip_address    = (known after apply)
  + runner_internal_ip_address        = (known after apply)
  + ssh_config                        = (known after apply)
```

Выполним `terraform apply --auto-approve`:
```shell
sergey.belov@Try-Goose-Grass-MacBook-Pro terraform % terraform apply --auto-approve
Running apply in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

<...>

Terraform will perform the following actions:

Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

app_internal_ip_address = "192.168.2.15"
db01_internal_ip_address = "192.168.2.17"
db02_internal_ip_address = "192.168.2.30"
gitlab_internal_ip_address = "192.168.2.21"
main_instance_external_ip_address = "178.154.223.24"
monitoring_internal_ip_address = "192.168.2.39"
runner_internal_ip_address = "192.168.2.19"
ssh_config = <<EOT

<...>
```

Проверим Terraform Cloud:

![tc-apply-1](images/tc-apply-1.png)

![tc-apply-2](images/tc-apply-2.png)

Также проверим в интерфейсе Yandex.Cloud что все корректно работает.

![yc-apply-1](images/yc-apply-1.png)

**Виртуальные машины:**

![yc-apply-1-VMs](images/yc-apply-1-VMs.png)

**Виртуальные сети:**

![yc-apply-1-networks](images/yc-apply-1-networks.png)

**DNS-записи:**

![yc-apply-1-DNS](images/yc-apply-1-dns.png)

Вся инфраструктура успешно развернута.

Попробуем применить `terraform destroy`:
```shell
<...>

Do you really want to destroy all resources in workspace "dvpspdc-3-graduate"?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
  
<...>

Apply complete! Resources: 0 added, 0 changed, 18 destroyed.
```

Снова проверим Terraform Cloud и интерфейс Yandex.Cloud:

![tc-destroy-1](images/tc-destroy-1.png)

![yc-destroy-1](images/yc-destroy-1.png)

Инфраструктура успешно уничтожена.

### 3. Установка Nginx и LetsEncrypt

