#!/bin/bash

# Usage:
# ./cert-make-ca.sh 'C=GB,L=CARDIFF,O=EXAMPLE,OU=KAFKA,CN=CA' '../security/ca'

DN="$1"
DN="${DN:=kafka}"
NAME="$2"

DIR=$(dirname ${NAME})
CONFIG="/tmp/$(basename ${NAME}).conf"
CERT="${NAME}.crt"
KEY="${NAME}.key"
KEYSTORE="${NAME}.jks"
TRUSTSTORE="${DIR}/trust.jks"

PASSPHRASE="GQLBSQFSAPTC"

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