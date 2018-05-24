---
layout: post
title:  "gorelease发布管理"
date:   2018-05-24 13:52:00
categories: computer config
---
首先要配置一下goreleaser.yml，这里用WebSocks作为示例。
```
builds:
- binary: websocks-local
  main: ./cmd/websocks-local/main.go
  goos:
     - windows
     - darwin
     - linux
     - freebsd
  goarch:
     - amd64
     - 386
     - arm
     - arm64
  goarm:
    - 6
    - 7
- binary: websocks-server
  main: ./cmd/websocks-server/main.go
  goos:
     - windows
     - darwin
     - linux
     - freebsd
  goarch:
     - amd64
     - 386
     - arm
     - arm64
  goarm:
    - 6
    - 7
archive:
  name_template: '{{ .ProjectName }}_{{ .Os }}_{{ .Arch }}{{ if .Arm }}v{{ .Arm }}{{ end }}'
  replacements:
    darwin: Darwin
    linux: Linux
    windows: Windows
    386: i386
    amd64: x86_64
  format_overrides:
  - goos: windows
    format: zip
```
配置好了以后要记得往.gitignore里加上一行’dist’，因为goreleaser会默认把编译编译好的文件输出到dist文件夹。

这样goreleaser就算配置好了，我们可以先编译一下试试

```
goreleaser --skip-validate --skip-publish --snapshot
```
没什么问题的话就把改动添加到git里面，push到github
```
git add .
git commit -S -m "add goreleaser"
git tag -a v0.1.0 -m "First release"
git push origin master
git push origin v0.1.0
```
在release之前，我们要先添加一下github的token，如果没有的话要先去这里申请一个
```
export GITHUB_TOKEN='YOUR_TOKEN'
```
至此，全部工作都搞定了，可以一键起飞了
```
goreleaser
```
