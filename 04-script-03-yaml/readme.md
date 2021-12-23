## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
  
***

Исправленная версия:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import json
import yaml

list_of_sites = ('drive.google.com', 'mail.google.com', 'google.com')
last_check = {}  # Объявляем dict для хранения данных последней проверки

# Подготовим массив для хранения данных последней проверки
for site in list_of_sites:
    last_check[site] = '-1.-1.-1.-1'

for site in list_of_sites:
    ip = socket.gethostbyname(site)
    print(site + " - " + ip)
    # Поскольку по условиям задачи мы знаем, что нет балансировки,
    # можем считать, что у одного адреса один IP.
    if last_check[site] == '-1.-1.-1.-1':
        # Если это первый запуск скрипта, просто записываем IP-адрес
        last_check[site] = ip
    else:
        if last_check[site] != ip:
            print('[ERROR] ' + site + 'IP mismatch: ' + last_check[site] + ' ' + ip)
            last_check[site] = ip

with open("ips.json", "w") as ipsjson:
    ipsjson.write(json.dumps(last_check))

with open("ips.yml", "w") as ipsyml:
    ipsyml.write(yaml.dump(last_check, explicit_start=True, explicit_end=True))

print("\nAll data have been successfully written into ips.json and ips.yml\n")
```

### Вывод скрипта при запуске при тестировании:
```
Opalennyi-iMac-2:04-script-03-yaml opalennyi$ python3 http_2.py
drive.google.com - 64.233.164.194
mail.google.com - 209.85.233.83
google.com - 74.125.131.139

All data have been successfully written into ips.json and ips.yml
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "64.233.164.194", "mail.google.com": "209.85.233.83", "google.com": "74.125.131.139"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 64.233.164.194
google.com: 74.125.131.139
mail.google.com: 209.85.233.83
...

```
