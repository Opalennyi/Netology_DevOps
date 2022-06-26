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
eb06745bb927: Pushed
33d35b6b1f7b: Layer already exists
03fa23cc689d: Layer already exists
37cc07dfaaa7: Pushed
99f692f45359: Pushed
174f56854903: Layer already exists
latest: digest: sha256:a628ec66b67f8e443b855dc6adec11e824f01c87b886b67f522b7a3a31f1f734 size: 1584
```

Образ в репозитории dockerhub: https://hub.docker.com/repository/docker/opalennyi/elasticsearch-m1

Запустим контейнер с собранным образом и запросим путь `/`:
```bash
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker run --name 06-db-05-elasticsearch --platform linux/amd64 -e container_name=netology_elasticsearch -p 9200:9200 -p 9300:9300 -d opalennyi/elasticsearch-m1
934fa0806d646a465e1364d0b1ae85710c854e9ab8a5fd982f001bbf2dd5e3c7
sergey.belov@Try-Goose-Grass-MacBook-Pro docker % docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS         PORTS                                            NAMES
934fa0806d64   opalennyi/elasticsearch-m1   "/elasticsearch-8.2.…"   6 seconds ago   Up 5 seconds   0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp   06-db-05-elasticsearch

```