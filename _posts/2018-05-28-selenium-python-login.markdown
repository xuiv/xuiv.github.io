---
layout: post
title:  "selenium抓取网页两例"
date:   2018-05-28 19:09:00
categories: computer config
---

{% highlight python %}
#!/usr/bin/env python2

import os
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.action_chains import ActionChains

def isElementExist(client,element):
    try:
        client.find_element_by_xpath(element)
        return True
    except:
        return False
        
def waitElement(client,element):
    while not isElementExist(client,element):
        time.sleep(2)

def loginnvy(client):
    try:
        client.get("https://codenvy.io/site/login")
        if isElementExist(client,"//input[@value='Login']"):
            client.find_element_by_id("username").clear()
            client.find_element_by_id("username").send_keys("username")
            client.find_element_by_name("password").clear()
            client.find_element_by_name("password").send_keys("password")
            client.find_element_by_xpath("//input[@value='Login']").click()
        waitElement(client,"//div[@id='navbar-workspaces-item']/span")
        client.find_element_by_xpath("//div[@id='navbar-workspaces-item']/span").click()
        waitElement(client,"//div[@id='navbar']/md-toolbar/div/navbar-recent-workspaces/div/section/md-list/md-list-item[2]/navbar-dropdown-menu/md-menu/div/a/div/span[2]/div/span[2]")
        client.find_element_by_xpath("//div[@id='navbar']/md-toolbar/div/navbar-recent-workspaces/div/section/md-list/md-list-item[2]/navbar-dropdown-menu/md-menu/div/a/div/span[2]/div/span[2]").click()
        return True
    except:
        return False
        
os.system("rm -rf /tmp/*")

client = webdriver.Firefox()
client.set_window_size(1366, 768)

while True:
    if not loginnvy(client):
        continue
    time.sleep(900)
{% endhighlight %}

{% highlight python %}
#!/usr/bin/env python3

import os
import time
import sys
sys.path.append('/projects/selenium')

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.action_chains import ActionChains

def isElementExist(client,element):
    try:
        client.find_element_by_xpath(element)
        return True
    except:
        return False
            
os.system("pkill chrome")
os.system("rm -f /projects/.chrome/Singleton*")

chrome_options = webdriver.ChromeOptions()
#chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--user-data-dir=/projects/.chrome')
client = webdriver.Chrome(chrome_options=chrome_options, executable_path='/home/user/chromedriver')
client.set_window_size(1366, 768)

client.get("https://c9.io/login")
if isElementExist(client,"//button[@type='submit']"):
    client.find_element_by_id("id-username").clear()
    client.find_element_by_id("id-username").send_keys("username")
    client.find_element_by_id("id-password").clear()
    client.find_element_by_id("id-password").send_keys("password")
    client.find_element_by_xpath("//button[@type='submit']").click()
    
STR_READY_STATE = ''
while STR_READY_STATE != 'complete':
    time.sleep(0.001)
    STR_READY_STATE = client.execute_script('return document.readyState') 
      
mainwindow = client.current_window_handle
client.execute_script('''window.open("about:blank", "_blank");''')
time.sleep(2)
client.switch_to_window(client.window_handles[1])

client.get("https://codeanywhere.com/login")
if isElementExist(client,"//button[@type='submit']"):
    client.find_element_by_id("login-email").clear()
    client.find_element_by_id("login-email").send_keys("username")
    client.find_element_by_id("login-password").clear()
    client.find_element_by_id("login-password").send_keys("password")
    client.find_element_by_xpath("//button[@type='submit']").click()

client.switch_to_window(mainwindow)    
if isElementExist(client,"//a[@href='https://ide.c9.io/username/app']"):
    client.find_element_by_xpath("//a[@href='https://ide.c9.io/username/app']").click()

#content = client.page_source.encode('utf-8')
#print(content)
#client.quit()

{% endhighlight %}
