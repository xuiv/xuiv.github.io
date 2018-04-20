---
layout: post
title:  "use wpa_cli link wifi"
date:   2018-04-20 15:51:00
categories: computer config
---

目前可以使用wireless-tools 或wpa_supplicant工具来配置无线网络。请记住重要的一点是，对无线网络的配置是全局性的，而非针对具体的接口。

   wpa_supplicant是一个较好的选择，但缺点是它不支持所有的驱动。请浏览wpa_supplicant网站获得它所支持的驱动列表。另外，wpa_supplicant目前只能连接到那些你已经配置好ESSID的无线网络，它可以让您连接到那些使用WPA的AP。wireless-tools支持几乎所有的无线网卡和驱动，但它不能连接到那些只支持WPA的AP。

    经过编译后的wpa_supplicant源程序可以看到两个主要的可执行工具：wpa_supplicant和wpa_cli。wpa_supplicant是核心程序，它和wpa_cli的关系就是服务和客户端的关系：后台运行wpa_supplicant，使用wpa_cli来搜索、设置、和连接网络。



如何用wpa_supplicant使能一个wifi连接？

1、运行wpa_supplicant程序；

执行：/system/bin/wpa_supplicant -d -Dwext -iwlan0 -c/data/misc/wifi/wpa_supplicant.conf

其中：

```
-i<ifname> : 网络接口名称

-c<conf>: 配置文件名称
-C<ctrl_intf>: 控制接口名称
-D<driver>: 驱动类型名称
-p<driver_param>: 驱动参数
-b<br_ifname>: 桥接口名称

-d: 增加调试信息
```


/system/bin/wpa_supplicant ：是 wpa_supplicant可执行程序的 path；

2、运行命令行工具wpa_cli ；

执行 ：wpa_cli -iwlan0 -p/data/system/wpa_supplicant

注，-p/data/system/wpa_supplicant中的wpa_supplicant并不是可执行程序，而是个控制套接字。

此时会进入交互模式。其中交互模式的命令如下表：
```
Full command     Short command  Description
status           stat           displays the current connection status
disconnect       disc           prevents wpa_supplicant from connecting to any access point
quit             q              exits wpa_cli
terminate        term           kills wpa_supplicant
reconfigure      recon          reloads wpa_supplicant with the configuration file supplied (-c parameter)
scan             scan           scans for available access points (only scans it, doesn't display anything)
scan_result      scan_r         displays the results of the last scan
list_networks    list_n         displays a list of configured networks and their status (active or not, enabled or disabled)
select_network   select_n       select a network among those defined to initiate a connection (ie select_network 0)
enable_network   enable_n       makes a configured network available for selection (ie enable_network 0)
disable_network  disable_n      makes a configured network unavailable for selection (ie disable_network 0)
remove_network   remove_n       removes a network and its configuration from the list (ie remove_network 0)
add_network      add_n          adds a new network to the list. Its id will be created automatically
set_network      set_n          shows a very short list of available options to configure a network when supplied with no parameters. 
                                See next section for a list of extremely useful parameters to be used with set_network and get_network.
get_network      get_n          displays the required parameter for the specified network. See next section for a list of parameters
save_config      save_c         saves the configuration
```
设置网络的基本格式：set_network <network id> <key><parameter> [<parameter>]

显示网络信息的基本格式：get_network <network id> <key>

相应的参数如下表：
```
Key              Description                                          Parameters
ssid             Access point name                                    string
id_str           String identifying the network                       string
priority         Connection priority over other APs                   number (0 being the default low priority)
bssid            Mac address of the access point                      mac address
scan_ssid        Enable/disbale ssid scan                             0, 1, 2
key_mgmt         Type of key management                               WPA-PSK, WPA_EAP, None
pairwise         Pairwise ciphers for WPA                             CCMP, TKIP
group=TKIP       Group ciphers for WPA                                CCMP, TKIP, WEP104, WEP40
psk              Pre-Shared Key (clear or encrypted)                  string
wep_key0         WEP key (up to 4: wep_key[0123])                     string
eap              Extensible Authentication Protocol                   MD5, MSCHAPV2, OTP, GTC, TLS, PEAP, TTLS
identity         EAP identity string                                  string
password         EAP password                                         string
ca_cert          Pathname to CA certificate file                      /full/path/to/certificate
client_cert      Pathname to client certificate                       /full/path/to/certificate (PEM/DER)
private_key      Pathname to a client private key file                /full/path/to/private_key (PEM/DER/PFX)
```
eg.1、连接无加密的AP
```
>add_network  (It will display a network id for you, assume it returns 0)

>set_network 0 ssid "666"

>set_network 0 key_mgmt NONE

>enable_network 0

>quit
```


eg.2、连接WEP加密AP
```
>add_network   (assume return 1)

>set_network 1 ssid "666"

>set_network 1 key_mgmt NONE

>set_network 1 wep_key0 "your ap password"

>enable_network 1
```


eg.3、连接WPA-PSK/WPA2-PSK加密的AP
```
>add_network   (assume return 2)

>set_network 2 ssid "666"

>set_network 2psk "your pre-shared key"

>enable_network 2
```


到此，wifi模块就能连接上AP了。



3、以上是通过命令行工具wpa_cli来实现wifi网络的连接。当然，也可以通过wpa_supplicant的配置文件来实现连接。

再回顾下运行wpa_supplicant时执行的命令：

/system/bin/wpa_supplicant -d -Dwext -iwlan0 -c/data/misc/wifi/wpa_supplicant.conf

我们在执行时加上了-c/data/misc/wifi/wpa_supplicant.conf，我们可以将我们要连接的AP的设置以一定的格式写入wpa_supplicant.conf配置文件中即可。



例如： 
```
ctrl_interface=DIR=/data/system/wpa_supplicant GROUP=system update_config=1

network={

ssid="my access point"

proto=WPA

key_mgmt=WPA-PSK

psk="you pass words"

}
```
