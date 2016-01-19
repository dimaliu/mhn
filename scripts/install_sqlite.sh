#!/usr/bin/env bash

set -e
set -x
SCRIPTS=`dirname "$(readlink -f "$0")"`
MHN_HOME=$SCRIPTS/..

if [ -f /etc/debian_version ]; then
    OS=Debian  # XXX or Ubuntu??
    apt-get update
    apt-get -y install sqlite
    exit 0

elif [ -f /etc/redhat-release ]; then
    OS=RHEL

    #if libsqlite3.so is already installed move on
    if [ ! -f /usr/local/lib/libsqlite3.so ]; then
        yum update
        yum -y install epel-release
        yum -y groupinstall "Development tools"

        wget https://sqlite.org/2016/sqlite-autoconf-3100100.tar.gz
        tar -xvzf sqlite-autoconf-3100100.tar.gz
        cd sqlite-autoconf-3100100
        ./configure
        make && make install
        echo "sqlite install complete"

        ldconfig
    fi

else
    echo -e "Unknown OS. Exiting"
    exit -1

fi