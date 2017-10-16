---
title: Git状态跟踪
date: 2017-06-12 14:23:51
tags: Git
---
对于任何一个文件，在 Git 内都只有三种状态：已提交（committed），已修改（modified）和已暂存（staged）。

1.已提交：表示该文件已经被安全地保存在版本库中了。

2.已修改：表示修改了某个文件，但还没有提交到暂存区。

3.已暂存：表示把已修改的文件已经放到暂存区了，下次提交时一并被保存到版本库中。
## 检查当前文件状态
要确定哪些文件当前处于什么状态，可以用 `git status` 命令。
```bash
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working tree clean
```
<!--more-->
说明现在的工作目录相当干净，并且当前所在分支为master。

在当前目录下创建一个README文件，然后运行 `git status` 会看到该文件出现在未跟踪文件列表中：
```bash
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

        README

nothing added to commit but untracked files present (use "git add" to track)
```
未跟踪的文件意味着Git在之前的快照（提交）中没有这些文件。
## 跟踪新文件
使用命令 `git add` 开始跟踪文件README：
```bash
$ git add README
```
再运行 `git status` 命令，会看到 README 文件已被跟踪，并处于暂存状态：
```bash
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   README
		
```
只要在 “Changes to be committed” 这行下面的，就说明是已暂存状态。`git add` 后面可以指明要跟踪的文件或目录路径。如果是目录的话，就说明要递归跟踪该目录下的所有文件。
## 暂存已修改文件
修改已跟踪过的文件 README，然后再次运行 `git status` 命令：
```bash
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   README

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README
```
README文件出现了两次，一次是未暂存，一次是一暂存。如果现在提交的话，那么提交的将是已暂存的README，对README的修改并不会被提交。

重新运行 `git add` 把最新版本README重新暂存起来：
```bash
$ git add README
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   README
```
## 忽略某些文件
如日志文件，编译缓存文件等没必要纳入Git管理的文件，我们可以创建一个.gitignore文件来将这些文件排除在外。比如：
```bash
$ cat .gitignore
*.[oa]
*~
```
第一行告诉 Git 忽略所有以 `.o` 或 `.a` 结尾的文件。

第二行告诉 Git 忽略所有以波浪符（~）结尾的文件。

文件 .gitignore 的格式规范如下：

- 所有空行或者以注释符号 ＃ 开头的行都会被 Git 忽略。
- 可以使用标准的 glob 模式匹配（glob指shell简化后的正则表达式）。
- 匹配模式最后跟反斜杠（/）说明要忽略的是目录。
- 要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（!）取反。

看一个 .gitignore 文件的例子：
```bash
# 此为注释 – 将被 Git 忽略
# 忽略所有 .a 结尾的文件
*.a
# 但 lib.a 除外
!lib.a
# 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
/TODO
# 忽略 build/ 目录下的所有文件
build/
# 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
doc/*.txt
# ignore all .txt files in the doc/ directory
doc/**/*.txt
```
## 查看已暂存和未暂存的更新
再次修改README文件，但不添加到暂存区。现在README已经修改了两次，第一次添加内容“hello git”并且使用 git add 添加到了暂存区。第二次添加内容“hello world”，但并未添加到暂存区。

若要看已经暂存起来的文件和上次提交时的快照之间的差异，可以用 `git diff --staged`命令：
```bash
$ git diff --staged
diff --git a/README b/README
new file mode 100644
index 0000000..8d0e412
--- /dev/null
+++ b/README
@@ -0,0 +1 @@
+hello git

```
直接使用 `git diff` 命令查看已暂存和未暂存文件之间的差异：
```bash
$ git diff
diff --git a/README b/README
index 8d0e412..05fe86c 100644
--- a/README
+++ b/README
@@ -1 +1,2 @@
 hello git
+hello world

```
可看到，对于README文件来说，未暂存和已暂存文件相比，添加了一行“hello world”。
## 提交更新
使用 git commit -m 命令来提交更新：
```bash
$ git commit -m '创建README文件，内容为hello git'
[master 1f9882d] 创建README文件，内容为hello git
 1 file changed, 1 insertion(+)
 create mode 100644 README
```
## 跳过暂存区
假如你觉得 `git add` 过程繁琐，可以使用 `git commit -a` 命令来跳过添加文件到暂存区的步骤，直接提交。

比如，对于README的第二次修改，我们还未将其添加到暂存区，所以第一次使用 `git commit` 命令只是提交了对README文件的第一次修改：
```bash
$ git status
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README

no changes added to commit (use "git add" and/or "git commit -a")
```
使用 `git commit -a` 命令直接将README文件的第二次修改提交到版本库：
```bash
$ git commit -a -m "添加hello world"
[master db06721] 添加hello world
 1 file changed, 1 insertion(+)
```
## 移除文件
移除文件分为两种情况：从版本库和本地工作目录中移除；仅从版本库移除。

1.从版本库和本地工作目录中移除。使用 `git rm` 命令来移除README:
```bash
$ git rm README
rm 'README'
$ git commit -m '删除README'
[master 99a0462] 删除README
 1 file changed, 3 deletions(-)
 delete mode 100644 README
```
到本地工作目录下查看，会发现README文件已经不存在了。

这里有种情况，假如README文件还在暂存区并未提交，使用 git rm 命令将会出错：
```bash
$ git rm README
error: the following file has changes staged in the index:
    README
(use --cached to keep the file, or -f to force removal)
```
Git提示我们使用 `git rm -f` 命令来删除。
```bash
$ git rm -f temp.log
rm 'temp.log'
```

2.仅从版本库移除。

比如现在不小心将temp.log文件添加并提交到版本库中了：
```bash
$ git add temp.log
$ git commit -m "add temp.log"
[master fa31ea5] add temp.log
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 temp.log
```
现在想将其从版本库中删除，但并不删除本地文件，而是随后将其添加到.gitignore文件中，可以使用命令`git rm --cached`：
```bash
$ git rm --cached  temp.log
rm 'temp.log'

$ git commit -m "delete temp.log"
[master e512a82] delete temp.log
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 temp.log
```
## 移动文件（重命名）
git mv 命令用来重命名文件，比如将REAME文件重命名为README.config：
```bash
$ git mv README README.config
$ git status
On branch master
Your branch is ahead of 'origin/master' by 7 commits.
  (use "git push" to publish your local commits)
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        renamed:    README -> README.config
```
其过程类似于：
```bash
$ mv README README.config
$ git rm README
$ git add README.config
```
> [《Pro Git》](http://iissnan.com/progit/)学习笔记

