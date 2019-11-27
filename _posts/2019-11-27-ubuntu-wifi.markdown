---
layout: post
title:  "ubuntu server 使用wifi"
date:   2019-11-27 11:14:00
categories: computer config
---

ubuntu server 使用wifi
```
sudo apt install iw wpasupplicant
sudo ip link show
sudo iwconfig
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
