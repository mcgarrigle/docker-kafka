#!/usr/bin/bash

BROKER=kafka:29092

kafkacat -b $BROKER -L

date | kafkacat -P -b $BROKER -t x
kafkacat -C -e -b $BROKER -t x
