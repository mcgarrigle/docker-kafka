#!/usr/bin/bash

HERE=$(dirname $0)

BROKER=kafka:29092
TOPIC="events"

kafka-topics.sh --bootstrap-server ${BROKER} --topic ${TOPIC} --describe

echo
echo '#publish'
echo "///// message $(date) //" |kafka-console-producer.sh --bootstrap-server kafka:29092 --topic ${TOPIC} 
echo '#publish complete'

# export KAFKA_OPTS="-Dlog4j.configuration=file:${HERE}/log4j.properties"
echo
echo '#subscribe'
kafka-console-consumer.sh --bootstrap-server ${BROKER} --topic ${TOPIC} --from-beginning --timeout-ms 10000
echo '#subscribe complete'

exit

echo '#list'
kafkacat -b $BROKER -L
echo '#list complete'

echo '#publish'
date | kafkacat -v -v -v -v -P -b $BROKER -t x
echo '#publish complete'

echo '#subscribe'
kafkacat -C -e -b $BROKER -t x
echo '#subscribe complete'
