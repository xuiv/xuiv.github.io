---
layout: post
title:  "OpenWRT random MAC address"
date:   2018-04-20 19:04:00
categories: computer config
---

#/etc/rc.local
```
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

aria2c --conf-path=/mnt/mmcblk0/aria2c/aria2c.conf -D

NEWMAC0=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\1\2\3\4\5\6/')
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:81/')
uci set network.lan_dev.macaddr=${NEWMAC}
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:82/')
uci set network.wan_dev.macaddr=${NEWMAC}
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:83/')
uci set wireless.@wifi-iface[0].macaddr=${NEWMAC}
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:84/')
uci set wireless.@wifi-iface[1].macaddr=${NEWMAC}
uci set network.wwan.hostname=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null | md5sum | sed 's/^\(..\)\(..\)\(..\).*$/\1\2\3/')
uci commit network
uci commit wireless
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:30/')
ifconfig eth0 down;ifconfig eth0 hw ether ${NEWMAC};ifconfig eth0 up
#/etc/init.d/network restart
wifi reload

vlmcsdmulti-mips32el-openwrt-uclibc-static vlmcsd &

exit 0
```

# /etc/crontabs/root
```
*/60  * * * * sleep 30 && touch /etc/banner && /sbin/getnewmac.sh
```

# /sbin/getnewmac.sh
```
#!/bin/sh


NEWMAC0=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\1\2\3\4\5\6/')
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:81/')
uci set network.lan_dev.macaddr=${NEWMAC}
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:82/')
uci set network.wan_dev.macaddr=${NEWMAC}
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:83/')
uci set wireless.@wifi-iface[0].macaddr=${NEWMAC}
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:84/')
uci set wireless.@wifi-iface[1].macaddr=${NEWMAC}
uci set network.wwan.hostname=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null | md5sum | sed 's/^\(..\)\(..\)\(..\).*$/\1\2\3/')
uci commit network
uci commit wireless
NEWMAC=$(echo ${NEWMAC0} | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/e8:\2:\3:\4:\5:30/')
ifconfig eth0 down;ifconfig eth0 hw ether ${NEWMAC};ifconfig eth0 up
#/etc/init.d/network restart
wifi reload

```
