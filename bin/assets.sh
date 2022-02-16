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

url="https://downloads.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz"

file="/tmp/$(basename $url)"

download $url $file

tar xzf $file

# end
