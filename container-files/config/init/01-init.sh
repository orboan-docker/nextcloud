#!/bin/bash

set -e

mkdir -p /etc/ssl/acme/${DOMAIN}

cp /certs/${DOMAIN}/* /etc/ssl/acme/${DOMAIN}/

cat >> /var/www/html/resources/config/ca-bundle.crt <<EOF

Collabora chain
===============
EOF
if [ -f "/certs/ca-chain.cert.pem" ]; then
cat /certs/ca-chain.cert.pem >> /var/www/html/resources/config/ca-bundle.crt
else
echo "WARNING: You must add ca-chain.cert.pem from collabora container to nextcloud ca-bundle.crt"
echo "In collabora container: /etc/loolwsd/ca-chain.cert.pem"
echo "In nextcloud container: /var/www/html/resources/config/ca-bundle.crt"
echo "cat /path/to/ca-chain.cert.pem >> /path/to/ca-bundle.crt"
fi

echo "127.0.0.1   ${DOMAIN}" >> /etc/hosts

if [ ! -f "/etc/apache2/sites-enabled/default-ssl.conf" ]; then
ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
fi

chown www-data:nogroup /var/www/html/config/config.php
