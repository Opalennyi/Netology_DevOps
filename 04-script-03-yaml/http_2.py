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