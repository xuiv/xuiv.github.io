---
layout: post
title:  "lenovo C440 freebsd config"
date:   2018-04-20 15:51:00
categories: computer config
---

`
#/boot/loader.conf

autoboot_delay=3
beastie_disable="YES"
if_rtwn_load="YES"
legal.realtek.license_ack=1
rtwn-rtl8192cfwU_load="YES"
rtwn-rtl8192cfwU_B_load="YES"
wlan_wep_load="YES"
wlan_ccmp_load="YES"
wlan_tkip_load="YES"

#/etc/rc.conf

clear_tmp_enable="YES"
sendmail_enable="NONE"
hostname="BSD"
ifconfig_re0="inet 192.168.10.2 netmask 255.255.255.0"
defaultrouter=""
sshd_enable="YES"
ntpd_enable="YES"
powerd_enable="YES"
# Set dumpdev to "AUTO" to enable crash dumps, "NO" to disable
dumpdev="NO"
wlans_rtwn0="wlan0"
ifconfig_wlan0="WPA SYNCDHCP"
hald_enable="YES"
dbus_enable="YES"

#~/.cshrc

setenv PATH ~/go/bin:${PATH}
setenv XMODIFIERS @im=fcitx
setenv GTK_IM_MODULE fcitx
setenv GTK3_IM_MODULE fcitx

#/etc/wpa_supplicant.conf 

ctrl_interface=/var/run/wpa_supplicant
eapol_version=2
ap_scan=1
fast_reauth=1

network={
	ssid="wifi"
	psk="12345678"
}

network={
	ssid="router"
	key_mgmt=WPA-PSK
	proto=RSN
	psk="12345678"
}

`