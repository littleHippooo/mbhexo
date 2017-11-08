---
title: Linux打包指令tar
date: 2017-04-17 10:24:07
tags: Linux
---
gzip, bzip2, xz 也能够针对目录来进行压缩，不过它们都是对目录下的文件逐个压缩的。而tar指令则可以将这些文件先打包成一个大文件，然后再进行压缩操作。

仅用tar命令打包不压缩的文件，称为tarfile，既打包又压缩的文件，如file.tar.gz则成为tarball。

tar指令的选项非常多，一般只是用几个常用的，基本语法如下：
<!--more-->
```bash
tar [-z|-j|-J] [cv] [-f 待建立的文件名] filename...    <==打包与压缩
tar [-z|-j|-J] [tv] [-f 已有的tar格式文件名]           <==查看文件名
tar [-z|-j|-J] [xv] [-f 已有的tar格式文件名] [-C 目录]  <==解压缩
选项与参数：
-c ：建立打包文件，可搭配 -v 来察看过程中被打包的档名(filename)
-t ：察看打包文件的内容含有哪些档名，重点在察看『档名』就是了；
-x ：解打包或解压缩的功能，可以搭配 -C (大写) 在特定目录解开。特别留意的是， -c, -t, -x 不可同时出现在一串指令列中。
-z ：透过 gzip 的支持进行压缩/解压缩：此时档名最好为 *.tar.gz
-j ：透过 bzip2 的支持进行压缩/解压缩：此时档名最好为 *.tar.bz2
-J ：透过 xz 的支持进行压缩/解压缩：此时档名最好为 *.tar.xz。特别留意， -z, -j, -J 不可以同时出现在一串指令列中
-v ：在压缩/解压缩的过程中，将正在处理的文件名显示出来！
-f filename：-f 后面要立刻接要被处理的档名！建议 -f 单独写一个选项
-C 目录 ：这个选项用在解压缩，若要在特定目录解压缩，可以使用这个选项。
-p(小写) ：保留备份数据的原本权限与属性，常用于备份(-c)重要的配置文件
-P(大写) ：保留绝对路径，亦即允许备份数据中含有根目录存在之意；
--exclude=FILE：在压缩的过程中，不要将 FILE 打包！
```
一般来说，tar命令只要记住下面这个范例就行了：

压 缩：`tar -jcv -f filename.tar.bz2`要被压缩的文件或目录名称

查 询：`tar -jtv -f filename.tar.bz2`

解压缩：`tar -jxv -f filename.tar.bz2 -C`欲解压缩的目录

filename.tar.bz2 是我们自己取的文件名，tar 并不会自动帮我们生成打包压缩后的文件名。文件命名最好符合规范。示例：
## 使用tar命令打包/etc/目录，然后使用`-z`，`-j`，`-J`选项进行压缩，并观察结果与耗时
```bash
root@ubuntu:/temp# time tar -zpcv -f etc.tar.gz /etc
tar: Removing leading `/' from member names
/etc/
/etc/ucf.conf
/etc/selinux/
/etc/selinux/semanage.conf
...
 
real	0m0.848s  //耗时0.848秒
user	0m0.456s
sys	0m0.080s
   
root@ubuntu:/temp# time tar -jpcv -f etc.tar.bz2 /etc
tar: Removing leading `/' from member names
/etc/
/etc/ucf.conf
/etc/selinux/
/etc/selinux/semanage.conf
...
 
real	0m1.781s  //耗时1.781秒
user	0m1.220s
sys	0m0.060s
 
root@ubuntu:/temp# time tar -Jpcv -f etc.tar.xz /etc
 
real	0m7.700s  //耗时7.700秒
user	0m5.428s
sys	0m0.456s
```
## 查阅 tar 文件的数据内容
```bash
root@ubuntu:/temp# tar -ztv -f etc.tar.gz 
drwxr-xr-x root/root         0 2017-04-13 09:31 etc/
-rw-r--r-- root/root      1260 2016-03-17 04:58 etc/ucf.conf
drwxr-xr-x root/root         0 2016-04-21 06:07 etc/selinux/
...
```
可发现，每个文件名都没了根目录。正如备份的时候出现的警告：tar: Removing leading `/' from member names那样。这种做法主要是为了防止解压缩的时候出现覆盖源文件的情况。

{% note danger %}如果要保留文件的根目录/，则可以使用`-P`（大写）选项。{% endnote %}
## 指定目录解压缩
如果直接在当前目录下执行命令：`tar -jxv -f /root/etc.tar.bz2`，则目录下会多出个etc的目录。如果要指定解压缩的目录，可以使用`-C`选项。如将/temp/etc.tar.gz解压到/tmp目录下
```bash
root@ubuntu:/temp# tar -zxv -f etc.tar.gz -C /tmp
```
## 指定解压某个文件
除了一次性全部解压，我们还可以指定解压某个文件。比如我要解压etc.tar.gz下的etc/shadow，可以使用如下命令：
```bash
root@ubuntu:/temp# tar -zxv -f etc.tar.gz etc/shadow
etc/shadow
```
## 打包某目录，但不含该目录下的某些文件
比如我想打包/etc目录，但是不想包含目录下的ppp和qqq文件：
```bash
root@ubuntu:/temp# tar -zcv -f etc.tar.gz --exclude=/etc/ppp --exclude=/etc/qqq /etc
```
或者：
```bash
root@ubuntu:/temp# vi exclude-file
```
里面输入
```bash
/etc/ppp
/etc/qqq
```
然后使用命令：
```bash
root@ubuntu:/temp# tar -zcvf etc.tar.gz --exclude-from exclude-file /etc
```
## 仅备份比某个时刻还要新的文件
比如，仅备份比/etc/passwd文件新的文件（mtime）：
```bash
root@ubuntu:/temp# ls -l /etc/passwd
-rw-r--r-- 1 root root 2243 Apr 13 09:30 /etc/passwd
root@ubuntu:/temp# tar -zcv -f etc.newer.passwd.tar.gz --newer-mtime="2017/04/13 09:30" /etc/*
tar: Option --newer-mtime: Treating date '2017/04/13 09:30' as 2017-04-13 09:30:00
tar: Removing leading `/' from member names
/etc/acpi/
tar: /etc/acpi/asus-wireless.sh: file is unchanged; not dumped
tar: /etc/acpi/asus-keyboard-backlight.sh: file is unchanged; not dumped
...
```

> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记