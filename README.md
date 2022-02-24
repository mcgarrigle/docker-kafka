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

$ cert-make-ca.sh 'C=GB,L=CARDIFF,O=MAC,OU=KAFKA,CN=CA'
  # generates
  # ca.key
  # ca.crt
  # trust.jks
  # trust.pass

$ cert-make-host.sh 'C=GB,L=CARDIFF,O=MAC,CN=KAFKA' kafka.mac.wales
  # generates
  # kafka.mac.wales.key
  # kafka.mac.wales.crt
  # kafka.mac.wales.jks
  # kafka.mac.wales.pass

$ cert-make-user.sh 'C=GB,L=CARDIFF,O=MAC,OU=KAFKA'
  # generates
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

Hint:  If kafka faile son restart then wait until ephemeral znodes have timed out before restarting kafka.
