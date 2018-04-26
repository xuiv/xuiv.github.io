---
layout: post
title:  "GAE与Heroku部署"
date:   2018-04-26 18:51:00
categories: computer config
---

```
gcloud init
 
# To continue, you must log in. Would you like to log in (Y/n)? Y
 
gcloud config set project project_ID # change the project_id 
 
dev_appserver.py app.yaml #Note 1
 
gcloud app deploy
 
gcloud app browse
```

```
cd $GOPATH\src\go_shortify_web_app_heroku
 
#heroku part
heroku login
heroku buildpacks:set heroku/go
 
#glide part
glide create
glide install
 
#git part
git init
heroku git:remote -a project_id
git add .
git commit -m "adding files"
git push heroku master
 
heroku logs --tail
```
