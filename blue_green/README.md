Running in Docker
----------------

```bash
# running container to deploy
sudo docker build -t deploy .
sudo docker run \
    --rm \
    --network host \
    -v /etc/infrastructure/builds/blue_green:/builds \
    -v /etc/infrastructure/playbooks:/playbooks \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -e SHA=$GIT_COMMIT \
    -e OLD_SHA=$GIT_PREVIOUS_SUCCESSFUL_COMMIT \
    -e ANSIBLE_SECRET_PATH \
    -e ENVRC_PATH \
    -v $ANSIBLE_SECRET_PATH:$ANSIBLE_SECRET_PATH \
    -v $ENVRC_PATH:$ENVRC_PATH \
    -e NODES=$NODES \
    -e SIZE=$SIZE \
    deploy
```
