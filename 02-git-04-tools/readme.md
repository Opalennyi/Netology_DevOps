#### 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

Полный хэш: `aefead2207ef7e2aa5dc81a34aedf0cad4c32545`  
Комментарий: `Update CHANGELOG.md`

**Как сделано:** `git show aefea` в каталоге склонированного репозитория.

#### 2. Какому тегу соответствует коммит `85024d3`?

`tag: v0.12.23`

**Как сделано:** `git show 85024d3` в каталоге склонированного репозитория, вывод команды: `commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)`

#### 3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

Два родителя: `56cd7859e05c36c06b56d013b55a252d0bb7e158` и `9ea88f22fc6269854151c571162c5bcf958bee2b`.

**Как сделано:** `git show b8d720` — узнаем, что это merge-коммит. Получаем вот такой вывод: `Merge: 56cd7859e 9ea88f22f`  
В принципе, этого бы нам уже хватило, но для получения полных хэшей выполняем `git show b8d720^1` и `git show b8d720^2`

#### 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
33ff1c03b (tag: v0.12.24) v0.12.24  
b14b74c49 [Website] vmc provider links  
3f235065b Update CHANGELOG.md  
6ae64e247 registry: Fix panic when server is unreachable  
5c619ca1b website: Remove links to the getting started guide's old location  
06275647e Update CHANGELOG.md  
d5f9411f5 command: Fix bug when using terraform login on Windows  
4b6d06cc5 Update CHANGELOG.md  
dd01a3507 Update CHANGELOG.md  
225466bc3 Cleanup after v0.12.23 release

**Как сделано:** `git log v0.12.23..v0.12.24 --oneline`

#### 5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит так `func providerSource(...)` (вместо троеточего перечислены аргументы).

Это коммит `8c928e835`

**Как сделано:** `git log -S'func providerSource(' --oneline`, получаем коммит:
`8c928e835 main: Consult local directories as potential mirrors of providers`

#### 6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.
78b122055 Remove config.go and update things using its aliases  
52dbf9483 keep .terraform.d/plugins for discovery  
41ab0aef7 Add missing OS_ARCH dir to global plugin paths  
66ebff90c move some more plugin search path logic to command  
8364383c3 Push plugin discovery down into command package  

**Как сделано:** `git grep 'func globalPluginDirs'`  
Получаем вывод: `plugins.go:func globalPluginDirs() []string {`  
Затем: `git log --no-patch --oneline -L:globalPluginDirs:plugins.go`

#### 7. Кто автор функции `synchronizedWriters`?

Martin Atkins <mart@degeneration.co.uk>

Как сделано: `git log -S'func synchronizedWriters(' --pretty=medium`  
Находим всего два коммита, более ранний из них — коммит Мартина Аткинса. К тому же, у более позднего коммита комментарий `remove unused`, то есть скорее всего там функция была уже удалена, поскольку вывод `git grep 'synchronizedWriters'` пустой.
