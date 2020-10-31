#!/usr/bin/env python3

from kafka import KafkaConsumer

# maybe want 'latest' in production code

consumer = KafkaConsumer('sample', bootstrap_servers=['localhost:9092'], auto_offset_reset = 'earliest')

for message in consumer:
  print (message)
