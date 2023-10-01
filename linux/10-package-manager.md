# Пакетные менеджеры

Apt - Debian/Ubuntu  
Yum - centos

Все пакетные менеджеры имею свой список репозитариев, с базой готовых пакетов. Информация о них хранится в файле: 
/etc/apt/sources.list

deb - бинарный рпозитарий  
deb-src - бинарный репозитарий с исходным кодом


apt update - обновить пакеты и создать локальный репозитарий  
apt install [имя пакета] - установить пакет

apt remove [имя пакета]- удалить пакет без изменненых вами конфигов  
apt reinstall [имя пакета]- переустановить пакет  
apt purge [имя пакета]- полностью удалить пакет, вместе со всеми его конфигурационными файлами  
apt autoremove - очистить ненужные пакеты  
apt autoclean - очистка кеша пакетов  
apt upgrade обновить пакет до актуальной версии, если пакет не указан будет обновлены все пакеты системы  
apt list - вывести список доступных пакетов  
apt list --installed список установленных пакетов  
apt info [имя пакета]  - Посмотреть описание пакета, утилиты  

apt search [имя] - поиск пакетов с именем, которое включает ключевое слово '[имя]'  
apt show [имя] - посмотреть информацию о пакете с именем '[имя]'  
apt edit-sources - открыть с настройками репозитариев в текстовом редакторе  
apt build-dep [имя] - установить зависимости необходимые для сборки выбранного пакета  
apt-cache depends [имя] - посмотреть зависимые пакеты '[имя]'  

## Подключить новый репозитарий для установки свежей версии node js 

По умолчанию на 2023 год apt install nodejs устанавливает версию v10.24.0
https://deb.nodesource.com/

Чтобы установить ноую версию nodejs  необходимо добавить новый репозитарий

    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    ~$ NODE_MAJOR=20
    ~$ echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list


## Сборка и компиляция образа на примере nginx brotli

Nginx Brotli - это модуль расширения для веб-сервера Nginx, который обеспечивает поддержку сжатия Brotli. Brotli - это алгоритм сжатия, разработанный Google, который обеспечивает более высокие коэффициенты сжатия по сравнению с другими методами сжатия, такими как Gzip. Он особенно эффективен для сжатия текстовых ресурсов, таких как файлы HTML, CSS и JavaScript.  
Включение поддержки Brotli в Nginx позволяет уменьшить размер веб-ресурсов, что приводит к более быстрой загрузке страниц и улучшению общей производительности. Это особенно полезно для веб-сайтов с большим количеством текстового контента.  
Для использования Nginx с поддержкой Brotli необходимо скомпилировать Nginx с модулем Brotli. Для этого требуется загрузить исходный код Brotli, скомпилировать его, а затем настроить и собрать Nginx с включенным модулем Brotli.
После того, как Nginx будет скомпилирован с поддержкой Brotli, вы можете настроить его для сжатия ваших веб-ресурсов с использованием Brotli. Это можно сделать, добавив соответствующие директивы в файл конфигурации Nginx, указав, какие файлы или типы файлов должны быть сжаты с помощью Brotli.  
Обратите внимание, что включение сжатия Brotli требует дополнительных ресурсов сервера, поэтому важно учитывать его влияние на производительность сервера и использование ресурсов.  

### Переходим в директорию для сборки 
    cd /usr/local/src
#### Устанавливаем нужные инструменты
    apt -y install build-essential curl git gcc libpcre3-dev libssl-dev zlib1g-dev libbrotli-dev
#### качаем последний стабильный nginx
    latest_nginx=$(curl -sL https://nginx.org/en/download.html | egrep -o "nginx\-[0-9.]+\.tar[.a-z]*" | head -n 1)
    wget "https://nginx.org/download/${latest_nginx}"
    tar -xaf "${latest_nginx}"
    cd nginx-1.25.2

#### качаем Brotli
    git clone https://github.com/google/ngx_brotli.git
    cd ngx_brotli
    git submodule update --init 
#### Переходим на диру выше (ngx_brotli должен обязательно лежать в папке nginx)
    cd ..
#### Создаём цель для команды make
    ./configure --add-module=$(pwd)/ngx_brotli --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid  \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp  \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp  \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx  \
        --group=nginx --with-compat --with-threads \
        --with-http_addition_module --with-http_auth_request_module \
        --with-http_dav_module --with-http_flv_module \
        --with-http_gunzip_module --with-http_gzip_static_module \
        --with-http_mp4_module --with-http_random_index_module  \
        --with-http_realip_module \
        --with-http_secure_link_module --with-http_slice_module \
        --with-http_ssl_module --with-http_stub_status_module \
        --with-stream_ssl_module --with-stream_ssl_preread_module \
    #    --with-cc-opt='-02 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -mtune=generic -fPIC'
    #    --with-ld-opt='-Wl,-z,relro -Wl, -z,now -pie'
    #    --with-file-aio
    
#### Запускаем процесс компиляции на всех ядрах, проверяем, ставим
    make -j$(nproc)
    make test
    make install
#### Проверяем, что модуль добавился
    2>&1 nginx -V | grep -o brotli
#### Чистим за собой
    make clean
#### Добавляем юзера nginx и требуемое для успешного запуска nginx
    useradd --no-create-home nginx
    mkdir -p /var/cache/nginx/client_temp
    chown nginx:root /var/cache/nginx/client_temp
#### Проверяем конфигу nginx
    nginx -t

#### Всё, наш веб сервер собран и готов к запуску
