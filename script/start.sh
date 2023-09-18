#!/bin/bash

ENV_FILE=/opt/ztncui/.env

if [ -z $MYADDR ]; then
    echo "Set Your IP Address to continue."
    echo "If you don't do that, I will automatically detect."
    MYEXTADDR=$(curl --connect-timeout 5 ip.sb)
    if [ -z $MYEXTADDR ]; then
        MYINTADDR=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
        MYADDR=${MYINTADDR}
    else
        MYADDR=${MYEXTADDR}
    fi
    echo "YOUR IP: ${MYADDR}"
fi


MYADDR=${MYADDR}
HTTP_PORT=${HTTP_PORT:-3000}
HTTP_ALL_INTERFACES=${HTTP_ALL_INTERFACES}

echo "NODE_ENV=production" > $ENV_FILE
echo "MYADDR=$MYADDR" >> $ENV_FILE
echo "HTTP_PORT=$HTTP_PORT" >> $ENV_FILE
if [ ! -z $HTTP_ALL_INTERFACES ]; then
    echo "HTTP_ALL_INTERFACES=$HTTP_ALL_INTERFACES" >> $ENV_FILE
fi


ZT_ADDR=${ZT_ADDR:-127.0.0.1:9993}
if [ -z $ZT_TOKEN ];then
    if [ ! -f /var/lib/zerotier-one/authtoken.secret ]; then
        echo "Zerotier AuthToken is not found"
        exit 1
    else
        ZT_TOKEN=$(cat /var/lib/zerotier-one/authtoken.secret)
    fi
fi

echo "ZT_ADDR=$ZT_ADDR" >> $ENV_FILE
echo "ZT_TOKEN=$ZT_TOKEN">> /app/ztncui/src/.env

echo "ZTNCUI ENV CONFIGURATION: "
cat $ENV_FILE

mkdir -p /opt/ztncui/etc/storage
if [ ! -f /opt/ztncui/etc/passwd ]; then
    cp -v /opt/ztncui/default.passwd /opt/ztncui/etc/passwd
fi

cd /opt/ztncui && npm start