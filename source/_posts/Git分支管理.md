---
title: Git分支管理
date: 2017-06-26 16:10:22
tags: Git
---
`git branch`命令不仅仅能创建和删除分支，如果不加任何参数，它会给出当前所有分支的清单：
```bash
$ git branch
  develop
* master
  test
```
带`*`表示当前所在分支。使用命令`git branch -v`则可以查看各个分支最后一个提交对象的信息：
```bash
$ git branch -v
  develop ef993bc update About.html
* master  0986092 [ahead 26] update index.html
  test    19fffc0 add test file
```
<!--more-->
使用命令`git branch --merged`可以查看哪些分支与当前分支进行了合并操作：
```bash
$ git branch --merged
  develop
* master
```
与之相反的命令为`git branch --no-merged`:
```bash
$ git branch --no-merged
  test
```
test分支中还包含着尚未合并进来的工作成果，所以简单地用`git branch -d`删除该分支会提示错误，因为那样做会丢失数据：
```bash
$ git branch -d test
error: The branch 'test' is not fully merged.
If you are sure you want to delete it, run 'git branch -D test'.
```
Git提示可以用大写的删除选项 -D 强制执行。

