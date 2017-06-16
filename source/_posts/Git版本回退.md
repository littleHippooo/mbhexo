---
title: Git版本回退
date: 2017-06-13 16:23:19
tags: Git
---
Git中，每次commit提交都会生成一个历史纪录。使用 `git log` 查看commit历史：
```bash
$ git log --oneline 
ec88247 modifyed bar.html,foo.txt add new.txt
47384c8 modify bar.html in clone again
31e1f6f modify foo.txt in original again
8747b24 Merge branch 'master' of /home/mrbird/projects/first-project
27b76ec modify foo.txt in original
796e40d modify bar.html in clone
8e1b132 modify foo.txt,add 'hello msg'
94418b1 add bar.html,modify foo.txt,delete bar.txt
c2e4810 add foo.txt bar.txt
```
<!--more-->
每个记录都有一个与之对应的commit id，所以可以使用命令`git reset --hard commit_id`来回退到相应的版本。除此之卡，在Git中，使用HEAD来代表当前版本，如需回退到前一个版本，可以使用命令`git reset --hard HEAD^`，前两个版本则用`HEAD~2`表示，以此类推。

当前版本id为ec88247...比如，现要回退到commit_id为47384c8...的版本，可以使用如下命令：
```bash
$ git reset --hard 47384c8
HEAD is now at 47384c8again modify bar.html in clone 
```
或： 
```bash
$ git reset --hard HEAD^
HEAD is now at 47384c8 modify bar.html in clone again
```
再次查看commit历史：
```bash
$ git log --oneline 
47384c8 modify bar.html in clone again
31e1f6f modify foo.txt in original again
8747b24 Merge branch 'master' of /home/mrbird/projects/first-project
27b76ec modify foo.txt in original
796e40d modify bar.html in clone
8e1b132 modify foo.txt,add 'hello msg'
94418b1 add bar.html,modify foo.txt,delete bar.txt
c2e4810 add foo.txt bar.txt
```
可发现，commit_id为ec88247...的记录已经不见了，如果要回退到这个版本，又忘记了与之对应的commit_id该怎么办呢。这时候可以使用`git reflog`命令来查看操作历史：
```bash
$ git reflog
47384c8 HEAD@{0}: reset: moving to 47384c8
ec88247 HEAD@{1}: reset: moving to ec88247
... 
```
可看到，回退到commit_id为47384c8...的上一个版本的commit_id为ec88247...，所以，使用如下命令即可回到一开始回退前的版本：
```bash
$ git reset --hard ec88247
HEAD is now at ec88247 modifyed bar.html,foo.txt add new.txt
```