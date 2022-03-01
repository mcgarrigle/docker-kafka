#!/bin/sh

TOPIC=events

kafka-topics.sh --bootstrap-server kafka:29093 --command-config tests/admin.properties --create --topic ${TOPIC}
kafka-topics.sh --bootstrap-server kafka:29093 --command-config tests/admin.properties --list

kafka-acls.sh   --bootstrap-server kafka:29093 --command-config tests/admin.properties \
  --add \
  --topic events \
  --producer \
  --consumer --group ${TOPIC}-group \
  --allow-principal "User:$1"

