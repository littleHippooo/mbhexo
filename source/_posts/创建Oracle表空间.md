---
title: 创建Oracle表空间
date: 2016-09-03 19:31:49
tags: [Oracle,DataBase]
---
分三步：

1.创建空间名，分配大小
```sql
CREATE TABLESPACE mySpace DATAFILE 'D:\mySpace.ora' SIZE 1024m
```
mySpace空间名,'D:\mySpace.ora'存放路径，1024m空间大小。

2.创建用户，设置密码
```sql
CREATE USER mrBird IDENTIFIED BY 123456 DEFAULT TABLESPACE mySpace QUOTA 1024m ON USERS
```
<!--more-->
mrBird为用户名，123456为该用户密码，mySpace为上条创建的空间名，因为只创建mrBird这一个用户，所以把1024m全部分配给该用户。

3.授权
```sql
grant all privileges to mrBird
```