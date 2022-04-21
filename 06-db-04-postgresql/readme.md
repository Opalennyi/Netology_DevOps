## Задача 1

_Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume._

```bash
sergey.belov@Sergeys-MacBook-Air ~ % docker pull postgres:13
13: Pulling from library/postgres
c229119241af: Pull complete
3ff4ca332580: Pull complete
5037f3c12de6: Pull complete
0444ef779945: Pull complete
47098a4166e7: Pull complete
203cca980fab: Pull complete
a479b6c0e001: Pull complete
1eaa9abe8ca4: Pull complete
113f50383ee6: Pull complete
2abdc4f6d216: Pull complete
208ab7ebe2d3: Pull complete
0695aa3abf50: Pull complete
ba6456490b54: Pull complete
Digest: sha256:43568014f86275fd51992b9c8a6cf528d3acb6da8bcabfac04ed5abecb56a1c1
Status: Downloaded newer image for postgres:13
docker.io/library/postgres:13

sergey.belov@Sergeys-MacBook-Air ~ % docker run --name 06-db-04-postgresql -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DB=testdb --volume=/Users/sergey.belov/PycharmProjects/Netology_DevOps/06-db-04-postgresql/postgresql-files:/var/lib/postgresql -d postgres:13
9bc364bd2844078dcaedd8568617282ecb18c2ea68a77340dc38cfce6e022ad1
sergey.belov@Sergeys-MacBook-Air ~ % docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS      NAMES
9bc364bd2844   postgres:13   "docker-entrypoint.s…"   20 seconds ago   Up 14 seconds   5432/tcp   06-db-04-postgresql
sergey.belov@Sergeys-MacBook-Air ~ % docker logs 9bc364bd2844
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.utf8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/data ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... Etc/UTC
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok


Success. You can now start the database server using:

    pg_ctl -D /var/lib/postgresql/data -l logfile start

initdb: warning: enabling "trust" authentication for local connections
You can change this by editing pg_hba.conf or using the option -A, or
--auth-local and --auth-host, the next time you run initdb.
waiting for server to start....2022-04-06 19:21:01.242 UTC [49] LOG:  starting PostgreSQL 13.6 (Debian 13.6-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
2022-04-06 19:21:01.249 UTC [49] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2022-04-06 19:21:01.277 UTC [50] LOG:  database system was shut down at 2022-04-06 19:20:59 UTC
2022-04-06 19:21:01.306 UTC [49] LOG:  database system is ready to accept connections
 done
server started
CREATE DATABASE


/usr/local/bin/docker-entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*

waiting for server to shut down...2022-04-06 19:21:02.920 UTC [49] LOG:  received fast shutdown request
.2022-04-06 19:21:02.932 UTC [49] LOG:  aborting any active transactions
2022-04-06 19:21:02.938 UTC [49] LOG:  background worker "logical replication launcher" (PID 56) exited with exit code 1
2022-04-06 19:21:02.945 UTC [51] LOG:  shutting down
2022-04-06 19:21:03.092 UTC [49] LOG:  database system is shut down
 done
server stopped

PostgreSQL init process complete; ready for start up.

2022-04-06 19:21:03.254 UTC [1] LOG:  starting PostgreSQL 13.6 (Debian 13.6-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
2022-04-06 19:21:03.256 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2022-04-06 19:21:03.259 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2022-04-06 19:21:03.277 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2022-04-06 19:21:03.321 UTC [63] LOG:  database system was shut down at 2022-04-06 19:21:03 UTC
2022-04-06 19:21:03.340 UTC [1] LOG:  database system is ready to accept connections
```

_Подключитесь к БД PostgreSQL используя `psql`._

```bash
root@9bc364bd2844:/# psql
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  role "root" does not exist

root@9bc364bd2844:/# psql -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=#
```

_Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам._

_**Найдите и приведите** управляющие команды для:_
- _вывода списка БД_

```postgres
\l[+]   [PATTERN]      list databases
```

- _подключения к БД_

```postgres
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```

- _вывода списка таблиц_

```postgres
\dt[S+] [PATTERN]      list tables
```

- _вывода описания содержимого таблиц_

```postgres
\d[S+]  NAME           describe table, view, sequence, or index
```

- _выхода из psql_

```postgres
\q                     quit psql
```

## Задача 2

_Используя `psql` создайте БД `test_database`._

```postgres
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```postgres
root@9bc364bd2844:/# psql test_database < /var/lib/postgresql/test_dump.sql -U postgres
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```

П*ерейдите в управляющую консоль `psql` внутри контейнера.*

_Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице._

```postgres
test_database=# ANALYZE;
ANALYZE
```

_Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах._

Самый простой способ, как мне видится, такой:

```postgres
test_database=# SELECT attname, MAX(avg_width) FROM pg_stats WHERE tablename='orders' GROUP BY attname;
 attname | max
---------+-----
 id      |   4
 price   |   4
 title   |  16
(3 rows)
```

В этом случае мы получаем максимальное значение по каждой группе `attname`. После всего, что я прочитал на stackoverflow.com, я понимаю, что, в целом, это верный вывод запроса, потому что если в выводе будет несколько макимальных значений, в запросе не описано, как именно обрабатывать такие случаи.

Если все же необходимо придумать запрос, который бы обрабатывал случаи одинаковых значений для максимального значения и выводить тот столбец/те столбцы, у которого/которых максимально значение этого параметра, отправьте, пожалуйста, задание на доработку, я продолжу думать.

## Задача 3

_Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499)._

_Предложите SQL-транзакцию для проведения данной операции._

```SQL
BEGIN;

CREATE TABLE orders_1 (LIKE orders INCLUDING ALL);
ALTER TABLE orders_1 INHERIT orders;

CREATE TABLE orders_2 (LIKE orders INCLUDING ALL);
ALTER TABLE orders_2 INHERIT orders;

ALTER TABLE orders_1 ADD CONSTRAINT partition_check CHECK (price > 499);
ALTER TABLE orders_2 ADD CONSTRAINT partition_check CHECK (price <= 499);

COMMIT;
```

_Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?_

Да, можно; нужно воспользоваться [секционированием таблицы](https://postgrespro.ru/docs/postgresql/10/ddl-partitioning):

```SQL
CREATE TABLE orders (*описываем таблицу*) PARTITION BY RANGE (price);

CREATE TABLE orders_sub500 PARTITION OF orders
    FOR VALUES FROM (0) TO (500);
    
CREATE TABLE orders_500andabove PARTITION OF orders
    FOR VALUES FROM (500) TO (1000000);
```

Ручной вариант разбиения таблицы — это, условно говоря, старый метод секционирования, метод выше — новый, но должен быть объявлен при создании таблицы.

Мне не удалось найти, возможно ли создать секцию без правой границы лимита значений — судя по всему, нет.

## Задача 4

_Используя утилиту `pg_dump` создайте бекап БД `test_database`._

```postgresql
root@9bc364bd2844:/# pg_dump -U postgres test_database > /var/lib/postgresql/test_database.sql
root@9bc364bd2844:/# ls /var/lib/postgresql/
data  test_database.sql  test_dump.sql
root@9bc364bd2844:/# exit
exit
sergey.belov@Sergeys-MacBook-Air ~ % ls /Users/sergey.belov/PycharmProjects/Netology_DevOps/06-db-04-postgresql/postgresql-files
data			test_database.sql	test_dump.sql
```

_Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?_

Добавил бы ограничение UNIQUE на столбец.

```postgresql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```