---
title: JSON小记
date: 2016-10-25 10:33:47
tags: JSON
---
JSON全称`JavaScript Object Notation`，是一种轻量级的数据交换格式，取名自JavaScript对象，但两者之间并没有什么直接的联系。JSON语法和JavaScript对象语法上区别如下表所示：

<!--more-->
<table>
        <tr>
            <th>
                对比内容
            </th>
            <th>
                JSON
            </th>
            <th>
                JS对象
            </th>
        </tr>
        <tr>
            <td>
                键名
            </td>
            <td>
                必须是加双引号
            </td>
            <td>
                    可允许不加、加单引号、加双引号
            </td>
        </tr>
        <tr>
            <td>
                属性值
            </td>
            <td>
                
                    只能是数值（10进制）、
                
                
                    字符串（双引号）、
                
                
                    布尔值和null，
                
                
                    也可以是数组或者符合</br>
                
                
                    JSON要求的对象，
                
                
                    不能是函数、NaN, Infinity,
                
                
                    &nbsp;-Infinity和undefined
                
            </td>
            <td>
                什么都可以
            </td>
        </tr>
        <tr>
            <td>
                逗号问题
            </td>
            <td>
                最后一个属性后面不能有逗号
            </td>
            <td>
                可以
            </td>
        </tr>
        <tr>
            <td>
                数值
            </td>
            <td>
                前导0不能用，小数点后必须有数字
            </td>
            <td>
                没限制
            </td>
        </tr>
</table>

可以看到，相对于JS对象，JSON的格式更严格，所以大部分写的JS对象是不符合JSON的格式的。

如：
```javascript
var obj1 = {}; // 这只是 JS 对象
 
// 可把这个称做：JSON 格式的 JavaScript 对象 
var obj2 = {"width":100,"height":200,"name":"rose"};
 
// 可把这个称做：JSON 格式的字符串
var str1 = '{"width":100,"height":200,"name":"rose"}';
 
// 这个可叫 JSON 格式的数组，是 JSON 的稍复杂一点的形式
var arr = [  
    {"width":100,"height":200,"name":"rose"},
    {"width":100,"height":200,"name":"rose"},
    {"width":100,"height":200,"name":"rose"},
];
 
// 这个可叫稍复杂一点的 JSON 格式的字符串     
var str2='['+  
    '{"width":100,"height":200,"name":"rose"},'+
    '{"width":100,"height":200,"name":"rose"},'+
    '{"width":100,"height":200,"name":"rose"},'+
']'; 
```
以下是JSON的一些转换方法。
## JavaScript
### js对象→json字符串
转换函数`JSON.stringify`，函数签名如下所示：
```javascript
JSON.stringify(value[, replacer [, space]]) 
```
下面将分别展开带1~3个参数的用法：

**基本使用——仅需一个参数**

```javascript
//创建js对象
var obj = {"name":"mrbird","age":24};
//将此对象转成json字符串
var str = JSON.stringify(obj);
// "{"name":"mrbird","age":24}"
```
**第二个参数可以是函数，也可以是一个数组**

如果第二个参数是一个函数，那么序列化过程中的每个属性都会被这个函数转化和处理.

如果第二个参数是一个数组，那么只有包含在这个数组中的属性才会被序列化到最终的JSON字符串中。

如果第二个参数是`null`，那作用上和空着没啥区别，但是不想设置第二个参数，只是想设置第三个参数的时候，就可以设置第二个参数为`null`。

这第二个参数若是函数：

```javascript
var friend={  
    "firstName": "Good",
    "lastName": "Man",
    "phone":"1234567",
    "age":18
};
 
var friendAfter=JSON.stringify(friend,function(key,value){  
    if(key==="phone")
        return "(000)"+value;
    else if(typeof value === "number")
        return value + 10;
    else
        return value; //如果你把这个else分句删除，那么结果会是undefined
});
 
console.log(friendAfter);  
//输出：{"firstName":"Good","lastName":"Man","phone":"(000)1234567","age":28}
```
第二个参数若是数组：
```javascript
var friend={  
    "firstName": "Good",
    "lastName": "Man",
    "phone":"1234567",
    "age":18
};
 
//注意下面的数组有一个值并不是上面对象的任何一个属性名
var friendAfter=JSON.stringify(friend,["firstName","address","phone"]);
 
console.log(friendAfter);  
//{"firstName":"Good","phone":"1234567"}
//指定的“address”由于没有在原来的对象中找到而被忽略
```
如果第二个参数是一个数组，那么只有在数组中出现的属性才会被序列化进结果字符串，只要在这个提供的数组中找不到的属性就不会被包含进去，而这个数组中存在但是源JS对象中不存在的属性会被忽略，不会报错。

**第三个参数用于美化输出**

指定缩进用的空白字符，可以取以下几个值：

· 是1-10的某个数字，代表用几个空白字符

· 是字符串的话，就用该字符串代替空格，最多取这个字符串的前10个字符

· 没有提供该参数等于设置成null，也等于设置一个小于1的数

```javascript
var friend={  
    "firstName": "Good",
    "lastName": "Man",
    "phone":{"home":"1234567","work":"7654321"}
};
 
//直接转化是这样的：
//{"firstName":"Good","lastName":"Man","phone":{"home":"1234567","work":"7654321"}}
 
var friendAfter=JSON.stringify(friend,null,4);  
console.log(friendAfter);  
/*
{
    "firstName": "Good",
    "lastName": "Man",
    "phone": {
        "home": "1234567",
        "work": "7654321"
    }
}
*/
 
var friendAfter=JSON.stringify(friend,null,"HAHAHAHA");  
console.log(friendAfter);  
/*
{
HAHAHAHA"firstName": "Good",  
HAHAHAHA"lastName": "Man",  
HAHAHAHA"phone": {  
HAHAHAHAHAHAHAHA"home": "1234567",  
HAHAHAHAHAHAHAHA"work": "7654321"  
HAHAHAHA}  
}
*/
 
var friendAfter=JSON.stringify(friend,null,"WhatAreYouDoingNow");  
console.log(friendAfter);  
/* 最多只取10个字符
{
WhatAreYou"firstName": "Good",  
WhatAreYou"lastName": "Man",  
WhatAreYou"phone": {  
WhatAreYouWhatAreYou"home": "1234567",  
WhatAreYouWhatAreYou"work": "7654321"  
WhatAreYou}  
}
*/
```
`JSON.stringify`函数有几个需要注意的地方：

1.键名不是双引号的（包括没有引号或者是单引号），会自动变成双引号；字符串是单引号的，会自动变成双引号。

2.最后一个属性后面有逗号的，会被自动去掉。

3.非数组对象的属性不能保证以特定的顺序出现在序列化后的字符串中 这个好理解，也就是对非数组对象在最终字符串中不保证属性顺序和原来一致。

4.布尔值、数字、字符串的包装对象在序列化过程中会自动转换成对应的原始值 也就是你的什么`new String(“bala”)`会变成”bala”，`new Number(2017)`会变成2017。

5.`undefined`、任意的函数（其实有个函数会发生神奇的事，后面会说）以及 symbol值。

- 出现在非数组对象的属性值中：在序列化过程中会被忽略。

- 出现在数组中时：被转换成 `null`。

```javascript
JSON.stringify({x: undefined, y: function(){return 1;}, z: Symbol("")});  
//出现在非数组对象的属性值中被忽略："{}"
JSON.stringify([undefined, Object, Symbol("")]);  
//出现在数组对象的属性值中，变成null："[null,null,null]"
```
### 将JSON字符串解析为JS数据结构
函数`JSON.parse`的签名如下：
```javascript
JSON.parse(text[, reviver]) ﻿ 
```
如果第一个参数，即JSON字符串不是合法的字符串的话，那么这个函数会抛出错误。值得注意的是这里有一个可选的第二个参数，这个参数必须是一个函数，这个函数作用在属性已经被解析但是还没返回前，将属性处理后再返回。
```javascript
var friend={  
    "firstName": "Good",
    "lastName": "Man",
    "phone":{"home":"1234567","work":["7654321","999000"]}
};
 
//我们先将其序列化
var friendAfter=JSON.stringify(friend);  
//'{"firstName":"Good","lastName":"Man","phone":{"home":"1234567","work":["7654321","999000"]}}'
 
//再将其解析出来，在第二个参数的函数中打印出key和value
JSON.parse(friendAfter,function(k,v){  
    console.log(k);
    console.log(v);
    console.log("----");
});
/*
firstName  
Good  
----
lastName  
Man  
----
home  
1234567  
----
0  
7654321  
----
1  
999000  
----
work  
[]
----
phone  
Object  
----
 
Object  
----
*/
```
仔细看一下这些输出，可以发现这个遍历是由内而外的，可能由内而外这个词大家会误解，最里层是内部数组里的两个值啊，但是输出是从第一个属性开始的，怎么就是由内而外的呢？

这个由内而外指的是对于复合属性来说的，通俗地讲，遍历的时候，从头到尾进行遍历，如果是简单属性值（数值、字符串、布尔值和null），那么直接遍历完成，如果是遇到属性值是对象或者数组形式的，那么暂停，先遍历这个子JSON，而遍历的原则也是一样的，等这个复合属性遍历完成，那么再完成对这个属性的遍历返回。

本质上，这就是一个深度优先的遍历。
### 影响 JSON.stringify 的神奇函数——object.toJSON 
如果你在一个JS对象上实现了`toJSON`方法，那么调用`JSON.stringify`去序列化这个JS对象时，`JSON.stringify`会把这个对象的`toJSON`方法返回的值作为参数去进行序列化。
```javascript
var info={  
    "msg":"I Love You",
    "toJSON":function(){
        var replaceMsg=new Object();
        replaceMsg["msg"]="Go Die";
        return replaceMsg;
    }
};
 
JSON.stringify(info);  
//出si了，返回的是：'"{"msg":"Go Die"}"',说好的忽略函数呢
```
这个函数就是这样子的。

其实Date类型可以直接传给`JSON.stringify`做参数，其中的道理就是，Date类型内置了`toJSON`方法。
## Java
下面是JSON和Java对象等的转换方法。准备工作，创建Emp实体类：
```java
public class Emp implements Serializable {
    private String name;
    private Integer age;
    
    public Emp() {
    	
    }
    public Emp(String name, Integer age) {
        super();
        this.name = name;
        this.age = age;
    }
    //get,set略
}
```
### java对象→json字符串
```java
@Test
public void test1() {
    //1.获取Java对象
    Emp e = new Emp("mrbird",24);
    //2.先将其转换成json对象(Map)
    JSONObject obj = JSONObject.fromObject(e);
    //3.在将json对象转成字符串
    System.out.println(obj.toString());
}
```
输出：
```xml
{"age":24,"name":"mrbird"}
```
### 集合/数组→json字符串
```java
@Test
public void test2() {
    //1.获取集合/数组
    List<Emp> list = new ArrayList<Emp>();
    list.add(new Emp("mrbird",24));
    list.add(new Emp("leanote",33));
    //2.先把集合转成json数组(List)
    JSONArray ary = JSONArray.fromObject(list);
    //3.把整个数组转成字符串
    System.out.println(ary.toString());
}
```
输出：
```xml
[{"age":24,"name":"mrbird"},{"age":33,"name":"leanote"}]
```
### json字符串→java对象
```java
@Test
public void test3() {
    //1.获取json字符串
    String str = "{\"name\":\"mrbird\",\"age\":24}";
    //2.将此字符串转成json对象(Map)
    JSONObject obj = JSONObject.fromObject(str);
    //3.将json对象转换成Java对象(bean)
    Emp e = (Emp)JSONObject.toBean(obj, Emp.class);
    System.out.println(e.getName());
}
```
输出：
```xml
mrbird
```
### json字符串转→List 
```java
@Test
public void test4() {
    //1.获取json字符串
    String str = 
    	"[{\"name\":\"mrbird\",\"age\":24}," +
    	"{\"name\":\"leanote\",\"age\":33}]";
    //2.先将此字符串转成json数组(List)
    //当前List中存的是Map。
    JSONArray ary = JSONArray.fromObject(str);
    //3.将List<Map>转成List<Emp>
    //JSONArray会自动实例化一个集合，然后将ary中的每一个Map转成Emp，
    //增加到这个新建的集合中
    List<Emp> list = (List<Emp>)JSONArray.toCollection(ary, Emp.class);
    for(Emp e : list) {
        System.out.println(e.getName());
    }
}
```
> 参考文章 -- [JSON：如果你愿意一层一层剥开我的心，你会发现...这里水很深——深入理解JSON](https://apriltail.com/2017/03/25/json-ru-guo-ni-yuan-yi-yi-ceng-yi-ceng-bo-kai-wo-de-xin-ni-hui-fa-xian-zhe-li-shui-hen-shen-shen-ru-li-jie-json/)
