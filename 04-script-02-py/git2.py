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