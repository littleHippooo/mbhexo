---
title: MongoDB shell
date: 2017-02-18 15:12:28
tags: [MongoDB,DataBase]
---
## 启动MongoDB
安装好MongoDB，将其bin目录配置到系统环境变量path后，在磁盘上创建一个数据库保存目录，比如D:\MongoDB，然后打开命令窗口输入如下命令启动MongoDB服务：
```bash
> mongod --dbpath=d:\mongodb
```
当看到输出如下信息，表明启动成功，端口号为27017：
```bash
...
[thread1] waiting for connections on port 27017
```
打开另外一个命令窗口作为客户端，输入mongo即可连上服务：
```bash
> mongo
MongoDB shell version v3.4.2
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.2
```
<!--more-->
## 语法糖
MongoDB shell自带了一些语法糖：
```bash
show dbs     列出所有DB
use dbname   切换当前DB
show tables  或 show collections  列出当前DB的所有表/集合
show users   列出当前DB的所有用户
show profile 列出当前DB的所有慢查询
show logs     列出运行日志
```
## 使用shell执行脚本
假如在C:\Program Files\MongoDB\Server\3.4\bin目录下创建一个test.js脚本文件：
```bash
print("hello MnogoDB") 
```
有两种方式让MongoDB执行该脚本：
### 连上服务前
```bash
> exit
bye
 
C:\Users\Dell>cd ../../program files/mongodb/server/3.4/bin
C:\Program Files\MongoDB\Server\3.4\bin>mongo test.js
MongoDB shell version v3.4.2
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.2
hello MnogoDB   
```
可看到，shell页面执行了test.js脚本并如期输出hello MongoDB（路径必须和脚本所在路径一致）。
### 连上服务后
连上服务后，可使用`load()`函数执行脚本：
```bash
> load("test.js")
hello MnogoDB
true
```
另外一个就是可以在shell中初始化一些辅助函数，比如定义一个hello.js：
```javascript
var hello = function(){
    var world = ["handsome","charming"];
    var index = Math.floor(Math.random()*2);
    print("hello mrbird,you are so "+world[index]);
}
```
在shell中加载这个脚本，hello函数就可以使用了：
```bash
> typeof hello
undefined
> load("hello.js")
true
> typeof hello
function
> hello()
hello mrbird,you are so charming
```
## .mongorc.js
对于一些常用的脚本，如果每次启动服务后都用load()手动加载，这将很繁琐。对于这些常用的脚本，我们可以将其放在.mongorc.js文件中，因为MongoDB启动的时候，会自动加载该脚本。

比如在.mongorc.js加入一句问候语：
```bash
print("Hello mrbird,welcome to use mongoDB")
```
连接服务时，shell窗口输出：
```bash
> mongo
MongoDB shell version v3.4.2
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.2
Hello mrbird,welcome to use mongoDB
```
也可以加如一些实用功能，比如添加防止自己误删的js脚本：
```javascript
var no = function(){
    print("Please don't");
};
// 禁止删除数据库
db.dropDatabases = DB.prototype.dropDatabases = no;
// 禁止删除集合
DBCollection.prototype.drop = no;
// 禁止删除索引
DBCollection.prototype.dropIndex = no;
```
测试一下：
```bash
> show collections
blog
> db.blog.drop();
Please don't
> show collections
blog
```
## 配合编辑器    
在shell中编辑文档是一件麻烦的事情，我们可以在.mongorc.js文件中加入自己的脚本编辑器：
```javascript
EDITOR = "\"D:\\Program Files (x86)\\Notepad++\\notepad++.exe\""
```
这里指定编辑器为notepad++，然后在shell中即可实用edit命令来编辑一个变量：
```bash
> db.blog.findOne()
{
    "_id" : ObjectId("58a86088eb4ef940034d2733"),
    "title" : "mongodb shell",
    "content" : "mongodb超级有趣",
    "date" : ISODate("2017-02-18T14:55:39.679Z")
}
> var msg = db.blog.findOne()
> edit msg
```
界面弹出：

![7997296-file_1487997498567_17ef5.png](img/7997296-file_1487997498567_17ef5.png)

在编辑器中修改content内容后，保存并退出编辑器，变量就会被重新解析然后加载回shell：
```bash
> db.blog.update({title: "mongodb shell"},msg)
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.blog.findOne()
{
    "_id" : ObjectId("58a86088eb4ef940034d2733"),
    "title" : "mongodb shell",
    "content" : "mongodb is interesting",
    "date" : ISODate("2017-02-18T14:55:39.679Z")
}
```
可看到，文档已修改。

> [《MongoDB权威指南》](https://book.douban.com/subject/25960887/)读书笔记    