## Задача 1

_Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы._

_Приведите получившуюся команду или docker-compose манифест._

```bash
Opalennyi-iMac-2:06-db-02-sql opalennyi$ docker pull postgres:12
12: Pulling from library/postgres
5eb5b503b376: Already exists
daa0467a6c48: Pull complete
7cf625de49ef: Pull complete
bb8afcc973b2: Pull complete
c74bf40d29ee: Pull complete
2ceaf201bb22: Pull complete
1255f255c0eb: Pull complete
12a9879c7aa1: Pull complete
f7ca80cc6dd3: Pull complete
6714db455645: Pull complete
ee4f5626bf60: Pull complete
621bb0c2ae77: Pull complete
a19e980f0a72: Pull complete
Digest: sha256:505d023f030cdea84a42d580c2a4a0e17bbb3e91c30b2aea9c02f2dfb10325ba
Status: Downloaded newer image for postgres:12
docker.io/library/postgres:12
Opalennyi-iMac-2:06-db-02-sql opalennyi$ docker run --rm --name 06-db-02-sql -p 5432:5432 -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=mysecretpassword -d postgres:12
43b34e6127edb8fc8d364010f751fb7aeb30221c11953a9da07fb99fabde205b
Opalennyi-iMac-2:06-db-02-sql opalennyi$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                    NAMES
43b34e6127ed   postgres:12   "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds   0.0.0.0:5432->5432/tcp   06-db-02-sql
Opalennyi-iMac-2:06-db-02-sql opalennyi$ sudo docker exec -it 06-db-02-sql psql -U test-admin-user
Password:
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

test-admin-user=#
```

## Задача 2

_В БД из задачи 1:_ 
- _создайте пользователя test-admin-user и БД test_db_
- _в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)_
- _предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db_
- _создайте пользователя test-simple-user_  
- _предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db_

_Таблица orders:_
- _id (serial primary key)_
- _наименование (string)_
- _цена (integer)_

_Таблица clients:_
- _id (serial primary key)_
- _фамилия (string)_
- _страна проживания (string, index)_
- _заказ (foreign key orders)_

_Приведите:_
- _итоговый список БД после выполнения пунктов выше,_

```sql
test_db=# \dt
              List of relations
 Schema  |  Name   | Type  |      Owner
---------+---------+-------+-----------------
 test_db | clients | table | test-admin-user
 test_db | orders  | table | test-admin-user
(2 rows)
```

- _описание таблиц (describe)_

```sql
test_db=# \d orders
                                   Table "test_db.orders"
 Column |          Type          | Collation | Nullable |              Default
--------+------------------------+-----------+----------+------------------------------------
 id     | integer                |           | not null | nextval('orders_id_seq'::regclass)
 name   | character varying(100) |           |          |
 price  | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
    
test_db=# \d clients
                                    Table "test_db.clients"
  Column  |         Type          | Collation | Nullable |               Default
----------+-----------------------+-----------+----------+-------------------------------------
 id       | integer               |           | not null | nextval('clients_id_seq'::regclass)
 surname  | character varying(50) |           |          |
 country  | character varying(35) |           |          |
 order_id | integer               |           |          |
Indexes:
    "country_index" hash (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
```

- _SQL-запрос для выдачи списка пользователей с правами над таблицами test_db_

```sql
SELECT grantee, table_name, privilege_type FROM information_schema.role_table_grants WHERE table_schema='test_db';
```

- _список пользователей с правами над таблицами test_db_

```sql
test_db=# SELECT grantee, table_name, privilege_type FROM information_schema.role_table_grants WHERE table_schema='test_db';
     grantee      | table_name | privilege_type
------------------+------------+----------------
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | UPDATE
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | TRIGGER
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | DELETE
(22 rows)
```

Аналогичного результата мы можем добиться командой `\dp` psql:

```sql
test_db=# \dp
                                                Access privileges
 Schema  |      Name      |   Type   |              Access privileges              | Column privileges | Policies
---------+----------------+----------+---------------------------------------------+-------------------+----------
 test_db | clients        | table    | "test-admin-user"=arwdDxt/"test-admin-user"+|                   |
         |                |          | "test-simple-user"=arwd/"test-admin-user"   |                   |
 test_db | clients_id_seq | sequence |                                             |                   |
 test_db | orders         | table    | "test-admin-user"=arwdDxt/"test-admin-user"+|                   |
         |                |          | "test-simple-user"=arwd/"test-admin-user"   |                   |
 test_db | orders_id_seq  | sequence |                                             |                   |
(4 rows)
```

Но для использования команды `\dp` psql-интерфейса предварительно была переопределена переменная `search_path`.

**Полный листинг действий:**
```sql
test-admin-user=# CREATE DATABASE test_db;
CREATE DATABASE
test-admin-user=# \connect test_db;
You are now connected to database "test_db" as user "test-admin-user".
test_db=# CREATE SCHEMA test_db;
CREATE SCHEMA
test_db=# CREATE TABLE test_db.orders (id SERIAL PRIMARY KEY, name VARCHAR(100), price INT);
CREATE TABLE
test_db=# CREATE TABLE test_db.clients (id SERIAL, surname VARCHAR(50), country VARCHAR(35), order_id INT, FOREIGN KEY (order_id) REFERENCES test_db.orders(id));
CREATE TABLE
test_db=# CREATE INDEX country_index ON test_db.clients USING hash (country);
CREATE INDEX

test_db=# \dt
Did not find any relations.
test_db=# SHOW search_path;
   search_path
-----------------
 "$user", public
(1 row)

test_db=# SET search_path TO test_db, public;
SET

test_db=# \dt
              List of relations
 Schema  |  Name   | Type  |      Owner
---------+---------+-------+-----------------
 test_db | clients | table | test-admin-user
 test_db | orders  | table | test-admin-user
(2 rows)

test_db=# \dp
                                   Access privileges
 Schema  |      Name      |   Type   | Access privileges | Column privileges | Policies
---------+----------------+----------+-------------------+-------------------+----------
 test_db | clients        | table    |                   |                   |
 test_db | clients_id_seq | sequence |                   |                   |
 test_db | orders         | table    |                   |                   |
 test_db | orders_id_seq  | sequence |                   |                   |
(4 rows)

test_db=# GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";
GRANT
test_db=# GRANT ALL ON TABLE test_db.clients TO "test-admin-user";
GRANT
test_db=# GRANT ALL ON TABLE test_db.orders TO "test-admin-user";
GRANT
test_db=# \dp
                                                Access privileges
 Schema  |      Name      |   Type   |              Access privileges              | Column privileges | Policies
---------+----------------+----------+---------------------------------------------+-------------------+----------
 test_db | clients        | table    | "test-admin-user"=arwdDxt/"test-admin-user" |                   |
 test_db | clients_id_seq | sequence |                                             |                   |
 test_db | orders         | table    | "test-admin-user"=arwdDxt/"test-admin-user" |                   |
 test_db | orders_id_seq  | sequence |                                             |                   |
(4 rows)

test_db=# CREATE USER "test-simple-user";
CREATE ROLE
test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA test_db TO "test-simple-user";
GRANT

test_db=# \dp
                                                Access privileges
 Schema  |      Name      |   Type   |              Access privileges              | Column privileges | Policies
---------+----------------+----------+---------------------------------------------+-------------------+----------
 test_db | clients        | table    | "test-admin-user"=arwdDxt/"test-admin-user"+|                   |
         |                |          | "test-simple-user"=arwd/"test-admin-user"   |                   |
 test_db | clients_id_seq | sequence |                                             |                   |
 test_db | orders         | table    | "test-admin-user"=arwdDxt/"test-admin-user"+|                   |
         |                |          | "test-simple-user"=arwd/"test-admin-user"   |                   |
 test_db | orders_id_seq  | sequence |                                             |                   |
(4 rows)
```

## Задача 3

_Используя SQL синтаксис, наполните таблицы следующими тестовыми данными:_

_Таблица orders_

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

_Таблица clients_

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

_Используя SQL синтаксис:_
- _вычислите количество записей для каждой таблицы_ 
- _приведите в ответе:_
    - _запросы_ 
    - _результаты их выполнения._

Запросы для вычисления количества записей в таблицах:
```sql
test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)
```

**Полный листинг действий:**
```sql
test_db=# INSERT INTO orders (name, price) VALUES ('Шоколад', 10);
INSERT 0 1
test_db=# INSERT INTO orders (name, price) VALUES ('Принтер', 3000);
INSERT 0 1
test_db=# INSERT INTO orders (name, price) VALUES ('Книга', 500);
INSERT 0 1
test_db=# INSERT INTO orders (name, price) VALUES ('Монитор', 7000);
INSERT 0 1
test_db=# INSERT INTO orders (name, price) VALUES ('Гитара', 4000);
INSERT 0 1
test_db=# SELECT * from test_db.orders;
 id |  name   | price
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_db=# INSERT INTO clients (surname, country) VALUES ('Иванов Иван Иванович', 'USA');
INSERT 0 1
test_db=# INSERT INTO clients (surname, country) VALUES ('Петров Петр Петрович', 'Canada');
INSERT 0 1
test_db=# INSERT INTO clients (surname, country) VALUES ('Иоганн Себастьян Бах', 'Japan');
INSERT 0 1
test_db=# INSERT INTO clients (surname, country) VALUES ('Ронни Джеймс Дио', 'Russia');
INSERT 0 1
test_db=# INSERT INTO clients (surname, country) VALUES ('Ritchie Blackmore', 'Russia');
INSERT 0 1
test_db=# SELECT * from test_db.clients;
 id |       surname        | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)
```

## Задача 4

_Часть пользователей из таблицы clients решили оформить заказы из таблицы orders._

_Используя foreign keys свяжите записи из таблиц, согласно таблице:_

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

_Приведите SQL-запросы для выполнения данных операций._

```sql
test_db=# UPDATE clients SET order_id=(SELECT id FROM orders WHERE name='Книга') WHERE surname='Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET order_id=(SELECT id FROM orders WHERE name='Монитор') WHERE surname='Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET order_id=(SELECT id FROM orders WHERE name='Гитара') WHERE surname='Иоганн Себастьян Бах';
UPDATE 1

test_db=# SELECT * from test_db.clients ORDER BY id;
 id |       surname        | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)
```

_Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса._

```sql
test_db=# SELECT * from clients WHERE order_id IS NOT NULL ORDER BY id;
 id |       surname        | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(3 rows)
```

_Подсказка - используйте директиву `UPDATE`._

## Задача 5

_Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN)._

_Приведите получившийся результат и объясните что значат полученные значения._

```sql
test_db=# EXPLAIN SELECT * from clients WHERE order_id IS NOT NULL ORDER BY id;
                            QUERY PLAN
------------------------------------------------------------------
 Sort  (cost=27.01..27.83 rows=328 width=214)
   Sort Key: id
   ->  Seq Scan on clients  (cost=0.00..13.30 rows=328 width=214)
         Filter: (order_id IS NOT NULL)
(4 rows)
```

Планировщиком будет произведена сортировка — `Sort`.

`cost`:
* первое число — приблизительная стоимость запуска; время, которое проходит, прежде чем начнётся этап вывода данных;
* второе число — приблизительная общая стоимость выполнения запроса при условии его полного выполнения.

`rows` — ожидаемое число строк, которое будет выведено при выполнении плана до конца.

`width` — ожидаемые средний размер строк в байтах, выводимых этим запросом.

`Sort Key` — параметр, по которому сортируется вывод (в запросе задана сортировка `ORDER BY id`, планировщик сначала сортирует все данные по этому параметру).

Затем происходит простое последовательное сканирование (`Seq Scan`) по таблице `clients`.

Сканирование происходит с условием, происходит фильтрация (`Filter`) по условию `order_id IS NOT NULL`.