---
layout: post
title:  "mysql修改密码"
date:   2018-04-23 18:10:00
categories: computer config
---

查看、修改mysql的用户名和密码

第一步：

这时你需要进入/etc/mysql目录下，然后sudo vim/vi debian.cnf查看里面的用户名和密码，然后使用这个文件中的用户名和密码进入mysql,假如debian.cnf中的用户名为debian-sys-maint,则：

mysql -u debian-sys-maint -p按回车，这时需要你输入密码，复制debian.cnf中的密码（不要手动输入，因为容易产生错误）。

此时你能进入到mysql里面了

第二步：

修改人root密码

根据上一步登录mysql客户端

复制代码
```
mysql> use mysql;
Database changed
mysql> update user set password=password('new password') where user='root';
Query OK, 4 rows affected (0.00 sec)
Rows matched: 4  Changed: 4  Warnings: 0
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
mysql> quit
```
复制代码
第三步：

用新改的root和密码登录查看。

Now create this mysql database. Open a temporary file with mysql commands wordpress.sql and write the following lines:
```
CREATE DATABASE wordpress;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
ON wordpress.*
TO wordpress@localhost
IDENTIFIED BY 'yourpasswordhere';
FLUSH PRIVILEGES;
```
Execute these commands.
```
cat wordpress.sql | sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf
```
