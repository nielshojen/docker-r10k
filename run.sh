#!/bin/bash

if test -n "${PRIVATE_KEY}"; then
	echo -e "${PRIVATE_KEY}" > /root/.ssh/id_rsa
	chmod 0600 /root/.ssh/id_rsa
fi

mkdir -p /etc/puppetlabs/r10k
cat << EOF > /etc/puppetlabs/r10k/r10k.yaml
---
cachedir: '/var/cache/r10k'

sources:
  production:
    remote: '${REPOSITORY}'
    basedir: '/etc/puppetlabs/code/environments'

git:
  provider: shellgit
EOF

r10k deploy environment --puppetfile --verbose --color

# Sleep to allow filesystem to sync
sleep 10