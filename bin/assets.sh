#!/bin/bash
#
# download all the assets

function download {
  local url=$1
  local file="/tmp/$(basename $url)"
  echo "download $url"
  if [ -e $file ]; then
    return
  fi
  curl -L -s $url -o $file
  echo "downloaded $file"
}

# ---------------------------------------------------------

download "https://downloads.apache.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz"

# end
