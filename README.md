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

$ cert-make-ca.sh 'CN=CA,OU=KAFKA,O=EXAMPLE,L=CARDIFF,C=GB'
  # generates:
  # ca.key
  # ca.crt
  # trust.jks
  # trust.pass

# make host cert

$ cert-make-host.sh 'OU=KAFKA,O=EXAMPLE,L=CARDIFF,C=GB' kafka kafka1 kafka2 kafka3 kafka.example.com
  # generates:
  # kafka.key
  # kafka.crt
  # kafka.jks
  # kafka.pass

# make user certifcate for admin user

$ cert-make-user.sh 'OU=KAFKA,O=EXAMPLE,L=CARDIFF,C=GB' admin
  # generates:
  # admin.key
  # admin.crt
  # admin.jks
  # admin.pass

$ cert-make-user.sh 'OU=KAFKA,O=EXAMPLE,L=CARDIFF,C=GB'
  # generates:
  # u10083b58.key
  # u10083b58.crt
  # u10083b58.jks
  # u10083b58.pass
```

## Run Docker Compose

Make sure ``.../kafka/bin`` is in your path.
```
$ docker compose up -d

kafka-topics.sh --bootstrap-server localhost:9092 --create --topic events
kafka-topics.sh --bootstrap-server localhost:9092 --list

date | kafka-console-producer.sh --bootstrap-server localhost:9092 --topic events
kafka-console-consumer.sh  --bootstrap-server localhost:9092 --topic events --group event-consumer
```
Check consumer group offsets:
```
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group event-consumer --describe
```
Reset consumer group offset:
```
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --topic events --group event-consumer --reset-offsets --to-earliest --execute
```
Build kakacat (outside the scope of this README)

## Test
```
$ kafka-topics.sh --bootstrap-server kafka:29093 --command-config tests/admin.properties --create --topic events
$ kafka-topics.sh --bootstrap-server kafka:29093 --command-config tests/admin.properties --list

$ kafka-acls.sh   --bootstrap-server kafka:29093 --command-config tests/admin.properties \
  --add \
  --topic events \
  --producer \
  --consumer --group event-group \
  --allow-principal 'User:C=GB,L=CARDIFF,O=EXAMPLE,OU=KAFKA,CN=admin'

$ echo fum |./root/kafkacat -P -b kafka:29093 -t events -X security.protocol=SSL -X ssl.ca.location=security/kafka.crt
$ ./root/kafkacat -C -e -b kafka:29093 -t events -X security.protocol=SSL -X ssl.ca.location=security/kafka.crt
```

Hint:  If kafka fails on restart then wait until ephemeral znodes have timed out before restarting kafka.
