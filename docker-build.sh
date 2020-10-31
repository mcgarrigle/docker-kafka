#!/bin/bash

function packages {
  for package in $@; do
    yum install -y  "$package"
  done
}

function download {
  local url=$1
  local file="/tmp/$(basename $url)"
  echo "download $url"
  if [ -e $file ]; then
    return
  fi
  curl -s $url -o $file
  echo "downloaded $file"
}

function install_epel {
  rpm --import 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  rpm -ih 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
}

function install_java {
  packages java-1.8.0-openjdk.x86_64
}

function install_python {
  packages git vim python36 python36-pip
  pip3 install kafka-python
}

function install_nifi {
  version="1.8.0"
  file="nifi-${version}-bin.tar.gz"
  echo "file ${file}"
  cd /opt
  tar -xvzf "/tmp/${file}"
  ln -s "nifi-${version}" nifi
}

# https://www.digitalocean.com/community/tutorials/how-to-install-apache-kafka-on-centos-7

function install_kafka {
  useradd kafka -m
  usermod -aG wheel kafka
  version='kafka_2.11-2.1.1'
  file="${version}.tgz"
  cd /opt
  tar -xvzf "/tmp/${file}" # unzip
  mv "${version}/" kafka/ # rename to kafka for simplicity
  # enable the deletion of topics
  echo -e "\ndelete.topic.enable = true" >> "kafka/config/server.properties"
}

# -------------------------------------------

unset http_proxy https_proxy

install_epel
install_java
install_python
install_nifi
install_kafka

# end
