#### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

````bash
Opalennyi-iMac-2:03-sysadmin-01-terminal opalennyi$ vagrant ssh netology1
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
<...>
vagrant@netology1:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86286sec preferred_lft 86286sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:fd:12:36 brd ff:ff:ff:ff:ff:ff
    inet 172.28.128.10/24 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fefd:1236/64 scope link
       valid_lft forever preferred_lft forever
````

#### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

Для выполнения этого задания было необходимо поднять все три виртуальные машины, которые указаны в новом `vagrantfile`: netology1, netology2 и netology3.

Для всех трех машин нужно было выполнить `sudo apt-get update`, `sudo apt-get upgrade`, после чего установить пакет `lldp` и выполнить команду `sudo systemctl enable lldpd && systemctl start lldpd` на каждой из трех машин.

````bash
vagrant@netology1:~$ sudo lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 00:01:00
  Chassis:
    ChassisID:    mac 08:00:27:73:60:cf
    SysName:      netology3
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fe73:60cf
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:cf:55:b2
    PortDescr:    eth1
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 00:00:59
  Chassis:
    ChassisID:    mac 08:00:27:73:60:cf
    SysName:      netology3
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fe73:60cf
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:7f:d7:18
    PortDescr:    eth1
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
````

Но этого вывода мне удалось добиться только один раз и только с `netology3`, при этом в какой-то момент системное имя изменилось на `vagrant.vm`.

````bash
vagrant@vagrant:~$ sudo lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 00:00:54
  Chassis:
    ChassisID:    mac 08:00:27:73:60:cf
    SysName:      vagrant.vm
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fe73:60cf
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:7f:d7:18
    PortDescr:    eth1
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 00:00:50
  Chassis:
    ChassisID:    mac 08:00:27:73:60:cf
    SysName:      vagrant.vm
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fe73:60cf
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:cf:55:b2
    PortDescr:    eth1
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
````

#### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

Это технология VLAN. В Linux есть пакет `vlan`.

Для настройки VLAN в Ubuntu необходимо отредактировать файл `/etc/network/interfaces` — так информация о созданных виртуальных сетях сохранится после перезагрузки.

````bash
vagrant@vagrant:~$ sudo nano /etc/network/interfaces
vagrant@vagrant:~$ sudo cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d
auto eth0.1400
iface eth0.1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
vagrant@vagrant:~$
````

Но это можно сделать и через `vconfig`:  
`vagrant@vagrant:~$ sudo ifconfig eth0.2 192.168.1.2 netmask 255.255.255.0 up`


До перезагрузки:
````bash
vagrant@vagrant:~$ ls /proc/net/vlan
config  eth0.2
vagrant@vagrant:~$ sudo cat /proc/net/vlan/config
VLAN Dev name	 | VLAN ID
Name-Type: VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD
eth0.2         | 2  | eth0
vagrant@vagrant:~$ sudo cat /proc/net/vlan/eth0.2
eth0.2  VID: 2	 REORDER_HDR: 1  dev->priv_flags: 1021
         total frames received            0
          total bytes received            0
      Broadcast/Multicast Rcvd            0

      total frames transmitted            9
       total bytes transmitted          726
Device: eth0
INGRESS priority mappings: 0:0  1:0  2:0  3:0  4:0  5:0  6:0 7:0
 EGRESS priority mappings:
````

После перезагрузки удаляется созданный локально `eth0.2`, зато запускается скрипт, обрабатывающий `/proc/net/vlan/config`:
````bash
vagrant@vagrant:~$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
Connection to 127.0.0.1 closed.
Opalennyi-iMac-2:03-sysadmin-01-terminal opalennyi$ vagrant ssh netology1
vagrant@vagrant:~$ ls /proc/net/vlan
config  eth0.1400
vagrant@vagrant:~$ sudo cat /proc/net/vlan/config
VLAN Dev name	 | VLAN ID
Name-Type: VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD
eth0.1400      | 1400  | eth0
vagrant@vagrant:~$ sudo cat /proc/net/vlan/eth0.1400
eth0.1400  VID: 1400	 REORDER_HDR: 1  dev->priv_flags: 1021
         total frames received            0
          total bytes received            0
      Broadcast/Multicast Rcvd            0

      total frames transmitted           11
       total bytes transmitted          866
Device: eth0
INGRESS priority mappings: 0:0  1:0  2:0  3:0  4:0  5:0  6:0 7:0
 EGRESS priority mappings:
````

#### 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

Всего 8 адресов, но доступных для использования — 6.
````bash
vagrant@vagrant:~$ ipcalc 192.168.1.1/29
Address:   192.168.1.1          11000000.10101000.00000001.00000 001
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   192.168.1.0/29       11000000.10101000.00000001.00000 000
HostMin:   192.168.1.1          11000000.10101000.00000001.00000 001
HostMax:   192.168.1.6          11000000.10101000.00000001.00000 110
Broadcast: 192.168.1.7          11000000.10101000.00000001.00000 111
Hosts/Net: 6                     Class C, Private Internet
````

Доступные адреса — от 192.168.1.1 до 192.168.1.6.

В 29-тибитной подсети 24-хбитной сети мы "заимствуем" 5 бит идентификатора хоста, что дает нам 2 ^ 5 = 32 подсети. В каждой подсети может быть не больше 2 ^ 3 - 2 = 6 хостов.

Сеть выглядит так:
````bash
vagrant@vagrant:~$ ipcalc 10.10.10.0/24
Address:   10.10.10.0           00001010.00001010.00001010. 00000000
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
Hosts/Net: 254                   Class A, Private Internet
````

Мы можем задать, например, подсети `00001010.00001010.00001010.01100 000`, `00001010.00001010.00001010.10010 000`, `00001010.00001010.00001010.00101 000`. 

#### 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

Судя по презентации, мы можем использовать подсеть 100.64.0.0/10. Поскольку нам не нужно больше 40–50 хостов в подсети, нам нужно иметь 6 бит для номера хоста (2 ^ 6 = 64 хоста максимум, иначе 2 ^ 5 = 32, этого нам мало).

Таким образом, мы можем использовать подсеть 100.64.0.0/26.

#### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

В Linux:
````bash
vagrant@vagrant:~$ arp -vne
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0
10.0.2.3                 ether   52:54:00:12:35:03   C                     eth0
Entries: 2	Skipped: 0	Found: 2
````

В Windows: `arp -a`.

Чтобы удалить одну запись:
````bash
vagrant@vagrant:~$ sudo arp -d 10.0.2.3
vagrant@vagrant:~$ arp -vne
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0
Entries: 1	Skipped: 0	Found: 1
````

Чтобы очистить всю таблицу:
````bash
vagrant@vagrant:~$ arp -vne
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0
10.0.2.3                 ether   52:54:00:12:35:03   C                     eth0
Entries: 2	Skipped: 0	Found: 2
vagrant@vagrant:~$ sudo ip -s -s neigh flush all
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 ref 1 used 20/0/20 probes 4 REACHABLE
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 ref 1 used 16/11/11 probes 1 REACHABLE

*** Round 1, deleting 2 entries ***
*** Flush is complete after 1 round ***
vagrant@vagrant:~$ arp -vne
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0
Entries: 1	Skipped: 0	Found: 1
````

Двойное использование ключа `-s` позволяет нам получить больше информации в выводе.