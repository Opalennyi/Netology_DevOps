## Задача 1

_Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume._

```bash
sergey.belov@Sergeys-Air ~ % docker pull mysql:8
8: Pulling from library/mysql
a4b007099961: Pull complete
e2b610d88fd9: Pull complete
38567843b438: Pull complete
5fc423bf9558: Pull complete
aa8241dfe828: Pull complete
cc662311610e: Pull complete
9832d1192cf2: Pull complete
f2aa1710465f: Pull complete
4a2d5722b8f3: Pull complete
3a246e8d7cac: Pull complete
2f834692d7cc: Pull complete
a37409568022: Pull complete
Digest: sha256:b2ae0f527005d99bacdf3a220958ed171e1eb0676377174f0323e0a10912408a
Status: Downloaded newer image for mysql:8
docker.io/library/mysql:8
sergey.belov@Sergeys-MacBook-Air ~ % docker run --name 06-db-03-mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=testdb --volume=/Users/sergey.belov/PycharmProjects/Netology_DevOps/06-db-03-mysql/mysql-files:/var/lib/mysql -d mysql:8
67a7cc825fac9bc23536bf67ab1b7b764827464df518d906bd8c028dfad74857
sergey.belov@Sergeys-MacBook-Air ~ % docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS        PORTS                 NAMES
67a7cc825fac   mysql:8   "docker-entrypoint.s…"   4 seconds ago   Up 1 second   3306/tcp, 33060/tcp   06-db-03-mysql
sergey.belov@Sergeys-MacBook-Air ~ % docker logs 67a7cc825fac
2022-04-03 12:59:31+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.28-1debian10 started.
2022-04-03 12:59:32+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2022-04-03 12:59:32+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.28-1debian10 started.
2022-04-03 12:59:32+00:00 [Note] [Entrypoint]: Initializing database files
2022-04-03T12:59:32.380384Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.28) initializing of server in progress as process 43
2022-04-03T12:59:32.423831Z 0 [Warning] [MY-010159] [Server] Setting lower_case_table_names=2 because file system for /var/lib/mysql/ is case insensitive
2022-04-03T12:59:32.459603Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Восстановимся из бэкапа, находящегося на хосте:

```bash
sergey.belov@Sergeys-MacBook-Air ~ % docker exec -i 67a7cc825fac mysql testdb < /Users/sergey.belov/PycharmProjects/Netology_DevOps/06-db-03-mysql/files/test_dump.sql
```

Перейдите в управляющую консоль `mysql` внутри контейнера.

```bash
sergey.belov@Sergeys-MacBook-Air ~ % docker exec -it 67a7cc825fac bash
root@67a7cc825fac:/# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Используя команду `\h` получите список управляющих команд.

```bash
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'
```

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```bash
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

<...>
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```mysql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| testdb             |
+--------------------+
5 rows in set (0.13 sec)

mysql> use testdb;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+------------------+
| Tables_in_testdb |
+------------------+
| orders           |
+------------------+
1 row in set (0.01 sec)
```

**Приведите в ответе** количество записей с `price` > 300.

```mysql
mysql> SELECT count(*) FROM orders WHERE price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.04 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```mysql
mysql> CREATE USER test@localhost
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"Name": "James", "Surname": "Pretty"}';
Query OK, 0 rows affected (0.62 sec)
```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
```mysql
mysql> GRANT SELECT ON testdb.* TO test@localhost;
Query OK, 0 rows affected, 1 warning (0.09 sec)

mysql> SHOW GRANTS FOR test@localhost;
+--------------------------------------------------+
| Grants for test@localhost                        |
+--------------------------------------------------+
| GRANT USAGE ON *.* TO `test`@`localhost`         |
| GRANT SELECT ON `testdb`.* TO `test`@`localhost` |
+--------------------------------------------------+
2 rows in set (0.02 sec)
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

```mysql
mysql> SELECT *
    -> FROM information_schema.user_attributes
    -> WHERE user = 'test';
+------+-----------+----------------------------------------+
| USER | HOST      | ATTRIBUTE                              |
+------+-----------+----------------------------------------+
| test | localhost | {"Name": "James", "Surname": "Pretty"} |
+------+-----------+----------------------------------------+
1 row in set (0.13 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

```mysql
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.05 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

<...>

mysql> SHOW PROFILES;
+----------+------------+------------------------------------------+
| Query_ID | Duration   | Query                                    |
+----------+------------+------------------------------------------+
|        1 | 0.30064550 | SHOW DATABASES                           |
|        2 | 0.37069375 | DESCRIBE orders                          |
|        3 | 0.01608275 | SELECT * FROM orders WHERE FIELD='title' |
|        4 | 0.00934525 | SELECT * FROM orders                     |
+----------+------------+------------------------------------------+
4 rows in set, 1 warning (0.01 sec)
```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```mysql
mysql> SELECT TABLE_NAME, ENGINE
    -> FROM information_schema.TABLES
    -> WHERE TABLE_SCHEMA = 'testdb';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.15 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```mysql
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (1.45 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'testdb';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | MyISAM |
+------------+--------+
1 row in set (0.01 sec)

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.36 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'testdb';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.01 sec)

mysql> SHOW PROFILES;
+----------+------------+----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                  |
+----------+------------+----------------------------------------------------------------------------------------+
|        1 | 0.30064550 | SHOW DATABASES                                                                         |
|        2 | 0.37069375 | DESCRIBE orders                                                                        |
|        3 | 0.01608275 | SELECT * FROM orders WHERE FIELD='title'                                               |
|        4 | 0.00934525 | SELECT * FROM orders                                                                   |
|        5 | 0.14672975 | SELECT TABLE_NAME, ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'testdb' |
|        6 | 1.44387450 | ALTER TABLE orders ENGINE = MyISAM                                                     |
|        7 | 0.00867075 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'testdb' |
|        8 | 0.35714100 | ALTER TABLE orders ENGINE = InnoDB                                                     |
|        9 | 0.01045100 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'testdb' |
+----------+------------+----------------------------------------------------------------------------------------+
9 rows in set, 1 warning (0.00 sec)
```

В выводе запроса нас интересуют строки 6 и 8. Изменение `engine` на MyISAM заняло 1.44387450 секунды, на InnoDB —  0.35714100 секунды.

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

```bash
root@67a7cc825fac:/# cat /etc/mysql/my.cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
```

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```bash
root@67a7cc825fac:/# cat /etc/mysql/my.cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL


#Setting default engine as InnoDB
default-storage-engine		= InnoDB

# Adding lines once a second; we can lose some data
innodb_flush_log_at_trx_commit	= 2

# Using tables compression
innodb_file_per_table		= ON

# Setting size of non-commited transactions
innodb_log_buffer_size		= 1M

# Setting cache buffer as 30 % of 4GB of RAM
innodb_buffer_pool_size		= 1.2G

# Setting log files size
innodb_log_file_size		= 100M


# Custom config should go here
!includedir /etc/mysql/conf.d/
```