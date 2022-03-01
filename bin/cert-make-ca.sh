#!/bin/bash

# Usage:
# cert-make-ca.sh 'CN=CA,OU=KAFKA,O=EXAMPLE,L=CARDIFF,C=GB'

passphrase() {
  echo $RANDOM | md5sum | head -c $1
}

DN="$1"

PASSPHRASE=$(passphrase 12)

CONFIG="/tmp/ca.conf"
CERT="ca.crt"
KEY="ca.key"
TRUSTSTORE="trust.jks"

echo "${PASSPHRASE}" > "trust.pass"
echo "KAFKA_SSL_TRUSTSTORE_PASSWORD=${PASSPHRASE}" > "keystores.pass"

SUBJECT=$(echo "${DN}" | tr ',' '\n')

cat > "${CONFIG}" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
$SUBJECT

[v3_req]
basicConstraints=CA:TRUE
EOF

openssl req -x509 \
  -nodes \
  -newkey rsa:4096 \
  -config "${CONFIG}" \
  -out "${CERT}" \
  -keyout "${KEY}" \
  -days 3650

openssl x509 -in "${CERT}" -text -noout

rm -f "${TRUSTSTORE}"
echo
keytool -import \
  -file "${CERT}" \
  -alias ca1 \
  -keystore "${TRUSTSTORE}" \
  -storepass $PASSPHRASE \
  -noprompt 
#  2> /dev/null

echo '------------------------------------'
echo /// TRUSTSTORE
keytool -list -keystore "${TRUSTSTORE}" -storepass $PASSPHRASE 2> /dev/null
