---
title: Linux文件时间类型
date: 2017-04-12 16:10:58
tags: Linux
---
Linux文件有三个主要的变动时间：

`modification time (mtime)`： 当该文件的『内容数据』变更时，就会更新这个时间。内容数据指的是文件的内容，而不是文件的属性或权限。

`status time (ctime)`： 当该文件的『状态 (status)』改变时，就会更新这个时间，举例来说，像是权限与属性被更改了，都会更新这个时间。

`access time (atime)`： 当『该文件的内容被取用』时，就会更新这个读取时间 (atime)。举例来说，我们使用 cat 去读取/etc/ltrace.conf， 就会更新该文件的atime 。
<!--more-->

查看/etc/ltrace.conf文件的相关时间：
```bash
root@ubuntu:/home/mrbird# date;ls -l /etc/ltrace.conf;ls -l --time=atime /etc/ltrace.conf;ls -l --time=ctime /etc/ltrace.conf 
Wed Apr 12 02:32:27 PDT 2017
-rw-r--r-- 1 root root 14867 Apr 11  2016 /etc/ltrace.conf
-rw-r--r-- 1 root root 14867 Apr 12 00:31 /etc/ltrace.conf
-rw-r--r-- 1 root root 14867 Apr 11 03:20 /etc/ltrace.conf
```
默认的情况下，`ls` 显示出来的是该文件的 mtime。要修改文件相关时间属性，可以使用`touch`指令。

语法：
```bash
touch [-acdmt] 文件
选项与参数：
-a ：仅修订 access time；
-c ：仅修改文件的时间，若该文件不存在则不建立新文件；
-d ：后面可以接欲修订的日期而不用目前的日期，也可以使用 --date="日期或时间"
-m ：仅修改 mtime ；
-t ：后面可以接欲修订的时间而不用目前的时间，格式为[YYYYMMDDhhmm]
```
新建一个空文件，并查看其时间：
```bash
root@ubuntu:/temp# touch testouch
root@ubuntu:/temp# ls -l testouch
-rw-r--r-- 1 root root 0 Apr 12 02:40 testouch
```
修改testouch的mtime为两天前：
```bash
root@ubuntu:/temp# ls -l testouch
-rw-r--r-- 1 root root 0 Apr 10 02:45 testouch
```
修改testouch的atime为2017/01/01 00:00：
```bash
root@ubuntu:/temp# touch -a -t 201701010000 testouch 
root@ubuntu:/temp# ls -l --time=atime testouch 
-rw-r--r-- 1 root root 0 Jan  1 00:00 testouch
```
> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记