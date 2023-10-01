# Что такое LAMP/LEMP? 
LAMP - это абреавитура которая состоит из:
 * **Linux** - операционная система
 * **Apache** - веб-сервер
 * **Mysql/MariaDB** - сервер баз данных
 * **PHP** - интерпретатор применяемого в разработке web приложения языка. Иногда его меняют на Perl или Python

В Абревиатуре LEMP в качесте вебсервера выступает Engine-x - nginx. Он считается более производительным чем Apache. 

**Apache** - веб-сервер который позволяеь размещать на сервере сайты и другие веб приложения. Это программа которая открывает запрошенные с вашего сервера веб приложения.

На debian все службы добавляются в автозапуск автоматически на Centos вручную

## Установка Apache в debian/cantOS

### Для debian

    apt -y install apache2
    systemctl status apache2

cat /etc/apache2/apache2.conf - основная кофигурация apache2

### Centos

    yum -y install httpd
    systemctl status httpd
    systemctl start httpd && systemctl enable httpd

cat /etc/httpd/conf/httpd.conf- основная кофигурация apache2

На CentOS после установки нужно отредактировать настройки встроенного фаервола:

    firewall-cmd --permanent --zone=public --add-service=http --add-service=https
    firewall-cmd --reload
Проверить, что настройки успешно применились, можно с помощью команды: 

    firewall-cmd --list-all
В блоке Services в списке должны отображаться http и https.

Теперь на Debian/Catos можно открыть приветственную страницу. CentOS 8 Apache по умолчанию не имеет приветственной страницы

## Установка mysql/mariadb в CentOS/Debian
**Mysql** = это сервер базы данных   
**MariaDb** - его форк/модификация  

Внимание: Установка mysql подобно этой

## Debian

    apt -y install mariadb-server mariadb-client
    systemctl status mariadb

## Centos
    yum -y install mariadb mariadb-server
    systemctl start mariadb && systemctl enable mariadb
    systemctl status mariadb

Проверить версию mysql/mariadb

    mariadb --version # взаимозаменяемы
    mysql --version # взаимозаменяемы

Для настройки после установки следует запустить mysql_secure_installation
C его помощью вы сможете отключить небезопасные опции, которые по умолчанию включены для работы тестового режима после установки.
Рекомендуется включать их все, т. к. чтобы не нарушать стандарты безопасности для работы с базой данных

    mysql_secure_installation

Описание шагов mysql_secure_installation:

* Новый пароль root для сервера баз данных (по умолчанию отсутствует) — потребуется ввести и подтвердить новый пароль;
* Удаление анонимных пользователей (один присутствует по умолчанию для тестового режима);
* Отключение удалённого доступа для пользователя root;
* Удаление тестовой базы данных и доступов к ней;
* Перезагрузка таблиц для применения новых параметров.

## Установка PHP в Debian и CentOS

**PHP** - язык программирования для создания и управления веб приложением, включая веб сайты написанные на нем. Без PHP вебсервер будет отображать только код сайта а не красивую вебстраницу.

### Debian:

Установим php и модули к нему для корректной работы на большинства сайтах и CMS

    apt info php - чтобы посмотреть устанвливаему версию php

если все устраивает

    apt install -y php libapache2-mod-php php-mysql php-gd php-mbstring php-curl php-zip

Она автоматически настроится в качестве модуля Apache чтобы применить достаточно перезапустить службу

    systemctl restart apache2

Php поставляется со многими модулями доступными из коробки (по умолчанию) для получения их списка:

    apt-cache search php | egrep "module" | grep "default"

### Centos

    yum info php - посмотреть версию пакета php
    yum -y install php php-mysqlnd php-common php-cli php-json php-opcache php-mbstring php-curl php-zip
    systemctl restart httpd
    yum search php | grep module посмотреть дополнительные пакеты php

## Установка nginx 
nginx часто применятся в качестве внешнего кеширующего илт frontend сервера. Он разработа для отдачи статических данных, при этом он обечпечивает стабильную, высокую производительность сайтов, даже при очень высоких нагрузках. Генерировать динамическое содержимое он не может (есть версия nginx - openresty которая это может), поэтому он часто применяется в связке со внутренним backend сервером для обработки динамических данных которые затем отдаются nginx как статика.

Важно отчетить что большинство CMS зачточены под работу apache и некоторый функционал в nginx может не работать

Т.к nginx занимают порт 80 следует изменить в Apache порт 80 или отключить его

    systemctl stop apache2 && systemctl disable apache2

    apt -y install nginx 
    systemctl status nginx

Проверим что 80 порт действительно слушает nginx

    ss -tulpn | grep "80" убедиться что nginx слушает порт

## Установка Php-fpm  и соединение с nginx (Для LEMP)

**Php-FPM** в отличие от apache не веб сервер. Это простой, легций и быстрый менеджер процессов PHP. Благодаря чему быстрей обрабатываются запросы. Php-FPM контролирует количество workerov PHP, частоту их перезапуска, и другие вещи для контроля сервера.

    apt -y install php-fpm
    systemctl status php7.3-fpm

Настроим php-fpm

    cat /etc/php/7.3/fpm/pool.d/www.conf # основные настройки php-fpm в Debian
    cat /etc/php-fpm.d/www.conf # основные настройки php-fpm в CentOS

В файле ищем блок кода Unix user/group of processes и меняем apache на **www-data** для Debian и Ubuntu и **nginx** для CentOS.

    cat /etc/php/7.3/fpm/php.ini конфиг php для php-fpm в Debian  
    cat /etc/php.ini конфиг php для php-fpm в CentOS

В файле ищем раздел Paths and Directories (он почти в самом конце файла), внутри находим параметр **cgi.fix_pathinfo** Нужно раскомментировать его (удалить «;» в начале строки) и изменить значение с «1» на «0».

**;cgi.fix_pathinfo=1** на **cgi.fix_pathinfo=0**

Перезагружаем службы

    systemctl reload nginx && systemctl reload php7.3-fpm

## Настройка базового конфигурационного файла для сайта в nginx

Осталось добавить конфигурацию

Удаляем конфигурационный файл default, использующийся по умолчанию, и создаём его замену, default.conf:

    unlink /etc/nginx/sites-enabled/default отсоединяем default конфигурацию

###### Debian
    vi /etc/nginx/sites-available/default.conf в Debian/Ubuntu
    server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.php index.html index.htm;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        include snippets/fastcgi-php.conf;
    }
    
    location ~ /\.ht {
        access_log off;
        log_not_found off;
        deny all;
    }
    }

###### Centos
    vi /etc/nginx/conf.d/default.conf в CentOS

    server {
    listen 80;
    server_name _;
    root /var/www/html/;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
            fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

    location ~ /\.ht {
        access_log off;
        log_not_found off;
        deny all;
    }
    }

сохраняем и создаем символическую ссылку

    ln /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

Тестируем конфигурацию и запускаем

    nginx -t
    nginx -s reload



