ls -l /proc/$$/ns узнать все процессы bash со всеми namespace от этого процесса
echo $$ узнать номер pid процесса bash
ps aux | grep $$ узнать все процессы bash

lsns отобразить все namespaces в системе
unshare - программа которая позволяет запустить процесс в другом namespace
    unshare -u bash запустить bash в другом namespace (-u в другом hostname) (ls -l /proc/$$/ns можно увидеть в дргом терминале) 
    hostname получить hostname системы
    hostname testdocker задать новый hostname
    unshare --pid --net --fork --mount-proc /bin/bash изолировать pid процессы, сеть, сделать fork в bash
    ps aux показать процессы (уже не показывает родительские)
    ip a показать сетевые интерфейсы (нет ничего кроме loopback)
    nsenter утилита которая позоляет войти в другой namespace
    nsenter -t 796556 --pid --net --mount --ipc --uts bash подключиться к процессу в другом namespace
    
 


namespace:
    net ограничить сеть от хоста
    pid ограничение процессов от остальных
    user позволяет марить userов
    uts позволяет отделять hostaname от хоста

