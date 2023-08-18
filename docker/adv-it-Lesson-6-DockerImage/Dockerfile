# docker build -t myk8sapp .
# docker run -it --name myk8sapp -p 1234:80 myk8sapp
FROM amazonlinux

RUN yum -y update
RUN yum -y install httpd php

COPY ./index.php /var/www/html/index.php

RUN mkdir /run/php-fpm
CMD /usr/sbin/php-fpm && /usr/sbin/httpd -D FOREGROUND

EXPOSE 80