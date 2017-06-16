---
title: '一些JS技巧[转]'
date: 2017-04-17 07:03:50
tags: JavaScript
---
## 使用+将字符串转换成数字

这个技巧非常有用，其非常简单，可以交字符串数据转换成数字，不过其只适合用于字符串数据，否则将返回`NaN`，比如下面的示例：
```javascript
function toNumber(strNumber) {
    return +strNumber;
}
console.log(toNumber("1234")); // 1234
console.log(toNumber("ACB")); // NaN
```
这个也适用于 `Date`，在本例中，它将返回的是时间戳数字：
```javascript
console.log(+new Date()) // 1461288164385
```
<!--more-->
## 并条件符

如果你写了一段这样的代码：
```javascript
if (conected) {
    login();
}
```
你也可以将变量简写，并且使用&&和函数连接在一起，比如上面的示例，可以简写成这样：
```javascript
conected && login();
```
## 使用 || 运算符

在ES6中有默认参数这一特性。为了在老版本的浏览器中模拟这一特性，可以使用||操作符，并且将将默认值当做第二个参数传入。如果第一个参数返回的值为 false，那么第二个值将会认为是一个默认值。如下面这个示例：
```javascript
function User(name, age) {
    this.name = name || "Oliver Queen";
    this.age = age || 27;
}
 
var user1 = new User();
console.log(user1.name); // Oliver Queen
console.log(user1.age); // 27
 
var user2 = new User("Barry Allen", 25);
console.log(user2.name); // Barry Allen
console.log(user2.age); // 25
```
## 检测对象中属性

当你需要检测一些属性是否存在，避免运行未定义的函数或属性时，这个小技巧就显得很有用。如果你打算定些一些跨兼容的浏览器代码，你也可能会用到这个小技巧。例如，你想使用 `document.querySelector()` 来选择一个 id，并且让它能兼容IE6浏览器，但是在IE6浏览器中这个函数是不存在的，那么使用这个操作符来检测这个函数是否存在就显得非常的有用，如下面的示例：
```javascript
if ('querySelector' in document) {
    document.querySelector("#id");
} else {
    document.getElementById("id");
}
```
在这个示例中，如果 `document` 不存在 `querySelector` 函数，那么就会调用 `docuemnt.getElementById("id")`。

## 获取数组中最后一个元素
`Array.prototype.slice(begin,end)`用来获取begin和end之间的数组元素。如果你不设置end参数，将会将数组的默认长度值当作end值。但有些同学可能不知道这个函数还可以接受负值作为参数。如果你设置一个负值作为begin的值，那么你可以获取数组的最后一个元素。如：
```javascript
var array = [1,2,3,4,5,6];
 
console.log(array.slice(-1)); // [6]
console.log(array.slice(-2)); // [5,6]
console.log(array.slice(-3)); // [4,5,6]
```
## 数组截断

这个小技巧主要用来锁定数组的大小，如果用于删除数组中的一些元素来说，是非常有用的。例如，你的数组有10个元素，但你只想只要前五个元素，那么你可以通过 `array.length=5` 来截断数组。如下这个示例：
```javascript
var array = [1,2,3,4,5,6];
console.log(array.length); // 6
 
array.length = 3;
console.log(array.length); // 3
console.log(array); // [1,2,3]
```
## 合并数组

如果你要合并两个数组，一般情况之下你都会使用`Array.concat()`函数：
```javascript
var array1 = [1,2,3];
var array2 = [4,5,6];
 
console.log(array1.concat(array2)); // [1,2,3,4,5,6];
```
然后这个函数并不适合用来合并两个大型的数组，因为其将消耗大量的内存来存储新创建的数组。在这种情况之个，可以使用 `Array.pus().apply(arr1,arr2)`来替代创建一个新数组。这种方法不是用来创建一个新的数组，其只是将第一个第二个数组合并在一起，同时减少内存的使用：
```javascript
var array1 = [1,2,3];
var array2 = [4,5,6];
 
console.log(array1.push.apply(array1, array2)); // [1,2,3,4,5,6];
```
## 将NodeList转换成数组

如果你运行 `document.querySelectorAll(“p”)` 函数时，它可能返回DOM元素的数组，也就是`NodeList`对象。但这个对象不具有数组的函数功能，比如 `sort()`、`reduce()`、`map()`、`ilter()` 等。为了让这些原生的数组函数功能也能用于其上面，需要将节点列表转换成数组。可以使用 `[].slice.call(elements)` 来实现：
```javascript
var elements = document.querySelectorAll("p"); // NodeList
var arrayElements = [].slice.call(elements); // 将NodeList转化为数组
var arrayElements = Array.from(elements); // 另一种方式将NodeList转化为数组
```
## HTML5 DOM 选择器
```javascript
// querySelector() 返回匹配到的第一个元素
var item = document.querySelector('.item');
console.log(item);
 
// querySelectorAll() 返回匹配到的所有元素，是一个nodeList集合
var items = document.querySelectorAll('.item');
console.log(items[0]);
```
## 鼠标滚轮事件
```javascript
$('#content').on("mousewheel DOMMouseScroll", function (event) { 
    // chrome & ie || // firefox
    var delta = (event.originalEvent.wheelDelta && (event.originalEvent.wheelDelta > 0 ? 1 : -1)) || 
        (event.originalEvent.detail && (event.originalEvent.detail > 0 ? -1 : 1));  
    
    if (delta > 0) { 
        // 向上滚动
        console.log('mousewheel top');
    } else if (delta < 0) {
        // 向下滚动
        console.log('mousewheel bottom');
    } 
});
```
## 检测浏览器是否支持svg
```javascript
function isSupportSVG() { 
    var SVG_NS = 'http://www.w3.org/2000/svg';
    return !!document.createElementNS &&!!document.createElementNS(SVG_NS, 'svg').createSVGRect; 
} 
 
// 测试
console.log(isSupportSVG());
```
## 检测浏览器是否支持canvas
```javascript
function isSupportCanvas() {
    if(document.createElement('canvas').getContext){
        return true;
    }else{
        return false;
    }
}
 
// 测试
console.log(isSupportCanvas());
```
> 转自http://www.mrfront.com/