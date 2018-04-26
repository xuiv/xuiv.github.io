---
layout: post
title:  "Cloud9 Nginx 配置文件"
date:   2018-04-26 19:18:00
categories: computer config
---
```
# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts to this file

##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

server {
	listen 8080 default_server;
	listen [::]:8080 default_server ipv6only=on;

	root /usr/share/nginx/html;
	index index.html index.htm;

	# Make site accessible from http://localhost/
	server_name localhost;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
		# Uncomment to enable naxsi on this location
		# include /etc/nginx/naxsi.rules
		# proxy_pass http://localhost:8082/;
	}

    location /vpn {
        include uwsgi_params;
        uwsgi_pass unix:/home/ubuntu/bin/upv.sock;
    }

	# Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
	#location /RequestDenied {
	#	proxy_pass http://127.0.0.1:8080;    
	#}

	#error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	#
	#error_page 500 502 503 504 /50x.html;
	#location = /50x.html {
	#	root /usr/share/nginx/html;
	#}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	#location ~ \.php$ {
	#	fastcgi_split_path_info ^(.+\.php)(/.+)$;
	#	# NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
	#
	#	# With php5-cgi alone:
	#	fastcgi_pass 127.0.0.1:9000;
	#	# With php5-fpm:
	#	fastcgi_pass unix:/var/run/php5-fpm.sock;
	#	fastcgi_index index.php;
	#	include fastcgi_params;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}


# another virtual host using mix of IP-, name-, and port-based configuration
#
#server {
#	listen 8000;
#	listen somename:8080;
#	server_name somename alias another.alias;
#	root html;
#	index index.html index.htm;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}


# HTTPS server
#
#server {
#	listen 443;
#	server_name localhost;
#
#	root html;
#	index index.html index.htm;
#
#	ssl on;
#	ssl_certificate cert.pem;
#	ssl_certificate_key cert.key;
#
#	ssl_session_timeout 5m;
#
#	ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
#	ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
#	ssl_prefer_server_ciphers on;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen       8080;
	listen	[::]:8080;
    server_name  x.hello-xuiv.c9.io;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location / {
        proxy_pass http://upp;
        
        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
    
}

server {
    listen       8080;
    listen  [::]:8080;
    server_name  ink.hello-xuiv.c9.io;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location / {
        proxy_pass http://ink;

        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

}

server {
    listen       8080;
    listen  [::]:8080;
    server_name  port.hello-xuiv.c9.io;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location / {
        proxy_pass http://port;

        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

}

server {
    listen 8080;
    listen [::]:8080;
    server_name blog.hello-xuiv.c9.io;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/blog.hello-xuiv.c9.io/fullchain.pem; 
    ssl_certificate_key /etc/letsencrypt/live/blog.hello-xuiv.c9.io/privkey.pem;
    ssl_session_timeout 5m;
    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2; 
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_prefer_server_ciphers on;
    location / {
        proxy_pass https://blog; 
        client_max_body_size 35m;
    }
}

server {
    listen 8080;
    listen [::]:8080;
    server_name blog.hello-xuiv.c9users.io;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/blog.hello-xuiv.c9users.io/fullchain.pem; 
    ssl_certificate_key /etc/letsencrypt/live/blog.hello-xuiv.c9users.io/privkey.pem;
    ssl_session_timeout 5m;
    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2; 
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_prefer_server_ciphers on;
    location / {
        proxy_pass https://blog; 
        client_max_body_size 35m;
    }
}

upstream upp {
	server localhost:8081;
}

upstream ink {
    server localhost:8083;
}

upstream blog {
    server localhost:8443;
}

upstream port {
    server localhost:4040;
}
```
