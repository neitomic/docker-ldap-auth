#!/bin/bash

if [ ! -f /.root_pw_set ]; then
	/root/.scripts/set-root-pass.sh
fi

if [ ! -f /.ldap_configured ]; then
	/root/.scripts/config_ldap.sh
fi

exec /usr/sbin/init
exec /sbin/nslcd
exec /usr/sbin/sshd -D