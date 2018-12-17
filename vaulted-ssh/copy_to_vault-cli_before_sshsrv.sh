vault secrets enable -path=ssh-client-signer ssh
vault write ssh-client-signer/roles/my-role -<<"EOH"
{
  "allow_user_certificates": true,
  "allowed_users": "*",
  "allow_user_key_ids": "true",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "deploy",
  "ttl": "3m0s"
}
EOH
vault write ssh-client-signer/config/ca generate_signing_key=true
apk update
apk add openssh-client openssh-keygen
mkdir -p /root/.ssh
chmod go-rwx /root/.ssh
ssh-keygen -t ed25519 -N '' -m pem -C 'john.smith@example.com' -f /root/.ssh/vaulted.pem
# vault write ssh-client-signer/sign/my-role public_key=@/root/.ssh/vaulted.pem.pub
vault write -field=signed_key ssh-client-signer/sign/my-role public_key=@/root/.ssh/vaulted.pem.pub key_id='john.smith@example.com' valid_principals='deploy,admin' | tee /root/.ssh/signed-cert.pub
ssh-keygen -Lf /root/.ssh/signed-cert.pub
