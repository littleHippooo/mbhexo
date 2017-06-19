---
title: Git撤销操作
date: 2017-06-19 09:33:17
tags: Git
---
## 修改最后一次提交
如果提交后发现想要修改提交信息，可以直接使用 `git commit --amend` 命令，使用该命令后，Git会启动文本编辑器，然后可看到上次提交时的说明，编辑它确认没问题后保存退出，就会使用新的提交说明覆盖刚才的提交信息：
```bash
$ git commit --amend
```
<!--more-->
如果刚才提交时忘了暂存某些修改，可以先补上暂存操作，然后再运行 `--amend` 提交：
```bash
$ git add forgotten_file
$ git commit --amend
```
## 取消已经暂存的文件
```bash
$ git status
On branch master
Your branch is ahead of 'origin/master' by 8 commits.
  (use "git push" to publish your local commits)
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   README.config
        modified:   README.md
```
使用命令 `git reset HEAD README.config` 将README.config移出暂存区：
```bash
$ git reset HEAD README.config
Unstaged changes after reset:
M       README.config

$ git status
On branch master
Your branch is ahead of 'origin/master' by 8 commits.
  (use "git push" to publish your local commits)
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   README.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README.config
```
可看到，README.config已经为Changes not staged for commit状态。
## 取消对文件的修改
将README.config移出暂存区后，可以进一步使用命令 `git checkout -- README.config` 取消对README.config的修改。
```bash
$ cat README.config
hello

$ git checkout -- README.config

$ git status
On branch master
Your branch is ahead of 'origin/master' by 8 commits.
  (use "git push" to publish your local commits)
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   README.md

$ cat README.config

```
> [《pro git》](http://iissnan.com/progit/)学习笔记
