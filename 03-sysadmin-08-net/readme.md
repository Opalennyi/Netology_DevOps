#### 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP

````bash
route-views>show ip route 188.243.183.57
Routing entry for 188.242.0.0/15, supernet
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 7w0d ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 7w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 2
      Route tag 6939
      MPLS label: none


route-views>show bgp 188.243.183.57
BGP routing table entry for 188.242.0.0/15, version 65720010
Paths: (23 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 1
  20912 3257 9002 35807
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      Community: 3257:8052 3257:50001 3257:54900 3257:54901 20912:65004 65535:65284
      path 7FE1792AC338 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 20764 35807
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      Community: 20764:3002 20764:3010 20764:3021 35807:1551 35807:5000
      path 7FE027BBC328 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 20764 35807
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 8283:1 8283:101 20764:3002 20764:3010 20764:3021 35807:1551 35807:5000
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001
      path 7FE1756381C8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 9002 35807
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840
      path 7FE16F4924A8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 9002 35807
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067
      path 7FE03BC02750 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 20764 35807
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      Community: 174:21101 174:22014 53767:5000
````

#### 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

Создадим dummy0-интерфейс:

````bash
vagrant@vagrant:~$ cat /etc/modules
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.

vagrant@vagrant:~$ sudo su
root@vagrant:/home/vagrant# echo "dummy" >> /etc/modules
root@vagrant:/home/vagrant# cat /etc/modules
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.

dummy
root@vagrant:/home/vagrant# exit

vagrant@vagrant:~$ cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d
auto eth0.1400
iface eth0.1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
vagrant@vagrant:~$ sudo nano /etc/network/interfaces
vagrant@vagrant:~$ cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d
auto dummy0
iface dummy0 inet static
    address 10.2.2.2/32
    pre-up ip link add dummy0 type dummy
    post-down ip link del dummy0
````

Добавим несколько статических маршрутов и посмотрим на изменения в таблице маршрутизации:

```bash
vagrant@vagrant:~$ ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100

vagrant@vagrant:~$ sudo ip route add 188.242.0.0/15 dev dummy0
vagrant@vagrant:~$ sudo ip route add 172.16.10.0/24 dev dummy0
vagrant@vagrant:~$ ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
172.16.10.0/24 dev dummy0 scope link
188.242.0.0/15 dev dummy0 scope link
```

#### 3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

````bash
vagrant@vagrant:~$ sudo ss -ltpn
State             Recv-Q            Send-Q                       Local Address:Port                        Peer Address:Port            Process
LISTEN            0                 4096                               0.0.0.0:111                              0.0.0.0:*                users:(("rpcbind",pid=593,fd=4),("systemd",pid=1,fd=35))
LISTEN            0                 4096                         127.0.0.53%lo:53                               0.0.0.0:*                users:(("systemd-resolve",pid=594,fd=13))
LISTEN            0                 128                                0.0.0.0:22                               0.0.0.0:*                users:(("sshd",pid=813,fd=3))
LISTEN            0                 4096                                  [::]:111                                 [::]:*                users:(("rpcbind",pid=593,fd=6),("systemd",pid=1,fd=37))
LISTEN            0                 128                                   [::]:22                                  [::]:*                users:(("sshd",pid=813,fd=4))
````

Всего открытых портов три: 22, 53 и 111.

Как говорит Википедия,  
> **rpcbind** — демон, сопоставляющий универсальные адреса и номера программ RPC. Это сервер, преобразующий номера программ RPC в универсальные адреса.  

Он использует порт 111.

`sshd` — серверный процесс OpenSSH. Он прослушивает входящие соединения, использующие протокол SSH, и действует как сервер для этого протокола. Занимается аутентификацией пользователей, шифрованием, соединениями терминалов, передачей файлов и туннелированием ([Источник](https://www.ssh.com/academy/ssh/sshd)). Он использует порт 22.

`systemd-resolve`, использующий порт 53, — менеджер разрешения сетевых имен (Network Name Resolution manager) для локальных приложений, работает как распознаватель для системы доменных имен ([Источник](https://wiki.archlinux.org/title/Systemd-resolved)).

#### 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

````bash
vagrant@vagrant:~$ sudo ss -lun
State                   Recv-Q                  Send-Q                                     Local Address:Port                                     Peer Address:Port                  Process
UNCONN                  0                       0                                                0.0.0.0:111                                           0.0.0.0:*
UNCONN                  0                       0                                          127.0.0.53%lo:53                                            0.0.0.0:*
UNCONN                  0                       0                                         10.0.2.15%eth0:68                                            0.0.0.0:*
UNCONN                  0                       0                                                   [::]:111                                              [::]:*
````

Здесь мы снова видим три порта: 53, 68 и 111, но не видим процессы.

Резонно предположить, что порты 53 и 111 используют те же процессы, что и TCP-порты (`systemd-resolve` и `rcpbind` соответственно).

68-й порт также имеет зарегистрированное IANA применение ([Википедия](https://ru.wikipedia.org/wiki/Список_портов_TCP_и_UDP)):
> BOOTPC (Bootstrap Protocol Client) — для клиентов бездисковых рабочих станций, загружающихся с сервера BOOTP; также используется DHCP (Dynamic Host Configuration Protocol)

Не видно, какой именно процесс использует порт, но можно предположить, что это процесс, отвечающий за автоматическое получение IP-адреса при загрузке системы.

#### 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

Сначала я посмотрел все устройства в локальной сети на локальной машине.

````bash
Opalennyi-iMac-2:~ opalennyi$ sudo arp -a
? (10.0.1.1) at 90:72:40:1:1a:50 on en1 ifscope [ethernet]
? (10.0.1.2) at 44:5c:e9:1e:5b:39 on en1 ifscope [ethernet]
? (10.0.1.4) at b0:34:95:50:35:32 on en1 ifscope [ethernet]
? (10.0.1.5) at 84:38:35:68:77:b6 on en1 ifscope [ethernet]
? (10.0.1.10) at c4:57:6e:5b:7c:16 on en1 ifscope [ethernet]
? (10.0.1.12) at 82:9f:31:6:7e:6d on en1 ifscope [ethernet]
? (10.0.1.15) at 7c:87:ce:80:1:62 on en1 ifscope [ethernet]
? (10.0.1.23) at d0:27:88:72:45:7b on en1 ifscope [ethernet]
? (10.0.1.25) at 7c:c3:a1:a5:21:1b on en1 ifscope permanent [ethernet]
? (10.0.1.35) at 78:2:f8:fc:f0:dd on en0 ifscope [ethernet]
? (10.0.1.42) at 10:5b:ad:1b:6a:2d on en1 ifscope [ethernet]
? (10.0.1.255) at ff:ff:ff:ff:ff:ff on en1 ifscope [ethernet]
all-systems.mcast.net (224.0.0.1) at 1:0:5e:0:0:1 on en1 ifscope permanent [ethernet]
? (224.0.0.251) at 1:0:5e:0:0:fb on en1 ifscope permanent [ethernet]
? (225.255.255.255) at 1:0:5e:7f:ff:ff on en1 ifscope permanent [ethernet]
? (239.255.255.250) at 1:0:5e:7f:ff:fa on en1 ifscope permanent [ethernet]
broadcasthost (255.255.255.255) at ff:ff:ff:ff:ff:ff on en1 ifscope [ethernet]
````

Схема сети (не все устройства удалось идентифицировать — не помню сходу все, что подключено):

![LAN](images/LAN.png)