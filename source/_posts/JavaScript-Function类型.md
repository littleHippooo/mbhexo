---
title: JavaScript Function类型
date: 2016-12-07 15:51:55
tags: JavaScript
---
## 函数声明与函数表达式
函数声明长这样：
```javascript
function sum(num1, num2){
    return num1 + num2;
}
```
函数表达式长这样：
```javascript
var sum = function(num1, num2){
    return num1 + num2;
};
```
<!--more-->
区别：

解析器在向执行环境中加载数据时，对函数声明和函数表达式并非一视同仁。解析器会率先读取函数声明，并使其在执行任何代码之前可用（可以访问）；至于函数表达式，则必须等到解析器执行到它所在的代码行，才会真正被解释执行。

如下面语句不报错：
```javascript
alert(sum(10,10));
function sum(num1, num2){
    return num1 + num2;
}
```
而下面语句报错：
```javascript
alert(sum(10,10));
var sum = function(num1, num2){
    return num1 + num2;
};
```
除了什么时候可以通过变量访问函数这一点区别之外，函数声明与函数表达式的语法其实是等价的。
## 作为值的函数
因为ECMAScript 中的函数名本身就是变量，所以函数也可以作为值来使用。也就是说，不仅可以像传递参数一样把一个函数传递给另一个函数，而且可以将一个函数作为另一个函数的结果返回。如：
```javascript
function callSomeFunction(someFunction, someArgument){
    return someFunction(someArgument);
}
function add10(num){
    return num + 10;
}
var result1 = callSomeFunction(add10, 10);
alert(result1); //20
```
## 函数内部属性
### arguments

在函数体内可以通过`arguments` 对象来访问参数数组，从而获取传递给函数的每一个参数，比如定义一个计算任意个参数的和的函数：
```javascript
function sum() {
    var s = 0;
    for(var i=0;i<arguments.length;i++) {
        s += arguments[i];
    }
    return s;
}
```
虽然`arguments`的主要用途是保存函数参数，但这个对象还有一个名叫`callee`的属性，该属性是一个指针，指向拥有这个`arguments`对象的函数。请看下面这个非常经典的阶乘函数。  
```javascript
function factorial(num){
    if (num <=1) {
        return 1;
    } else {
        return num * factorial(num-1)
    }
}    
```
这个函数的执行与函数名factorial 紧紧耦合在了一起。为了消除这种紧密耦合的现象，可以像下面这样使用`arguments.callee`。
```javascript
function factorial(num){
    if (num <=1) {
        return 1;
    } else {
        return num * arguments.callee(num-1)
    }
} 
```
### this      
`this`引用的是函数据以执行的环境对象——或者也可以说是this 值（当在网页的全局作用域中调用函数时，this 对象引用的就是window）。如：
```javascript
window.color = "red";
var o = { color: "blue" };
function sayColor(){
    alert(this.color);
}
sayColor(); //"red"
o.sayColor = sayColor;
o.sayColor(); //"blue" 
```
### caller

ECMAScript 5 也规范化了另一个函数对象的属性：`caller`。这个属性中保存着调用当前函数的函数的引用，如果是在全局作用域中调用当前函数，它的值为`null`。例如： 
```javascript
function outer(){
    inner();
}
function inner(){
    alert(inner.caller);
}
outer(); 
```
以上代码会导致警告框中显示outer()函数的源代码。因为outer()调用了inner()，所以inner.caller 就指向outer()。  
## 属性和方法
ECMAScript 中的函数是对象，因此函数也有属性和方法。每个函数都包含两个属性：length 和prototype。
### length
`length`属性表示函数希望接收的命名参数的个数，如下面的例子所示。 
```javascript
function sayName(name){
    alert(name);
}
function sum(num1, num2){
    return num1 + num2;
}
function sayHi(){
    alert("hi");
}
alert(sayName.length); //1
alert(sum.length); //2
alert(sayHi.length); //0
```
### prototype    
对于ECMAScript 中的引用类型而言，`prototype`是保存它们所有实例方法的真正所在。如：
```javascript
function Person(){
}
Person.prototype.name = "Nicholas";
Person.prototype.age = 29;
Person.prototype.job = "Software Engineer";
Person.prototype.sayName = function(){
    alert(this.name);
};
var person1 = new Person();
person1.sayName(); //"Nicholas"
var person2 = new Person();
person2.sayName(); //"Nicholas"
alert(person1.sayName == person2.sayName); //true
```
可以通过`isPrototypeOf()`方法来确定一个对象是否是另一个对象的原型：
```javascript
alert(Person.prototype.isPrototypeOf(person1)); //true
alert(Person.prototype.isPrototypeOf(person2)); //true
```
使用`Object.getPrototypeOf()`可以方便地取得一个对象的原型：
```javascript
alert(Object.getPrototypeOf(person1) == Person.prototype); //true
alert(Object.getPrototypeOf(person1).name); //"Nicholas"
```
每当代码读取某个对象的某个属性时，都会执行一次搜索，目标是具有给定名字的属性。搜索首先从对象实例本身开始。如果在实例中找到了具有给定名字的属性，则返回该属性的值；如果没有找到，则继续搜索指针指向的原型对象，在原型对象中查找具有给定名字的属性。如果在原型对象中找到了这个属性，则返回该属性的值。

虽然可以通过对象实例访问保存在原型中的值，但却不能通过对象实例重写原型中的值。如果我们在实例中添加了一个属性，而该属性与实例原型中的一个属性同名，那我们就在实例中创建该属性，该属性将会屏蔽原型中的那个属性。
```javascript
function Person(){
}
Person.prototype.name = "Nicholas";
Person.prototype.age = 29;
Person.prototype.job = "Software Engineer";
Person.prototype.sayName = function(){
    alert(this.name);
};
var person1 = new Person();
var person2 = new Person();
person1.name = "Greg";
alert(person1.name); //"Greg"——来自实例
alert(person2.name); //"Nicholas"——来自原型
```
使用`delete`操作符则可以完全删除实例属性，从而让我们能够重新访问原型中的属性，如下所示。
```javascript
function Person(){
}
Person.prototype.name = "Nicholas";
Person.prototype.age = 29;
Person.prototype.job = "Software Engineer";
Person.prototype.sayName = function(){
    alert(this.name);
};
var person1 = new Person();
var person2 = new Person();
person1.name = "Greg";
alert(person1.name); //"Greg"——来自实例
alert(person2.name); //"Nicholas"——来自原型
delete person1.name;
alert(person1.name); //"Nicholas"——来自原型
```
使用`hasOwnProperty()`方法可以检测一个属性是存在于实例中，还是存在于原型中。这个方法（不要忘了它是从Object 继承来的）只在给定属性存在于对象实例中时，才会返回true。     
```javascript
function Person(){
}
Person.prototype.name = "Nicholas";
Person.prototype.age = 29;
Person.prototype.job = "Software Engineer";
Person.prototype.sayName = function(){
    alert(this.name);
};
var person1 = new Person();
var person2 = new Person();
alert(person1.hasOwnProperty("name")); //false
 
person1.name = "Greg";
alert(person1.name); //"Greg"——来自实例
alert(person1.hasOwnProperty("name")); //true
alert(person2.name); //"Nicholas"——来自原型
alert(person2.hasOwnProperty("name")); //false
 
delete person1.name;
alert(person1.name); //"Nicholas"——来自原型
alert(person1.hasOwnProperty("name")); //false
```
在单独使用`in`操作符会在通过对象能够访问给定属性时返回true，无论该属性存在于实例中还是原型中。看一看下面的例子。
```javascript
function Person(){
}
Person.prototype.name = "Nicholas";
Person.prototype.age = 29;
Person.prototype.job = "Software Engineer";
Person.prototype.sayName = function(){
    alert(this.name);
};
 
var person1 = new Person();
var person2 = new Person();
 
alert(person1.hasOwnProperty("name")); //false
alert("name" in person1); //true
 
person1.name = "Greg";
alert(person1.name); //"Greg" ——来自实例
alert(person1.hasOwnProperty("name")); //true
alert("name" in person1); //true
 
alert(person2.name); //"Nicholas" ——来自原型
alert(person2.hasOwnProperty("name")); //false
alert("name" in person2); //true
 
delete person1.name;
alert(person1.name); //"Nicholas" ——来自原型
alert(person1.hasOwnProperty("name")); //false
alert("name" in person1); //true
```
要取得对象上所有可枚举的实例属性，可以使用ECMAScript 5 的`Object.keys()`方法。这个方法接收一个对象作为参数，返回一个包含所有可枚举属性的字符串数组。
```javascript
function Person(){
}
Person.prototype.name = "Nicholas";
Person.prototype.age = 29;
Person.prototype.job = "Software Engineer";
Person.prototype.sayName = function(){
    alert(this.name);
};
 
var keys = Object.keys(Person.prototype);
alert(keys); //"name,age,job,sayName"
 
var p1 = new Person();
p1.name = "Rob";
p1.age = 31;
var p1keys = Object.keys(p1);
alert(p1keys); //"name,age"
```
如果你想要得到所有实例属性，无论它是否可枚举，都可以使用`Object.getOwnPropertyNames()`方法。
```javascript
var keys = Object.getOwnPropertyNames(Person.prototype);
alert(keys); //"constructor,name,age,job,sayName"
 
var p1 = new Person();
p1.name = "Rob";
p1.age = 31;
var p1keys = Object.getOwnPropertyNames(p1);
alert(p1keys); //"name,age"
```
每个函数都包含两个非继承而来的方法：`apply()`和`call()`。
### apply()和call()
这两个方法的用途都是在特定的作用域中调用函数，实际上等于设置函数体内this 对象的值。`apply()`方法接收两个参数：一个是在其中运行函数的作用域，另一个是参数数组。其中，第二个参数可以是Array 的实例，也可以是`arguments`对象。例如：
```javascript
function sum(num1, num2){
    return num1 + num2;
}
function callSum1(num1, num2){
    return sum.apply(this, arguments); // 传入arguments 对象
}
function callSum2(num1, num2){
    return sum.apply(this, [num1, num2]); // 传入数组
}
alert(callSum1(10,10)); //20
alert(callSum2(10,10)); //20
```
在这里，`this`就相当于`window`。

对于`call()`方法而言，第一个参数是`this` 值没有变化，变化的是其余参数都直接传递给函数。
```javascript
function sum(num1, num2){
    return num1 + num2;
}
function callSum(num1, num2){
    return sum.call(this, num1, num2);
}
alert(callSum(10,10)); //20
```
事实上，传递参数并非`apply(`)和`call()`真正的用武之地；它们真正强大的地方是能够扩充函数赖以运行的作用域。
```javascript
window.color = "red";
var o = { color: "blue" };
function sayColor(){
    alert(this.color);
}
 
sayColor(); //red
sayColor.call(this); //red
sayColor.call(window); //red
sayColor.call(o); //blue
```
ECMAScript 5 还定义了一个方法：`bind()`。这个方法会创建一个函数的实例，其`this` 值会被绑定到传给`bind()`函数的值。例如：  
```javascript
window.color = "red";
var o = { color: "blue" };
function sayColor(){
    alert(this.color);
}
var objectSayColor = sayColor.bind(o);
objectSayColor(); //blue﻿​
```
> [《JavaScript高级程序设计》](https://book.douban.com/subject/10546125/)读书笔记