# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. _Установите ansible версии 2.10 или выше._

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro ~ % brew install ansible
<...>
sergey.belov@Try-Goose-Grass-MacBook-Pro ~ % ansible --version
ansible [core 2.13.4]
  config file = None
  configured module search path = ['/Users/sergey.belov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/homebrew/Cellar/ansible/6.4.0/libexec/lib/python3.10/site-packages/ansible
  ansible collection location = /Users/sergey.belov/.ansible/collections:/usr/share/ansible/collections
  executable location = /opt/homebrew/bin/ansible
  python version = 3.10.6 (main, Aug 30 2022, 04:58:14) [Clang 13.1.6 (clang-1316.0.21.2.5)]
  jinja version = 3.1.2
  libyaml = True
```

2. _Создайте свой собственный публичный репозиторий на github с произвольным именем._

Сделано в начале курса.

3. _Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий._

Скачан, перенесен.

## Основная часть

1. П*опробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.*

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /opt/homebrew/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Из таска Print fact получаем значение `some_fact` равное 12.

2. _Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'._

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % cat group_vars/all/examp.yml
---
  some_fact: "all default fact"
```

3. _Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний._

**Centos 7:**

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % docker run -d -i --name centos7 centos:7 /bin/bash
Unable to find image 'centos:7' locally
7: Pulling from library/centos
6717b8ec66cd: Already exists
Digest: sha256:c73f515d06b0fa07bb18d8202035e739a494ce760aa73129f60f4bf2bd22b407
Status: Downloaded newer image for centos:7
b92034ff8afa9d1fd1d00390a3d6cb450a84acd889b0edad4445e703494707c5
```

**Ubuntu (в неё установим python3, поскольку в базовой сборке Ubuntu Python'а нет):**
```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % docker run -d -i --name ubuntu ubuntu /bin/bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
00f50047d606: Pull complete
Digest: sha256:20fa2d7bb4de7723f542be5923b06c4d704370f0390e4ae9e1c833c8785644c1
Status: Downloaded newer image for ubuntu:latest
6e0fa547e63c1b9a6bffcae264e8ba4ebcfe76f1388c94509c07c735c36ca887

sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % docker exec -it ubuntu apt-get update
Get:1 http://ports.ubuntu.com/ubuntu-ports jammy InRelease [270 kB]
<...>
Reading package lists... Done

sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % docker exec -it ubuntu apt-get install python3
Reading package lists... Done
<...>
running python post-rtupdate hooks for python3.10...
Processing triggers for libc-bin (2.35-0ubuntu3.1) ...
```

4. _Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`._

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Из таска Print fact получаем значение `some_fact` равное `el` для Centos7 и `deb` — для Ubuntu.

5. _Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'._

Внесем изменения в `group_vars`:

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % nano group_vars/deb/examp.yml
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact"
  
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % nano group_vars/el/examp.yml
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % cat group_vars/el/examp.yml
---
  some_fact: "el default fact"
```

6. _Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов._

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

7. _При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`._

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful

sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```

8. _Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности._

Попробуем запустить Ansible:
```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
```

Запустим его с ключом `--ask-vault-pass`:
```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml
Vault password:

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9_Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`._

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-doc -l -t module
```

Список модулей, подходящих для `control node`:
```zsh
add_host                                                                                 Add a host (and alternatively a group) to the ansible-playbook in-memory inventory
amazon.aws.aws_az_facts                                                                  Gather information about availability zones in AWS
amazon.aws.aws_az_info                                                                   Gather information about availability zones in AWS
amazon.aws.aws_caller_info                                                               Get information about the user and account being used to make AWS calls
amazon.aws.aws_s3                                                                        manage objects in S3
amazon.aws.cloudformation                                                                Create or delete an AWS CloudFormation stack
amazon.aws.cloudformation_info                                                           Obtain information about an AWS CloudFormation stack
amazon.aws.ec2                                                                           create, terminate, start or stop an instance in ec2
amazon.aws.ec2_ami                                                                       Create or destroy an image (AMI) in ec2
amazon.aws.ec2_ami_info                                                                  Gather information about ec2 AMIs
<...>
```

...и так далее. Всего модулей огромное число, они все, в целом, подходят для использования на контролирующей ноде.

10. _В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения._

```yaml
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker

  inside:
    hosts:
      localhost:
        ansible_connection: local%
```

11. _Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`._

```zsh
sergey.belov@Try-Goose-Grass-MacBook-Pro playbook % ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml
Vault password:

PLAY [Print os facts] ****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /opt/homebrew/bin/python3.10, but future installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ********************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Все значения получены правильно:
* для Centos (`el`) — `el default fact`;
* для Ubuntu (`deb`) — `deb default fact`;
* для localhost (`inside`) — `all default fact`.

12. _Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`._

Done. You're here :)