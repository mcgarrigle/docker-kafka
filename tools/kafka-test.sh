#!/bin/bash

echo foo|kafka-console-producer.sh --broker-list localhost:9092 --topic sample
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic sample --from-beginning
