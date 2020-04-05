#!/bin/bash
set -eu


printl() {
    echo ===================================================================
    echo                $@
    echo ===================================================================
}

printl provisioning
sleep 5

IPS=`terraform output -json services | jq -r '. | join(",")'`,

cd $PLAYBOOK_DIR
ANSIBLE_SSH_RETRIES=3 ansible-playbook \
    --vault-password-file $ANSIBLE_SECRET_PATH \
    -u ${REMOTE_USER} \
    -e release=${NEW_RELEASE} \
    -i ${IPS} \
    ./services-playbook.yml
