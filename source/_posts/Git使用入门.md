---
title: Git使用入门
date: 2017-05-27 15:04:31
tags: Git
---
## 准备Git环境
首先在ubuntu中查看是否安装了Git：
```bash
$ git
The program 'git' is currently not installed. You can install it by typing:
sudo apt install git
```
linux提示尚未安装Git，并提供了安装的指令：`sudo apt install git`。第一次使用Git需要设置个人信息，如用户名邮箱等：
```bash
$ git config --global user.name "mrbird"
$ git config --global user.email "mrbird@leanote.com" 
```
<!--more-->
## 创建Git项目
首先创建一个projects目录，然后在projects下创建first-project项目，包含foo.txt和bar.txt两个文件：
```bash
$ mkdir projects
$ cd projects/
$ mkdir first-project
$ cd first-project/
$ vi foo.txt
$ vi bar.txt
$ tree -A projects/
projects/
└── first-project
    ├── bar.txt
    └── foo.txt
 
1 directory, 2 files
```
### 创建版本库
首先，我们需要在first-project下创建一个Git版本库，用于存储项目本身及其历史。对于一个带有版本库的项目目录，一般称之为**工作区**。
```bash
$ cd first-project/
$ git init
Initialized empty Git repository in /home/mrbird/projects/first-project/.git/
```
再次使用`tree`命令就可以看到，在first-project目录下多了个.git隐藏目录，该目录就是Git用于跟踪并管理版本库用的：
```bash
$ tree -aA projects/
projects/
└── first-project
    ├── bar.txt
    ├── foo.txt
    └── .git
...
```
### 首次提交
接下来，需要将foo.txt和bar.txt添加到版本库中去。在Git中，通常将项目的一个版本称之为一次提交。提交分为两个步骤：
1. 使用`git add`命令来确定下次提交前应该包含的文件；
2. 使用`git commit`命令将这些文件传送到版本库中，并生成散列值以标识这次更新。

```bash
$ git add foo.txt  bar.txt 
$ git commit -m "add foo.txt bar.txt"
[master (root-commit) c2e4810] add foo.txt bar.txt
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 bar.txt
 create mode 100644 foo.txt
```
### 检查状态
现在将first-project目录下的bar.txt文件删除，添加bar.html文件，修改foo.txt文件内容。然后使用`git status`命令查看状态： 
```bash
$ git status
On branch master
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)
 
	deleted:    bar.txt
	modified:   foo.txt
 
Untracked files:
  (use "git add <file>..." to include in what will be committed)
 
	bar.html
 
no changes added to commit (use "git add" and/or "git commit -a")
```
因为还没有使用`git add`命令将bar.html添加到版本库，所以显示为未跟踪状态（Untracked）。
我们也可以使用`git diff`命令来查看被修改的文件具体修改了啥：
```bash
$ git diff foo.txt
diff --git a/foo.txt b/foo.txt
index e69de29..3f9a7b1 100644
--- a/foo.txt
+++ b/foo.txt
@@ -0,0 +1 @@
+foo file
```
可以看出，foo.txt文件添加了一行内容：foo file。
### 提交修改
将上述的修改归档成一次新的提交，即添加foo.txt和新文件bar.html，删除bar.txt：
```bash
$ git add foo.txt bar.html 
$ git rm bar.txt 
rm 'bar.txt'
```
再次使用`git status`命令查看当前状态：
```bash
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
 
	new file:   bar.html
	deleted:    bar.txt
	modified:   foo.txt
```
这时候我们就可以放心的使用`git commit`来提交这些修改：
```bash
$ git commit -m "add bar.html,modify foo.txt,delete bar.txt"
[master 94418b1] add bar.html,modify foo.txt,delete bar.txt
 3 files changed, 2 insertions(+)
 create mode 100644 bar.html
 delete mode 100644 bar.txt
```
### 显示历史
使用`git log`命令可以查看所有提交的历史，并按时间顺序倒序排列：
```bash
$ git log
commit 94418b10e64f46bc4f48049037fadcb12efc5d10
Author: mrbird <mrbird@leanote.com>
Date:   Sat May 27 14:09:51 2017 +0800
 
    add bar.html,modify foo.txt,delete bar.txt
 
commit c2e48100c4f2fc8afaed2b1cac90deaf6a7e34ec
Author: mrbird <mrbird@leanote.com>
Date:   Sat May 27 11:08:29 2017 +0800
 
    add foo.txt bar.txt
```
## Git协作功能
假如现在还有另外一位开发者也参与开发first-project这个项目，为了方便实验，现在在projects目录下开辟另外一个工作区first-project-clone，供第二位开发者使用。
### 克隆版本库
现使用`git clone`来克隆first-project，该版本库副本包含了所有原始信息和整个项目的历史信息：
```bash
$ git clone projects/first-project/ projects/first-project-clone
Cloning into 'projects/first-project-clone'...
done.
```
克隆后，观察项目结构：
```bash
$ tree -aA projects/
projects/
├── first-project
│   ├── bar.html
│   ├── foo.txt
│   └── .git
│       ├── ...
└── first-project-clone
    ├── bar.html
    ├── foo.txt
    └── .git
        ├── ...
```
### 从另一个版本库中获取修改
现在，在first-project/foo.txt文件中插入一行信息"hello world,hello git"，并且提交修改：
```bash
$ cd projects/first-project
$ vi foo.txt 
$ git add foo.txt 
$ git commit -m "modify foo.txt in original"
[master 8e1b132] modify foo.txt in original
 1 file changed, 1 insertion(+)
```
同时修改克隆版本库first-project-clone中的bar.html，并且提交修改：
```bash
$ git add bar.html
$ git commit -m "modify bar.html in clone"
[master 796e40d] modify bar.html in clone
 1 file changed, 1 insertion(+)
```
现在，新的提交已经被存入到了first-project版本库中，但是其克隆版本库first-project-clone并没有取得这次修改（即foo.txt还是保持原样）。如果克隆版本库也要获取原版本库中的修改，我们可以使用`git pull`命令来获取：
```bash
$ cd ../first-project-clone/
$ cat foo.txt 
foo file
$ git pull
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From /home/mrbird/projects/first-project
   8e1b132..27b76ec  master     -> origin/master
Merge made by the 'recursive' strategy.
 foo.txt | 1 +
 1 file changed, 1 insertion(+)
$ cat foo.txt 
foo file
hello world,hello git
```
由于在创建克隆版本库的时候，原版本库的路径就已经被存储到克隆版本库中了。所以在克隆版本库中使用git pull命令，不带路径的话，默认就是从原版本库中取回修改。
从结果中可以看出，Git从原版本库中取回了修改，与克隆体中的修改进行了比对，并且合并了这些修改。这个过程称为合并（merge）。
{% note danger %}在pull过程中，如果发生了冲突，比如两位开发者同时对foo.txt文件进行了修改，Git不会自动去处理这些冲突，必须手动去做修改。{% endnote %}在pull取回修改，并且merge合并之后，可以使用`git log --graph`命令来查看图形化日志：
```bash
﻿$ git log --graph --oneline 
*   8747b24 Merge branch 'master' of /home/mrbird/projects/first-project
|\  
| * 27b76ec modify foo.txt in original
* | 796e40d modify bar.html in clone
|/  
* 94418b1 add bar.html,modify foo.txt,delete bar.txt
* c2e4810 add foo.txt bar.txt
```
从上面可以清晰的看出，分支合并的情况。
### 从任意版本库中取回修改
`git pull`带上仓库路径的话就可以从任意一个版本库中取回修改了，现在在原版本库first-project中取回其克隆版本库first-project-clone对bar.html的修改：
```bash
$ git pull ../first-project-clone/
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 5 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (5/5), done.
From ../first-project-clone
 * branch            HEAD       -> FETCH_HEAD
Updating 27b76ec..8747b24
Fast-forward
 bar.html | 1 +
 1 file changed, 1 insertion(+)
```
### 创建共享版本库
除了使用`git pull`命令从别的版本库取回修改外，我们还可以使用`git push`命令将本地修改传送给其他版本库。
不过，`git push`命令只适用于那些没有开发者在上面具体工作的版本库。通常的做法是创建一个没有工作区的版本库，也称之为裸版本库。裸版本库就是单纯用于存放各个开发这提交（push）的修改，方便别的开发者取回（pull）这些修改。现使用`git clone --bare`命令来创建裸版本库：
```bash
$ git clone --bare first-project first-project-bare
Cloning into bare repository 'first-project-bare'...
done.
```
### 使用push向裸版本库提交修改
再次修改原版本库first-project中的foo.txt文件，并且提交修改：
```bash
$ git add foo.txt 
$ git commit -m "modify foo.txt in original again"
[master 31e1f6f] modify foo.txt in original again
 1 file changed, 1 insertion(+), 1 deletion(-)
```
现在使用`git push`向裸版本库提交这次修改，push需要指定目标版本库路径以及其分支。
```bash
$ git push ../first-project-bare/ master
Counting objects: 3, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 316 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To ../first-project-bare/
   8747b24..31e1f6f  master -> master
```
如果另一位开发者在我们之前就已经push了修改，那此次的push操作将会被拒绝，必须先pull回修改，才能push我们的修改。
### 使用pull从裸版本库取回修改
```bash
$ cd ../first-project
$ git pull ../first-project-bare/ master
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From ../first-project-bare
 * branch            master     -> FETCH_HEAD
Updating 8747b24..31e1f6f
Fast-forward
 foo.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```