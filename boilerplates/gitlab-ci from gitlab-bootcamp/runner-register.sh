#!/bin/bash -x

# Redirect all stdout and stderr to mytest.log
exec > mytest.log 2>&1
while ! curl -f -LI localhost:8888;do echo sleeping; sleep 5;done;
echo Connected!;
sudo docker ps
docker ps --filter "name=^gitlab$" --format "{{.ID}}"
export gitlab_id=$(docker ps --filter "name=^gitlab$" --format "{{.ID}}")

echo "Gitlab container id: $gitlab_id"

export runner_token=$(docker exec -i $gitlab_id /opt/gitlab/bin/gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")

echo "Runner token: $runner_token"

export runner_id=$(docker ps --filter "name=^gitlab-runner$" --format "{{.ID}}")
docker exec -i $runner_id gitlab-runner register  --non-interactive   --url "http://gitlab.local:8888/"   --registration-token $runner_token   --executor "docker"   --docker-image docker:19.03.13   --description "docker-runner" --docker-volumes /var/run/docker.sock:/var/run/docker.sock  --tag-list "docker"   --run-untagged="true"   --locked="false"   --access-level="not_protected"   --env "DOCKER_DRIVER=overlay2" --env "DOCKER_TLS_CERTDIR="  --docker-privileged  --docker-network-mode "bootcamp_network"   --docker-extra-hosts "gitlab.local:172.40.0.2" --docker-pull-policy if-not-present 