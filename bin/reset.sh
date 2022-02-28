#!/bin/bash

docker-compose down

if [ "$1" == "hard" ]; then
  docker volume rm kafka_volume_kafka kafka_volume_zookeeper_data kafka_volume_zookeeper_log
fi

docker-compose up -d
docker-compose ps
