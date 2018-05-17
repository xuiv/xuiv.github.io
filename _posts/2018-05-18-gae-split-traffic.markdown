---
layout: post
title:  "GAE路由分支"
date:   2018-05-18 07:08:00
categories: computer config
---
```
  $ gcloud app versions list
```
To send all traffic to '20180518t071934' of service 'default', run:
```
  $ gcloud app services set-traffic default --splits 20180518t071934=1
```
To split traffic evenly between '1' and '20180518t071934' of service 'default', run:
```
  $ gcloud app services set-traffic default --splits 1=.5,20180518t071934=.5
```
To split traffic across all services:
```
  $ gcloud app services set-traffic --splits 1=.5,20180518t071934=.5
```
preview:
```
  $ goapp serve app.yaml
```
app.yaml:
```
runtime: go
api_version: go1

handlers:
- url: /stylesheets
  static_dir: stylesheets

- url: /(.*\.(gif|png|jpg))$
  static_files: static/\1
  upload: static/.*\.(gif|png|jpg)$

- url: /.*
  script: _go_app
```
https://cloud.google.com/appengine/docs/standard/go/config/appref
