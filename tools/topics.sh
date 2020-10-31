#!/bin/bash

export PATH=/opt/kafka/bin:$PATH

function new-topic {
  topic="$1"
  kafka-topics.sh --create --replication-factor 1 --partitions 3 --topic "$topic" --zookeeper localhost:2181
}

new-topic "RP-I07Y-PX"
new-topic "NI-I07Y-PJ"

kafka-topics.sh --list --zookeeper localhost:2181
