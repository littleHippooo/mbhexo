---
title: ubuntu16.04搭建Java开发环境
date: 2017-03-25 17:42:10
tags: ubuntu
---
## 安装JDK
JDK1.8下载地址：[http://pan.baidu.com/s/1qYPORRA](http://pan.baidu.com/s/1qYPORRA)，JDK安装步骤：

1.将下载的包解压到/opt/jvm：
```bash
sudo mkdir /opt/jvm
sudo tar zxvf jdk-8u77-linux-x64.tar.gz -C /opt/jvm
```
如果提示失败，是因为目录权限不足，可以使用chmod改变权限：
```bash
sudo chmod 777 /opt /opt/jvm
```
<!--more-->

2.配置jdk的环境变量，打开 /etc/profile文件（sudo vim /etc/profile），在文件末尾添加下语句：
```bash
export JAVA_HOME=/opt/jvm/jdk1.8.0_77
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
```
点击Esc，输入`:wq`保存退出。

3.使其生效：
```bash
sudo source /etc/profile
```
如若提示sudo: source：找不到命令，可以切换为root，再次执行，操作如下：
```bash
sudo -s -H
source /etc/profile
```
检查是否成功：
```bash
mrbird@mrbird-xps13:~$ java -version
java version "1.8.0_77"
Java(TM) SE Runtime Environment (build 1.8.0_77-b03)
Java HotSpot(TM) 64-Bit Server VM (build 25.77-b03, mixed mode)
```
## 安装eclipse
eclipse下载，官网：[https://www.eclipse.org/downloads/eclipse-packages/?osType=linux&release=undefined](https://www.eclipse.org/downloads/eclipse-packages/?osType=linux&release=undefined)，或者百度云：[http://pan.baidu.com/s/1pKMmRR9](http://pan.baidu.com/s/1pKMmRR9)。eclipse安装步骤：       

1.下载后切换到下载目录，将其解压到/opt/文件夹中：
```bash
sudo tar zxvf eclipse-jee-neon-3-linux-gtk-x86_64.tar.gz -C /opt
```
2.然后到/opt/eclipse目录下双击eclipse即可，为了方便，建议将其锁定到启动器。 
## 安装MySQL
1.在Ubuntu 16.04上安装MySQL：
```bash
sudo apt-get install mysql-server mysql-client
```
2.安装过程中需要你输入MySQL 管理员用户（root）密码 。

3.运行MySQL初始化安全脚本：
```bash
sudo mysql_secure_installation
```
4.根据提示信息设置：更改root密码、移除MySQL的匿名用户、禁止root远程登录、删除test数据库。

检查是否成功：
```bash
mrbird@mrbird-xps13:~$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.17-0ubuntu0.16.04.1 (Ubuntu)
 
Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.
 
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
 
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
 
mysql> show databases
    -> ;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)
 
mysql> 
```