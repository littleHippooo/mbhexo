---
title: MongoDB 文档查询
date: 2017-02-22 14:17:26
tags: [MongoDB,DataBase]
---
MongoDB查询涵盖以下几个方面：

1.使用find或者findOne函数和查询文档对数据库执行查询；

2.使用$条件查询实现范围查询，数据集包含查询，不等式查询，以及其它一些查询；

3.查询将会返回一个数据库游标，游标只会在你需要时才将需要的文档批量返回；

4.针对游标执行的元操作，包括忽略一定数量的结果，或者限定返回结果的数量，以及对结果排序。
<!--more-->
## find简介
指定需要返回的键

比如，我只对blog集合的博文post感兴趣，可以使用以下查询语句：
```bash
> db.blog.find({},{"post":1})
{ "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"), "post" : "MongoDB文档CUD" }
{ "_id" : ObjectId("58acf64b3c8ad0b0d9d65f4a"), "post" : "MongoDB shell" }
{ "_id" : ObjectId("58acf65d3c8ad0b0d9d65f4d"), "post" : "start Spring Boot" }
```
如果不希望返回“_id”，可以这样：
```bash
> db.blog.find({},{"post":1,"_id":0})
{ "post" : "MongoDB文档CUD" }
{ "post" : "MongoDB shell" }
{ "post" : "start Spring Boot" }
```
## 查询条件    
### 比较操作符
MongoDB中的比较操作符有五种，其中`$gt`，`$gte`，`$lt`，`$lte`分别对应`>`，`>=`，`<`，`<=`，比如查询blog阅读量pageview大于5的文档：
```bash
> db.blog.find({"pageview":{"$gte":5}}).pretty()
{
    "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"),
    "name" : "mrbird's blog",
    "post" : "MongoDB文档CUD",
    "pageview" : 5,
    "like" : 2,
    "date" : ISODate("2017-02-22T05:45:03.006Z")
}   
```
这四种操作符也可用于日期比较，比如：
```bash
> var date = new Date("01/01/2017")
> db.blog.find({"date":{"$gte":date}},
... {"post":1,"date":1,"_id":0})
{ "post" : "MongoDB文档CUD", "date" : ISODate("2017-02-22T05:45:03.006Z") }
{ "post" : "MongoDB shell", "date" : ISODate("2017-02-22T05:45:03.006Z") }
{ "post" : "start Spring Boot", "date" : ISODate("2017-02-22T05:45:03.006Z") }
```
另外一个比较操作符为`$ne`，`not equal`，可以用于所有类型，比如：
```bash
> db.blog.find({"post":{"$ne":"MongoDB shell"}},
... {"post":1})
{ "_id" : ObjectId("58acf0743c8ad0b0d9d65f45"), "post" : "MongoDB文档CUD" }
{ "_id" : ObjectId("58acf65d3c8ad0b0d9d65f4d"), "post" : "start Spring Boot" }
```
### OR查询
`$in`操作符可以查询一个键的多个值，比如：
```bash
> db.blog.find({"post":{"$in":["MongoDB文档CUD","MongoDB shell"]}},
... {"post":1,"_id":0})
{ "post" : "MongoDB文档CUD" }
{ "post" : "MongoDB shell" }  
```
其中数组中的值可以是不同类型的。

与`$in`相反的是`$nin`，如：
```bash
> db.blog.find({"post":{"$nin":["MongoDB文档CUD","MongoDB shell"]}},
... {"post":1,"_id":0})
{ "post" : "start Spring Boot" }
```
`$or`操作符和SQL中的含义类似，比如查询post为MongoDB文档CUD或者pageview为3的文档：
```bash
> db.blog.find({"$or":[{"post":"MongoDB文档CUD"},{"pageview":3}]},
...{"post":1,"pageview":1,"_id":0}).pretty()
{ "post" : "MongoDB文档CUD", "pageview" : 5 }
{ "post" : "MongoDB shell", "pageview" : 3 }
{ "post" : "start Spring Boot", "pageview" : 3 }
```
### $not  
`$mod`为取模运算符，比如查询pageview为3的倍数的博文：
```bash
> db.blog.find({"pageview":{"$mod":[3,0]}},{"post":1,"pageview":1,"_id":0})
{ "post" : "MongoDB shell", "pageview" : 3 }
{ "post" : "start Spring Boot", "pageview" : 3 }
```
`$not`运算符用于取反，比如取pageview不为3的倍数的博文：
```bash
> db.blog.find({"pageview":{"$not":{"$mod":[3,0]}}}, 
...{"post":1,"pageview":1,"_id":0})
{ "post" : "MongoDB文档CUD", "pageview" : 5 }
```
### $and
`$and`操作符和SQL中的含义类似，比如查找post为MongoDB文档CUD且pageview大于3的文档：
```bash
> db.blog.find({"$and":[{"post":"MongoDB文档CUD"},{"pageview":{"$gt":3}}]},
... {"post":1,"pageview":1,"_id":0})
{ "post" : "MongoDB文档CUD", "pageview" : 5 }    
```
## 特定类型的查询
`null`。查询文档某个键的值为`null`，会将不包含该键的文档也查询出来，比如：
```bash
> db.blog.find({},{"post":1,"like":1,"_id":0})
{ "post" : "MongoDB文档CUD", "like" : 2 }
{ "post" : "MongoDB shell" }
{ "post" : "start Spring Boot", "like" : null }
> db.blog.find({"like":null},{"post":1,"like":1,"_id":0})
{ "post" : "MongoDB shell" }
{ "post" : "start Spring Boot", "like" : null }  
```
可以通过`$exists`条件判断键是否存在，比如：
```bash
> db.blog.find({"like":{"$in":[null],"$exists":true}}, 
...{"post":1,"like":1,"_id":0})
{ "post" : "start Spring Boot", "like" : null }
```
MongoDB查询也支持键值的正则表达式匹配，这里就懒得记录了。
### 查询数组
先看个栗子：
```bash
> db.food.find()
{ "_id" : ObjectId("58ad45986596dd54570ce1ed"), "fruit" : [ "西瓜", "香蕉", "桃子" ] }
{ "_id" : ObjectId("58ad45c76596dd54570ce1ee"), "fruit" : [ "西瓜", "芒果", "杨桃" ] }
{ "_id" : ObjectId("58ad45f76596dd54570ce1ef"), "fruit" : [ "哈密瓜", "葡萄", "樱桃" ] }
> db.food.find({"fruit":"西瓜"})
{ "_id" : ObjectId("58ad45986596dd54570ce1ed"), "fruit" : [ "西瓜", "香蕉", "桃子" ] }
{ "_id" : ObjectId("58ad45c76596dd54570ce1ee"), "fruit" : [ "西瓜", "芒果", "杨桃" ] }
```
查找既包含西瓜又包含芒果的文档，使用`$all`操作符：
```bash
> db.food.find({"fruit":{"$all":["西瓜","芒果"]}})
{ "_id" : ObjectId("58ad45c76596dd54570ce1ee"), "fruit" : [ "西瓜", "芒果", "杨桃" ] }
```
其中，数组中值的顺序不重要。

如果不使用`$all` 就是精准匹配了，比如下面这个查询将查询不出任何结果：
```bash
> db.food.find({"fruit":["西瓜","芒果"]})
```
也可以根据数组的下标进行查询，比如：
```bash
> db.food.find({"fruit.1":"葡萄"})
{ "_id" : ObjectId("58ad45f76596dd54570ce1ef"), "fruit" : [ "哈密瓜", "葡萄", "樱桃" ] }
```
`$size`操作符用于根据数组的长度进行查询匹配，比如查找fruit数组长度为3的文档：
```bash
> db.food.find({"fruit":{"$size":3}})
{ "_id" : ObjectId("58ad45986596dd54570ce1ed"), "fruit" : [ "西瓜", "香蕉", "桃子" ] }
{ "_id" : ObjectId("58ad45c76596dd54570ce1ee"), "fruit" : [ "西瓜", "芒果", "杨桃" ] }
{ "_id" : ObjectId("58ad45f76596dd54570ce1ef"), "fruit" : [ "哈密瓜", "葡萄", "樱桃" ] }
```
注意：`$size`操作符不能`$gt`等比较操作符一起使用！

`$slice`操作符可以返回某个键匹配的数组元素的一个子集，比如：
```bash
> db.food.find({},{"fruit":{"$slice":2}})
{ "_id" : ObjectId("58ad45986596dd54570ce1ed"), "fruit" : [ "西瓜", "香蕉" ] }
{ "_id" : ObjectId("58ad45c76596dd54570ce1ee"), "fruit" : [ "西瓜", "芒果" ] }
{ "_id" : ObjectId("58ad45f76596dd54570ce1ef"), "fruit" : [ "哈密瓜", "葡萄" ] }
```
如果想返回数组的后两个元素，可以这样：
```bash
> db.food.find({},{"fruit":{"$slice":-2}})
{ "_id" : ObjectId("58ad45986596dd54570ce1ed"), "fruit" : [ "香蕉", "桃子" ] }
{ "_id" : ObjectId("58ad45c76596dd54570ce1ee"), "fruit" : [ "芒果", "杨桃" ] }
{ "_id" : ObjectId("58ad45f76596dd54570ce1ef"), "fruit" : [ "葡萄", "樱桃" ] }
```
`$slice`也可以指定偏移量，比如：
```bash
> db.food.find({},{"fruit":{"$slice":[1,3]}})
{ "_id" : ObjectId("58ad45986596dd54570ce1ed"), "fruit" : [ "香蕉", "桃子" ] }
{ "_id" : ObjectId("58ad45c76596dd54570ce1ee"), "fruit" : [ "芒果", "杨桃" ] }
{ "_id" : ObjectId("58ad45f76596dd54570ce1ef"), "fruit" : [ "葡萄", "樱桃" ] }
```
[1,1]表示跳过前1个元素，返回第2~3个元素，如果没有那么多元素，就返回第2个元素之后的所有元素。
### 数组的范围查询
数组的范围查询需要注意一个问题，如：
```bash
> db.test.find()
{ "_id" : ObjectId("58b0eca3a263b332501bc7b5"), "x" : 5 }
{ "_id" : ObjectId("58b0eca9a263b332501bc7b6"), "x" : 15 }
{ "_id" : ObjectId("58b0ecaea263b332501bc7b7"), "x" : 25 }
{ "_id" : ObjectId("58b0ecbda263b332501bc7b8"), "x" : [ 5, 25 ] }    
> db.test.find({"x":{"$gt":10,"$lt":20}})
{ "_id" : ObjectId("58b0eca9a263b332501bc7b6"), "x" : 15 }
{ "_id" : ObjectId("58b0ecbda263b332501bc7b8"), "x" : [ 5, 25 ] }
```
查询结果不符合预期，因为数组中的5符合`$lt:20，25`符合`$gt:10`。要对数组元素进行范围查询，可借助`$elemMatch`操作符：
```bash
> db.test.find({"x":{"$elemMatch":{"$gt":10,"$lt":20}}})
> //查询不到任何结果
```
这个查询没有任何结果，因为`{ "_id" : ObjectId("58b0eca9a263b332501bc7b6"), "x" : 15 }`文档x的值不是数组类型，并且`$elemMatch`操作符使得数组元素的每一个值都必须与条件相匹配。
### 查询内嵌文档
```bash
> db.blog.find().pretty()
{
    "_id" : ObjectId("58b11d0ca263b332501bc7b9"),
    "title" : "MongoDB查询",
    "like" : "2",
    "comments" : {
        "name" : "ltsc",
        "comment" : "good post"
    }
}
{
    "_id" : ObjectId("58b11daca263b332501bc7ba"),
    "title" : "MongoDB shell",
    "like" : "3",
    "comments" : [
            {
                "name" : "ltsc",
                "comment" : "good post"
            },
            {
                "name" : "xiaohema",
                "comment" : "不明觉厉"
            }
    ]
} 
```
要查询包含名为"xiaohema"，并且评论为"不明觉厉的"博文，可以使用以下查询：
```bash
> db.blog.find({"comments":{"$elemMatch":{"name":"xiaohema","comment":"不明觉厉"}}}).pretty()
{
    "_id" : ObjectId("58b11daca263b332501bc7ba"),
    "title" : "MongoDB shell",
    "like" : "3",
    "comments" : [
            {
                "name" : "ltsc",
                "comment" : "good post"
            },
            {
                "name" : "xiaohema",
                "comment" : "不明觉厉"
            }
    ]
}
```
## $where查询    
当一般查询都不能满足查询要求的时候，可以考虑使用`$where`操作符，比如有如下文档：
```bash
> db.food.find({},{"_id":0})
{ "草莓蛋糕" : 4, "芝士蛋糕" : 5, "巧克力蛋糕" : 4 }
{ "摩卡咖啡" : 3, "拿铁咖啡" : 6, "热巧克力" : 1 }
```
现要查询含有相同数量食物的文档，可以使用`$where`操作符：
```bash
> db.food.find({"$where":function(){
... for(var current in this){
...     for(var next in this){
...         if(current != next && this[current] == this[next]){
...             return true;
...         }
...     }
... }
... }},{"_id":0})
{ "草莓蛋糕" : 4, "芝士蛋糕" : 5, "巧克力蛋糕" : 4 }
```
但是在实际情况下，出于对性能和安全的考虑，应该尽量不使用`$where`。
## 游标
MongoDB使用游标返回`find`查询结果，使用`hasNext`函数判断游标中是否还有其他结果，使用`next`函数来迭代结果，如：
```bash
> function create(){
... db.test.drop();
... for(var i = 0;i<100;i++){
...     db.test.insert({"x":i});
... }}
> create()
> var cursor = db.test.find()
> cursor.hasNext()
true
> cursor.next()
{ "_id" : ObjectId("58b12834a263b332501bc7bd"), "x" : 0 }
> cursor.next()
{ "_id" : ObjectId("58b12834a263b332501bc7be"), "x" : 1 }
> cursor.next()
{ "_id" : ObjectId("58b12834a263b332501bc7bf"), "x" : 2 }
```
游标还实现了JavaScript的迭代器接口，可以使用`forEach`循环来迭代输出结果：
```bash
> cursor.forEach(function(x){
... print(x.x);
... })
3
4
5
6
7
...
98
99
> cursor.hasNext()
false
```
### limit，skip和sort
`limit`用于限制返回结果的数量，比如：
```bash
> db.test.find().limit(3)
{ "_id" : ObjectId("58b12834a263b332501bc7bd"), "x" : 0 }
{ "_id" : ObjectId("58b12834a263b332501bc7be"), "x" : 1 }
{ "_id" : ObjectId("58b12834a263b332501bc7bf"), "x" : 2 }
```
要是匹配的数量还不到3个，则返回匹配的数量。

`skip`则是用于跳过N个数量后，返回剩下的查询结果，比如：
```bash
> db.test.find().skip(97)
{ "_id" : ObjectId("58b12834a263b332501bc81e"), "x" : 97 }
{ "_id" : ObjectId("58b12834a263b332501bc81f"), "x" : 98 }
{ "_id" : ObjectId("58b12834a263b332501bc820"), "x" : 99 }
```
`sort`则是用于对返回结果的排序，-1表示降序，1表示升序，如：
```bash
> db.test.find().limit(4).sort({"x":-1})
{ "_id" : ObjectId("58b12834a263b332501bc820"), "x" : 99 }
{ "_id" : ObjectId("58b12834a263b332501bc81f"), "x" : 98 }
{ "_id" : ObjectId("58b12834a263b332501bc81e"), "x" : 97 }
{ "_id" : ObjectId("58b12834a263b332501bc81d"), "x" : 96 }
```
当使用`skip`略过较多数量文档时，速度会变得很慢，比如常用的分页需求：
```bash
> var page1 = db.test.find().limit(100)
> var page2 = db.test.find().skip(100).limit(100)
> var page3 = db.test.find().skip(200).limit(100)
```
正如前面所说的，这会导致速度很慢，可以使用下面这种思路取代，比如使用`date`降序来显示文档列表：
```bash
> var page1 = db.test.find().sort({"date":-1}).limit(100)
```
然后可以使用最后一个文档的`date`作为查询条件，如：
```bash
var latest = null
while(page1.hasNext()){
    latest = page1.next();
}
//获取下一页
var page2 = db.test.find({"date":{"$gt":{latest.date}}});
page2.sort({"date":-1}).limit(100); 
```
### 获取的一致性
看个栗子：
```bash
var cursor = db.test.find();
while(cursor.hasNext()){
    var current = curosr.next();
    var modify = process(current);
    db.test.save(modify);
}
```
其中`process`为某个修改文档函数。这样做当文档较大的时候，游标可能会多次返回同一个文档，而并不能预期的进行遍历。

因为当保存文档的时候，如果文档较大，文档间的空隙又不足，这时候文档无法预期的保存回数据库，MongoDB会将其挪至集合的末尾，为了避免这种情况，我们可以对查询添加快照。使用查询快照后，查询会对"_id"进行遍历，这就保证了每个文档只会返回一次，修改上述查询：
```bash
var cursor = db.test.find().snapshot();
```
> [《MongoDB权威指南》](https://book.douban.com/subject/25960887/)读书笔记    