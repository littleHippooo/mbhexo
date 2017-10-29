---
title: Linux文件内容查阅
date: 2017-04-12 12:15:59
tags: Linux
---
Linux文件内容查阅主要使用以下命令：

`cat`：由第一行开始显示文件内容。

`tac`：从最后一行开始显示，可以看出 tac 是 cat 的倒着写。

`nl`：显示的时候，顺道输出行号。

`more`：一页一页的显示文件内容。

`less`：与 more 类似，但是比 more 更好的是，他可以往前翻页。

<!--more-->
`head`：只看头几行。

`tail`：只看尾巴几行。

`od`：以二进制的方式读取文件内容。
## 直接检视文件内容
### cat：
`cat` 是 Concatenate (连续) 的简写，主要的功能是将一个文件的内容连续的印出在屏幕上面。

语法：
```bash
cat [-AbEnTv]
选项与参数：
-A ：相当于 -vET 的整合选项，可列出一些特殊字符而不是空白而已；
-b ：列出行号，仅针对非空白行做行号显示，空白行不标行号！
-E ：将结尾的断行字符 $ 显示出来；
-n ：打印出行号，连同空白行也会有行号，与 -b 的选项不同；
-T ：将 [tab] 按键以 ^I 显示出来；
-v ：列出一些看不出来的特殊字符
```
示例：

使用cat命令查阅/etc/legal文件内容，并加上行号：
```bash
root@ubuntu:~# cat -n /etc/legal
     1	
     2	The programs included with the Ubuntu system are free software;
     3	the exact distribution terms for each program are described in the
     4	individual files in /usr/share/doc/copyright.
     5	
     6	Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
     7	applicable law.
     8	
```
### tac（反向列示）：
`tac` 刚好是将 cat 反写过来，所以他的功能就跟 cat 相反。cat 是由第一行到最后一行连续显示在屏幕上，而 tac 则是由最后一行到第一行反向在屏幕上显示出来。

使用tac命令查阅/etc/legal文件内容：
```bash
root@ubuntu:~# tac /etc/legal 
 
applicable law.
Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
 
individual files in /usr/share/doc/copyright.
the exact distribution terms for each program are described in the
The programs included with the Ubuntu system are free software;
```
### nl（添加行号打印）：
`nl`可以将输出的文件内容自动的加上行号。其预设的结果与cat -n有点不太一样， nl可以将行号做比较多的显示设计，包括位数与是否自动补齐 0 等等的功能。

语法：
```bash
nl [-bnw] 文件
选项与参数：
-b ：指定行号指定的方式，主要有两种：
 -b a ：表示不论是否为空行，也同样列出行号(类似 cat -n)；
 -b t ：如果有空行，空的那一行不要列出行号(默认值)；
-n ：列出行号表示的方法，主要有三种：
 -n ln ：行号在屏幕的最左方显示；
 -n rn ：行号在自己字段的最右方显示，且不加 0 ；
 -n rz ：行号在自己字段的最右方显示，且加 0 ；
-w ：行号字段的占用的字符数
```
示例：

使用`nl`显示/etc/legal文件内容：
```bash
root@ubuntu:~# nl /etc/legal 
       
     1	The programs included with the Ubuntu system are free software;
     2	the exact distribution terms for each program are described in the
     3	individual files in /usr/share/doc/copyright.
       
     4	Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
     5	applicable law.
```
可见，空行并没有显示行号，可以使用`-b a`选项显示空行行号：
```bash
root@ubuntu:~# nl -b a /etc/legal 
     1	
     2	The programs included with the Ubuntu system are free software;
     3	the exact distribution terms for each program are described in the
     4	individual files in /usr/share/doc/copyright.
     5	
     6	Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
     7	applicable law.
     8	
```
## 可翻页查阅
当文件内容较多的时候，可以使用`more`和`less`命令来翻页显示文件内容。
### more：

使用more查阅/etc/ltrace.conf，页面最后一行会显示出目前显示的百分比：

![62680087-file_1491985160081_c33f.png](img/62680087-file_1491985160081_c33f.png)

还可以在最后一行输入一些有用的指令：
```bash
空格键 (space)：代表向下翻一页；
Enter ：代表向下翻一行；
/字符串 ：代表在这个显示的内容当中，向下搜寻『字符串』这个关键词；
:f ：立刻显示出文件名以及目前显示的行数；
q ：代表立刻离开 more ，不再显示该文件内容；
b 或 [ctrl]-b ：代表往回翻页，不过这动作只对文件有用，对管线无用。﻿​
```
### less：
`less` 的用法比起 more 又更加的有弹性，less可用的指令有：
``bash
空格键 ：向下翻动一页；
[pagedown]：向下翻动一页；
[pageup] ：向上翻动一页；
/字符串 ：向下搜寻『字符串』的功能；
?字符串 ：向上搜寻『字符串』的功能；
n ：重复前一个搜寻 (与 / 或 ? 有关)
N ：反向的重复前一个搜寻 (与 / 或 ? 有关)
g ：前进到这个资料的第一行去；
G ：前进到这个数据的最后一行去 (注意大小写)；
q ：离开 less 这个程序。﻿​
```
## 以行为单位查阅
### head（取出前面几行）：

语法：
```bash
head [-n number] 文件 
选项与参数：
-n ：后面接数字，代表显示几行的意思
```
示例：
```bash
#使用head指令查阅/etc/ltrace.conf，默认输出前10行
root@ubuntu:~# head /etc/ltrace.conf 
; ltrace.conf
;
; ~/.ltrace.conf will also be read, if it exists. The -F option may be
...

#只查看前1行
root@ubuntu:~# head -n 1 /etc/ltrace.conf 
; ltrace.conf
```

如果数字是负数的话，如使用指令`head -n -100 /etc/file` 则表示输出file文件去除后100行后的所有行。即如果file文件有150行，使用该指令后，只会输出前50行。

### tail（取出后面几行）：

语法：
```bash
tail [-n number] 文件 
选项与参数：
-n ：后面接数字，代表显示几行的意思
-f ：表示持续侦测后面所接的档名，要等到按下[ctrl]-c 才会结束 tail 的侦测
使用方法和head类似。
```
如果要查阅/etc/ltrace.conf第11行到20行的数据，我们可以使用管线 (|)连接head和tail指令。

{% note danger %}管线的意思是：前面的指令所输出的讯息，请透过管线交由后续 的指令继续使用。{% endnote %}
```bash
root@ubuntu:~# head -n 20 /etc/ltrace.conf | tail -n 10
typedef in_addr = struct(hex(uint));
int inet_aton(string, +in_addr*);
hex(uint) inet_addr(string);
hex(uint) inet_network(string);
string inet_ntoa(in_addr);
in_addr inet_makeaddr(hex(int), hex(int));
hex(uint) inet_lnaof(in_addr);
hex(uint) inet_netof(in_addr);
 
; bfd.h
```
加上行号：
```bash
root@ubuntu:~# cat -n /etc/ltrace.conf | head -n 20 | tail -n 10
    11	typedef in_addr = struct(hex(uint));
    12	int inet_aton(string, +in_addr*);
    13	hex(uint) inet_addr(string);
    14	hex(uint) inet_network(string);
    15	string inet_ntoa(in_addr);
    16	in_addr inet_makeaddr(hex(int), hex(int));
    17	hex(uint) inet_lnaof(in_addr);
    18	hex(uint) inet_netof(in_addr);
    19	
    20	; bfd.h 
```
### 非纯文本档： od

当查阅非文本文件的时候，应该使用od命令。

语法：
```bash
od [-t TYPE] 文件
选项或参数：
-t ：后面可以接各种『类型 (TYPE)』的输出，例如：
 a ：利用默认的字符来输出；
 c ：使用 ASCII 字符来输出
 d[size] ：利用十进制(decimal)来输出数据，每个整数占用 size bytes ；
 f[size] ：利用浮点数(floating)来输出数据，每个数占用 size bytes ；
 o[size] ：利用八进制(octal)来输出数据，每个整数占用 size bytes ；
 x[size] ：利用十六进制(hexadecimal)来输出数据，每个整数占用 size bytes ；
```
示例：

将/usr/bin/passwd 的内容使用 ASCII 方式来展现：
```bash
od -t c /usr/bin/passwd 
0000000 177   E   L   F 002 001 001  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000020 003  \0   >  \0 001  \0  \0  \0   0   >  \0  \0  \0  \0  \0  \0
0000040   @  \0  \0  \0  \0  \0  \0  \0 360 314  \0  \0  \0  \0  \0  \0
0000060  \0  \0  \0  \0   @  \0   8  \0  \t  \0   @  \0 034  \0 033  \0
0000100 006  \0  \0  \0 005  \0  \0  \0   @  \0  \0  \0  \0  \0  \0  \0
0000120   @  \0  \0  \0  \0  \0  \0  \0   @  \0  \0  \0  \0  \0  \0  \0
0000140 370 001  \0  \0  \0  \0  \0  \0 370 001  \0  \0  \0  \0  \0  \0
...
```
将/etc/issue 这个文件的内容以 8 进位列出储存值与 ASCII 的对照表：
```bash
root@ubuntu:~# od -t oCc /etc/issue
0000000 125 142 165 156 164 165 040 061 066 056 060 064 056 062 040 114
          U   b   u   n   t   u       1   6   .   0   4   .   2       L
0000020 124 123 040 134 156 040 134 154 012 012
          T   S       \   n       \   l  \n  \n
0000032
```
> [《鸟哥的Linux私房菜》](https://book.douban.com/subject/4889838/)读书笔记