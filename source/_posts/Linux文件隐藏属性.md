---
title: Linux文件隐藏属性
date: 2017-04-13 14:37:28
tags: Linux
---
Linux文件或目录除了`rwxrwxrwx`九个权限设定外，还有隐藏的属性。设置文件或目录的隐藏属性可以指令`chattr`，而显示文件或目录的隐藏属性则用指令`lsattr`。
<!--more-->
## chattr：
语法：
```bash
chattr [+-=][ASacdistu] 文件或目录名称
选项与参数：
+ ：增加某一个特殊参数，其他原本存在参数则不动。
- ：移除某一个特殊参数，其他原本存在参数则不动。
= ：设定一定，且仅有后面接的参数
A ：当设定了 A 这个属性时，若你有存取此文件(或目录)时，他的访问时间 atime 将不会被修改，可避免 I/O 较慢的机器过度的存取磁盘。
S ：一般文件是异步写入磁盘的，如果加上 S 这个属性时，当你进行任何文件的修改，该更动会『同步』写入磁盘中。
a ：当设定 a 之后，这个文件将只能增加数据，而不能删除也不能修改数据，只有 root 才能设定这属性
c ：这个属性设定之后，将会自动的将此文件『压缩』，在读取的时候将会自动解压缩，但是在储存的时候，将会先进行压缩后再储存。
d ：当 dump 程序被执行的时候，设定 d 属性将可使该文件(或目录)不会被 dump 备份
i ：他可以让一个文件『不能被删除、改名、设定连结也无法写入或新增数据』对于系统安全性有相当大的帮助。只有 root 能设定此属性。
s ：当文件设定了 s 属性时，如果这个文件被删除，他将会被完全的移除出这个硬盘空间，所以如果误删了，完全无法救回来了。
u ：与 s 相反的，当使用 u 来配置文件案时，如果该文件被删除了，则数据内容其实还存在磁盘中，可以使用来救援该文件。
注意 1：属性设定常见的是 a 与 i 的设定值，而且很多设定值必须要身为 root 才能设定。
注意 2：xfs 文件系统仅支援 AadiS 而已。
```
示例：

在/temp下新建一个文件，并加入`i`选项，然后尝试删除：
```bash
root@ubuntu:/temp# touch file2
root@ubuntu:/temp# chattr +i file2
root@ubuntu:/temp# rm file2
rm: cannot remove 'file2': Operation not permitted
```
操作被拒绝，只有移除`i`选项后，才能够删除：
```bash
root@ubuntu:/temp# chattr -i file2
root@ubuntu:/temp# rm file2
```
## lsattr：
语法：
```bash
lsattr [-adR] 文件或目录
选项与参数：
-a ：将隐藏文件的属性也秀出来；
-d ：如果接的是目录，仅列出目录本身的属性而非目录内的文件名；
-R ：连同子目录的数据也一并列出来。
```
示例：
```bash
root@ubuntu:/temp# touch file2
root@ubuntu:/temp# chattr +iA file2
root@ubuntu:/temp# lsattr file2
----i--A-----e-- file2
```
> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记