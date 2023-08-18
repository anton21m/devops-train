#  docker build . -t nginx-alpine -f DockerfileV2
# choose version
FROM alpine:3.18.3

ENV NGINX_VERSION 1.24.0-r6

# delete cache apk 
RUN apk add --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.18/main nginx=${NGINX_VERSION} \
    && mkdir -p /run/nginx
    
EXPOSE 80

# часто изменяемые слои вниз
COPY custom.conf /etc/nginx/http.d/

COPY www /var/www

CMD ["nginx", "-g", "daemon off;"]