---
layout: post
title:  "Darwin x86 in VirtualBox"
date:   2018-05-03 19:34:00
categories: computer config
---

For booting Darwin 8.0.1 in VirtualBox, you need to pass the 'rd=disk1s2' argument. The VM also either needs to have no ACPI or must have an I/O APIC. For Darwin 6.0.2 it's 'rd=disk1'.

```
Installation steps:

First boot:

Select disk

"2" (manual partitioning)

"y" (initialize MBR)

In fdisk:

> auto hfs

Ignore the warning

> update

> write

> quit

Enter partition name

"yes" (clean install)

"darwin" (volume name)

Continue (reboot)

Second boot (make sure to boot from CD again):

Select disk

"3" (existing partition)

Enter partition name

"hfs" (HFS+ filesystem)

"yes" (clean install)

"darwin" (volume name)

Wait for installation to complete...

Enter root password

"darwin" (hostname)

"3" (spawn shell)

# halt
```
