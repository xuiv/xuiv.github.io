---
layout: post
title:  "在Cloud9安装noVNC"
date:   2018-04-29 09:54:00
categories: computer config
---
```
git clone git://github.com/kanaka/noVNC
cd ./noVNC/utils/
openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem
nohup ${HOME}/noVNC/utils/launch.sh --listen 8085 --vnc localhost:5901 --web "/home/ubuntu/noVNC" >/dev/null 2>&1 &
```
在/etc/nginx/sites-enabled/default添加：
```
server {
    listen       8080;
    listen  [::]:8080;
    server_name  vnc.hello-xuiv.c9.io;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location / {
        proxy_pass http://vnc;

        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

}
```

```
upstream vnc {
    server localhost:8085;
}
```
