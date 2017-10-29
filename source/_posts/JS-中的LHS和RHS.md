---
title: JS 中的LHS和RHS
date: 2016-12-18 15:20:00
tags: JavaScript
---
LHS和RHS的含义是"赋值操作符的左侧或右侧"，并不一定意味着就是“=赋值操作符的左侧或右侧“。赋值操作还有其他几种形式，因此在概念上最好将其理解为”赋值操作的目标是谁（LHS）“以及”谁是赋值操作的源头（RHS）“。

比如下面这个例子：
```javascript
function foo(a){
    console.log(a);
}
foo(2);
```
<!--more-->
最后一行foo(..)函数的调用需要对foo进行RHS引用，意味着去找到”foo的值，并把它给我“。

代码中，隐式的 a = 2 操作进行了一次LHS查询，找到赋值操作的目标a——foo函数的形式参数。接下来对a进行RHS引用，并将得到的值传给console.log(..)。console.log(..)本身也需要对console进行一次RHS引用，查找是否有一个叫作log的方法。

当LHS查询失败时，引擎会在全局作用域中创建该变量：
```javascript
function foo(a){
    b = a;
}
foo(2);
console.log(window.b); //2
```
当RHS查询失败时，引擎会抛出`ReferenceError`异常：
```javascript
function foo(){
    var b = a;
}
foo();
```
引擎抛出：`Uncaught ReferenceError: a is not defined`。

> [《你不知道的JavaScript上卷》](https://book.douban.com/subject/26351021/)读书笔记