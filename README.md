# Kafka

This project maintains the development image for Kafka

The image contains:
* Kafka     3.1.0

## Docker Image Build
```
$ ./bin/assets.sh
$ docker build --tag kafka:test .
```

## Build PKI
```
$ cd security

# setup CA and generate truststore

$ cert-make-ca.sh 'C=GB,L=CARDIFF,O=MAC,OU=KAFKA,CN=CA'
  # generates:
  # ca.key
  # ca.crt
  # trust.jks
  # trust.pass

# make host cert

$ cert-make-host.sh 'C=GB,L=CARDIFF,O=MAC,CN=KAFKA' kafka kafka.mac.wales
  # generates:
  # kafka.key
  # kafka.crt
  # kafka.jks
  # kafka.pass

# make user certifcate for admin user

$ cert-make-user.sh 'C=GB,L=CARDIFF,O=EXAMPLE,OU=KAFKA' admin
  # generates:
  # admin.key
  # admin.crt
  # admin.jks
  # admin.pass

$ cert-make-user.sh 'C=GB,L=CARDIFF,O=MAC,OU=KAFKA'
  # generates:
  # U10083B58.key
  # U10083B58.crt
  # U10083B58.jks
  # U10083B58.pass
```

## Run Docker Compose
```
$ docker-compose up -d
```
Build kakacat (outside the scope of this README)

## Test
```
$ echo fum |./root/kafkacat -P -b kafka:29093 -t events -X security.protocol=SSL -X ssl.ca.location=security/kafka.crt
$ ./root/kafkacat -C -e -b kafka:29093 -t events -X security.protocol=SSL -X ssl.ca.location=security/kafka.crt
```

Hint:  If kafka fails on restart then wait until ephemeral znodes have timed out before restarting kafka.
