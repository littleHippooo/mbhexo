---
title: JavaScript中的块级作用域
date: 2017-07-12 10:36:50
tags: JavaScript
---
所谓的**块级作用域**通俗的讲就是使用`{}`创造一个代码块，然后在这之中声明的变量在代码块之外都是不可访问的。

在ES6标准发布之前，JavaScript表面上并没有的块级作用域的概念，但其实际包含一些隐式的块级作用域：函数作用域和`try/catch`。ES6中新增了`let`关键字，也可以显式的创造块级作用域。
<!--more-->

JavaScript中，`for`循环和`if`等语句都可以创建“块”，但其并不是块级作用域：
```javascript
// for 
for (var i = 0; i <= 3; i++) {
    var a = 5;
}
console.log(i); // 4
console.log(a); // 5

// if
if (true) {
    var b = 6;
}
console.log(b); // 6
```
可见在块里面声明的变量都被泄漏到外部作用域中了。
### 函数作用域
函数作用域实际上就是一个块级作用域：
```javascript
function foo() {
    var a = 3;
}
console.log(a); // ReferenceError: a is not defined
```
在函数外部对a的RHS查询失败，所以抛出`ReferenceError`异常。
### try/catch
ES3 规范中规定`try/catch`的`catch`分句会创建一个块作用域，其中声明的变量仅在`catch`内部有效。
```javascript
try {
    throw 2;
} catch (a) {
    console.log(a); // 2
}
console.log(a); // ReferenceError: a is not defined
```
### let
ES6引入的`let`关键字配合`{}`可以显示地创建块级作用域：
```javascript
{
    let a = 3;
    console.log(a); // 3
}
console.log(a); // ReferenceError: a is not defined
```
`const`关键字也可以创建块级作用域，只不过`const`用于声明常量罢了。