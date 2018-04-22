---
layout: post
title:  "U盘境像管理"
date:   2018-04-22 18:38:00
categories: computer config
---
```
$ sudo udisksctl loop-setup -f disk.img
Mapped file disk.img as /dev/loop0.
$ sudo gparted /dev/loop0
```
