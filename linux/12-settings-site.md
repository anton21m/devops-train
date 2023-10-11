# Настройка hosts чтобы не покупать Домен
hosts - текстовый системный файл, содержащий соответствие доменных имен и ip адресов. Запрос к этому файлу имеет приоритет перед обращением к глобальным DNS серверам. В отличие от системы DNS, содержимое файла задается администратором локального компьютера. Действильно это лишь на компьютере на котором мы его прописали.

Добавьте сделующие строки
```
vi /etc/hosts 
    127.0.0.1 example.com www.example.com 
```

**Поддомен www лучше всегда указывать чтобы избежать проблем.**

UPDATE: First VDS уже предоставляет домен вида [аккаунт].fvds.ru

# структура директорий и настрока прав

```
var - системная директория  
    www - директория для вебсервера  
        example1.com сайт вебсервера  
        example2.com сайт вебсервера  
```

Если сайт один можно загрузить все в **/var/www/html**

1. создадим папку и настроим права
```
mkdir /var/www/example.com
chmod -R www-data:www-data /var/www/example.com # для Debian
chmod -R nginx:nginx /var/www/example.com # для CentOS
```

Перед настройкой нужно отключить старый конфигурационный файл по умолчанию, который был создан для проверки работы веб-сервера:

2. Отсоединяем config по умолчанию и копируем конфиг поумолчанию
```
unlink /etc/nginx/sites-enabled/default.conf
```
Создаем конфигурационный файл нашего нового сайта, взяв за основу стандартный конфигурационный файл:
```
cp /etc/nginx/sites-available/default.conf /etc/nginx/sites-available/example.com.conf
```
3. Редактируем файл изменяя строчки
```
vi /etc/nginx/sites-available/example.com.conf
 - ставим server_name example.com www.example.com;
 - ставим root /var/www/example.com;
```

4. Включаем новый файл конфигурации и перезагружаем nginx
```
ln /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-enabled/example.com.conf
nginx -s reload
```

##### Centos

```
mkdir /etc/nginx/sites-enabled
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
vim /etc/nginx/nginx.conf
```

В блоке http { ... } находим блок server { … }, и в начале каждой строки этого блока ставим символ # (комментируем строки).

В пределах блока http { … } добавляем запись:

    include /etc/nginx/sites-enabled/*;

Переименовываем файл с конфигурацией по умолчанию, чтобы он не мешал работе нашего нового сайта:

    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.copy
    vim /etc/nginx/sites-enabled/example.com.conf

И копируем в файл базовые настройки:
```
server {
  listen 80;
  server_name www.example.com example.com;
  root /var/www/example.com;
  index index.php index.html index.htm;

  location / {
    try_files $uri $uri/ =404;
  }

  location ~ \.php$ {
        fastcgi_pass unix:/var/run/php-fpm/www.sock;
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
```

## Создание нового пользователя и БД mariadb

База данных - обязательный компонент любого современного сайта за исключением совсем простых. Одни из этапов установки cms является настройка БД. 

Чтобы создать нового пользователя и базу данных в mariadb:

```
mysql -u root -p
  create database exampledb;
  grant all privileges on exampledb.* to 'exampledb-user'@'localhost' identified by 'p@ssword' with grant option;
  exit;
```

Чтобы удалить пользователя

    DROP USER 'exampledb-user'@'%';

Чтобы залить дамп в базу данных

    mysql -u exampledb-user -p exampledb < dump.sql
  
## Установка wordpress на веб сервер

    cd /var/www/example.com/
    wget https://wordpress.org/latest.zip
    unzip latest.zip
    mv wordpress/* .

Настроим подключение к базе данных в wp-config.php и скопируем дамп в нее

    cp wp-config-sample.php wp-config.php
    vim wp-config.php 
    chown -R www-data:www-data /var/www/example.com/

## Настройка nginx под конкретный сайт Wordpress


Перед началом лучше сделать бекап конфига

    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

Формально процесс сводится к проверке настроек демонстрационно конфигурационных файлов и их адаптации под себя. Wordpress позволяет использовать модульную структуру конфига, так чтобы общие настройки веб сервера и настройки отдельных сайтов были разделены. Юлагодаря этому не придется копировать одни и теже параметры для кадого нового сайта. Юудет достаточно настроить базовые параметры и включить конфигурационные фалы с общими глобальными настройками. В итоге получится следующая структура.

**Wordpress рекомендует https://developer.wordpress.org/advanced-administration/server/web-server/nginx/#global-restrictions-file**

*Wordpress рекомендует следующую структуру:*

* **/etc/nginx/nginx.conf** — главный конфигурационный файл Nginx
/etc/nginx/global/restrictions.conf  
(для CentOS /etc/nginx/conf.d/global/restrictions.conf) — содержит ограничения на несанкционированный доступ к скрытым и системным файлам, настройки robots.txt  
* **/etc/nginx/global/wordpress.conf**
(для CentOS /etc/nginx/conf.d/global/wordpress.conf) — содержит глобальные настройки для работы сайтов  
* **/etc/nginx/sites-available/example.com.conf** — конфигурационный файл для сайта example.com  

Ubuntu и Debian:
```
vim  /etc/nginx/nginx.conf

user www-data;
worker_processes  auto;
worker_cpu_affinity auto;
error_log  /var/log/nginx/error.log;
pid       /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
#daemon     off;
events {
    worker_connections  1024;
}

http {
#   rewrite_log on;
    include mime.types;
    default_type       application/octet-stream;
    access_log         /var/log/nginx/access.log;
    sendfile           on;
#   tcp_nopush         on;
    keepalive_timeout  3;
#   tcp_nodelay        on;
#   gzip               on;
#php max upload limit cannot be larger than this
    client_max_body_size 13m;
    index              index.php index.html index.htm;
    include sites-enabled/*;
}
```
```
vim /etc/nginx/sites-available/example.com.conf

server {
    server_name example.com www.example.com;
    root /var/www/example.com;

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location ~ /\. {
        deny all;
    }

    location ~* /(?:uploads|files)/.*\.php$ {
        deny all;
    }

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include fastcgi.conf;
        fastcgi_intercept_errors on;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        include snippets/fastcgi-php.conf;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }
}
```

##### Centos

```
vim /etc/nginx/nginx.conf

user nginx;
worker_processes  auto;
worker_cpu_affinity auto;
error_log  /var/log/nginx/error.log;
pid        /var/run/nginx.pid;
#daemon     off;
events {
    worker_connections  1024;
}

http {
#   rewrite_log on;
    include mime.types;
    default_type       application/octet-stream;
    access_log         /var/log/nginx/access.log;
    sendfile           on;
#   tcp_nopush         on;
    keepalive_timeout  3;
#   tcp_nodelay        on;
#   gzip               on;
#php max upload limit cannot be larger than this
    client_max_body_size 13m;
    index              index.php index.html index.htm;
    include /etc/nginx/conf.d/*.conf;
    include sites-enabled/*;
}
```
```
vim /etc/nginx/sites-enabled/example.com.conf

server {
    server_name example.com www.example.com;
    root /var/www/example.com;
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location ~ /\. {
        deny all;
    }

    location ~* /(?:uploads|files)/.*\.php$ {
        deny all;
    }

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php-fpm/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }
}
```






