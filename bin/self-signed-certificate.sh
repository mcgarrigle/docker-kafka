#!/bin/bash

DIR="./security"

CN="$1"
CN="${CN:=kafka}"
CONFIG="/tmp/${CN}.conf"
CERT="${DIR}/${CN}.crt"
KEY="${DIR}/${CN}.key"
PASS="${DIR}/${CN}.pass"
KEYSTORE="${DIR}/${CN}.jks"
TRUSTSTORE="${DIR}/trust.jks"

for FILE in $KEY $CERT $PASS $KEYSTORE $TRUSTSTORE; do 
  rm -f "${FILE}"
done

PASSPHRASE=$(./bin/passphrase)

echo "KAFKA_SSL_KEYSTORE_PASSWORD=${PASSPHRASE}" > "${DIR}/${CN}.pass"

cat > "${CONFIG}" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
C = UK
ST = England
L = London
O = EXAMPLE.COM
emailAddress = email@example.com
CN = ${CN}

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${CN}
EOF

openssl req -x509 -newkey rsa:4096 -nodes \
  -config "${CONFIG}" \
  -out "${CERT}" \
  -keyout "${KEY}" \
  -days 3650

# openssl x509 -in "${CERT}" -text -noout

openssl pkcs12 -export \
  -password pass:$PASSPHRASE \
  -in  "${CERT}" \
  -inkey "${KEY}" \
  -chain \
  -CAfile "${CERT}" \
  -name "${CN}" \
  -out "${DIR}/${CN}.p12"

keytool -importkeystore \
  -srcstoretype PKCS12 \
  -srcstorepass $PASSPHRASE \
  -deststorepass $PASSPHRASE \
  -srckeystore "${DIR}/${CN}.p12" \
  -destkeystore "${KEYSTORE}" \
  2> /dev/null

keytool -import \
  -file "${CERT}" \
  -alias ca1 \
  -keystore "${TRUSTSTORE}" \
  -storepass $PASSPHRASE \
  -noprompt \
  2> /dev/null

echo '------------------------------------'
echo /// KEYSTORE
keytool -list -keystore "${KEYSTORE}" -storepass $PASSPHRASE 2> /dev/null

echo '------------------------------------'
echo /// TRUSTSTORE
keytool -list -keystore "${TRUSTSTORE}" -storepass $PASSPHRASE 2> /dev/null
