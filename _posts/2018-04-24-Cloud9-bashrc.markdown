---
layout: post
title:  "Cloud9 .bashrc"
date:   2018-04-24 13:08:00
categories: computer config
---

```
export PATH=~/workspace/bin:~/bin:${PATH}

alias mels='megals -u user@gmail.com -p password'
alias meget='megaget -u user@gmail.com -p password'
alias meput='megaput -u user@gmail.com -p password'
alias merm='megarm -u user@gmail.com -p password'

vvv=`pstree |grep upp`

if [ "${vvv}"x = ""x ]
then
        nohup upp -L socks+ws://:8081 -L :8084 >/dev/null 2>&1 &
        nohup ddn tcp 8084 --authtoken 3oRAe8qToVpjQgDNr31qe_6xDTbqbkp2D55yrRk7F80 >/dev/null 2>&1 &
        nohup ink preview $HOME/workspace/ink >/dev/null 2>&1 &
        vncserver -kill :1
        nohup sudo su - ubuntu -c /home/ubuntu/.vncserver -s /bin/bash -l >/dev/null 2>&1 &
        sudo service mysql start
        sudo service nginx start
        service apache2 start
fi
```
