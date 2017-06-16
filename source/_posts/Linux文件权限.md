---
title: Linux文件权限
date: 2017-03-21 09:49:16
tags: Linux
---
Linux 最优秀的地方之一就在于他的多人多任务环境。而为了让各个使用者具有较保密的文件数，因此文件的权限管理就变得很重要了。Linux一般将文件可存取的身份分为三个类别：`owner/group/others`，且三种身份各有`read/write/execute`等权限。
## 文件属性
使用`ls`命令查看当前目录下文件的属性：
```bash
mrbird@mrbird-xps13:~$ ls -alh
总用量 196K
drwxr-xr-x 32 mrbird mrbird 4.0K 3月  26 11:34 .
drwxr-xr-x  4 root   root   4.0K 3月  25 03:31 ..
drwxrwxr-x  4 mrbird mrbird 4.0K 3月  26 10:58 .audacity-data
-rw-------  1 mrbird mrbird 5.5K 3月  26 11:18 .bash_history
-rw-r--r--  1 mrbird mrbird  220 3月  25 03:31 .bash_logout
-rw-r--r--  1 mrbird mrbird 3.7K 3月  25 03:31 .bashrc
drwx------ 25 mrbird mrbird 4.0K 3月  26 11:34 .cache
drwx------ 30 mrbird mrbird 4.0K 3月  26 10:51 .config
drwxrwxr-x  4 mrbird mrbird 4.0K 3月  25 20:19 .cxoffice
drwx------  3 mrbird mrbird 4.0K 3月  25 11:35 .dbus
...
```
<!--more-->
文件属性分为7个部分，从左到右依次是：文件类型和权限，连接数，拥有者，群组，文件容量，修改日期和文件名。

1.**文件的类型与权限（permission）**：

如：`drwxrwxr-x`我们拆分为`d` `rwx`  `rwx` `r-x` 四个部分，第一部分代表文件类型，类型有：

• 当为[ d ]则是目录，例如上面文件名为『.config』的那一行。

• 当为[ - ]则是文件，例如上表档名为『.bash_history』那一行。

• 若是[ l ]则表示为连结档（link file）。

• 若是[ b ]则表示为装置文件里面的可供储存的接口设备（可随机存取装置）。

• 若是[ c ]则表示为装置文件里面的串行端口设备，例如键盘、鼠标（一次性读取装置）。

剩余的三个部分分别表示**文件拥有者可具备的权限**，**加入此群组账号的权限**和**非本人且没有加入本群组之其他账号的权限**。其中rwx分别表示：[ r ]代表可读（read）、[ w ]代表 可写（write）、[ x ]代表可执行（execute）。如果没有权限，就用减号[ - ]表示。

2.**连接数（`i-node`）**：

每个文件都会将他的权限与属性记录到文件系统的 `i-node` 中，不过我们使用的目录树却是使用文件名来记录，因此每个档名就会连结到一个 `i-node`。这个属性记录的就是有多少不同的档名连结到相同的一个 `i-node` 号码了。

3.**拥有者**：表示这个文件(或目录)的『拥有者账号』。

4.**群组**：

在 Linux 系统下，你的账号会加入于一个或多个的群组中。例如p1，p2，p3均属于 people 这个群组，假设某个文件所属的群组为 people，且该文件的权限为（`-rwxrwx---`），则p1，p2，p3三人对于该文件都具有可读、可写、可执行的权限（看群组权限）。 但如果是不属于people群组的其他账号，对于此文件就不具有任何权限了。   

5.**文件容量**：代表文件的容量大小，默认单位为 bytes。

6.**修改日期**：代表文件创建或最后修改的日期。

7.**文件名**：如果为隐藏文件，则以`.`开头。
## 更改文件属性和权限
涉及的指令：`chgrp`：改变文件所属群组，`chown`：改变文件拥有者，`chmod`：改变文件的权限。

1.chgrp（change group）：

语法：
```bash
chgrp [-R] dirname/filename ...
选项与参数:
-R : 进行递归（recursive）的持续变更，亦即连同次目录下的所有文件、
    目录都更新成为这个群组之意。常常用在变更某一目录内所有的文件的情况。
```
比如，改变文件examples.desktop的群组为root：
```bash
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-r--r-- 1 mrbird mrbird   8.8K 3月  25 03:31 examples.desktop
...
root@mrbird-xps13:/home/mrbird# chgrp root examples.desktop 
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-r--r-- 1 mrbird root   8.8K 3月  25 03:31 examples.desktop
...
```
2.chown（change owner）：

`chown`不但可以改变文件拥有者，也可以改变群组！语法如下：
```bash
chown [-R] 账号名称 文件或目录
chown [-R] 账号名称:组名 文件或目录
选项与参数:
-R : 进行递归(recursive)的持续变更,亦即连同次目录下的所有文件都变更
```
例：将examples.desktop的拥有者改为root：
```bash
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-r--r-- 1 mrbird mrbird 8.8K 3月  25 03:31 examples.desktop
...
root@mrbird-xps13:/home/mrbird# chown root examples.desktop 
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-r--r-- 1 root   mrbird 8.8K 3月  25 03:31 examples.desktop
...
```
例：将examples.desktop的拥有者和群组都改为root：
```bash
root@mrbird-xps13:/home/mrbird# chown root:root examples.desktop 
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-r--r-- 1 root   root   8.8K 3月  25 03:31 examples.desktop
...
```
3.chmod：

改变权限有两种方式：数字类型和符号类型。

• 数字类型改变文件权限：

`rwx`分别代表421，例如当权限为: [`-rwxrwx---`] 分数 则是：

owner = rwx = 4+2+1 = 7

group = rwx = 4+2+1 = 7

others= --- = 0+0+0 = 0 

数字类型改变权限语法：
```bash
chmod [-R] xyz 文件或目录
选项与参数:
xyz : 就是刚刚提到的数字类型的权限属性,为 rwx 属性数值的相加。
-R : 进行递归(recursive)的持续变更,亦即连同次目录下的所有文件都会变更
```
例：将examples.desktop的权限都启用：
```bash
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-r--r-- 1 root   root   8.8K 3月  25 03:31 examples.desktop
...
root@mrbird-xps13:/home/mrbird# chmod 777 examples.desktop 
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rwxrwxrwx 1 root   root   8.8K 3月  25 03:31 examples.desktop
...
```
• 符号类型改变文件权限

在符号类型改变权限的规则中，我们使用`u`，`g`，`o`来代表`user`，`group`和`owner`三种身份的权限。此外，`a` 则代表 `all` 亦即全部的身份。相应规则可看下表：

<table>
        <tr>
            <td>
                chmod
            </td>
            <td>
                    u</br>

                    g</br>

                    o</br>

                    a</br>
            </td>
            <td>
                    +(加入)</br>

                    -(除去)</br>

                    =(设定)</br>

            </td>
            <td>
                    r</br>
					
                    w</br>
					
                    x</br>
            </td>
            <td>
                文件或目录
            </td>
        </tr>
</table>

例如，将文件examples.desktop的权限改为`-rw-r--r--`：
```bash
root@mrbird-xps13:/home/mrbird# chmod u=rw,go=r examples.desktop 
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-r--r-- 1 root   root   8.8K 3月  25 03:31 examples.desktop
...
```
例如，增加文件examples.desktop每个人均可写入的权限：
```bash
root@mrbird-xps13:/home/mrbird# chmod a+w examples.desktop 
root@mrbird-xps13:/home/mrbird# ls -lh
总用量 48K
-rw-rw-rw- 1 root   root   8.8K 3月  25 03:31 examples.desktop
...
```
## 权限的意义

1.对于文件来说，`rwx`代表：

•  r (read)：可读取此一文件的实际内容,如读取文本文件的文字内容等。

•  w (write)：可以编辑、新增或者是修改该文件的内容（但不含删除该文件）。

•  x (eXecute)：该文件具有可以被系统执行的权限（类似与window中的exe，bat等）。

2.对于目录来说，`rwx`代表：

•  r (read contents in directory)：

表示具有读取目录结构列表的权限，所以当你具有读取（`r`）一个目录的权限时，表示你可以查询该目录下的文件名数据。 所以你就可以利用 `ls` 这个指令将该目录的内容列表显示出来。

•  w (modify contents of directory)：

表示你具有异动该目录结构列表的权限，也就是可以对该目录或者其下的文件进行曾删改操作！

•  x (access directory)：

目录的 `x` 代表的是用户能否进入该目录成为工作目录，所谓的工作目录（work directory）就是你目前所在的目录。