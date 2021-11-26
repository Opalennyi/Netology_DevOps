
#### 1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

````bash
vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep 'tmp'
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffca5af0410 /* 27 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")
````

Соответственно, она делает системный вызов `chdir`. Можем проверить в man'е через `man 2 chdir`:
> **NAME**  
>       chdir, fchdir - change working directory

#### 2. Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

При просмотре всего лога `strace` во всех трех случаях видно, что перед выводом на экран последним открывается файл `/usr/share/misc/magic.mgc`, поэтому, судя по всему, библиотека находится там. В целом, это подтверждается мануалом magic'а:
> The file(1) command identifies the
     type of a file using, among other tests, a test for whether the
     file contains certain “magic patterns”.  **The database of these
     “magic patterns” is usually located in a binary file in
     /usr/local/share/misc/magic.mgc** or a directory of source text magic
     pattern fragment files in /usr/local/share/misc/magic.  The
     database specifies what patterns are to be tested for, what message
     or MIME type to print if a particular pattern is found, and
     additional information to extract from the file.

#### 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

````bash
/proc/<pid>/fd/
cat /dev/null > /proc/<pid>/fd/<file descriptor>
````

#### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Нет, поскольку процессы не выполняются, а просто присутствуют в списке процессов ОС, чтобы родительский процесс мог считать код их завершения. Однако, как мне говорит Википедия, они
> "блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом".

Вычислительные ресурсы будут отъедать процессы-сироты.

#### 5. В iovisor BCC есть утилита `opensnoop`. На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты?

````bash
vagrant@vagrant:~$ sudo opensnoop-bpfcc -d 1
PID    COMM               FD ERR PATH
777    vminfo              4   0 /var/run/utmp
580    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
580    dbus-daemon        18   0 /usr/share/dbus-1/system-services
580    dbus-daemon        -1   2 /lib/dbus-1/system-services
580    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
````

#### 6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

````bash
vagrant@vagrant:~$ strace uname -a
execve("/usr/bin/uname", ["uname", "-a"], 0x7ffefe3cf828 /* 27 vars */) = 0
````

Она использует системный вызов `uname`.

`man 2 uname` говорит нам:
> **NOTES**  
> <...>  
>        Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

Можем проверить:
```
vagrant@vagrant:~$ uname -a
Linux vagrant 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

vagrant@vagrant:~$ cat  /proc/sys/kernel/version
#90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021

vagrant@vagrant:~$ cat  /proc/sys/kernel/osrelease
5.4.0-80-generic
```

#### 7. Чем отличается последовательность команд через `;` и через `&&` в bash?

Команды, разделенные `;`, выполняются последовательно. Shell ждет завершения обеих команд по очереди. В приведенном в задании примере — Hi выведется в любом случае, эта команда исполнится после `test`.

Команды, разделенные `&&`, выполняются вместе: команда справа от `&&` (command2) выполняется тогда и только тогда, когда команда слева от разделителя (command1) возвращает 0 (выполняется успешно). В примере — Hi будет выведен только если `/tmp/some_dir` существует и является директорией.

#### Есть ли смысл использовать в bash `&&`, если применить `set -e`?

Зависит от контекста использования. Если это просто команда в терминале, то нет, смысла нет, в любом случае обе команды выполнятся только если обе вернут 0. Если это какой-то более длинный скрипт, если я правильно понимаю работу `set -e`, то выполнение всего скрипта прекратится как только хотя бы одна команда вернет не 0. Если нам нужно локальное условие, а не глобальное, то `&&` будет иметь смысл (в конце концов, это именно логический оператор).

#### 8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

> -e&nbsp;&nbsp;Exit immediately if a command exits with a non-zero status.  
> -u&nbsp;&nbsp;Treat unset variables as an error when substituting.  
> -x&nbsp;&nbsp;Print commands and their arguments as they are executed.  
> -o&nbsp;&nbsp;option-name  
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pipefail&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status

`-e`, как мы обсудили в предыдущем задании, прекращает выполнение сценария, если команда возвращает ненулевое значение.  
`-u` требует, чтобы все используемые переменные были предварительно объявлены. Если переменная не была предварительная объявлена, она воспринимается как ошибка и выполнение скрипта прекращается. Это хорошая программистская практика, мы знаем, какие переменные используются в коде, они объявляются глобально, не могут быть ошибочно перезаписаны, и их легче найти в коде.  
`-x` выводит все исполняемые команды и их аргументы. Необходимо для debugging'а.  
`-o pipefail` возвращает 0 из всего скрипта только если все команды в нем выполняются успешно. Это полезно, чтобы убедиться, что все выполняемые команды завершились успешно и мы не получили ошибочно код успешного завершения.

Самым спорным для меня остается `-x` — он все же нужен в основном для отладки, как я понимаю, в "продакшене" после отладки можно обойтись, я полагаю, без него. Остальные три флага — good practice.

#### 9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

````bash
vagrant@vagrant:~$ ps -o stat
STAT
Ss
R+
````

Их значение:
> S&nbsp;&nbsp;&nbsp;&nbsp;interruptible sleep (waiting for an event to complete)  
> s&nbsp;&nbsp;&nbsp;&nbsp;is a session leader

То есть это статус для процесса, который находится в прерываемом сне и при этом является session-лидером. Это означает, что id сессии идентичен id процесса.

> R&nbsp;&nbsp;&nbsp;&nbsp;running or runnable (on run queue)  
> +&nbsp;&nbsp;&nbsp;&nbsp;is in the foreground process group

Это статус работающего процесса, который является foreground-процессом, то есть процессом, о котором знает пользователь, и который требут или запуска пользователем, или какого-то взаимодействия с пользователем.