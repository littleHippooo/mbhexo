---
title: Linux常用压缩指令
date: 2017-04-17 08:52:57
tags: Linux
---
Linux 上常见的压缩指令有 `gzip`，`bzip2` 以及最新的 `xz`。压缩率从高到底为xz，bzip2，gzip。压缩率越高，压缩所花的时间就越长。所以实际工作中需要根据具体情况在压缩率和压缩时间中做出抉择。

以下为几个常见的压缩文件扩展名：
```bash
*.Z         compress 程序压缩的文件；
*.zip       zip 程序压缩的文件；
*.gz        gzip 程序压缩的文件；
*.bz2       bzip2 程序压缩的文件；
*.xz        xz 程序压缩的文件；
*.tar       tar 程序打包的数据，并没有压缩过；
*.tar.gz    tar 程序打包的文件，其中并且经过 gzip 的压缩
*.tar.bz2   tar 程序打包的文件，其中并且经过 bzip2 的压缩
*.tar.xz    tar 程序打包的文件，其中并且经过 xz 的压缩
```
<!--more-->
`compress`指令已经过时了，取而代之的是`gzip`。
## gzip, zcat/zmore/zless/zgrep
`gzip`可以解开 `compress`，`zip` 与 `gzip` 等软件所压缩 的文件。 `gzip` 所建立的压缩文件为 *.gz，`gzip`语法：
```bash
gzip [-cdtv#] 文件名
zcat 文件名.gz
选项与参数：
-c ：将压缩的数据输出到屏幕上，可透过数据流重导向来处理；
-d ：解压缩的参数；
-t ：可以用来检验一个压缩文件的一致性～看看文件有无错误；
-v ：可以显示出原文件/压缩文件案的压缩比等信息；
-# ：# 为数字的意思，代表压缩等级，-1 最快，但是压缩比最差、-9 最慢，但是压缩比最好！预设是 -6
```
示例：

使用`gzip`压缩/temp/services文件，并查看压缩比：
```bash
root@ubuntu:/temp# gzip -v services 
services:	 61.6% -- replaced with services.gz
root@ubuntu:/temp# ls -lh /etc/services services.gz 
-rw-r--r-- 1 root root  20K Oct 25  2014 /etc/services
-rw-r--r-- 1 root root 7.4K Apr 17 16:15 services.gz
```
因为services是文本文件，所以可以使用`zcat`/`zmore`/`zless` 去读取 ：
```bash
root@ubuntu:/temp# zcat services.gz 
# Network services, Internet style
#
# Note that it is presently the policy of IANA to assign a single well-known
# port number for both TCP and UDP; hence, officially ports have two entries
# even if the protocol doesn't support UDP operations.
...
```
将services.gz解压缩：
```bash
root@ubuntu:/temp# gzip -d services.gz 
```
使用`gzip`指令以最好的压缩比压缩services，并保留原文件：
```bash
gzip -9 -c services > services.gz
```
`-c` 可以将原本要转成压缩文件的资料内容，将它变成文字类型从屏幕输出， 然后我们可以透过大于 (`>`) 这个符号，将原本应该由屏幕输出的数据，转成输出到文件而不是屏幕，所以就能够建立出压缩文件了。只是文件名也要自己写， 当然最好还是遵循 gzip 的压缩文件名规范。
## bzip2, bzcat/bzmore/bzless/bzgrep
`bzip2`则是为了取代 `gzip` 并提供更佳的压缩比而来的，语法和`gzip`差不多：
```bash
bzip2 [-cdkzv#] 文件名
bzcat 文件名.bz2
选项与参数：
-c ：将压缩的过程产生的数据输出到屏幕上。
-d ：解压缩的参数。
-k ：保留源文件，而不会删除原始的文件。
-z ：压缩的参数 (默认值，可以不加)。
-v ：可以显示出原文件/压缩文件案的压缩比等信息。
-# ：与 gzip 同样的，都是在计算压缩比的参数， -9 最佳， -1 最快！
```
示例：

使用`bzip2`命令压缩services文件：
```bash
root@ubuntu:/temp# bzip2 -v services
  services:  2.712:1,  2.950 bits/byte, 63.13% saved, 19605 in, 7229 out.
```
## xz, xzcat/xzmore/xzless/xzgrep
`bzip2` 已经具有很棒的压缩比，不过显然某些自由软件开发者还不满足，因此后来还推出了 `xz` 这个压缩比更高的软件。`xz`的语法：
```bash
xz [-dtlkc#] 文件名
xcat 文件名.xz
选项与参数：
-d ：就是解压缩
-t ：测试压缩文件的完整性，看有没有错误
-l ：列出压缩文件的相关信息
-k ：保留原本的文件不删除
-c ：同样的，就是将数据由屏幕上输出的意思
-# ：同样的，也有较佳的压缩比的意思
```
## 对比
分别使用`gzip`，`bzip2`和`xz`命令默认压缩比对service文件进行压缩，并查看时间：
```bash
root@ubuntu:/temp# time gzip -c services > services.gz;time bzip2 -k services;time xz -k services
 
real	0m0.003s
user	0m0.000s
sys	0m0.000s
 
real	0m0.004s
user	0m0.000s
sys	0m0.000s
 
real	0m0.076s
user	0m0.016s
sys	0m0.020s
```
查看压缩后的文件大小：
```bash
root@ubuntu:/temp# ls -l services services.gz services.bz2 services.xz 
-rw-r--r-- 1 root root 19605 Apr 17 16:42 services
-rw-r--r-- 1 root root  7554 Apr 17 16:43 services.gz
-rw-r--r-- 1 root root  7229 Apr 17 16:42 services.bz2
-rw-r--r-- 1 root root  7156 Apr 17 16:42 services.xz
```
> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记