---
layout: post
title:  "Darwin x86 in VirtualBox"
date:   2018-05-03 19:34:00
categories: computer config
---

For booting Darwin 8.0.1 in VirtualBox, you need to pass the 'rd=disk1s2' argument. The VM also either needs to have no ACPI or must have an I/O APIC. For Darwin 6.0.2 it's 'rd=disk1'.
