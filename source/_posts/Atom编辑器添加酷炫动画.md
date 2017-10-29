---
title: Atom编辑器添加酷炫动画
date: 2016-03-18 19:06:51
tags: Atom
---
由于没有安装完整依赖库或者那堵伟大的墙的原因，使得原本只是安装一个Package的操作变得不那么简单。这里介绍一种100%安装成功的方法：

1.首先安装node.js：[https://nodejs.org/en/](https://nodejs.org/en/)。

2.然后下载 activate-power-mode-master 并解压到 C:\Users\Administrator\\.atom\packages目录下。

3.使用CMD命令切换到activate-power-mode-master文件夹下，执行npm命令：

<!--more-->
```bash
C:\Users\Administrator\.atom\packages\activate-power-mode-master>npm install lodash
C:\Users\Administrator\.atom\packages\activate-power-mode-master>npm install lodash.random
C:\Users\Administrator\.atom\packages\activate-power-mode-master>npm install lodash.throttle
```
执行命令之后，打开Atom编辑器，Ctrl+Alt+O开启就可以看到酷炫的动画啦。

如果想关闭震动效果的话，修改activate-power-mode-master/lib/activate-power-mode.coffee文件68行为：
```javascript
if @getConfig "screenShake.disabled"    
```
附上一张效果图：

![44215495-file_1487994346574_e1c1.gif](img/44215495-file_1487994346574_e1c1.gif)
