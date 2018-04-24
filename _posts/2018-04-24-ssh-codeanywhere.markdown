---
layout: post
title:  "ssh简易用法"
date:   2018-04-24 19:40:00
categories: computer config
---

ssh host13.codeanyhost.com -p 43160 -l cabox -C -L 1082:127.0.0.1:1080

-N 不执行脚本或命令，通常与-f连用。
-C 压缩数据传输。
-f 后台执行
-D 指定socket代理端口
