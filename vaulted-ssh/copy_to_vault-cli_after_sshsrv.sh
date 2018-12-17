SSH="ssh -o StrictHostKeyChecking=no -i /root/.ssh/vaulted.pem -i /root/.ssh/signed-cert.pub"

for user in root deploy admin deploy; do
  ${SSH} ${user}@ssh-srv 'echo -n "Logged in to $HOSTNAME as user: "; whoami; echo exiting...'
  echo "sleeping for 5s..."
  sleep 5
done
