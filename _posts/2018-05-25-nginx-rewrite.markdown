---
layout: post
title:  "Nginx Rewrite规则相关指令"
date:   2018-05-25 12:34:00
categories: computer config
---
 
Nginx Rewrite规则相关指令有if、rewrite、set、return、break等，其中rewrite是最关键的指令。

rewrite 的语法

语法: rewrite regex replacement flag

默认: none

作用域: server, location, if

This directive changes URI in accordance with the regular expression and the replacement string. Directives are carried out in order of appearance in the configuration file.

这个指令根据表达式来更改URI，或者修改字符串。指令根据配置文件中的顺序来执行。

Be aware that the rewrite regex only matches the relative path instead of the absolute URL. If you want to match the hostname, you should use an if condition, like so:

注意重写表达式只对相对路径有效。如果你想配对主机名，你应该使用if语句。

rewrite只是会改写路径部分的东东，不会改动用户的输入参数，因此这里的if规则里面，你无需关心用户在浏览器里输入的参数，rewrite后会自动添加的，因此，我们只是加上了一个？号和后面我们想要的一个小小的参数 ***https=1就可以了。

nginx的rewrite规则参考：
```
~ 为区分大小写匹配
~* 为不区分大小写匹配
!~和!~*分别为区分大小写不匹配及不区分大小写不匹
-f和!-f用来判断是否存在文件
-d和!-d用来判断是否存在目录
-e和!-e用来判断是否存在文件或目录
-x和!-x用来判断文件是否可执行
last 相当于Apache里的[L]标记，表示完成rewrite，呵呵这应该是最常用的
break 终止匹配, 不再匹配后面的规则
redirect 返回302临时重定向 地址栏会显示跳转后的地址
permanent 返回301永久重定向 地址栏会显示跳转后的地址
nginx有以下内置变量
$args, 请求中的参数;
```
$content_length, HTTP请求信息里的"Content-Length";

$content_type, 请求信息里的"Content-Type";

$document_root, 针对当前请求的根路径设置值;

$document_uri, 与$uri相同;

$host, 请求信息中的"Host"，如果请求中没有Host行，则等于设置的服务器名;

$limit_rate, 对连接速率的限制;

$request_method, 请求的方法，比如"GET"、"POST"等;

$remote_addr, 客户端地址;

$remote_port, 客户端端口号;

$remote_user, 客户端用户名，认证用;

$request_filename, 当前请求的文件路径名

$request_body_file

$request_uri, 请求的URI，带查询字符串;

$query_string, 与$args相同;

$scheme, 所用的协议，比如http或者是https，比如rewrite  ^(.+)$  $scheme://example.com$1  redirect;

$server_protocol, 请求的协议版本，"HTTP/1.0"或"HTTP/1.1";

$server_addr, 服务器地址，如果没有用listen指明服务器地址，使用这个变量将发起一次系统调用以取得地址(造成资源浪费);

$server_name, 请求到达的服务器名;

$server_port, 请求到达的服务器端口号;

$uri, 请求的URI，可能和最初的值有不同，比如经过重定向之类的。

这些变量可以用在rewrite规则里，也可以打印日志的时候用
nginx 日志
nginx 日志相关指令主要有两条，一条是log_format，用来设置日志格式，另外一条是access_log，用来指定日志文件的存放路径、格式和缓存大 小，通俗的理解就是先用log_format来决定把哪些信息打印到日志里，然后在用zccess_log定义虚拟主机时或全局日志时 在把定义的log_format 跟在后面；
log_format 格式:
```
log_format     main        '$remote_addr - $remote_user [$time_local] "$request" '
                                          '$status $body_bytes_s ent "$http_referer" '   
                                          '"$http_user_agent" "$http_x_forwarded_for"';
```
main表示给后面定义的日志个数取了个名为main的名称，便于在access_log指令中引用
上面的log_format打印出来的日志形如
 111.22.33.44 - - [10/Jan/2001:02:14:14 +0200] "GET / HTTP/1.1" 200 1234 "http://www.fromserver.com/from.htm" "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"
对比日志格式和输出的结果可以发现，日志格式用一对单引号包起来，多个日志格式段用可以放在不同的行，最后用分号(;)结尾
单引号中的双引号("),空白符，中括号([)等字符原样输出，比较长的字符串通常用双引号(")包起来，看起来不容易更加清楚，$开始的变量会替换为真实的值

$remote_user 为-表示没有值
access_log 指令示例
access_log  /home/example/nginx/logs/access.log  main;
/home/example/nginx/logs/access.log表示nginx日志将输出到该文件，每条日志内容如main定义

多目录转成参数
abc.domian.com/sort/2 => abc.domian.com/index.php?act=sort&name=abc&id=2

if ($host ~* (.*)\.domain\.com) {
# ~*不区分大小写匹配，
# '.' 匹配任意单个字符
#()表示将()里面的匹配结果保存到变量中，第一个括号中匹配的放在$1变量，第二个括号中匹配的值放在$2中，依此类推
#开始一个新的匹配，会把$1等变量的值替换为新的匹配的值，这里$1的值为abc
#为了保存匹配结果，可以像下面的行那样，将匹配的结果放在一个新的变量中
set $sub_name $1;
#这里开始一次新的匹配，$1的值变成了新的值2
#每一次rewrite的第一个参数对应的是host后面的字符串，这里表示/sort/2
#这个也有待验证，还有就是如果第二次只有两个括号，第一次有三个，则 $3的值是多少？
#rewrite 第一个参数最后的\/? 表示最后可以带/也可以不带/
rewrite ^/sort\/(\d+)\/?$ /index.php?act=sort&name=$sub_name&id=$1 last;
}
待验证问题：

if ($host ~* (.*)\.domain\.co) 

是说 不区分大小写的情况下，$host中是否包含(.*)\.domain\.co模式，因此$host=abc.domain.com也算匹配模式

要排除.com需要在模式后加$符号，即修改为if ($host ~* (.*)\.domain\.co$) 

目录对换
/123456/xxxx -> /xxxx?id=123456

rewrite ^/(\d+)/(.+)/ /$2?id=$1 last;
我自己写的是这样的

        rewrite ^/\/(\d+)\/(\w+)\/? /$2?id=$1 last;

‘.’匹配任意单个字符，.+则匹配至少包含一个字符的任意字符串，给出的结果其实是将第一级目录放到之后目录的后面

/123456/abc/def/ rewrite后结果为/abc/def?id=123456

注意：/123456/abc/def/最后一个/都被去掉了



例如下面设定nginx在用户使用ie浏览器访问的时候，重定向到/nginx-ie目录下：

if ($http_user_agent ~ MSIE) {
# ~ 区分大小写匹配
rewrite ^(.*)$ /nginx-ie/$1 break;
}
下面是 $http_user_agent取值的一个例子

"$http_user_agent" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; InfoPath.3; .NET4.0E)"

上面的例子是用Mozilla浏览器访问，但是仍然包含MSIE子串，因此，上面的rewrite规则应该是不严格的，应该用if ($http_user_agent ~ ^MSIE)，限定以 MSIE开头更加严格

目录自动加“/”
```
if (-d $request_filename){
rewrite ^/(.*)([^/])$ http://$host/$1$2/ permanent;
}
```
用([^/])匹配最后一个非'/'的字符,然后自己强行再添加一个'/'($2变量后的那个）

Location 指令

是用来为匹配的 URI 进行配置，URI 即语法中的"/uri/"，可以是字符串或正则表达式。但如果要使用正则表达式，则必须指定前缀。

我的理解是：如果URI中包含某个模式，则进行后面的处理。
基本语法
```
location [ =|~|~*|^~|@ ] /uri/ { … }
〖=〗 表示精确匹配，如果找到，立即停止搜索并立即处理此请求。
〖~ 〗 表示区分大小写匹配
〖~*〗 表示不区分大小写匹配
〖^~ 〗 表示只匹配字符串,不查询正则表达式。
〖@〗 指定一个命名的location，一般只用于内部重定向请求。
匹配过程
首先对字符串进行匹配查询，最确切的匹配将被使用。然后，正则表达式的匹配查询开始，匹配第一个结果后会停止搜索，如果没有找到正则表达式，将使用字符串的搜索结果，如果字符串和正则都匹配，那么正则优先级较高。
配置实例
```
```
location  = / {
  # 只匹配对 / 目录的查询.
  [ config A ]
}
location  / {
  # 匹配以 / 开始的查询，即所有查询都匹配。
  [ config B ]
}
location ^~ /images/ {
  # 匹配以 /images/ 开始的查询，不再检查正则表达式。
  [ config C ]
}
location ~* \.(gif|jpg|jpeg)$ {
  # 匹配以gif, jpg, or jpeg结尾的文件，但优先级低于config C。
  [ config D ]
}
```
禁止ht access
```
location ~/\.ht {
#ht是一个文件或目录,无论ht在哪一级，都禁止访问）
deny all;
}
```
禁止多个目录
```
location ~ ^/(cron|templates)/ {
#禁止访问第一级目录中名为cron或templates的目录
deny all;
break;
}
```
禁止以/data开头的文件
可以禁止/data目录下所有文件的访问;
```
location ~ ^/data {
deny all;
}
```
禁止单个文件
```
location ~ /data/sql/data.sql {
deny all;
}
```
expires
语法： expires [time|epoch|max|off]
默认值： expires off
作用域： http, server, location
该指令可以控制HTTP应答中的“Expires”和“Cache-Control”的头标，（起到控制页面缓存的作用）。可以在time值中使用正数或负数。“Expires”头标的值将通过当前系统时间加上设定的 time 值来获得。
epoch 指定“Expires”的值为 1 January, 1970, 00:00:01 GMT。
max 指定“Expires”的值为 31 December 2037 23:59:59 GMT，“Cache-Control”的值为10年。
-1 指定“Expires”的值为 服务器当前时间 -1s,即永远过期
“Cache-Control”头标的值由指定的时间来决定：
    负数：Cache-Control: no-cache
    正数或零：Cache-Control: max-age = #, # 为指定时间的秒数s。其他的单位有d（天），h（小时）

"off" 表示不修改“Expires”和“Cache-Control”的值
控制图片等过期时间为30天，这个时间可以设置的更长。具体视情况而定
```
location ~ \.(gif|jpg|jpeg|png|bmp|ico)$ {

           log_not_found off;  #不记录404 not  found 错误日志
           expires 30d;

           break;
       }
```
控制匹配/resource/或者/mediatorModule/里所有的文件缓存设置到最长时间
```
        location ~ /(resource|mediatorModule)/ {
                root    /opt/demo;
                expires max;
        }
```
设定某个文件的过期时间;这里为600秒，并不记录访问日志
```
location ^~ /html/scripts/loadhead_1.js {
access_log   off;
root /opt/lampp/htdocs/web;
expires 600;
break;
}
```
文件反盗链并设置过期时间

这里的return 412 为自定义的http状态码，默认为403，方便找出正确的盗链的请求

“rewrite ^/ http://leech.divmy.com/leech.gif;”显示一张防盗链图片

“access_log off;”不记录访问日志，减轻压力

“expires 3d”所有文件3天的浏览器缓存
```
location ~* ^.+\.(jpg|jpeg|gif|png|swf|rar|zip|css|js)$ {
valid_referers none blocked *.c1gstudio.com *.c1gstudio.net localhost 208.97.167.194;
if ($invalid_referer) {
rewrite ^/ http://leech.divmy.com/leech.gif;
return 412;
break;
}
access_log   off;
root /opt/lampp/htdocs/web;
expires 3d;
break;
}
```
设置GZIP
一般情况下压缩后的html、css、js、php、jhtml等文件，大小能降至原来的25%，也就是说，原本一个100k的html，压缩后只剩下25k。这无疑能节省很多带宽，也能降低服务器的负载。
在nginx中配置gzip比较简单
具体可见http://wiki.codemongers.com/NginxChsHttpGzipModule
一般情况下只要在nginx.conf的http段中加入下面几行配置即可
```
   gzip  on;
   gzip_min_length  1000;
   gzip_buffers     4 8k;
   gzip_types       text/plain application/x-javascript text/css text/html application/xml;
```
可以通过网页gzip检测工具来检测网页是否启用了gzip

只充许固定ip访问网站，并加上密码
```
root  /opt/htdocs/www;
allow   208.97.167.194;
allow   222.33.1.2;
allow   231.152.49.4;
deny    all;
auth_basic “C1G_ADMIN”;
auth_basic_user_file htpasswd;
```
将多级目录下的文件转成一个文件，增强seo效果
/job-123-456-789.html 指向/job/123/456/789.html
```
rewrite ^/job-([0-9]+)-([0-9]+)-([0-9]+)\.html$ /job/$1/$2/jobshow_$3.html last;
```
将根目录下某个文件夹指向2级目录
如/shanghaijob/ 指向 /area/shanghai/
如果你将last改成permanent，那么浏览器地址栏显是/location/shanghai/
```
rewrite ^/([0-9a-z]+)job/(.*)$ /area/$1/$2 last;
```
上面例子有个问题是访问/shanghai 时将不会匹配
```
rewrite ^/([0-9a-z]+)job$ /area/$1/ last;
rewrite ^/([0-9a-z]+)job/(.*)$ /area/$1/$2 last;
```
这样/shanghai 也可以访问了，但页面中的相对链接无法使用，
如./list_1.html真实地址是/area/shanghia/list_1.html会变成/list_1.html,导至无法访问。

那我加上自动跳转也是不行咯
(-d $request_filename)它有个条件是必需为真实目录，而我的rewrite不是的，所以没有效果
```
if (-d $request_filename){
rewrite ^/(.*)([^/])$ http://$host/$1$2/ permanent;
}
```
知道原因后就好办了，让我手动跳转吧
```
rewrite ^/([0-9a-z]+)job$ /$1job/ permanent;
rewrite ^/([0-9a-z]+)job/(.*)$ /area/$1/$2 last;
```
文件和目录不存在的时候重定向：
```
if (!-e $request_filename) {
proxy_pass http://127.0.0.1;
}
```
域名跳转
```
server
{
listen       80;
server_name  jump.88dgw.com;
index index.html index.htm index.php;
root  /opt/lampp/htdocs/www;
rewrite ^/ http://www.88dgw.com/;
access_log  off;
}
```
多域名转向
```
server_name  www.7oom.com/  www.divmy.com/;
index index.html index.htm index.php;
root  /opt/lampp/htdocs;
if ($host ~ “c1gstudio\.net”) {
rewrite ^(.*) http://www.7oom.com$1/ permanent;
}
```
三级域名跳转
```
if ($http_host ~* “^(.*)\.i\.c1gstudio\.com$”) {
rewrite ^(.*) http://top.88dgw.com$1/;
break;
}
```
域名镜向
```
server
{
listen       80;
server_name  mirror.c1gstudio.com;
index index.html index.htm index.php;
root  /opt/lampp/htdocs/www;
rewrite ^/(.*) http://www.divmy.com/$1 last;
access_log  off;
}
```
某个子目录作镜向
```
location ^~ /zhaopinhui {
rewrite ^.+ http://zph.divmy.com/ last;
break;
}
discuz ucenter home (uchome) rewrite

rewrite ^/(space|network)-(.+)\.html$ /$1.php?rewrite=$2 last;
rewrite ^/(space|network)\.html$ /$1.php last;
rewrite ^/([0-9]+)$ /space.php?uid=$1 last;
discuz 7 rewrite

rewrite ^(.*)/archiver/((fid|tid)-[\w\-]+\.html)$ $1/archiver/index.php?$2 last;
rewrite ^(.*)/forum-([0-9]+)-([0-9]+)\.html$ $1/forumdisplay.php?fid=$2&page=$3 last;
rewrite ^(.*)/thread-([0-9]+)-([0-9]+)-([0-9]+)\.html$ $1/viewthread.php?tid=$2&extra=page\%3D$4&page=$3 last;
rewrite ^(.*)/profile-(username|uid)-(.+)\.html$ $1/viewpro.php?$2=$3 last;
rewrite ^(.*)/space-(username|uid)-(.+)\.html$ $1/space.php?$2=$3 last;
rewrite ^(.*)/tag-(.+)\.html$ $1/tag.php?name=$2 last;
```
给discuz某版块单独配置域名
```
server_name  bbs.c1gstudio.com news.c1gstudio.com;

location = / {
if ($http_host ~ news\.divmy.com$) {
rewrite ^.+ http://news.divmy.com/forum-831-1.html last;
break;
}
}
discuz ucenter 头像 rewrite 优化

location ^~ /ucenter {
location ~ .*\.php?$
{
#fastcgi_pass  unix:/tmp/php-cgi.sock;
fastcgi_pass  127.0.0.1:9000;
fastcgi_index index.php;
include fcgi.conf;
}

location /ucenter/data/avatar {
log_not_found off;
access_log   off;
location ~ /(.*)_big\.jpg$ {
error_page 404 /ucenter/images/noavatar_big.gif;
}
location ~ /(.*)_middle\.jpg$ {
error_page 404 /ucenter/images/noavatar_middle.gif;
}
location ~ /(.*)_small\.jpg$ {
error_page 404 /ucenter/images/noavatar_small.gif;
}
expires 300;
break;
}
}
jspace rewrite

location ~ .*\.php?$
{
#fastcgi_pass  unix:/tmp/php-cgi.sock;
fastcgi_pass  127.0.0.1:9000;
fastcgi_index index.php;
include fcgi.conf;
}

location ~* ^/index.php/
{
rewrite ^/index.php/(.*) /index.php?$1 break;
fastcgi_pass  127.0.0.1:9000;
fastcgi_index index.php;
include fcgi.conf;
}
```
Nginx与Apache的Rewrite规则实例对比

简单的Nginx和Apache 重写规则区别不大，基本上能够完全兼容。例如：

Apache Rewrite 规则：
```
RewriteRule ^/(mianshi|xianjing)/$ /zl/index.php?name=$1 [L]

RewriteRule ^/ceshi/$ /zl/ceshi.php [L]

RewriteRule ^/(mianshi)_([a-zA-Z]+)/$ /zl/index.php?name=$1_$2 [L]

RewriteRule ^/pingce([0-9]*)/$ /zl/pingce.php?id=$1 [L]
```
Nginx Rewrite 规则：
```
rewrite ^/(mianshi|xianjing)/$ /zl/index.php?name=$1 last;

rewrite ^/ceshi/$ /zl/ceshi.php last;

rewrite ^/(mianshi)_([a-zA-Z]+)/$ /zl/index.php?name=$1_$2 last;

rewrite ^/pingce([0-9]*)/$ /zl/pingce.php?id=$1 last;
```
由以上示例可以看出，Apache的Rewrite规则改为Nginx的Rewrite规则，其实很简单：Apache的RewriteRule指令换成Nginx的rewrite指令，Apache的[L]标记换成Nginx的last标记，中间的内容不变。

如果Apache的Rewrite规则改为Nginx的Rewrite规则后，使用nginx -t命令检查发现nginx.conf配置文件有语法错误，那么可以尝试给条件加上引号。例如一下的Nginx Rewrite规则会报语法错误：
```
rewrite ^/([0-9]{5}).html$ /x.jsp?id=$1 last;
```
加上引号就正确了：
```
rewrite “^/([0-9]{5}).html$” /x.jsp?id=$1 last;
```
Apache与Nginx的Rewrite规则在URL跳转时有细微的区别：

Apache Rewrite 规则：
```
RewriteRule ^/html/tagindex/([a-zA-Z]+)/.*$ /$1/ [R=301,L]
```
Nginx Rewrite 规则：
```
rewrite ^/html/tagindex/([a-zA-Z]+)/.*$ http://$host/$1/ permanent;
```
以上示例中，我们注意到，Nginx Rewrite 规则的置换串中增加了“http://$host”，这是在Nginx中要求的。

另外，Apache与Nginx的Rewrite规则在变量名称方面也有区别，例如：

Apache Rewrite 规则：
```
RewriteRule ^/user/login/$ /user/login.php?login=1&forward=http://%{HTTP_HOST} [L]
```
Nginx Rewrite 规则：
```
rewrite ^/user/login/$ /user/login.php?login=1&forward=http://$host   last;
```
Apache与Nginx Rewrite 规则的一些功能相同或类似的指令、标记对应关系：
```
Apache的RewriteCond指令对应Nginx的if指令；
Apache的RewriteRule指令对应Nginx的rewrite指令；
Apache的[R]标记对应Nginx的redirect标记；
Apache的[P]标记对应Nginx的last标记；
Apache的[R,L]标记对应Nginx的redirect标记；
Apache的[P,L]标记对应Nginx的last标记；
Apache的[PT,L]标记对应Nginx的last标记；
```
允许指定的域名访问本站，其他域名一律跳转到http://www.aaa.com
```
Apache Rewrite 规则：
RewriteCond %{HTTP_HOST}    ^(.*?)\.domain\.com$
RewriteCond %{HTTP_HOST}    !^qita\.domain\.com$
RewriteCond %{DOCUMENT_ROOT}/market/%1/index.htm -f
RewriteRule ^/wu/$ /market/%1/index.htm [L]
```
Nginx的if指令不支持嵌套，也不支持AND、OR等多条件匹配，相比于Apache的RewriteCond，显得麻烦一些，但是，我们可以通过下一页的Nginx配置写法来实现这个示例：

Nginx Rewrite 规则：
```
if ($host ~* ^(.*?)\.domain\.com$) set $var_wupin_city $1;
     set $var_wupin ‘1′;

if ($host ~* ^qita\.domain\.com$)

    set $var_wupin ‘0′;

 if (!-f $document_root/market/$var_wupin_city/index.htm)

     set $var_wupin ‘0′;

if ($var_wupin ~ ‘1′)

    rewrite ^/wu/$ /market/$var_wupin_city/index.htm last;
}
```
另外这里还有一个工具可以直接把apache规则转化为nginx规则

http://www.anilcetin.com/convert-apache-htaccess-to-nginx/

参考：

http://wiki.nginx.org/NginxChsHttpRewriteModule

http://blog.csdn.net/cnbird2008/archive/2009/08/04/4409620.aspx

http://www.divmy.com/
