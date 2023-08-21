#!/bin/bash
#
# download all the assets

function download {
  local url=$1
  local file=$2
  echo "download $url"
  if [ -e $file ]; then
    return
  fi
  curl -L -s $url -o $file
  echo "downloaded $file"
}

# ---------------------------------------------------------

cd /tmp

url="https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz"

file="$(basename $url)"

download $url $file

tar xzf $file
