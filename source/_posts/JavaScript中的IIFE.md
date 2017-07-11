---
title: JavaSript中的IIFE
date: 2017-07-11 18:49:23
tags: JavaScript
---
IIFE(Immediately Invoked Function Expression)指的是立即执行函数表达式，常见的形式有两种：`(function(){ .. })()`和`(function(){ .. }())`。IIFE的存在一般是为了减少命名污染的问题。考虑如下代码：
<!--more-->
```javascript
function foo() {
    var a = 3;
    console.log(a);
}
foo(); // 3
```
假如函数foo()只执行一次，我们更加关注的是函数所实现的功能而并不在意函数叫什么（因为并不需要在别的地方被调用），这时候建议使用IIFE来代替：
```javascript
(function() {
    var a = 3;
    console.log(a); // 3
})();
```
或者
```javascript
(function(){
    var a = 3;
    console.log(a); // 3
}());
```
为了提高函数的可读性，你可能会给这个匿名函数表达式加上一个名称，比如：
```javascript
(function foo(){
    var a = 3;
    console.log(a); // 3
}());
```
对IIFE的具名并不会污染其外部的词法作用域，你可以继续在外部声明一个名称为foo的函数，比如：
```javascript
function foo() {
    var a = 4;
    console.log(a); 
}
(function foo(){
    var a = 3;
    console.log(a); // 3
}());
foo(); // 4
```