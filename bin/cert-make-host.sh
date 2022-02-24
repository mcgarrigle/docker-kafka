#!/bin/bash

# Usage:
#
# cert-make-host.sh <subject> <cn> [san 1] ... [san n]
#
# creates a key, certificate, java keystore and a keystore password
#
# $ cert-make-host.sh 'C=GB,L=CARDIFF,O=EXAMPLE,CN=KAFKA' kafka kafka.example.com

passphrase() {
  echo $RANDOM | md5sum | head -c $1
}

DN="$1"
CN="$2"

SAN=$(echo $@ | xargs -n 1 | awk '{print "DNS." NR " =",$0}')

CONFIG="/tmp/${CN}.conf"
CSR="/tmp/${CN}.csr"

PASS="${CN}.pass"
CERT="${CN}.crt"
KEY="${CN}.key"
P12="${CN}.p12"

KEYSTORE="${CN}.jks"

echo "Generating certificate for ${CN}"

PASSPHRASE=$(passphrase 12)

echo "${PASSPHRASE}" > "${PASS}"
echo "KAFKA_SSL_KEYSTORE_PASSWORD=${PASSPHRASE}" >> "keystores.pass"

SUBJECT=$(echo "${DN}" | tr ',' '\n')

cat > "${CONFIG}" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_req

[dn]
${SUBJECT}

[v3_req]
basicConstraints=CA:FALSE
subjectAltName=@alternatives

[alternatives]
${SAN}
EOF

openssl genrsa -out "${KEY}" 4096

# convert from CONF to CSR

openssl req -new \
  -sha256 \
  -nodes \
  -key "${KEY}" \
  -config "${CONFIG}" \
  -out "${CSR}"

# sign CSR generating certificate

openssl x509 -req \
  -in "${CSR}" \
  -extfile "${CONFIG}" \
  -extensions "v3_req" \
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
  -out "${P12}"

keytool -importkeystore \
  -srcstoretype PKCS12 \
  -srcstorepass $PASSPHRASE \
  -deststorepass $PASSPHRASE \
  -srckeystore "${P12}" \
  -destkeystore "${KEYSTORE}" \
  2> /dev/null

rm -f "${P12}"

echo '------------------------------------'
echo /// KEYSTORE
keytool -list -keystore "${KEYSTORE}" -storepass $PASSPHRASE 2> /dev/null
