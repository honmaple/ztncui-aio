#!/bin/sh

set -x

MYADDR=$1

if [ -z $MYADDR ];then
    echo "IP is null"
    exit 1
fi

chmod 777 /tmp/mkmoonworld-x86_64
zerotier-idtool initmoon /var/lib/zerotier-one/identity.public > moon.json
chmod 777 moon.json
moonip="[\"${MYADDR}/9993\"]"
sed -i "s#127.0.0.1#${MYADDR}#g" moon.json
sed -i "s#\[\]#${moonip}#g" moon.json
cat moon.json
zerotier-idtool genmoon moon.json
/tmp/mkmoonworld-x86_64 moon.json

mkdir /var/lib/zerotier-one/moons.d
cp *.moon /var/lib/zerotier-one/moons.d
mv world.bin planet
cp -f planet /var/lib/zerotier-one/planet

moon_id=$(cat /var/lib/zerotier-one/identity.public | cut -d ':' -f1)
echo -e "Your ZeroTier moon id is \033[0;31m$moon_id\033[0m, you could orbit moon using \033[0;31m\"zerotier-cli orbit $moon_id $moon_id\"\033[0m"