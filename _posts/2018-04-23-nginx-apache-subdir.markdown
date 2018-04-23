---
layout: post
title:  "nginx子目录反向代理"
date:   2018-04-23 17:08:00
categories: computer config
---

$ sudo vim /etc/nginx/config.d/default.conf
```
upstream gitlab {
    # 这里我们需要先手动修改Gitlab的默认访问端口，默认为80
    server 192.168.1.2:8098;
}

upstream apache {
    server 192.168.1.2:8090;
}

upstream rabbit {
    server 192.168.1.2:15672;
}


server {
        listen    80;
        server_name    localhost;
        charset    utf-8;

        # http://192.168.1.2/file 即可访问apache文件服务器
        location /file {
            proxy_pass http://apache/;
        }

        location /rabbit {
          proxy_pass http://rabbit/;
           port_in_redirect   on;
           proxy_redirect     off;
           proxy_set_header   Host             $host;
           proxy_set_header   X-Real-IP        $remote_addr;
           proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
      }

        location /jenkins {
            proxy_pass http://192.168.1.2:8088/jenkins/;

        # Fix the "It appears that your reverse proxy set up is broken" error.
        # 修复点击系统管理，出现的反向代理设置有误提示
        port_in_redirect   on;
        proxy_redirect     off;
        proxy_set_header   Host             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
        }

    # 直接IP访问就是Gitlab
    location / {
        proxy_pass http://gitlab/;
    }
}
```
