#!/bin/bash

docker-compose down

if [ "$1" == "hard" ]; then
  docker volume rm kafka_volume_kafka kafka_volume_zookeeper
fi

docker-compose up -d
