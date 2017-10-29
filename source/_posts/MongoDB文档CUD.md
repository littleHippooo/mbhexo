---
title: MongoDB文档CUD
date: 2017-02-19 14:38:57
tags: [MongoDB,DataBase]
---
## 插入文档
使用`insert`向集合中插入一个文档：
```bash
> db.test.insert({"name":"mrbird"})
WriteResult({ "nInserted" : 1 })
> db.test.findOne()
{ "_id" : ObjectId("58a99b8168e0d7b9f6992c69"), "name" : "mrbird" }
```
插入的文档没有“_id”键的话，这个操作会自动为文档添加一个“_id”键。
<!--more-->
批量插入文档则需使用`insertMany`函数，函数接收一个文档数组：
```bash
> db.test.insertMany([{"name":"Jane"},{"name":"KangKang"}])
{
    "acknowledged" : true,
    "insertedIds" : [
        ObjectId("58a99d6468e0d7b9f6992c6b"),
        ObjectId("58a99d6468e0d7b9f6992c6c")
    ]
}
> db.test.find()
{ "_id" : ObjectId("58a99b8168e0d7b9f6992c69"), "name" : "mrbird" }
{ "_id" : ObjectId("58a99d6468e0d7b9f6992c6b"), "name" : "Jane" }
{ "_id" : ObjectId("58a99d6468e0d7b9f6992c6c"), "name" : "KangKang" }
```

要查看一个文档的大小，可以使用`Object.bsonsize(doc)`函数（单位为字节）：
```bash
> Object.bsonsize(db.test.find({"name":"mrbird"}))
1215
```
## 删除文档
删除文档使用`remove`函数，接收一个查询文档，所有匹配的文档都将会被删除：
```bash
> db.test.remove({"name":"mrbird"})
WriteResult({ "nRemoved" : 1 })
> db.test.find()
{ "_id" : ObjectId("58a99d6468e0d7b9f6992c6b"), "name" : "Jane" }
{ "_id" : ObjectId("58a99d6468e0d7b9f6992c6c"), "name" : "KangKang" }
```
要清空整个集合的话，可以使用`drop`函数：
```bash
> db.test.drop()
true
> db.test.find()
```
## 更新文档  
使用`update`函数更新文档，接收两个参数，查询文档和修改器文档，如：
```bash
> db.test.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird.leanote.com"
}
> var mrbird = db.test.findOne({"name":"mrbird"})
> mrbird.blog = "mrbird's blog"
mrbird's blog
> db.test.update({"name":"mrbird"},mrbird)
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.test.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog"
}
```
`$inc`修改器用来增加或减少已有的键值，如果该键不存在则创造一个。比如：
```bash 
 > db.test.findOne({"name":"mrbird"})
    {
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog"
}
> db.test.update({"name":"mrbird"},{"$inc":{"pageview":1}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.test.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog",
    "pageview" : 1
}
> db.test.update({"name":"mrbird"},{"$inc":{"pageview":100}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.test.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog",
    "pageview" : 101
}
> db.test.update({"name":"mrbird"},{"$inc":{"pageview":-50}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.test.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog",
    "pageview" : 51
}
```
`$inc`只能用于整型，长整型或双精度浮点型的值。

`$set`用于修改文档的字段值，当这个字段不存在的时候就创建一个。如： 
```bash
> db.test.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog",
    "pageview" : 51
}
> db.test.update({"_id":ObjectId("58a9ace92363ff29a7d881e9")}, 
... {"$set":{"note":"love leanote!!"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.test.findOne({"_id":ObjectId("58a9ace92363ff29a7d881e9")})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog",
    "pageview" : 51,
    "note" : "love leanote!!"
}
```
`$set`还可以修改键的类型，比如将note键的值改为数组类型：
```bash
> db.test.update({"_id":ObjectId("58a9ace92363ff29a7d881e9")},
... {"$set":{"note":["love leanote","the fun of code"]}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.test.findOne({"_id":ObjectId("58a9ace92363ff29a7d881e9")})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog",
    "pageview" : 51,
    "note" : [
        "love leanote",
        "the fun of code"
    ]
} 
```
`$set`也可以修改内嵌文档，比如：
```bash
> db.blog.findOne()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb",
    "comment" : {
        "name" : "xiaohema",
        "msg" : "学习了，感谢分享"
    }
}
> db.blog.update({"name":"mrbird's blog"},
... {"$set":{"comment.msg":"好，支持威武有希望了"}})
> db.blog.findOne()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb",
    "comment" : {
        "name" : "xiaohema",
        "msg" : "好，支持威武有希望了"
    }
} 
```
使用`$unset`可删除键，比如：
```bash
> db.test.update({"_id":ObjectId("58a9ace92363ff29a7d881e9")},
... {"$unset":{"note":1}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.test.findOne({"_id":ObjectId("58a9ace92363ff29a7d881e9")})
{
    "_id" : ObjectId("58a9ace92363ff29a7d881e9"),
    "name" : "mrbird",
    "blog" : "mrbird's blog",
    "pageview" : 51
}
```
### 数组修改器
`$push`会向已有的数组末尾添加一个值，如果数组不存在，则创建该数组。比如：
```bash
> db.blog.findOne()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb"
}
> db.blog.update({"name":"mrbird's blog"}, {"$push":
...{"comments": {"name":"ltsc","msg":"不明觉厉"}}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.blog.findOne()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb",
    "comments" : [
        {
            "name" : "ltsc",
            "msg" : "不明觉厉"
        }
    ]
}
```
如果要一次性向数组中添加多个值，可以使用`$push`结合`$each`修改器。比如：
```bash
> db.blog.update({"name":"mrbird's blog"},
... {"$push":{"comments":{"$each":[
... {"name":"Althars","msg":"siguoyi"},
... {"name":"jint","msg":"厉害了我的哥"}]}}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.blog.findOne()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb",
    "comments" : [
        {
            "name" : "ltsc",
            "msg" : "不明觉厉"
        },
        {
            "name" : "Althars",
            "msg" : "siguoyi"
        },
        {
            "name" : "jint",
            "msg" : "厉害了我的哥"
        }
    ]
```
`$slice`可以在为数组添加值的时候截取数组，但必须配合`$push`和`$each`一起使用，否则报语法错误，比如：
```bash
> db.user.findOne()
{
    "_id" : ObjectId("58aa5e8a6a294f5543ff66eb"),
    "name" : "KangKang",
    "sex" : "male",
    "habbit" : [
        "basketball",
        "football",
        "swimming",
        "running"
    ]
}
> db.user.update({"name":"KangKang"},
... {"$push":{"habbit":{"$each":
... ["eating"],"$slice":-3}}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.findOne()
{
    "_id" : ObjectId("58aa5e8a6a294f5543ff66eb"),
    "name" : "KangKang",
    "sex" : "male",
    "habbit" : [
        "swimming",
        "running",
        "eating"
    ]
}
```
从结果可以看出，`$slice`截取了数组最新的三个值。注意，`$slice`的值必须是负整数。

现在有这么一种情况，`$push`修改器可以向一个数组中添加重复的值，如：
```bash
> db.user.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58aa7cb06a294f5543ff66ec"),
    "name" : "mrbird",
    "email" : [
        "mrbird@qq.com"
    ]
}
> db.user.update({"name":"mrbird"}, {"$push":{"email":"mrbird@qq.com"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58aa7cb06a294f5543ff66ec"),
    "name" : "mrbird",
    "email" : [
        "mrbird@qq.com",
        "mrbird@qq.com"
    ]
}
```
如果希望数组中添加的值不重复的话，可以使用`$addToSet`修改器：
```bash
> db.user.update({"name":"mrbird"}, {"$unset":{"email":1}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.findOne({"name":"mrbird"})
{ "_id" : ObjectId("58aa7cb06a294f5543ff66ec"), "name" : "mrbird" }
> db.user.update({"name":"mrbird"}, 
... {"$addToSet":{"email":{"$each":["mrbird@qq.com","mrbird@qq.com","mrbird@gmail.com"]}}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58aa7cb06a294f5543ff66ec"),
    "name" : "mrbird",
    "email" : [
        "mrbird@qq.com",
        "mrbird@gmail.com"
    ]
}
```
删除数组元素有几种方法，比如`$pop`，`{“$pop”:{"key":1}}`表示从数组尾部删除元素，-1则表示从头部删除：
```bash
> db.user.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58aa7cb06a294f5543ff66ec"),
    "name" : "mrbird",
    "email" : [
        "mrbird@qq.com",
        "mrbird@gmail.com"
    ]
}
> db.user.update({"name":"mrbird"},
... {"$pop":{"email":1}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.findOne({"name":"mrbird"})
{
    "_id" : ObjectId("58aa7cb06a294f5543ff66ec"),
    "name" : "mrbird",
    "email" : [
        "mrbird@qq.com"
    ]
}
```
另外一个删除数组元素的修改器为`$pull`，该操作符会将所有匹配的元素从数组中删除。比如：
```bash
> db.user.update({"name":"KangKang"},
... {"$push":{"habbit":"eating"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.findOne({"name":"KangKang"})
{
    "_id" : ObjectId("58aa5e8a6a294f5543ff66eb"),
    "name" : "KangKang",
    "sex" : "male",
    "habbit" : [
        "swimming",
        "running",
        "eating",
        "eating"
    ]
}
> db.user.update({"name":"KangKang"},
... {"$pull":{"habbit":"eating"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.findOne({"name":"KangKang"})
{
    "_id" : ObjectId("58aa5e8a6a294f5543ff66eb"),
    "name" : "KangKang",
    "sex" : "male",
    "habbit" : [
        "swimming",
        "running"
    ]
}    
```
还可以通过数组的下标修改数组内容，如下所示：
```bash
> db.blog.find({"name":"mrbird's blog"}).pretty()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb",
    "comments" : [
            {
                "name" : "ltsc",
                "msg" : "不明觉厉"
            },
            {
                "name" : "Althars",
                "msg" : "siguoyi"
            },
            {
                "name" : "jint",
                "msg" : "厉害了我的哥"
            }
    ]
}
> db.blog.update({"name":"mrbird's blog"},
... {"$set":{"comments.1.msg":"四国以"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.blog.find({"name":"mrbird's blog"}).pretty()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb",
    "comments" : [
            {
                "name" : "ltsc",
                "msg" : "不明觉厉"
            },
            {
                "name" : "Althars",
                "msg" : "四国以"
            },
            {
                "name" : "jint",
                "msg" : "厉害了我的哥"
            }
    ]
}
```
这种做法有局限性，就是必须先知道待修改字段的数组下标，可以使用另外一种方法，下面这种方法只需要知道待修改字段就行了：
```bash
> db.blog.update({"comments.msg":"四国以"},
... {"$set":{"comments.$.msg":"看完此文，犹如醍醐灌顶"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.blog.find({"name":"mrbird's blog"}).pretty()
{
    "_id" : ObjectId("58aa47f645b899838bfb6114"),
    "name" : "mrbird's blog",
    "post" : "mongodb",
    "comments" : [
            {
                "name" : "ltsc",
                "msg" : "不明觉厉"
            },
            {
                "name" : "Althars",
                "msg" : "看完此文，犹如醍醐灌顶"
            },
            {
                "name" : "jint",
                "msg" : "厉害了我的哥"
            }
    ]
}
```
`update`函数的第三个参数为`upsert`，设置为`true`时，新一个文档，没有找到匹配的查询文档时，插入该文档，找到了就更新，比如：
```bash
> db.blog.findOne({"name":"mrbrid","post":"MongoDB文档CUD"})
null
> db.blog.update({"name":"mrbrid","post":"MongoDB文档CUD"},
... {"$inc":{"pageview":1}},true)
WriteResult({
    "nMatched" : 0,
    "nUpserted" : 1,
    "nModified" : 0,
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45")
})
> db.blog.findOne({"name":"mrbrid","post":"MongoDB文档CUD"})
{
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"),
    "name" : "mrbrid",
    "post" : "MongoDB文档CUD",
    "pageview" : 1
}
```
update函数的第四个参数为`multi`，设置为`true`的时候，批量更新和查询文档匹配的文档，比如将mrbird's blog集合中所有文档的pageview增加1：
```bash
> db.blog.find().pretty()
{
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"),
    "name" : "mrbird's blog",
    "post" : "MongoDB文档CUD",
    "pageview" : 1
}
{
    "_id" : ObjectId("58acf64b3c8ad0b0d9d65f4a"),
    "name" : "mrbird's blog",
    "post" : "MongoDB shell",
    "pageview" : 1
}
{
    "_id" : ObjectId("58acf65d3c8ad0b0d9d65f4d"),
    "name" : "mrbird's blog",
    "post" : "start Spring Boot",
    "pageview" : 1
}
> db.blog.update({"name":"mrbird's blog"},{"$inc":{"pageview":1}},
... false,true)
WriteResult({ "nMatched" : 3, "nUpserted" : 0, "nModified" : 3 })
> db.blog.find().pretty()
{
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"),
    "name" : "mrbird's blog",
    "post" : "MongoDB文档CUD",
    "pageview" : 2
}
{
    "_id" : ObjectId("58acf64b3c8ad0b0d9d65f4a"),
    "name" : "mrbird's blog",
    "post" : "MongoDB shell",
    "pageview" : 2
}
{
    "_id" : ObjectId("58acf65d3c8ad0b0d9d65f4d"),
    "name" : "mrbird's blog",
    "post" : "start Spring Boot",
    "pageview" : 2
}
```
另外，调用`getLastError`可查看最近一次更新的文档数量，如：
```bash
> db.runCommand({getLastError:1})
{
    "connectionId" : 1,
    "updatedExisting" : true,
    "n" : 3,
    "syncMillis" : 0,
    "writtenTo" : null,
    "err" : null,
    "ok" : 1
}
```
拥有类似事务特性的更新与查询操作`findAndModify`。它是原子性的，会返回符合查询条件的更新后的文档。一次最多只更新一个文档，也就是条件`query`条件，且执行`sort`后的第一个文档。语法如下：
```bash
db.COLLECTION_NAME.findAndModify({
    query:{},
    update:{},
    remove:true|false,
    new:true|false,
    sort:{},
    fields:{},
    upsert:true|false}
);﻿​
```
1. query是查询选择器，与findOne的查询选择器相同。

2. update是要更新的值，不能与remove同时出现。

3. remove表示删除符合query条件的文档，不能与update同时出现。

4. new为true：返回更新后的文档，false：返回更新前的，默认是false。

5. sort：排序条件，与sort函数的参数一致。

6. fields:投影操作，与find的第二个参数一致。

7. upsert:与update的upsert参数一样。

例子：
```bash
> db.blog.findAndModify({
... "query":{"name":"mrbird's blog"},
... "update":{
... "$inc":{"pageview":1},
... "$set":{"like":1}}})
{
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"),
    "name" : "mrbird's blog",
    "post" : "MongoDB文档CUD",
    "pageview" : 3
}
> db.blog.find().pretty()
{
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"),
    "name" : "mrbird's blog",
    "post" : "MongoDB文档CUD",
    "pageview" : 4,
    "like" : 1
}
{
    "_id" : ObjectId("58acf64b3c8ad0b0d9d65f4a"),
    "name" : "mrbird's blog",
    "post" : "MongoDB shell",
    "pageview" : 3
}
{
    "_id" : ObjectId("58acf65d3c8ad0b0d9d65f4d"),
    "name" : "mrbird's blog",
    "post" : "start Spring Boot",
    "pageview" : 3
} 
```
可发现，执行`findAndModify`后，返回被更新前（默认显示更新前的）的文档，并且只更新了匹配的第一条文档。

如果要返回被更新后的文档，我们设置new 为true：
```bash
> db.blog.findAndModify({ 
..."query":{"name":"mrbird's blog"}, 
..."update":{  "$inc":{"pageview":1}, "$set":{"like":2}},
..."new":true})
{
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"),
    "name" : "mrbird's blog",
    "post" : "MongoDB文档CUD",
    "pageview" : 5,
    "like" : 2
}
```
> [《MongoDB权威指南》](https://book.douban.com/subject/25960887/)读书笔记 