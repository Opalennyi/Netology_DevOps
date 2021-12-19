#### 1. Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```
* **Какое значение будет присвоено переменной c?**

В текущем виде, никакое — мы получим ошибку, потому что невозможно сложить целочисленную переменную и строку.

* **Как получить для переменной c значение 12?**

`c = str(a) + b`

* **Как получить для переменной c значение 3?**

`c = a + int(b)`

#### 2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

Модифицированный скрипт (файл `git1.py`):

```python
#!/usr/bin/env python3

import os

directory = "~/PycharmProjects/Netology_DevOps/" # Изменил директорию в задании на директорию, где у меня все лежит
bash_command = ["cd " + directory, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
print("Files have been modified:") # Немного модифицируем/добавляем визуализацию вывода
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        # Узнаем настоящий путь до измененных файлов при помощи realpath, даже если в directory у нас относительный путь
        bash_command_modified = "realpath " + directory + result.replace('\tmodified:   ', '')
        prepare_result = os.popen(bash_command_modified).read()
        # Визуально модифицируем вывод — иначе слишком большие отступы
        prepare_result = prepare_result.replace('\n', '')
        print(prepare_result)
```

#### 3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

Файл `git2.py`:
```python
#!/usr/bin/env python3

import os

print("Please enter the path to the directory to work with: ")
directory = input()
print("\nYou have chosen directory " + directory + "\n") # Подтверждаем, что мы правильно приняли директорию

bash_command = ["cd " + directory, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
print("Files have been modified:") # Немного модифицируем/добавляем визуализацию вывода
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        # Узнаем настоящий путь до измененных файлов при помощи realpath, даже если в directory у нас относительный путь
        bash_command_modified = "realpath " + directory + result.replace('\tmodified:   ', '')
        prepare_result = os.popen(bash_command_modified).read()
        # Визуально модифицируем вывод — иначе слишком большие отступы
        prepare_result = prepare_result.replace('\n', '')
        print(prepare_result)
```

Если же мы хотим передавать директорию для работы как аргумент в консоли, а не вводить вручную, скрипт будет таким (файл `git3.py`):
```python
#!/usr/bin/env python3

import os
import sys

directory = sys.argv[1]
print("\nYou have chosen directory " + directory + "\n") # Подтверждаем, что мы правильно приняли директорию

bash_command = ["cd " + directory, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
print("Files have been modified:") # Немного модифицируем/добавляем визуализацию вывода
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        # Узнаем настоящий путь до измененных файлов при помощи realpath, даже если в directory у нас относительный путь
        bash_command_modified = "realpath " + directory + result.replace('\tmodified:   ', '')
        prepare_result = os.popen(bash_command_modified).read()
        # Визуально модифицируем вывод — иначе слишком большие отступы
        prepare_result = prepare_result.replace('\n', '')
        print(prepare_result)
```

#### 4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

Файл `http.py`:
```python
#!/usr/bin/env python3

import socket
import time

list_of_sites = ('drive.google.com', 'mail.google.com', 'google.com')
last_check = {} # Объявляем dict для хранения данных последней проверки

# Подготовим массив для хранения данных последней проверки
for site in list_of_sites:
    last_check[site] = '-1.-1.-1.-1'

for site in list_of_sites:
    ip = socket.gethostbyname(site)
    print(site + " - " + ip)
    # Поскольку по условиям задачи мы знаем, что нет балансировки,
    # можем считать, что у одного адреса один IP.
    if last_check[site] == '-1.-1.-1.-1':
        last_check[site] = ip
        # Если это первый запуск скрипта, просто записываем IP-адрес
        else:
        if last_check[site] != ip:
            print('[ERROR] ' + site + 'IP mismatch: ' + last_check[site] + ' ' + ip)
            last_check[site] = ip
print('\n')
```