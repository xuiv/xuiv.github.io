---
layout: post
title:  "v2ray添加-port选项"
date:   2018-05-10 07:56:00
categories: computer config
---

v2ray添加-port选项

定位v2ray.com/core/v2ray.go为core包添加域ListenPort：
```
var (
	ListenPort uint16 = 0	
)
```
定位v2ray.com/ext/tools/conf/v2ray.go找到如下代码：
```
if c.InboundConfig.Port == 0 && c.Port > 0 {
	c.InboundConfig.Port = c.Port
}
```
在其后添加：
```
// set listenport use option -port
if core.ListenPort > 0 {
	c.InboundConfig.Port = core.ListenPort
}
```
定位v2ray.com/core/main/main.go添加包引用：
```
import (
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"strconv"      // <------------添加
```
添加命令选项：
```
var (
	listenPort = flag.String("port", "", "Listen port for proxy.")          // <-------------添加
	configFile = flag.String("config", "", "Config file for V2Ray.")
	version    = flag.Bool("version", false, "Show current version of V2Ray.")
	test       = flag.Bool("test", false, "Test config file only, without launching V2Ray server.")
	format     = flag.String("format", "json", "Format of input file.")
	plugin     = flag.Bool("plugin", false, "True to load plugins.")
)
```
找到如下代码：
```
if *plugin {
	if err := core.LoadPlugins(); err != nil {
		fmt.Println("Failed to load plugins:", err.Error())
		os.Exit(-1)
	}
}
```
在其后添加：
```
if len(*listenPort) > 0 {
        port, err := strconv.ParseInt(*listenPort, 10, 16)
        if err == nil {
                core.ListenPort = uint16(port)
        }
}
```
