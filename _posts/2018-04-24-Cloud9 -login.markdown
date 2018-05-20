---
layout: post
title:  "Cloud9 登陆"
date:   2018-04-24 13:03:00
categories: computer config
---

```
// ==UserScript==
// @name           c9 auto login
// @namespace      http://xuiv.ga/
// @include        https://c9.io/login
// @description    c9 login
// @version 0.0.1.20180423135900
// ==/UserScript==
(function(_doc) {
    'use strict';

    // user and password
    var opts = {
        id : "user",
        pass: "password",
    };
    var loginForm = _doc.getElementsByTagName("form")[0];
    if(!loginForm) return;
	loginForm.elements.namedItem("username").value = opts.id;
	loginForm.elements.namedItem("password").value = opts.pass;
	loginForm.submit();
})(document);
```

```
// ==UserScript==
// @name         c9 auto login
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Cloud9 IDE login!
// @author       You
// @match        https://c9.io/login
// @grant        none
// ==/UserScript==

(function(_doc) {
    'use strict';

    // user and password
    var opts = {
        id : "user",
        pass: "password",
    };
    var loginForm = _doc.getElementsByTagName("form")[0];
    if(!loginForm) return;
    loginForm.elements.namedItem("username").value = opts.id;
    loginForm.elements.namedItem("password").value = opts.pass;
    loginForm.submit();
})(document);
```
