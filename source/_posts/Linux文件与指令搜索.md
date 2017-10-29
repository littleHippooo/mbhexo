---
title: Linux文件与指令搜索
date: 2017-04-14 15:23:21
tags: Linux
---
当我们要对Linux下的某个文件做修改的时候，必须先知道文件的位置，这时候就可以使用文件搜索指令来完成。而指令的搜索则可以知道该指令文件的实际存放位置。
## 指令搜索
### which

通过which可以知道指令的完整文件名放在哪里。语法：
```bash
which [-a] command
选项或参数：
-a ：将所有由 PATH 目录中可以找到的指令均列出，而不止第一个被找到的指令名称
```
<!--more-->
简单示例：
```bash
mrbird@ubuntu:~$ which ls
/bin/ls
mrbird@ubuntu:~$ which passwd
/usr/bin/passwd
mrbird@ubuntu:~$ which which
/usr/bin/which
```
`type`指令也可以实现指令搜索：
```bash
mrbird@ubuntu:~$ type passwd
passwd is hashed (/usr/bin/passwd)
mrbird@ubuntu:~$ type which
which is hashed (/usr/bin/which)
```
## 文件档名的搜寻
### whereis (由一些特定的目录中寻找文件文件名)：
`whereis` 只找系统中某些特定目录底下的文件 ，基本语法：
```bash
whereis [-bmsu] 文件或目录名
选项与参数：
-l :可以列出 whereis 会去查询的几个主要目录而已
-b :只找 binary 格式的文件
-m :只找在说明文件 manual 路径下的文件
-s :只找 source 来源文件
-u :搜寻不在上述三个项目当中的其他特殊文件
```
示例：
```bash 
#查看whereis搜寻的目录：
mrbird@ubuntu:~$ whereis -l
bin: /usr/bin
bin: /usr/sbin
bin: /usr/lib
bin: /bin
bin: /sbin
bin: /etc
bin: /lib
bin: /lib64
...
 
mrbird@ubuntu:~$ whereis passwd
passwd: /usr/bin/passwd /etc/passwd /usr/share/man/man1/passwd.1ssl.gz /usr/share/man/man1/passwd.1.gz /usr/share/man/man5/passwd.5.gz
#只查找在说明文件 manual 路径下的文件
mrbird@ubuntu:~$ whereis -m passwd
passwd: /usr/share/man/man1/passwd.1ssl.gz /usr/share/man/man1/passwd.1.gz /usr/share/man/man5/passwd.5.gz
```
### locate / updatedb：
`locate`则是利用数据库来搜寻文件名，并且没有实际的搜寻硬盘内的文件系统态。

`locate`语法：
```bash
locate [-ir] keyword
选项与参数：
-i ：忽略大小写的差异；
-c ：不输出档名，仅计算找到的文件数量
-l ：仅输出几行的意思，例如输出五行则是 -l 5
-S ：输出 locate 所使用的数据库文件的相关信息，包括该数据库纪录的文件/目录数量等
-r ：后面可接正规表示法的显示方式
```
示例：
```bash
#找出系统中所有与passwd相关的档名，且只列出5个
mrbird@ubuntu:~$ locate -l 5 passwd
/etc/passwd
/etc/passwd-
/etc/cron.daily/passwd
/etc/init/passwd.conf
/etc/pam.d/chpasswd
 
#列出locate查询所使用的数据库文件之文件名与各数据数量
mrbird@ubuntu:~$ locate -S
Database /var/lib/mlocate/mlocate.db:
	22,021 directories
	218,810 files
	11,880,406 bytes in file names
	5,267,885 bytes used to store database
```
为 `locate` 寻找的数据是由已建立的数据库 /var/lib/mlocate/里面的数据所搜寻到的， 所以不用直接在去硬盘当中存取数据。而数据库的建立默认是在每天执行一次，所以当你新建立起来的文件， 却还在数据库更新之前搜寻该文件，那么 `locate` 会告诉你找不到！可以使用`updatedb`指令手动更新数据库，因为 `updatedb` 会去搜寻硬盘，所以当你执行 `updatedb` 时，可能会等待数分钟的时间。
### find：
`find`指令直接搜索硬盘，所以具体搜索时间根据硬盘性能而定。基本语法：

与时间有关的选项：
```bash
find [PATH] [option] [action]
选项与参数：
1. 与时间有关的选项：共有 -atime, -ctime 与 -mtime ，以 -mtime 说明
 -mtime n ：n 为数字，意义为在 n 天之前的『一天之内』被更动过内容的文件；
 -mtime +n ：列出在 n 天之前(不含 n 天本身)被更动过内容的文件档名；
 -mtime -n ：列出在 n 天之内(含 n 天本身)被更动过内容的文件档名。
 -newer file ：file 为一个存在的文件，列出比 file 还要新的文件档名
```
举个例子，当n为4时：

+4 代表大于等于 5 天前的档名；-4 代表小于等于 4 天内的文件档名； 4 则是代表 4-5 那一天的文件档名。

示例：
```bash
#列出24小时内有更改过内容（mtime）的文件档名：
root@ubuntu:~# find / -mtime 0
 
#寻找/etc底下的文件，如果文件日期比/etc/passwd新就列出
root@ubuntu:~# find /etc -newer /etc/passwd
/etc
/etc/apparmor.d
/etc/apparmor.d/cache
/etc/apparmor.d/cache/.features
/etc/gshadow
```
与使用者或组名有关的参数：
```bash
选项与参数：
2. 与使用者或组名有关的参数：
 -uid n ：n 为数字，这个数字是用户的账号 ID，亦即 UID ，这个 UID 是记录在
 /etc/passwd 里面与账号名称对应的数字。
 -gid n ：n 为数字，这个数字是组名的 ID，亦即 GID，这个 GID 记录在/etc/group。
 -user name ：name 为使用者账号名称。例如 mrbird。
 -group name：name 为组名，例如 users 。
 -nouser ：寻找文件的拥有者不存在 /etc/passwd 的人。
 -nogroup ：寻找文件的拥有群组不存在于 /etc/group 的文件。
 当你自行安装软件时，很可能该软件的属性当中并没有文件拥有者，这是可能的。在这个时候，就可以使用 -nouser 与 -nogroup 搜寻。
```
示例：
```bash
#搜寻/home底下属于mrbird用户的文件
root@ubuntu:~# find /home -user mrbird
/home/mrbird
/home/mrbird/.sudo_as_admin_successful
...
 
#搜寻系统中不属于任何人的文件
root@ubuntu:~# find / -nouser
```
与文件权限及名称有关的参数：
```bash
选项与参数：
3. 与文件权限及名称有关的参数：
 -name filename：搜寻文件名为 filename 的文件；
 -size [+-]SIZE：搜寻比 SIZE 还要大(+)或小(-)的文件。这个 SIZE 的规格有：
       c: 代表 byte， k: 代表 1024bytes。所以，要找比 50KB还要大的文件，
       就是『 -size +50k 』
 -type TYPE ：搜寻文件的类型为 TYPE 的，类型主要有：一般正规文件 (f), 装置文件 (b, c),
       目录 (d), 连结档 (l), socket (s), 及 FIFO (p) 等属性。
 -perm mode ：搜寻文件权限『刚好等于』 mode 的文件，这个 mode 为类似 chmod
       的属性值，举例来说， -rwxr-xr-x 的属性为 0755。
 -perm -mode ：搜寻文件权限『必须要全部囊括 mode 的权限』的文件，举例来说，我
       们要搜寻 -rwxr--r-- ，亦即 0744 的文件，使用 -perm -0744，
       当一个文件的权限为 -rwsr-xr-x ，亦即 4755 时，也会被列出来，
       因为 -rwsr-xr-x 的属性已经囊括了 -rwxr--r-- 的属性了。
 -perm /mode ：搜寻文件权限『包含任一 mode 的权限』的文件，举例来说，我们搜寻
       -rwxr-xr-x ，亦即 -perm /755 时，当一个文件属性为 -rw-------
       也会被列出来，因为他有 -rw.... 的属性存在.
```
示例：
```bash
#找出档名为passwd这个文件
root@ubuntu:~# find / -name passwd
/usr/share/lintian/overrides/passwd
/usr/share/doc/passwd
/usr/share/bash-completion/completions/passwd
...

#找出文件名包含了passwd这个关键词的文件
root@ubuntu:~# find / -name *passwd*
/usr/share/app-install/desktop/kdepasswd:kde4__kdepasswd.desktop
/usr/share/app-install/desktop/usermode:redhat-userpasswd.desktop
/usr/share/lintian/overrides/base-passwd
...
 
#找出/run目录下，文件类型为Socket的文件
root@ubuntu:~# find /run -type s
/run/NetworkManager/private-dhcp
/run/cups/cups.sock
/run/uuidd/request
/run/avahi-daemon/socket
...
 
#搜寻文件权限为666的文件
root@ubuntu:~# find / -perm 666
/dev/vsock
/dev/net/tun
/dev/ptmx
...
```
额外可进行的操作：
```bash
选项与参数：
4. 额外可进行的动作：
 -exec command ：command 为其他指令，-exec 后面可再接额外的指令来处理搜寻到的结果。
 -print ：将结果打印到屏幕上，这个动作是预设动作。
```
示例：
```bash
#搜寻/run目录下文件权限为666的文件，并用ls -l命令查看其信息
root@ubuntu:~# find /run -perm 666 -exec ls -l {} \;
srw-rw-rw- 1 root root 0 Apr 13 10:34 /run/cups/cups.sock
srw-rw-rw- 1 root root 0 Apr 13 10:34 /run/uuidd/request
srw-rw-rw- 1 root root 0 Apr 13 10:34 /run/avahi-daemon/socket
srw-rw-rw- 1 root root 0 Apr 13 10:34 /run/acpid.socket
srw-rw-rw- 1 root root 0 Apr 13 10:34 /run/dbus/system_bus_socket
...
```
`{}`代表的是由 `find` 找到的内容，`-exec` 一直到`\;`是执行额外动作的指令。

这里不能用管线来代替`-exec`：
```bash
root@ubuntu:~# find /run -perm 666 | ls -l
total 0
```
> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记