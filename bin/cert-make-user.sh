#!/bin/bash

# Usage:
#
# cert-make-user.sh <base DN> [user CN]
#
# Creates a keystore containing:
# - Certificate for the user '<base DN>,<user CN>'
# - Private key for above certificate
# - The kafka CA root trust (generated by cert-make-ca.sh)
#
# If [user CN] is omitted then a user principal CN will be created
# of the form 'UXXXXXXXX' e.g. 'U4550C801'.
#
# $ cert-make-user.sh 'OU=KAFKA,O=EXAMPLE,L=CARDIFF,C=GB' admin
#
# will generate a certificate for 'CN=admin,OU=KAFKA,O=EXAMPLE,L=CARDIFF,C=GB'
#

passphrase() {
  echo $RANDOM | md5sum | head -c $1
}

if [ -z "$2" ]; then
  RAND="$(passphrase 8)"
  CN="u${RAND,,}"
else
  # X="$2"
  CN="${2,,}"
fi

BN="$1"
CONFIG="/tmp/${CN}.conf"
CSR="/tmp/${CN}.csr"
PASS="${CN}.pass"
CERT="${CN}.crt"
KEY="${CN}.key"
P12="${CN}.p12"
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
CN=${CN}
$SUBJECT

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
  -srckeystore "${P12}" \
  -srcstorepass $PASSPHRASE \
  -deststorepass $PASSPHRASE \
  -destkeystore "${KEYSTORE}" \
  2> /dev/null

keytool -import \
  -file "ca.crt" \
  -alias ca1 \
  -keystore "${KEYSTORE}" \
  -storepass $PASSPHRASE \
  -noprompt

rm -f "${P12}"

echo '------------------------------------'
echo /// KEYSTORE
keytool -list -keystore "${KEYSTORE}" -storepass $PASSPHRASE 2> /dev/null
