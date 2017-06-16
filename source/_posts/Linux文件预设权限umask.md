---
title: Linux文件预设权限umask
date: 2017-04-13 15:53:26
tags: Linux
---
当我们在Linux下创建一个新的目录或文件的时候，它都会有个默认的权限。这个权限的设定和`umask`有关，umask指的是：目前用户在建立文件或目录时候的权限默认值。

查阅当前用户umask方式有两种，一种可以直接输入 umask ，就可以看到数字型态的权限设定分数， 一种则是 加入 `-S (Symbolic)` 这个选项，就会以符号类型的方式来显示出权限了：
```bash
root@ubuntu:~# umask
0022
root@ubuntu:~# umask -S
u=rwx,g=rx,o=rx
```
<!--more-->
umask的第一个值为特殊权限。剩下的三个值分别就代表了r，w，x了。Linux中，文件的预设权限为`-rw-rw-rw-`，目录的预设权限为`drwxrwxrwx`。

{% note danger %}要注意的是，umask 的分数指的是该默认值需要减掉的权限！{% endnote %}

所以如果`umask`的值为022的时候，在创建新文件或目录的时候，其权限的计算方式为：

1. 建立文件时：(-rw-rw-rw-) - (-----w--w-) ==> -rw-r--r--

2. 建立目录时：(drwxrwxrwx) - (-----w--w-) ==> drwxr-xr-x

验证一下：
```bash
root@ubuntu:~# cd /temp
root@ubuntu:/temp# umask
0022
root@ubuntu:/temp# touch file1
root@ubuntu:/temp# mkdir dir1
root@ubuntu:/temp# ls -ld file1 dir1
drwxr-xr-x 2 root root 4096 Apr 13 14:35 dir1
-rw-r--r-- 1 root root    0 Apr 13 14:35 file1
```
改变umask的值：
```bash
root@ubuntu:/temp# umask 033
root@ubuntu:/temp# umask
0033
```
> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记