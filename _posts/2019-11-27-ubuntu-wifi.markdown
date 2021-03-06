---
layout: post
title:  "ubuntu server 使用wifi"
date:   2019-11-27 11:14:00
categories: computer config
---


/etc/netplan/****.yaml                   :sudo netplan apply
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: true
```
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      addresses:
        - 10.10.10.2/24
      gateway4: 10.10.10.1
      nameservers:
          search: [mydomain, otherdomain]
          addresses: [10.10.10.1, 1.1.1.1]
```
```
network:
  version: 2
  wifis:
    wl0:
      access-points:
        opennetwork: {}
      dhcp4: yes
```
```
network:
  version: 2
  renderer: networkd
  wifis:
    wlp2s0b1:
      dhcp4: no
      dhcp6: no
      addresses: [192.168.0.21/24]
      gateway4: 192.168.0.1
      nameservers:
        addresses: [192.168.0.1, 8.8.8.8]
      access-points:
        "network_ssid_name":
          password: "**********"
```
```
network:
  version: 2
  renderer: networkd
  wifis:
    wlp2s0b1:
      dhcp4: yes
      dhcp6: no
      access-points:
        "network_ssid_name":
          password: "**********"
```





ubuntu server 使用wifi
```
sudo apt install iw wpasupplicant wireless-tools network-manager
sudo ip link show
sudo iw dev enp9s0 scan
```

编辑/etc/network/interfaces文件
```
auto wlp9s0
iface wlp9s0 inet dhcp
wpa-ssid xxxxxx
wpa-psk 12345678
```
或者
```
auto wlp9s0
iface wlp9s0 inet static
address 192.168.0.20
netmask 255.255.255.0
gateway 192.168.0.1
dns-nameservers 223.5.5.5 223.6.6.6
wpa-ssid xxxx
wpa-psk 12345678
```
启用wifi
```
sudo ip link set down wlp9s0
sudo ip link set up wlp9s0
```
iw用法：
```
iw：
iw dev                                 查找无线网卡口
iw wlan0 link                       查看wlan0网口无线连接情况
ifconfig wlan0 up         /* 打开无线网卡 */
iw list                  /* 列出WIFI网卡的性能*/
iw dev wlan0 scan             // 扫描WIFI AP
iw wlan0 connect linux   // 连接到WIFI AP：linux (open) 没有设置密码
iw dev wlan0 link        /* 查看连接状态 */
dhclient wlan0                    //配置无线网卡wlan0
iw wlan0 connect foo keys 0:abcde d:1:0011223344    //连接到wep验证的无线网。
```
对于无密码或者WEP密码的SSID, iw可以胜任，但是对于WPA/WPA2的密码，就必须使用wpa_supplicant了
```
wpa_supplican:
wpa_supplicant -B -i wlan0 -c <(wpa_passphrase "ssid" "psk") (连接无线网ssid，密码psk)  
dhclient:
dhclient wlan0(为wlan0分配ip地址)  
```
