Собрать build
docker build -t webdav-nginx .



Активировать туннель если работаете через Docker desktop
ssh -i $(minikube ssh-key) -p "$(docker port minikube 22/tcp | awk -F ':' '{print $2}')" docker@$(docker port minikube 22/tcp | awk -F ':' '{print $1}') -L 8008:localhost:80

Открыть в браузере проект
http://k8s.test.local:8008/files/

Загрузить  файл по WEB DAV
curl -H "Host: k8s.test.local" 127.0.0.1:8008/files/ -T ingress.yaml
