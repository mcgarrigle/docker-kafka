#!/bin/bash

DIR="./config"

for E in pass p12 crt key jks; do
  echo "${DIR}/*.${E}"
done

