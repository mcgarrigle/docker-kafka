#!/usr/bin/bash

HERE=$(dirname $0)

BROKER=kafka:29092
TOPIC="events"

kafka-topics.sh --bootstrap-server ${BROKER} --topic ${TOPIC} --describe

# export KAFKA_OPTS="-Dlog4j.configuration=file:${HERE}/log4j.properties"
echo
echo '#subscribe'
kafka-console-consumer.sh --bootstrap-server ${BROKER} --topic ${TOPIC} --from-beginning --timeout-ms 5000
echo '#subscribe complete'
