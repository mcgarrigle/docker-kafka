#!/usr/bin/bash

BROKER=kafka:29092

echo '#list'
kafkacat -b $BROKER -L
echo '#list complete'

echo '#publish'
date | kafkacat -P -b $BROKER -t x -v
echo '#publish complete'

echo '#subscribe'
kafkacat -C -e -b $BROKER -t x
echo '#subscribe complete'
