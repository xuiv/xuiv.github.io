---
layout: post
title:  "use wpa_supplicant link wifi"
date:   2018-04-20 15:51:00
categories: computer config
---

```
手动连接wifi：
1.启动wpa_supplicant服务
[root@linux:~]# ifconfig wlan0 up
[root@linux:~]# /usr/sbin/wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf -B

2.启动wpa_cli
[root@linux:~]# wpa_cli
> scan
OK
<3>CTRL-EVENT-SCAN-RESULTS 
> scan_result
bssid / frequency / signal level / flags / ssid
6c:59:40:ec:7d:b4       2422    -66     [WPA-PSK-CCMP][WPA2-PSK-CCMP][ESS]      lizhiyong
50:fa:84:25:9b:72       2472    -82     [WPA-PSK-CCMP][WPA2-PSK-CCMP][ESS]      \xe4\xbd\xa0\xe6\x98\xaf\xe8\x83\x86\xe5\xb0\x8f\xe9\xac\xbc
> add_net 
1
> set_net 1 ssid "Youku"
OK
> set_net 1 psk " 12345678"
OK
> select_net 1
OK
> enable_net 1
OK
> q
[root@linux:~]# dhcpcd wlan0

开机自动连接wifi
[root@linux:~]# vi /etc/wpa_supplicant.conf
ctrl_interface=/var/run/wpa_supplicant
update_config=1

network={
        ssid="router"
        psk=" 12345678"
} 

[root@linux:~]# vi /etc/init.d/rcS
ifconfig wlan0 up
/usr/sbin/wpa_supplicant -Dbsd -iwlan0 -c/etc/wpa_supplicant.conf -B
dhcpcd wlan0 
```