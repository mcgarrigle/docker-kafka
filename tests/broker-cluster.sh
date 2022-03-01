#!/usr/bin/bash

HERE=$(dirname $0)

BROKER1=kafka1:19093
BROKER2=kafka2:29093

TOPIC="events"

# export KAFKA_OPTS="-Dlog4j.configuration=file:${HERE}/log4j.properties"

# export KAFKA_OPTS="-Djavax.net.debug=all"

echo
echo '#publish'
echo "//// AUTH message $(date) //" | kafka-console-producer.sh \
  --producer.config "${HERE}/producer.properties" \
  --bootstrap-server ${BROKER1} \
  --topic ${TOPIC} 
echo '#publish complete'

echo
echo '#subscribe'
kafka-console-consumer.sh \
  --consumer.config "${HERE}/consumer.properties" \
  --bootstrap-server ${BROKER2} \
  --topic ${TOPIC} \
  --group "${TOPIC}-group" \
  --from-beginning \
  --timeout-ms 5000
echo '#subscribe complete'
