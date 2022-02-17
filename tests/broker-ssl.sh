#!/usr/bin/bash

BROKER=kafka:29093

kafkacat -b $BROKER -L \
  -X security.protocol=SSL \
  -X ssl.ca.location=./security/kafka.crt \
