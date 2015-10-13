#!/bin/bash

if [ -f /.ldap_configured ]; then
	echo "LDAP is already configured!"
	exit 0
fi

LDAP_SERVER=${LDAP_SERVER:-172.28.182.2}
LDAP_BASE=${LDAP_BASE:-dc=hpcc,dc=com}

sed -i "s/^#URI.*/URI ldap:\/\/${LDAP_SERVER}/" /etc/openldap/ldap.conf
sed -i "s/^#BASE.*/BASE ${LDAP_BASE}/" /etc/openldap/ldap.conf

rm -rf /etc/pam.d/fingerprint-auth && cp /root/.scripts/templates/fingerprint-auth /etc/pam.d/
rm -rf /etc/pam.d/password-auth && cp /root/.scripts/templates/password-auth /etc/pam.d/
rm -rf /etc/pam.d/smartcart-auth && cp /root/.scripts/templates/smartcart-auth /etc/pam.d/
rm -rf /etc/pam.d/system-auth && cp /root/.scripts/templates/system-auth /etc/pamd.d/
rm -rf /etc/nsswitch.conf && cp /root/.scripts/templates/nsswitch.conf /etc/

sed -i "s/^uri.*/uri ldap:\/\/${LDAP_SERVER}/" /etc/nslcd.conf
sed -i "s/^base.*/base ${LDAP_BASE}/" /etc/nslcd.conf

touch /.ldap_configured

echo "========================================================================"
echo "LDAP is configured."
echo "    host: ${LDAP_SERVER}"
echo "    base: ${LDAP_BASE}"
echo ""
echo "========================================================================"