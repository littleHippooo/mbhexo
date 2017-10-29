---
title: JavaScript CreateObject
date: 2016-12-07 14:04:18
tags: JavaScript
---
创建自定义类型的最常见方式，就是组合使用构造函数模式与原型模式。构造函数模式用于定义实例属性，而原型模式用于定义方法和共享的属性。结果，每个实例都会有自己的一份实例属性的副本，但同时又共享着对方法的引用，最大限度地节省了内存。另外，这种混成模式还支持向构造函数传递参数。如：
<!--more-->

```javascript
function Person(name, age, job){
    this.name = name;
    this.age = age;
    this.job = job;
    this.friends = ["Shelby", "Court"];
}
Person.prototype = {
    constructor : Person,
    sayName : function(){
        return this.name;
    }
}
var person1 = new Person("Nicholas", 29, "Software Engineer");
var person2 = new Person("Greg", 27, "Doctor");
alert(person1.friends); //"Shelby,Count"
alert(person2.friends); //"Shelby,Count"
alert(person1.friends === person2.friends); //false
alert(person1.sayName === person2.sayName); //true
```
在这个例子中，实例属性都是在构造函数中定义的，而由所有实例共享的属性constructor 和方法sayName()则是在原型中定义的。而修改了person1.friends（向其中添加一个新字符串），并不会影响到person2.friends，因为它们分别引用了不同的数组。
这种构造函数与原型混成的模式，是目前在ECMAScript 中使用最广泛、认同度最高的一种创建自定义类型的方法。

> [《JavaScript高级程序设计》](https://book.douban.com/subject/10546125/)读书笔记