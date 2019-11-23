---
layout: post
title:  "Gvim右键菜单"
date:   2019-11-23 12:57:00
categories: computer config
---

```
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shell\用Gvim编辑]

[HKEY_CLASSES_ROOT\*\shell\用Gvim编辑\command]
@="C:\\Users\\polaris\\AppData\\Local\\Vim\\vim81\\gvim.exe -p --remote-tab-silent %1 %*"

[HKEY_CLASSES_ROOT\*\shell\用SublimeText编辑]

[HKEY_CLASSES_ROOT\*\shell\用SublimeText编辑\command]
@="C:\\Users\\polaris\\AppData\\Local\\SublimeText\\SublimeText\\sublime_text.exe %1"
```
