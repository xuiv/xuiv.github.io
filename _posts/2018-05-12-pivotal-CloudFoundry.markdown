---
layout: post
title:  "pivotal.io 应用发布"
date:   2018-05-12 13:30:00
categories: computer config
---

```
cf login -a https://api.run.pivotal.io
go get github.com/xuiv/v2ray-heroku
cd $GOPATH/src/github.com/xuiv/v2ray-heroku
cf push appname
```
https://v2ray.cfapps.io:4443
