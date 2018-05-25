---
layout: post
title:  "github免密码"
date:   2018-05-25 10:40:00
categories: computer config
---
解决方案：
方案一：

在你的用户目录下新建一个文本文件.git-credentials
在文件中输入以下内容：
```
https:{username}:{password}@github.com
```
{username}和{password}是你的github的账号和密码

修改git配置
执行命令：
```
git config --global credential.helper store
```
上述命令会在.gitconfig文件(.gitconfig与.git-credentials在同目录下)末尾添加如下配置:

经过上述三步配置之后, 你push代码到github时, 便无需再输入用户名密码了

方案二：

在命令行输入命令:
```
git config --global credential.helper store
```
这一步会在用户目录下的.gitconfig文件最后添加：
```
[credential]
    helper = store
```
push 代码
push你的代码 (git push), 这时会让你输入用户名和密码, 这一步输入的用户名密码会被记住, 下次再push代码时就不用输入用户名密码!这一步会在用户目录下生成文件.git-credential记录用户名密码的信息。
