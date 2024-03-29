ls -la /var/log - вывод всех фалов и папок с разрешениями и скрытыми файлами
echo "Helllo, world" вывод на печать (экран)
man echo вывести справку по команде echo
> (>>) перенаправить вывод в файл (override)

У потоков ввода - ввывода есть обозначения:
    0 - стандартный ввод (stdin)
    1 - стандартный вывод (stdout)
    2 - вывод ошибок (stderr)

abrakadabra 2> /dev/null сбросить ошибки
abrakadabra 2>> /var/log/test.log записать ошибки в test.log

| pipe передача вывода одних команд как аргумент другим командам
ls | grep "hello" найти в выводе "hello"

pwd (print workind directory) показать текущую директорию
cd (change directory) перейти в директорию
cd /home - перейти в папку /home
find . -name "hello.txt" найти hello.txt в текущей директории

Сокращения директорий
    / корневая папка сервера
    . текущая директория
    .. директория уровнем выше
    ~ домашняя папка текущего пользователя
    - предыдущая посещенная директория

Для навигации можно использовать абсолютные и относительные пути!!

apt (yum) -y install mc - файловый менеджер midnight commander

### поиск фалов и папок
find [где искать] [как искать] [что искать] 
    -type (f файлы, d директории) указать тип
    -mtime [7, +7] время изменения файлов младше или старше n дней
    -size размер файла


find / -name "hello.txt" найти файл на компьютере рекурсивно

whereis requirements* найти все файлы и папки начинающие с requirements

alias вывести все alias

man  вывести справочную информацию
help вывести инструкцию
info вывести документацию
Подробнее об отличиях здесь https://unix.stackexchange.com/questions/19451/difference-between-help-info-and-man-command

Запуск нескольких команд за раз 

Командная строка имеет несколько инструментов, которые позволяют запускать сразу несколько операций, управлять порядком их выполнения и выводом.

Например, если нам нужно выполнить несколько команд последовательно, не обязательно вводить каждую по отдельности. Можно перечислить их через точку с запятой:

echo -n "Hello, "; echo "World!"
Если нам нужно выполнить список зависимых друг от друга команд, для их разделения нужно использовать оператор &&. В таком случае следующая команда в списке будет выполнена только при условии успешного выполнения предыдущей.

    echo -n "Hello, " && echo "World!"

Оператор || действует наоборот — запускает следующую операцию при условии, что первая не выполнилась или завершилась с ошибкой.

    wrongCommand || echo "Что-то пошло не так!"

Также можно запускать команды параллельно. Для этого в конец команд добавляется символ &, каждая команда заключается в круглые скобки, которые между тем разделяются между собой точкой с запятой:

    (echo "Кто сказал, что убить двух зайцев" &); (echo "одним махом нельзя?" &)

### запуск bash скриптов

bash-скрипты - это сценарии командной строки, написанные для оболочки bash. Существуют и другие оболочки, например — zsh, tcsh, ksh, но мы сосредоточимся на bash.

Сценарии командной строки — это наборы тех же самых команд, которые можно вводить с клавиатуры, собранные в файлы и объединённые некоей общей целью. При этом результаты работы команд могут представлять либо самостоятельную ценность, либо служить входными данными для других команд. Сценарии — это мощный способ автоматизации часто выполняемых действий.

Суть bash-скриптов — записать все ваши действия в один файл и выполнять их по необходимости.
 
    vim script.sh
        echo "Hello world"
    chmod +x ./script.sh
    ./script.sh

##### сделать alias
    vim ~/.bashrc (или ~/.bash_alias)
        alias [короткая команда]='[исходная команда]'
        alias test = 'echo Hello test'
    source ~/.bashrc
    
$_ выведет последний аргумент команды, либо полный путть к bash скрипту

echo "this is a line" | tee file.txt выведет на экран и запишет в файл
