#!/bin/bash

CN="$1"
CONFIG="/tmp/${CN}.conf"

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
  -keyout "/etc/pki/tls/private/${CN}.key" \
  -out "/etc/pki/tls/certs/${CN}.crt" \
  -days 3650

# openssl x509 -in "/etc/pki/tls/certs/${CN}.crt" -text -noout
