TODO установить и выполнить 


https://artifacthub.io/packages/helm/ceph-csi/ceph-csi-rbd

helm repo add ceph-csi https://ceph.github.io/csi-charts

mkdir -p /srv/ceph-csi
cd /srv/ceph-csi

helm inspect values ceph-csi/ceph-csi-rbd > cephrbd.yaml

ceph fsid получить id кластера
ceph mon dump получить список мониторов

в cephrbd.yaml укзать кластеры и мониторы, включить security policy

helm upgrade -i ceph-csi-rbd ceph-csi/ceph-csi-rbd -f cephrbd.yaml -n ceph-csi-rbd --create-namespace применить чарт 

####
теперь создаем pool 

ceph osd pool create kube 32 
ceph application enable kube 'kubernetes' установить метку на pool
ceph osd pool application ls 

создаем пользователя для pool

ceph auth get-or-create client rdbkube mon 'allow r, allow command "osd blacklist"' osd 'allow rwx pool=kube' 

выдаст ключ для монитора

применить yaml в папке devops-train/k8s/slurm/persistent_data

kubectl get pv

#############
проверить что rbd диск создан

rbd ls -p kube показать rbd диски
rbd -p kube info <volume_id> посмотреть информацию о томе

2. ### cephfs

ceph auth get-or-create client.fs mon 'allow r' mgr 'allow rw' mds 'allow rw' osd 'allow rw pool=cephfs_data, allow rw pool=cehpfs_metadata'

применить yaml в папке devops-train/k8s/slurm/persistent_data

Чтобы посмотреть cephfs его необходимо примонтировать

mkdir /mnt/cephfs
ceph auth get-key client.admin > /etc/ceph/secret.key получить ключ
echo "172.16.0.6:6789:/ /mnt/cephfs ceph name=admin,secretfile=/etc/ceph/secret.key,noatime,_netdev   0    2" >> /etc/fstab
mount /mnt/cephfs

Можно посмотреть размер диска через расширенные атрибуты
yum install -y attr
getfattr -n ceph.quota.max_bytes . размер в байтах

