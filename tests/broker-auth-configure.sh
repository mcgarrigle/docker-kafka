#!/bin/sh

BROKER="kafka:29093"
TOPIC=events

kafka-topics.sh --bootstrap-server "${BROKER}" --command-config tests/admin.properties --create --topic ${TOPIC}
kafka-topics.sh --bootstrap-server "${BROKER}" --command-config tests/admin.properties --list

kafka-acls.sh   --bootstrap-server "${BROKER}" --command-config tests/admin.properties \
  --add \
  --topic events \
  --producer \
  --consumer --group ${TOPIC}-group \
  --allow-principal "User:$1"

