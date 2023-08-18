instruction from https://habr.com/ru/companies/timeweb/articles/680594/
минимальные требования: https://github.com/jimmidyson/gitlab-ce/blob/master/doc/install/requirements.md
оптимизация по памяти (c 4 гб до 2 гб): https://wiki.dieg.info/gitlab https://docs.gitlab.com/omnibus/settings/memory_constrained_envs.html
Включить container registry https://habr.com/ru/companies/timeweb/articles/589675/


Регистрация runner:
docker exec runner-docker gitlab-runner register --url <<url gitlab>> --token <<value>> --executor <<shell, docker-autoscaler, docker+machine, instance, kubernetes, docker-windows, docker, parallels, ssh, virtualbox, custom>>





Sample:

Work shell executor
gitlab-runner register \
  --non-interactive \
  --url "http://git.example.com/" \
  --registration-token "k11rfhKMYZBqxhHh9oRW" \
  --description "shell-runner" \
  --executor "shell"

Work (docker in docker)
Network: host fix it private local repository git
gitlab-runner register \
  --non-interactive \
  --url "http://git.example.com/" \
  --registration-token "k11rfhKMYZBqxhHh9oRW" \
  --description "docker/compose" \
  --executor "docker" \
  --docker-network-mode host \
  --docker-image docker/compose

