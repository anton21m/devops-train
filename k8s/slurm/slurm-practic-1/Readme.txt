### Закрепляем знания по Pod и Replicaset

1) Переходим в каталог с практикой, смотрим файл `pod.yaml` и запускаем его

```
cd slurm/2.Kubernetes_introduction/
cat pod.yaml
kubectl create -f pod.yaml
```

2) Проверяем что наш pod действительно стартанул:

`kubectl get po`

3) Посмотрим описание этого pod'a, статус и его events:

`kubectl describe pod my-pod`

4) Посмотрим на наш replicaset, запустим его:

```
cat replicaset.yaml
kubectl create -f replicaset.yaml
```

5) обратите внимание, что теперь и pod и replicaset работают:

```
kubectl get po 
kubectl get rs
```

6) увеличим количество реплик нашего replicaset до 3, убедимся что все сработало:

```
kubectl scale replicaset my-replicaset --replicas=3
kubectl get po
kubectl get rs
```

САМОСТОЯТЕЛЬНАЯ РАБОТА:

- Уменьшить количество реплик запущенного replicaset до 2 НЕ используя kubectl scale

7) Прибираемся за собой

`kubectl delete all --all`

### Закрепляем знания по Deployment
1) Смотрим на deployment.yaml, НО НЕ ЗАПУСКАЕМ ПОКА ЧТО

`cat deployment.yaml`

** САМОСТОЯТЕЛЬНАЯ РАБОТА: **
﻿
- Запустить Deployment c image=nginx:1.13
- у этого деплоймента должно быть 6 реплик
- Этот деплоймент должен при обновлении увеличивать количество новых реплик на 2 
- Этот деплоймент должен при обновлении уменьшать количество старых реплик на 2

2) Обновляем версию нашего деплоймента до nginx:1.14 и сразу смотрим, как проходит процесс обновления: