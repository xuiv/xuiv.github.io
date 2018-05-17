---
layout: post
title:  "go设置代理"
date:   2018-05-17 18:43:00
categories: computer config
---
```
git config –global http.proxy "127.0.0.1:1080"
go get …
```
或者可以在go get的同时指定代理：
```
http_proxy=127.0.0.1:1080 go get
```
