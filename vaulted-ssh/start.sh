#!/usr/bin/bash

export COMPOSE_PROJECT_NAME='hackathon'
docker-compose -f docker-compose-vault.yml up
docker cp copy_to_vault-cli_before_sshsrv.sh hackathon_vault-cli_1:/root/script.sh
docker cp copy_to_vault-cli_after_sshsrv.sh hackathon_vault-cli_1:/root/script2.sh
docker-compose -f docker-compose-vault.yml exec vault-cli sh -x /root/script.sh
docker-compose -f docker-compose-sshsrv.yml up
docker-compose -f docker-compose-vault.yml exec vault-cli sh /root/script2.sh
