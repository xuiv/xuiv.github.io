---
layout: post
title:  "ubuntu字体渲染"
date:   2018-04-21 17:59:00
categories: computer config
---

ubuntu  字体渲染
```
sudo add-apt-repository ppa:no1wantdthisname/ppa

sudo apt-get update

sudo apt-get upgrade
```
再到.profile中设置
```
export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=1 autofitter:warping=1 pcf:no-long-family-names=1" 
```
