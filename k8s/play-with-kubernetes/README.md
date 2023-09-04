https://accelazh.github.io/kubernetes/Play-With-Kubernetes-On-CentOS-7


# up ngrok
curl https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o ngrok.tgz
tar xvzf ngrok.tgz -C /usr/local/bin
ngrok config add-authtoken 1c8ona1fjyMQE2gH0ijQM6lRGRa_7urD1fEP2BFc8mBbWKnzg
ngrok http --domain=adapted-tapir-actively.ngrok-free.app 80

