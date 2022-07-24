## Задача 1

_Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:_

- _составьте Dockerfile-манифест для elasticsearch_
- _соберите docker-образ и сделайте `push` в ваш docker.io репозиторий_
- _запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины_

_Требования к `elasticsearch.yml`:_
- _данные `path` должны сохраняться в `/var/lib`_ 
- _имя ноды должно быть `netology_test`_

_В ответе приведите:_
- _текст Dockerfile манифеста_
- _ссылку на образ в репозитории dockerhub_
- _ответ `elasticsearch` на запрос пути `/` в json виде_

Для того чтобы собрать образ, используем [Dockerfile-манифест](docker/Dockerfile). В процессе формирования образа мы используем [файл с конфигурацией Elasticsearch](docker/elasticsearch.yml).

Из-за того, что Docker работает на MacBook'е с чипом M1, пришлось воспользоваться командой `buildx` и в явном виде указать платформу сборку, иначе в дальнейшем контейнер не запускался. 

```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker buildx build --platform linux/amd64 -t elasticsearch-m1 .
[+] Building 117.3s (11/11) FINISHED
<...>
 
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker image tag elasticsearch-m1 opalennyi/elasticsearch-m1
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker image push opalennyi/elasticsearch-m1
Using default tag: latest
The push refers to repository [docker.io/opalennyi/elasticsearch-m1]
Using default tag: latest
The push refers to repository [docker.io/opalennyi/elasticsearch-m1]
d4480076b1ec: Pushed
a8f8aab80fbd: Pushed
6a4af0e79b5d: Layer already exists
41315c65b4dc: Layer already exists
e9b388875e7f: Layer already exists
174f56854903: Layer already exists
latest: digest: sha256:7139fbd5e733ed93480d76fe62c202ead751fd97ed8265230c727372d3731ba3 size: 1584
```

Образ в репозитории dockerhub: https://hub.docker.com/r/opalennyi/elasticsearch-m1/

Запустим контейнер с собранным образом и запросим путь `/`:
```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker run --name 06-db-05-elasticsearch --platform linux/amd64 -e container_name=netology_elasticsearch -p 9200:9200 -p 9300:9300 -d opalennyi/elasticsearch-m1
71392a7e9b8cdf8bb104d84de10d5b420d5993209abc69eb4ae4c1cfc12f3043
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS         PORTS                                            NAMES
71392a7e9b8c   opalennyi/elasticsearch-m1   "/elasticsearch-8.2.…"   2 seconds ago   Up 2 seconds   0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp   06-db-05-elasticsearch
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker exec -it 71392a7e9b8c curl http://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "qBr7lCj4Q_eoUYw-vy2LyQ",
  "version" : {
    "number" : "8.2.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "b174af62e8dd9f4ac4d25875e9381ffe2b9282c5",
    "build_date" : "2022-04-20T10:35:10.180408517Z",
    "build_snapshot" : false,
    "lucene_version" : "9.1.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

_Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:_

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

_Получите список индексов и их статусов, используя API и **приведите в ответе** на задание._

```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker exec -it 71392a7e9b8c bash
[elasticsearch@71392a7e9b8c /]$ curl -X PUT "localhost:9200/my-index-1?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_replicas": 0,
>     "number_of_shards": 1
>   }
> },
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "my-index-1"
}
[elasticsearch@71392a7e9b8c /]$ curl -X PUT "localhost:9200/my-index-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_replicas": 1,
>     "number_of_shards": 2
>   }
> },
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "my-index-2"
}
[elasticsearch@71392a7e9b8c /]$ curl -X PUT "localhost:9200/my-index-3?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_replicas": 2,
>     "number_of_shards": 4
>   }
> },
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "my-index-3"
}
[elasticsearch@71392a7e9b8c /]$ curl -X GET "localhost:9200/_cat/indices/my-index-*"
yellow open my-index-2 FaO68istTAy8esIy6XIcSg 2 1 0 0 450b 450b
yellow open my-index-3 1RGWSFFLTcGB-Jw9TbWVaQ 4 2 0 0 900b 900b
green  open my-index-1 9nxEeSVxTomYL4q4y_F5Cw 1 0 0 0 225b 225b
```

_Получите состояние кластера `elasticsearch`, используя API._

```bash
[elasticsearch@71392a7e9b8c /]$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

_Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?_

Потому что в кластере всего одна нода, и если с ней что-то произойдет, мы потеряем данные. Такая конфигурация не устойчива к ошибкам.

```bash
[elasticsearch@71392a7e9b8c /]$ curl -X DELETE "localhost:9200/my-index-1?pretty"
{
  "acknowledged" : true
}
[elasticsearch@71392a7e9b8c /]$ curl -X DELETE "localhost:9200/my-index-2?pretty"
{
  "acknowledged" : true
}
[elasticsearch@71392a7e9b8c /]$ curl -X DELETE "localhost:9200/my-index-3?pretty"
{
  "acknowledged" : true
}
```

## Задача 3

_Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`._

```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker exec -it 71392a7e9b8c mkdir /elasticsearch-8.2.0/snapshots
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker exec -it 71392a7e9b8c bash -c 'echo "path.repo: [ /elasticsearch-8.2.0/snapshots ]" >> /elasticsearch-8.2.0/config/elasticsearch.yml'
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker restart 71392a7e9b8c
71392a7e9b8c
```

_Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`._

```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker exec -it 71392a7e9b8c curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-8.2.0/snapshots"
  }
}
{
  "acknowledged" : true
}
'
{
  "acknowledged" : true
}
```

_**Приведите в ответе** запрос API и результат вызова API для создания репозитория._

```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker exec -it 71392a7e9b8c curl -X GET "localhost:9200/_snapshot/netology_backup?pretty"
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-8.2.0/snapshots"
    }
  }
}
```

_Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов._

```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker exec -it 71392a7e9b8c bash
[elasticsearch@71392a7e9b8c /]$ curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_replicas": 0,
>     "number_of_shards": 1
>   }
> },
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
[elasticsearch@71392a7e9b8c /]$ curl -X GET localhost:9200/_cat/indices?v=true
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  yzBhvdVWRu2J9x25izICmw   1   0          0            0       225b           225b
```

_[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`._

_**Приведите в ответе** список файлов в директории со `snapshot`ами._

```bash
[elasticsearch@71392a7e9b8c /]$ curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot1?pretty"
{
  "accepted" : true
}
[elasticsearch@71392a7e9b8c /]$ ls -la /elasticsearch-8.2.0/snapshots
total 48
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Jul 24 21:18 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Jul 24 19:40 ..
-rw-r--r-- 1 elasticsearch elasticsearch   842 Jul 24 21:18 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jul 24 21:18 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Jul 24 21:18 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18291 Jul 24 21:18 meta-cydJDfzKToGfDE8viH9rlQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   351 Jul 24 21:18 snap-cydJDfzKToGfDE8viH9rlQ.dat
```

_Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов._

```bash
[elasticsearch@71392a7e9b8c /]$ curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}
[elasticsearch@71392a7e9b8c /]$ curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_replicas": 0,
>     "number_of_shards": 1
>   }
> },
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
[elasticsearch@71392a7e9b8c /]$ curl -X GET localhost:9200/_cat/indices?v=true
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 xHCxM7RKS7Cmfotg7AMU6g   1   0          0            0       225b           225b
```

_[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее._ 

_**Приведите в ответе** запрос к API восстановления и итоговый список индексов._

```bash
[elasticsearch@71392a7e9b8c /]$ curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot1/_restore?pretty" -H 'Content-Type: application/json' -d'
> {
>   "indices": "*",
>   "include_global_state": true
> }
> {
>   "acknowledged" : true
> }
> '
{
  "accepted" : true
}

[elasticsearch@71392a7e9b8c /]$ curl -X GET localhost:9200/_cat/indices?v=true
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 xHCxM7RKS7Cmfotg7AMU6g   1   0          0            0       225b           225b
green  open   test   1BgGz388QtqjuPE_noZ0tQ   1   0          0            0       225b           225b
```