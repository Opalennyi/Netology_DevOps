#### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Да, могут, потому что один файл может иметь несколько жестких ссылок, и в таком случае, цитируя Википедию:
>"он будет фигурировать на диске одновременно в различных каталогах или под различными именами в одном каталоге".

Если по какой-то причине нам нужно, чтобы из различных каталогов доступ был по-разному разграничен или при обращении по разным именам (этот кейс разбирали на лекции) у файла были разные права доступа, это возможно реализовать.

#### 3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим: <...>

````bash
Opalennyi-iMac-2:03-sysadmin-01-terminal opalennyi$ cat vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
````

#### 4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

````bash
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x7d00c228.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x7d00c228

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-5242879, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2048M

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

vagrant@vagrant:~$ sudo fdisk -l
<...>
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x7d00c228

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
````

#### 5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

````bash
vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x7d00c228.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x7d00c228

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
````

#### 6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

````bash
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 --level=raid1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.

vagrant@vagrant:~$ sudo fdisk -l
<...>
Disk /dev/md1: 1.102 GiB, 2144337920 bytes, 4188160 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

vagrant@vagrant:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
````

#### 7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

````bash
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 --level=raid0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

vagrant@vagrant:~$ sudo fdisk -l
<...>
Disk /dev/md0: 1018 MiB, 1067450368 bytes, 2084864 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 524288 bytes / 1048576 bytes

vagrant@vagrant:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
````

#### 8. Создайте 2 независимых PV на получившихся md-устройствах.

````bash
vagrant@vagrant:~$ sudo pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
vagrant@vagrant:~$ sudo pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
````

#### 9. Создайте общую volume-group на этих двух PV.

````bash
vagrant@vagrant:~$ sudo vgcreate netology-devops-volume-group /dev/md0 /dev/md1
  Volume group "netology-devops-volume-group" successfully created
````

#### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

````bash
vagrant@vagrant:~$ sudo lvcreate --size 100M --name LV-netology-devops netology-devops-volume-group /dev/md0
  Logical volume "LV-netology-devops" created.
````

#### 11. Создайте `mkfs.ext4` ФС на получившемся LV.

````bash
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/netology-devops-volume-group/LV-netology-devops
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
````

#### 12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

````bash
vagrant@vagrant:~$ sudo mkdir -v /tmp/new
mkdir: created directory '/tmp/new'
vagrant@vagrant:~$ sudo mount --verbose /dev/netology-devops-volume-group/LV-netology-devops /tmp/new
mount: /dev/mapper/netology--devops--volume--group-LV--netology--devops mounted on /tmp/new.
````

#### 13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

````bash
vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-12-02 22:47:38--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22715138 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                                  100%[=============================================================================================================>]  21.66M  5.01MB/s    in 4.6s

2021-12-02 22:47:43 (4.67 MB/s) - ‘/tmp/new/test.gz’ saved [22715138/22715138]
````

#### 14. Прикрепите вывод `lsblk`.

````bash
vagrant@vagrant:~$ lsblk
NAME                                                       MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                                                          8:0    0   64G  0 disk
├─sda1                                                       8:1    0  512M  0 part  /boot/efi
├─sda2                                                       8:2    0    1K  0 part
└─sda5                                                       8:5    0 63.5G  0 part
  ├─vgvagrant-root                                         253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1                                       253:1    0  980M  0 lvm   [SWAP]
sdb                                                          8:16   0  2.5G  0 disk
├─sdb1                                                       8:17   0    2G  0 part
│ └─md1                                                      9:1    0    2G  0 raid1
└─sdb2                                                       8:18   0  511M  0 part
  └─md0                                                      9:0    0 1018M  0 raid0
    └─netology--devops--volume--group-LV--netology--devops 253:2    0  100M  0 lvm   /tmp/new
sdc                                                          8:32   0  2.5G  0 disk
├─sdc1                                                       8:33   0    2G  0 part
│ └─md1                                                      9:1    0    2G  0 raid1
└─sdc2                                                       8:34   0  511M  0 part
  └─md0                                                      9:0    0 1018M  0 raid0
    └─netology--devops--volume--group-LV--netology--devops 253:2    0  100M  0 lvm   /tmp/new
````

#### 15. Протестируйте целостность файла.

````bash
vagrant@vagrant:~$ sudo gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
````

#### 16. Используя `pvmove`, переместите содержимое PV с RAID0 на RAID1.

````bash
vagrant@vagrant:~$ sudo pvmove /dev/md0 /dev/md1
  /dev/md0: Moved: 8.00%
  /dev/md0: Moved: 100.00%
  
vagrant@vagrant:~$ lsblk
NAME                                                       MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                                                          8:0    0   64G  0 disk
├─sda1                                                       8:1    0  512M  0 part  /boot/efi
├─sda2                                                       8:2    0    1K  0 part
└─sda5                                                       8:5    0 63.5G  0 part
  ├─vgvagrant-root                                         253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1                                       253:1    0  980M  0 lvm   [SWAP]
sdb                                                          8:16   0  2.5G  0 disk
├─sdb1                                                       8:17   0    2G  0 part
│ └─md1                                                      9:1    0    2G  0 raid1
│   └─netology--devops--volume--group-LV--netology--devops 253:2    0  100M  0 lvm   /tmp/new
└─sdb2                                                       8:18   0  511M  0 part
  └─md0                                                      9:0    0 1018M  0 raid0
sdc                                                          8:32   0  2.5G  0 disk
├─sdc1                                                       8:33   0    2G  0 part
│ └─md1                                                      9:1    0    2G  0 raid1
│   └─netology--devops--volume--group-LV--netology--devops 253:2    0  100M  0 lvm   /tmp/new
└─sdc2                                                       8:34   0  511M  0 part
  └─md0                                                      9:0    0 1018M  0 raid0
````

#### 17. Сделайте `--fail` на устройство в вашем RAID1 md.

````bash
vagrant@vagrant:~$ sudo mdadm --fail /dev/md1 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1

vagrant@vagrant:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1] sdb1[0](F)
      2094080 blocks super 1.2 [2/1] [_U]

unused devices: <none>
````

#### 18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

````bash
[ 3647.737440] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
````

#### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен.

````bash
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
````

#### 20. Погасите тестовый хост, `vagrant destroy`.

````bash
vagrant@vagrant:~$ exit
logout
Connection to 127.0.0.1 closed.
Opalennyi-iMac-2:03-sysadmin-01-terminal opalennyi$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
````