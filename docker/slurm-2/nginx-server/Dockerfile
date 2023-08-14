# docker build -t nginx .
# docker run --name nginx -p 80:80 --rm -d nginx
FROM nginx

COPY index.html /usr/share/nginx/html
ADD custom.conf /etc/nginx/conf.d/

EXPOSE 80

ENV FOO bar

CMD ["nginx", "-g", "daemon off;"]
