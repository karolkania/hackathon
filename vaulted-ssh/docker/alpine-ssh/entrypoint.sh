#!/bin/sh

# generate host keys if not present
ssh-keygen -A

if [ "${KEYPAIR_LOGIN}" = "true" ] && [ -f "${HOME}/.ssh/authorized_keys" ] ; then
    sed -i "s/#PermitRootLogin.*/PermitRootLogin without-password/" /etc/ssh/sshd_config
    sed -i "s/#PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config
    curl -v -o /etc/ssh/trusted-user-ca-keys.pem http://vault-srv:8200/v1/ssh-client-signer/public_key
    echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" | tee -a /etc/ssh/sshd_config
    addgroup deploys && adduser -D -G deploys -s /bin/ash deploy && passwd -u deploy
    addgroup admins && adduser -D -G admins -s /bin/ash admin && passwd -u admin
fi

# do not detach (-D), log to stderr (-e), passthrough other arguments
dumb-init /usr/sbin/sshd -D -e "$@"
