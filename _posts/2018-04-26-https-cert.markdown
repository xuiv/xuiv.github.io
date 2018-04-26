---
layout: post
title:  "https证书申请"
date:   2018-04-26 13:48:00
categories: computer config
---

如果要启用HTTPS，我们就需要从证书授权机构处获取一个证书，Let’s Encrypt 就是一个证书授权机构。我们可以从 Let’s Encrypt 获得网站域名的免费的证书。

Certbot是Let’s Encrypt推出的获取证书的客户端，可以让我们免费快速地获取Let’s Encrypt证书。

开始部署

进入Certbot的官网，选择你所使用的软件和系统环境，然后就会跳转到对应版本的安装方法，以Ubuntu + Nginx为例。
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot 
```
获取证书
安装完成后执行：
```
certbot certonly --webroot -w /var/www/example -d example.com -d www.example.com
```
这条命令的意思是为以/var/www/example为根目录的两个域名example.com和www.example.com申请证书。

如果你的网站没有根目录或者是你不知道你的网站根目录在哪里，可以通过下面的语句来实现：
```
certbot certonly --standalone -d example.com -d www.example.com
```
使用这个语句时Certbot会自动启用网站的443端口来进行验证，如果你有某些服务占用了443端口，就必须先停止这些服务，然后再用这种方式申请证书。

证书申请完之后，Certbot会告诉你证书所在的目录，一般来说会在/etc/letsencrypt/live/这个目录下。

配置Nginx启动HTTPS

找到网站的Nginx配置文件，找到listen 80;，修改为listen 443;在这一行的下面添加以下内容：
```
ssl on;
ssl_certificate XXX/fullchain.pem; # 修改为fullchain.pem所在的路径
ssl_certificate_key XXX/privkey.pem; # 修改为privkey.pem所在的路径
ssl_session_timeout 5m;
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
```
保存退出后，通过nginx -t来检查配置文件是否正确，有错误的话改之即可。配置文件检测正确之后，通过nginx -s reload来重载配置文件。

然后通过访问https://example.com来查看是否配置成功。

如果发现无法访问或者是加载不出来的话检查一下443端口有没有开启！

设置HTTP强制跳转HTTPS

上一步成功之后大家可能会发现通过原来的http://example.com无法访问网页了，因为HTTP默认走的是80端口，我们刚才将其修改为443端口了。在这里我们可以在配置文件的最后一行加入以下代码：
```
server {
    listen 80;
    server_name example.com; # 这里修改为网站域名
    rewrite ^(.*)$ https://$host$1 permanent;
}
```
意思是每一个通过80端口访问的请求都会强制跳转到443端口，这样一来访问http://example.com的时候就会自动跳转到https://example.com了。

设置证书自动续期

有心的小伙伴可能会留意到我们刚才申请的整数的有效期只有90天，不是很长，可是我们可以通过Certbot来实现自动续期，这样就相当于永久了。

开始部署

随便找一个目录，新建一个文件，名字随便起，在这里以example为例，在里面写入0 */12 * * * certbot renew --quiet --renew-hook "/etc/init.d/nginx reload"，保存。

然后在控制台里执行crontab example一切都OK了。原理是example里存入了一个每天检查更新两次的命令，这个命令会自动续期服务器里存在的来自Certbot的SSL证书。然后把example里存在的命令导入进Certbot的定时程序里。

附：
```
Nginx相关命令：
nginx -t # 验证配置是否正确
nginx -v # 查看Nginx的版本号
service nginx start # 启动Nginx
nginx -s stop # 快速停止或关闭Nginx
nginx -s quit # 正常停止或关闭Nginx
nginx -s reload # 重新载入配置文件
```
crontab相关命令：
```
cat /var/log/cron # 查看crontab日志
crontab -l # 查看crontab列表
crontab -e # 编辑crontab列表
systemctl status crond.service # 查看crontab服务状态
systemctl restart crond.service # 重启crontab
```
