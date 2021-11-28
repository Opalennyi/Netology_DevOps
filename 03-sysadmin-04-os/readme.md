#### 1. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:<br />* поместите его в автозагрузку,<br />* предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),<br />* удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

`vagrant@vagrant:~$ sudo nano /lib/systemd/system/node_exporter.service`

Содержание файла:
````bash
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter

[Install]
WantedBy=multi-user.target
````

Добавляем его в автозагрузку:  
````bash
vagrant@vagrant:~$ sudo systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /lib/systemd/system/node_exporter.service.
````

Предусмотрим возможность добавления опций через внешний файл, добавив строчку:
`EnvironmentFile=/etc/default/node_exporter`

Файл `node_exporter.service` будет теперь выглядеть вот так:
````commandline
vagrant@vagrant:~$ systemctl cat node_exporter
# /lib/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/etc/default/node_exporter
Type=simple
ExecStart=/home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter

[Install]
WantedBy=multi-user.target
````

Проверим, что процесс корректно стартует:
````bash
vagrant@vagrant:~$ systemctl status node_exporter
● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/lib/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: inactive (dead)

<...>

vagrant@vagrant:~$ systemctl start node_exporter
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to start 'node_exporter.service'.
Authenticating as: vagrant,,, (vagrant)
Password:
==== AUTHENTICATION COMPLETE ===
vagrant@vagrant:~$ systemctl status node_exporter.service
● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/lib/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-11-28 00:05:06 UTC; 15s ago
   Main PID: 56285 (node_exporter)
      Tasks: 4 (limit: 1071)
     Memory: 2.4M
     CGroup: /system.slice/node_exporter.service
             └─56285 /home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter
````

Проверим, что действительно есть такой процесс:
````bash
vagrant@vagrant:~$ ps -aux | grep node_exporter
root       56285  0.0  1.0 715964 11044 ?        Ssl  00:05   0:00 /home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter
vagrant    56303  0.0  0.0  10760   736 pts/0    S+   00:06   0:00 grep --color=auto node_exporter
````

Проверим, что процесс корректно завершается:
````bash
vagrant@vagrant:~$ systemctl stop node_exporter
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to stop 'node_exporter.service'.
Authenticating as: vagrant,,, (vagrant)
Password:
==== AUTHENTICATION COMPLETE ===
vagrant@vagrant:~$ systemctl status node_exporter.service
● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/lib/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Sun 2021-11-28 00:07:13 UTC; 4s ago
    Process: 56285 ExecStart=/home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter (code=killed, signal=TERM)
   Main PID: 56285 (code=killed, signal=TERM)
   
<...>

vagrant@vagrant:~$ ps -aux | grep node_exporter
vagrant    56328  0.0  0.0  10760   676 pts/0    S+   00:07   0:00 grep --color=auto node_exporter
````

Процесс успешно стартует и завершается через `systemctl`.

Перезагрузим систему и проверим, что процесс автоматически стартует:
````bash
vagrant@vagrant:~$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
Connection to 127.0.0.1 closed.
Opalennyi-iMac-2:03-sysadmin-01-terminal opalennyi$ vagrant ssh
<...>
Last login: Sat Nov 27 22:19:51 2021 from 10.0.2.2
vagrant@vagrant:~$ systemctl status node_exporter.service
● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/lib/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-11-28 00:10:36 UTC; 1min 6s ago
   Main PID: 758 (node_exporter)
      Tasks: 5 (limit: 1112)
     Memory: 14.6M
     CGroup: /system.slice/node_exporter.service
             └─758 /home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter
<...>
vagrant@vagrant:~$ ps -aux | grep node_exporter
root         758  0.0  1.2 715964 12968 ?        Ssl  00:10   0:00 /home/vagrant/node_exporter-1.3.0.linux-amd64/node_exporter
vagrant     1076  0.0  0.2  10760  2468 pts/0    S+   00:12   0:00 grep --color=auto node_exporter
````

Все успешно стартует после перезагрузки.