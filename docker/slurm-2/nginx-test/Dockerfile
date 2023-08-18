#  docker build . -t nginx-debian -f Dockerfile
# docker run --rm --name nginx-debian -p 7100:80 nginx-debian 
FROM debian

# it not work, nginx override this folder
# COPY ./html/index.html /var/www/html

RUN apt-get update
RUN apt-get install -y nginx

# it works
COPY ./html/index.html /var/www/html

COPY custom.conf /etc/nginx/conf.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]