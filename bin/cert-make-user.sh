#!/bin/bash

passphrase() {
  echo $RANDOM | md5sum | head -c $1
}

RAND="$(passphrase 8)"
CN="U${RAND^^}"
BN="$1"
CONFIG="/tmp/${CN}.conf"
CSR="/tmp/${CN}.csr"
PASS="${CN}.pass"
CERT="${CN}.crt"
KEY="${CN}.key"
KEYSTORE="${CN}.jks"

echo "Generating certificate for ${BN},CN=${CN}"

PASSPHRASE=$(passphrase 12)

echo "${PASSPHRASE}" > "${PASS}"

SUBJECT=$(echo "${BN}" | tr ',' '\n')

cat > "${CONFIG}" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_req

[dn]
$SUBJECT
CN=${CN}

[v3_req]
basicConstraints=CA:FALSE
EOF

openssl genrsa -out "${KEY}" 4096

openssl req -new \
  -sha256 \
  -nodes \
  -key "${KEY}" \
  -config "${CONFIG}" \
  -out "${CSR}"

openssl x509 -req \
  -in "${CSR}" \
  -out "${CERT}" \
  -CA "ca.crt" \
  -CAkey "ca.key" \
  -CAcreateserial \
  -days 3650 \
  -sha256

openssl x509 -in "${CERT}" -text -noout

openssl pkcs12 -export \
  -password pass:${PASSPHRASE} \
  -in  "${CERT}" \
  -inkey "${KEY}" \
  -chain \
  -CAfile "ca.crt" \
  -name "${CN}" \
  -out "${CN}.p12"

keytool -importkeystore \
  -srcstoretype PKCS12 \
  -srcstorepass $PASSPHRASE \
  -deststorepass $PASSPHRASE \
  -srckeystore "${CN}.p12" \
  -destkeystore "${KEYSTORE}" \
  2> /dev/null

echo '------------------------------------'
echo /// KEYSTORE
keytool -list -keystore "${KEYSTORE}" -storepass $PASSPHRASE 2> /dev/null
