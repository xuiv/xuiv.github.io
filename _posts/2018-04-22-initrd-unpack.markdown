---
layout: post
title:  "initrd解包打包"
date:   2018-04-22 19:45:00
categories: computer config
---
```
i) cpio -t < initrd.img-2.6.28-11-generic

ii) cpio -idv < initrd.img-2.6.28-11-generic 

iii) cpio -i -d -H newc -F initrd.img-2.6.28-11-generic --no-absolute-filenames

find . | cpio -o -Hnewc |gzip -9 > ../image.cpio.gz
```
