http://web.archive.org/web/20220316034750/https://medium.com/@benmeier_/a-quick-minimal-ipvs-load-balancer-demo-d5cc42d0deb4

Для эксперимента 3 docker контейнера load balancer:
```
docker run --rm --cap-add=NET_ADMIN -it ubuntu:latest
apt update && apt-get install -y ipvsadm sudo curl
ipvsadm -l
ipvsadm -A -t 1.2.3.4:80 -s rr
ipvsadm -a -t 1.2.3.4:80 -r 172.17.0.3 -m
ipvsadm -a -t 1.2.3.4:80 -r 172.17.0.4 -m

```
############
mkdir /srv/A /srv/B
echo "This is A" > /srv/A/index.html
docker run --rm -d -v "/srv/A:/usr/share/nginx/html" --name nginx-A nginx
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-A

echo "This is B" > /srv/B/index.html
docker run --rm -d -v "/srv/B:/usr/share/nginx/html" --name nginx-B nginx
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-B
###########

for i in {1..10}; do curl 1.2.3.4; done