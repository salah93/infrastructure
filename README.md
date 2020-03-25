Infrastructure
=============


Running in Docker
----------------
```bash
# running container to deploy
sudo docker build -t deploy .
sudo docker run \
    --rm \
    --network host \
    -v /etc/infrastructure/builds:/builds \
    -v /etc/infrastructure/playbooks:/playbooks \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    deploy
```
