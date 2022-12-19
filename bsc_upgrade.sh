#!/bin/bash

wget -P /var/tmp $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep geth_linux |cut -d\" -f4)

if cmp -s  /var/tmp/geth_linux  /opt/bsc/geth ; 
then
  echo "No need to update geth.service"
else
  echo "The update of the geth.service is necessary"
  systemctl stop geth.service || true
  echo "The geth.service is stopped"
  mv /opt/bsc/geth /opt/bsc/geth.back
  mv /var/tmp/geth_linux /opt/bsc/geth
  systemctl start geth.service || true
  echo "geth.service updated"
fi

if [ "$(pgrep geth)" == "" ];
then
   echo "[ WRN ] geth.service is not running !!!"
else
   echo "geth.service is running"
fi

rm -rf /var/tmp/geth_linux*
