# Kafka

This project maintains the development image for Kafka

The image contains:
* Kafka     3.1.0

## Docker Image Build
```
$ ./bin/assets.sh
$ docker build --tag kafka:latest .
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
