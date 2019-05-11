---
layout: post
title:  "v2ray端口映射和代理嵌套"
date:   2019-05-11 19:19:56
categories: computer config
---

服务器xxxx.xxxx.com内的8084端口映射到客户端1080端口
{% highlight json %}
{
  "log": {
    "loglevel": "warning"
  },

  "inbound":{
    "protocol": "dokodemo-door",
    "port": 1080,
    "settings": {
      "address": "localhost",
      "port": 8084,
      "network": "tcp,udp",
      "timeout": 0
    }
  },

  "outbound": {
      "protocol": "vmess",
      "settings": {
        "vnext": [{
            "address": "xxxx.xxxx.com",
            "port": 443,
            "users": [{
              "alterId": 64,
              "id": "b831381d-6324-4d53-ad4f-8cda48b30811",
              "security": "none",
              "level": 0
            }]
        }]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": null
        }
      }
  }
}
{% endhighlight %}

服务器xxxx.xxxx.com内还运行着shadowsocks，在8084端口侦听，v2ray可以通过vmess+ws代理连上它，你也可以把localhost换成任意其它ss服务器，反之也可以通过ss连vmess，可以提高安全性。
{% highlight json %}
{
  "log": {
    "loglevel": "warning"
  },

  "inbound": {
    "listen": "127.0.0.1",
    "port": 1080,
    "protocol": "socks",
    "settings": {
      "auth": "noauth",
      "udp": true
    },
    "domainOverride": [
      "http",
      "tls"
    ]
  },

  "outbound": {
    "protocol": "shadowsocks",
    "settings": { 
          "servers": [{
              "address": "localhost",
              "method": "aes-128-cfb",
              "password": "password",
              "port": 8084
          }]
    },
    "proxySettings": {
        "tag": "transit"  
    }
  },

  "outboundDetour": [{
      "protocol": "vmess",
      "settings": {
        "vnext": [{
            "address": "xxxx.xxxx.com",
            "port": 443,
            "users": [{
              "alterId": 64,
              "id": "b831381d-6324-4d53-ad4f-8cda48b30811",
              "security": "none",
              "level": 0
            }]
        }]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": null
        }
      },
      "tag": "transit"
  }]
}
{% endhighlight %}
