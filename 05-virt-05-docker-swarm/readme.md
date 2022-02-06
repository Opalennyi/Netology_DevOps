## Задача 1

_Дайте письменые ответы на следующие вопросы:_

- _В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?_

В режиме replication сервис запущен на определенном нами количестве нод, в режиме global на каждой ноде создается по реплике и сервис работает сразу на всех нодах роя.

- _Какой алгоритм выбора лидера используется в Docker Swarm кластере?_

Это протокол Raft, лидером становится нода, получившая больше всего голосов других нод.

- _Что такое Overlay Network?_

Overlay-сеть — это подсеть (распределенная сеть) для обмена данными между контейнерами на разных Docker daemon хостах swarm'а (роя).


## Задача 2

_Создать ваш первый Docker Swarm кластер в Яндекс.Облаке_

```bash
Opalennyi-iMac-2:terraform opalennyi$ ssh centos@84.252.128.224
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
1fducms57wb47xf54fi5o0rxa *   node01.netology.yc   Ready     Active         Leader           20.10.12
l8iyb1sxbr44y0d8ybvyw1q62     node02.netology.yc   Ready     Active         Reachable        20.10.12
43vrd65zogustbtmvnt587k5u     node03.netology.yc   Ready     Active         Reachable        20.10.12
48rrbr9xii2e67eu3z0dqrnw5     node04.netology.yc   Ready     Active                          20.10.12
v6spex3b6gsxfxfb7uf21byu1     node05.netology.yc   Ready     Active                          20.10.12
r719ms4z5lw13kwk9ohc0w0uf     node06.netology.yc   Ready     Active                          20.10.12
```

## Задача 3

_Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов._

```bash
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
5qf1v480zkzc   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
3kiej30irvca   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
kqcvtv4xfgm1   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
yneijpykv1rd   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
oo4xdi19bix0   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
ox7oioegkvq0   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
skbzfgoz7e4a   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
tjpk79i1x342   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## Задача 4 (*)

_Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:_
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

```bash
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-Ohubw8aqCmYsgw2M/w1+lQjjqFnpxhtbxDPxcnkqV9c

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[root@node01 ~]# service docker restart
Redirecting to /bin/systemctl restart docker.service
[root@node01 ~]# docker service ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.
[root@node01 ~]# docker swarm unlock
Please enter unlock key:
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
5qf1v480zkzc   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
3kiej30irvca   swarm_monitoring_caddy              replicated   0/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
kqcvtv4xfgm1   swarm_monitoring_cadvisor           global       5/5        google/cadvisor:latest
yneijpykv1rd   swarm_monitoring_dockerd-exporter   global       5/5        stefanprodan/caddy:latest
oo4xdi19bix0   swarm_monitoring_grafana            replicated   0/1        stefanprodan/swarmprom-grafana:5.3.4
ox7oioegkvq0   swarm_monitoring_node-exporter      global       5/5        stefanprodan/swarmprom-node-exporter:v0.16.0
skbzfgoz7e4a   swarm_monitoring_prometheus         replicated   0/1        stefanprodan/swarmprom-prometheus:v2.5.0
tjpk79i1x342   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
[root@node01 ~]#
```

Эта настройка (или запуск Docker'а с соответствующим ключом: `docker swarm init --autolock`) позволяет нам вручную расшифровывать Raft-логи. Если эта опция не включена, при запуске Docker'а TLS-ключ, используемый для шифрования коммуникации между нодами, и ключ, используемый для шифрования/дешифровки Raft-логов, автоматически загружаются в память каждой из нод-менеджеров. При включенной опции мы управляем этим процессом вручную и также получаем возможность в любой момент вручную изменить ключ шифрования/дешифровки.