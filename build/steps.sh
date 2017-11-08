#!/bin/sh

set -uex

MESOS_VERSION="1.4.0"
MESOS_LABEL="mesos"
MESOS_LABEL_VERSION="${MESOS_LABEL}-${MESOS_VERSION}"
MESOS_RELEASE_FILE=${MESOS_LABEL_VERSION}.tar.gz
MESOS_URL="http://www-us.apache.org/dist/mesos/"  # /1.4.0/mesos-1.4.0.tar.gz
MESOS_URL_RELEASE="${MESOS_URL}/${MESOS_VERSION}/${MESOS_RELEASE_FILE}"

# docker
apt-get install      apt-transport-https      ca-certificates      curl      gnupg2      software-properties-common
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce

# build
apt-get install -y openjdk-8-jdk autoconf libtool

# mesos
apt-get -y install build-essential python-dev python-six python-virtualenv libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev zlib1g-dev

# mh
apt-get install -y strace

# Mesos Download
wget "${MESOS_URL_RELEASE}"
tar -xvf "${MESOS_RELEASE_FILE}"

# Mesos Build
cd "${MESOS_LABEL_VERSION}"
mkdir build
cd build
../configure
make -j 4
make check
make install



