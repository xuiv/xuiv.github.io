---
layout: post
title:  "git回滚到任意版本"
date:   2018-05-17 17:46:00
categories: computer config
---
git回滚到任意版本
先显示提交的log
```
$ git log -3
commit 4dc08bb8996a6ee02f
Author: Mark <xxx@xx.com>
Date:   Wed Sep 7 08:08:53 2016 +0800

    xxxxx

commit 9cac9ba76574da2167
Author: xxx<xx@qq.com>
Date:   Tue Sep 6 22:18:59 2016 +0800

    improved the requst

commit e377f60e28c8b84158
Author: xxx<xxx@qq.com>
Date:   Tue Sep 6 14:42:44 2016 +0800

    changed the password from empty to max123
```
回滚到指定的版本
```
git reset --hard e377f60e28c8b84158
```
强制提交
```
git push -f origin master
```
