---
title: BOM location
date: 2016-12-12 15:41:50
tags: JavaScript
---
使用location 对象可以通过很多方式来改变浏览器的位置。如：
```javascript
location.assign("http://www.wrox.com");
```
或：
```javascript
window.location = "http://www.wrox.com";
location.href = "http://www.wrox.com";
```
<!--more-->
另外，修改location 对象的其他属性也可以改变当前加载的页面。下面的例子展示了通过将hash、search、hostname、pathname 和port 属性设置为新值来改变URL。
```javascript
//假设初始URL 为http://www.wrox.com/WileyCDA/
 
//将URL 修改为"http://www.wrox.com/WileyCDA/#section1"
location.hash = "#section1";
 
//将URL 修改为"http://www.wrox.com/WileyCDA/?q=javascript"
location.search = "?q=javascript";
 
//将URL 修改为"http://www.yahoo.com/WileyCDA/"
location.hostname = "www.yahoo.com";
 
//将URL 修改为"http://www.yahoo.com/mydir/"
location.pathname = "mydir";
 
//将URL 修改为"http://www.yahoo.com:8080/WileyCDA/"
location.port = 8080;
```
使用`location.replace(url)`会导致浏览器位置改变，但不会在历史记录中生成新记录。"后退"按钮将不可点击。

reload()：
```javascript
location.reload(); //重新加载（有可能从缓存中加载）
location.reload(true); //重新加载（从服务器重新加载）
```
