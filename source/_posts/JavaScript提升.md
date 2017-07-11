---
title: JavaScript中的提升
date: 2017-07-11 19:26:28
tags: JavaScript
---
对于`var a = 3`我们一般认为这是一个声明，但上JavaScript引擎并不这么认为。它将`var a`和`a = 2`当作两个单独的声明，第一个是编译阶段的任务，而第二个则是执行阶段的任务

这意味着无论作用域中的声明出现在什么地方，都将在代码本身被执行前首先进行处理。可以将这个过程形象地想象成所有的声明（变量和函数）都会被“移动”到各自作用域的最顶端，这个过程被称为**提升**。
<!--more-->
考虑如下代码段：
```javascript
a = 3;
var a;
console.log(a);
```
可能你会觉得上述代码将输出`undefined`，但其实际上它能够如愿的输出3。因为上述代码在经过JavaScript引擎编译之后，变成了这样：
```javascript
var a;
a = 3;
console.log(a);
```
这种对变量的声明被拉到其作用域的最顶端的过程就是**提升**。

再如有如下代码段：
```javascript
console.log(a);
var a = 3;
```
上述代码将输出`undefined`，而非`ReferenceError`异常，如上所述，在经过JavaScript引擎编译之后，`var a`被提升到了作用于顶部：
```javascript
var a;
console.log(a);
a = 3;
```
所以对a的RHS查询并不会失败，只不过a为`undefined`罢了。

函数的声明也可以被提升，比如：
```javascript
foo(); // 3
function foo() {
   var a = 3;
   console.log(a);
}
```
实际上为：
```javascript
function foo() {
   var a = 3;
   console.log(a);
}
foo(); // 3
```
函数声明的提升需要注意一点：

**函数优先原则**：函数声明和变量声明都会被提升。但函数声明将先被提升：
```javascript
foo(); // 4
var foo = function() {
   var a = 3;
   console.log(a);
}
function foo() {
   var a = 4;
   console.log(a);
}
```
经过JavaScript引擎编译之后，代码变成：
```javascript
function foo() {
   var a = 4;
   console.log(a);
}
foo();
foo = function() {
   var a = 3;
   console.log(a);
}
```
其中`var foo`这个重复的声明已经被略去。

> [《你不知道的JavaScript上卷》](https://book.douban.com/subject/26351021/)读书笔记