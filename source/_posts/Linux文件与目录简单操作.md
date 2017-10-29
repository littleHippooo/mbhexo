---
title: Linux文件与目录简单操作
date: 2017-04-10 17:03:52
tags: Linux
---
Linux下几个特殊的目录：
```bash
.        代表此层目录
..       代表上一层目录
-        代表前一个工作目录
~        代表『目前用户身份』所在的家目录
~mrbird  代表 mrbird 这个用户的家目录
```
<!--more-->
## 目录相关操作
几个常见的处理目录的指令：

`cd`：变换目录；`pwd`：显示当前目录；`mkdir`：建立一个新的目录；`rmdir`：删除一个空的目录。

### cd (change directory, 变换目录)：
```bash
#切换到var目录下
mrbird@ubuntu:~$ cd /var
#回到刚刚那个目录
mrbird@ubuntu:/var$ cd -
/home/mrbird
#切换到用户mrbird的家目录
mrbird@ubuntu:~$ cd ~mrbird
#上一层目录
mrbird@ubuntu:~$ cd ..
#当前目录
mrbird@ubuntu:/home$ cd .
```
### pwd (Print Working Directory，显示目前所在的目录)：
语法：
```bash
pwd [-P]
选项与参数：
-P ：显示出确实的路径，而非使用链接 (link) 路径。
```
示例：
```bash
root@ubuntu:/home/mrbird# pwd
/home/mrbird
root@ubuntu:/home/mrbird# cd /var/lock
root@ubuntu:/var/lock# pwd
/var/lock
root@ubuntu:/var/lock# pwd -P
/run/lock
```
加入`-p`选项后，显示出了/var/lock的真实路径，因为它是个链接档。
### mkdir (make directory，建立新目录)：

语法：
```bash
mkdir [-mp] 目录名称
选项与参数：
-m ：配置文件案的权限！直接设定，不需要看预设权限 (umask) 的脸色
-p ：帮助你直接将所需要的目录(包含上层目录)递归建立起来。﻿​
```
示例：
```bash
#创建目录temp
root@ubuntu:~# mkdir /temp
root@ubuntu:~# cd /temp
#直接创建多层级目录报错
root@ubuntu:/temp# mkdir test1/test2/test3
mkdir: cannot create directory 'test1/test2/test3': No such file or directory
#加入-p递归创建
root@ubuntu:/temp# mkdir -p test1/test2/test3
#创建目录test2，权限为711
root@ubuntu:/temp# mkdir -m 711 test2
root@ubuntu:/temp# ls -al
total 16
...
drwx--x--x  2 root root 4096 Apr 11 18:43 test2
```
### rmdir (删除『空』的目录)：

语法：
```bash
rmdir [-p] 目录名称
选项与参数：
-p ：连同『上层』『空的』目录也一起删除
```
示例：
```bash
#删除空目录test2
root@ubuntu:/temp# rmdir test2
root@ubuntu:/temp# ls
test1
#删除非空目录test1，提示无法删除
root@ubuntu:/temp# rmdir test1
rmdir: failed to remove 'test1': Directory not empty
#使用-p递归删除
root@ubuntu:/temp# rmdir -p test1/test2/test3
root@ubuntu:/temp# ls
```
## 文件与目录管理
相关的命令有：

`ls`：显示属性；`cp`：拷贝；`rm`：删除文件；`mv`移动目录或文件等。
### ls（list）文件与目录的检视：
语法：
```bash
ls [-aAdfFhilnrRSt] 文件名或目录名称..
ls [--color={never,auto,always}] 文件名或目录名称..
ls [--full-time] 文件名或目录名称..
选项与参数：
-a ：全部的文件，连同隐藏档( 开头为 . 的文件) 一起列出来(常用)
-A ：全部的文件，连同隐藏档，但不包括 . 与 .. 这两个目录
-d ：仅列出目录本身，而不是列出目录内的文件数据(常用)
-f ：直接列出结果，而不进行排序 (ls 预设会以档名排序！)
-F ：根据文件、目录等信息，给予附加数据结构，例如：
 *:代表可执行文件； /:代表目录； =:代表 socket 文件； |:代表 FIFO 文件；
-h ：将文件容量以人类较易读的方式(例如 GB, KB 等等)列出来；
-i ：列出 inode 号码，inode 的意义下一章将会介绍；
-l ：长数据串行出，包含文件的属性与权限等等数据；(常用)
-n ：列出 UID 与 GID 而非使用者与群组的名称 (UID 与 GID 会在账号管理提到！)
-r ：将排序结果反向输出，例如：原本档名由小到大，反向则为由大到小；
-R ：连同子目录内容一起列出来，等于该目录下的所有文件都会显示出来；
-S ：以文件容量大小排序，而不是用档名排序；
-t ：依时间排序，而不是用档名。
--color=never ：不要依据文件特性给予颜色显示；
--color=always ：显示颜色
--color=auto ：让系统自行依据设定来判断是否给予颜色
--full-time ：以完整时间模式 (包含年、月、日、时、分) 输出
--time={atime,ctime} ：输出 access 时间或改变权限属性时间 (ctime)
 而非内容变更时间 (modification time)
```
`ls`命令很常用，这里仅示例`--color`，`--full-time`，`--time`参数：

`--color`参数的使用：

![21476661-file_1491962046290_e17a.png](img/21476661-file_1491962046290_e17a.png)

`ls`默认显示根据文件特性显示颜色，可以使用`--color=never`关闭！

`--full-time`参数的使用：
```bash
root@ubuntu:/var# ls --full-time
total 48
drwxr-xr-x  2 root root     4096 2017-04-11 18:07:45.485003705 -0700 backups
drwxr-xr-x 15 root root     4096 2017-04-11 03:49:17.681766424 -0700 cache
drwxrwsrwt  2 root whoopsie 4096 2017-04-11 04:17:29.961240226 -0700 crash
drwxr-xr-x 64 root root     4096 2017-04-11 04:56:56.702320395 -0700 lib
drwxrwsr-x  2 root staff    4096 2016-04-12 13:14:23.000000000 -0700 local
...
```
该完整的呈现了文件的修改时间 (modification time)。
### cp（copy）复制文件或目录：
语法：
```bash
[root@study ~]# cp [-adfilprsu] 来源文件(source) 目标文件(destination)
[root@study ~]# cp [options] source1 source2 source3 .... directory
选项与参数：
-a ：相当于 -dr --preserve=all 的意思，至于 dr 请参考下列说明；(常用)
-d ：若来源文件为链接文件的属性(link file)，则复制链接文件属性而非文件本身；
-f ：为强制(force)的意思，若目标文件已经存在且无法开启，则移除后再尝试一次；
-i ：若目标文件(destination)已经存在时，在覆盖时会先询问动作的进行(常用)
-l ：进行硬式连结(hard link)的连结档建立，而非复制文件本身；
-p ：连同文件的属性(权限、用户、时间)一起复制过去，而非使用默认属性(备份常用)；
-r ：递归持续复制，用于目录的复制行为；(常用)
-s ：复制成为符号链接文件 (symbolic link)，亦即『快捷方式』文件；
-u ：destination 比 source 旧才更新 destination，或 destination 不存在的情况下才复制。
--preserve=all ：除了 -p 的权限相关参数外，还加入 SELinux 的属性, links, xattr 等也复制了。
     最后需要注意的，如果来源档有两个以上，则最后一个目的文件一定要是『目录』才行。
```
不同权限用户使用`cp`命令会产生不同的结果，下面举几个实例：
```bash
#用 root 身份，将家目录下的 .bashrc 复制到 /tmp 下，并更名为 bashrc
root@ubuntu:~# cp ~/.bashrc /temp/bashrc
#使用-i选项，当目标文件已经存在时，会进行操作询问
root@ubuntu:~# cp -i ~/.bashrc /temp/bashrc
cp: overwrite '/temp/bashrc'? y        <==n 不覆盖，y 为覆盖
 
root@ubuntu:/var/log# cd /temp
#复制/var/log/wtmp 到当前（/temp）目录，别忘记了加.
root@ubuntu:/temp# cp /var/log/wtmp .
root@ubuntu:/temp# ls
bashrc  wtmp
 
#使用ls -l命令观察源文件和复制文件的权限，可见两者并不一致
root@ubuntu:/temp# ls -l /var/log/wtmp wtmp
-rw-rw-r-- 1 root utmp 8448 Apr 11 18:11 /var/log/wtmp
-rw-r--r-- 1 root root 8448 Apr 11 19:08 wtmp
#使用-a选项，连同权限一起复制
root@ubuntu:/temp# cp -a /var/log/wtmp wtmp1
root@ubuntu:/temp# ls -l /var/log/wtmp wtmp wtmp1
-rw-rw-r-- 1 root utmp 8448 Apr 11 18:11 /var/log/wtmp
-rw-r--r-- 1 root root 8448 Apr 11 19:08 wtmp
-rw-rw-r-- 1 root utmp 8448 Apr 11 18:11 wtmp1
 
#配合-r选项将/var/log/目录下的所有内容复制到/temp目录下
root@ubuntu:/temp# cp -ar /var/log/ .
root@ubuntu:/temp# ls
bashrc  log  wtmp  wtmp1
root@ubuntu:/temp# ls log
Xorg.0.log        auth.log       dmesg      gpu-manager.log    lightdm  
...
 
#建立一个bashrc文件的连结档 (symbolic link)
root@ubuntu:/temp# cp -s bashrc bashrc_slink
root@ubuntu:/temp# cp -l bashrc bashrc_hlink
root@ubuntu:/temp# ls -l
total 36
-rw-r--r--  2 root root   3106 Apr 11 19:04 bashrc
-rw-r--r--  2 root root   3106 Apr 11 19:04 bashrc_hlink
lrwxrwxrwx  1 root root      6 Apr 11 19:24 bashrc_slink -> bashrc
...
```
最后一个例子中，使用 `-l` 及 `-s` 都会建立所谓的连结档(link file)，但是这两种连结档却有不一样的情况。那个 `-l` 就是所谓的实体链接(hard link)，至于 `-s` 则是符号链接(symbolic link)， 简单来说，bashrc_slink 是一个『快捷方式』，这个快捷方式会连结到 bashrc 去。所以你会看到档名右侧会有个指向(->)的符号。bashrc_hlink 文件与 bashrc 的属性与权限完全一模一样，与尚未进行连结前的差异则是第二栏的 link 数由 1 变成 2。
### rm（remove）移除文件或目录：
语法：
```bash
rm [-fir] 文件或目录
选项与参数：
-f ：就是 force 的意思，忽略不存在的文件，不会出现警告讯息；
-i ：互动模式，在删除前会询问使用者是否动作
-r ：递归删除，这是非常危险的选项！！
```
示例：
```bash
#删除/temp目录下的bashrc文件
root@ubuntu:/temp# rm -i bashrc
rm: remove regular file 'bashrc'? y
 
#删除/temp/log目录
root@ubuntu:/temp# rmdir log
rmdir: failed to remove 'log': Directory not empty
#非空目录，使用rm -r命令递归删除，无需询问的话去掉-i选项即可
root@ubuntu:/temp# rm -ri log
rm: descend into directory 'log'? y
rm: descend into directory 'log/vmware'? y
rm: remove regular file 'log/vmware/rc.local.log'? ^C
 
#删除一个带有 - 开头的文件
root@ubuntu:/temp# touch ./-aaa-
root@ubuntu:/temp# ls
-aaa-  bashrc_hlink  bashrc_slink  log  wtmp  wtmp1
root@ubuntu:/temp# rm -aaa-
rm: invalid option -- 'a'
Try 'rm ./-aaa-' to remove the file '-aaa-'.  <== bash给的建议
Try 'rm --help' for more information.
#因为-是选项的意思，系统误判，使用转义符解决：
root@ubuntu:/temp# rm ./-aaa-
root@ubuntu:/temp# ls
bashrc_hlink  bashrc_slink  log  wtmp  wtmp1
```
最后一个例子中，使用命令`rm -- -aaa-`也可以删除-aaa-文件。
### mv（move）移动文件与目录，或重命名：
语法：
```bash
mv [-fiu] source destination
mv [options] source1 source2 source3 .... directory
选项与参数：
-f ：force 强制的意思，如果目标文件已经存在，不会询问而直接覆盖；
-i ：若目标文件 (destination) 已经存在时，就会询问是否覆盖！
-u ：若目标文件已经存在，且 source 比较新，才会更新 (update)
```
示例：
```bash
#在/temp下新建目录tmp，然后将bashrc文件移动到该目录下
root@ubuntu:/temp# mkdir tmp
root@ubuntu:/temp# mv bashrc tmp
root@ubuntu:/temp# ls
bashrc_hlink  bashrc_slink  log  tmp  wtmp  wtmp1
root@ubuntu:/temp# ls tmp
bashrc
 
#将目录tmp重命名为tmp1
root@ubuntu:/temp# mv tmp tmp1
root@ubuntu:/temp# ls
bashrc_hlink  bashrc_slink  log  tmp1  wtmp  wtmp1
 
#将log目录下的wtmp和vmware文件一起移动到tmp1目录下
root@ubuntu:/temp# mv log/wtmp log/vmware tmp1
root@ubuntu:/temp# ls tmp1
bashrc  vmware  wtmp
```
## 查看文件类型

如果你想要知道某个文件的基本数据，例如是属于ASCII 或者是data 文件，或者是 binary等，可以利用 `file` 这个指令来查看：
```bash
mrbird@ubuntu:/temp$ file bashrc_hlink 
bashrc_hlink: ASCII text
mrbird@ubuntu:/temp$ file wtmp
wtmp: data
mrbird@ubuntu:/temp$ file /usr/bin/passwd 
/usr/bin/passwd: setuid ELF 64-bit LSB shared object, x86-64, version 1 (SYSV),
dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=40a9016718f4247f09acc62e1bbf056372bf31f5, stripped
```
> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记