---
title: Git远程仓库
date: 2017-06-16 14:57:32
tags: Git
---
远程仓库是指托管在网络上的项目仓库，可能会有好多个，其中有些你只能读，另外有些可以写。同他人协作开发某个项目时，需要管理这些远程仓库，以便推送或拉取数据，分享各自的工作进展。 管理远程仓库的工作，包括添加远程库，移除废弃的远程库，管理各式远程库分支，定义是否跟踪这些分支，等等。

<!--more-->
## 查看当前的远程库
使用 `git remote` 命令，它会列出每个远程库的简短名字。在克隆完某个项目后，至少可以看到一个名为 origin 的远程库，Git 默认使用这个名字来标识你所克隆的原始仓库：
```bash
$ git clone git://github.com/schacon/ticgit.git
Cloning into 'ticgit'...
remote: Counting objects: 1857, done.
remote: Total 1857 (delta 0), reused 0 (delta 0), pack-reused 1857
Receiving objects: 100% (1857/1857), 331.41 KiB | 89.00 KiB/s, done.
Resolving deltas: 100% (837/837), done.

$ cd ticgit

$ git remote
origin
```
使用 `git remote -v` 命令可以显示出远程仓库的地址：
```bash
$ git remote -v
origin  git://github.com/schacon/ticgit.git (fetch)
origin  git://github.com/schacon/ticgit.git (push)
```
## 添加远程仓库
要添加一个新的远程仓库，可以指定一个简单的名字，以便将来引用，运行 `git remote add [shortname] [url]`：
```bash
$ git remote add paul git://github.com/paulboone/ticgit.git

$ git remote
origin
paul
```
## 从远程仓库抓取数据
1.抓取并但不合并分支，使用命令 `git fetch [remote-name] [branch-name]`。
```bash
$ git fetch paul master
remote: Counting objects: 19, done.
remote: Total 19 (delta 11), reused 11 (delta 11), pack-reused 8
Unpacking objects: 100% (19/19), done.
From git://github.com/paulboone/ticgit
 * branch            master     -> FETCH_HEAD
 * [new branch]      master     -> paul/master

```
2.抓取并且自动合并分支，使用命令 `git pull [remote-name] [branch-name]`。
```bash
$ git pull origin master
From git://github.com/schacon/ticgit
 * branch            master     -> FETCH_HEAD
Already up-to-date.
```
## 推送数据到远程仓库
使用命令 `git push [remote-name] [branch-name]` 把本地的 master 分支推送到 origin 服务器上 :
```bash
$ git push origin master
```
符合下面两种情况才能成功推送：
1. 拥有远程仓库写的权限。
2. 在符合1的情况下，如果其他人已经向远程仓库推送了更新，必须先更新抓取到本地，合并到自己的项目中，然后才可以再次推送。

## 查看远程仓库信息
```bash
$ git remote show origin
* remote origin
  Fetch URL: git://github.com/schacon/ticgit.git
  Push  URL: git://github.com/schacon/ticgit.git
  HEAD branch: master
  Remote branches:
    master tracked
    ticgit tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (up to date)
```
## 远程仓库的删除和重命名
使用 `git remote rename` 命令修改某个远程仓库在本地的简称，比如想把 paul 改成 paulboone：
```bash
$ git remote rename paul paulboone

$ git remote
origin
paulboone
```
{% note danger %}对远程仓库的重命名，也会使对应的分支名称发生变化，原来的 paul/master 分支现在成了 paulboone/master{% endnote %}

使用命令 `git remote rm` 删除在本地的远程仓库地址：
```bash
$ git remote rm paulboone

$ git remote
origin
```

> [《Pro Git》](http://iissnan.com/progit/)学习笔记
