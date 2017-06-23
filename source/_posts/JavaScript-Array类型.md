---
title: JavaScript Array类型
date: 2016-11-29 16:07:38
tags: JavaScript
---
## 检测数组
ECMAScript 5 新增了`Array.isArray()`方法。这个方法的目的是最终确定某个值到底是不是数组。
```javascript
if (Array.isArray(value)){
    //对数组执行某些操作
}
```
<!--more-->
## 转换方法
所有对象都具有`toLocaleString()`、`toString()`和`valueOf()`方法。其中，调用数组的`toString()`方法会返回由数组中每个值的字符串形式拼接而成的一个以逗号分隔的字符串。而 调用valueOf()返回的还是数组。
```javascript
var colors = ["red", "blue", "green"]; // 创建一个包含3 个字符串的数组
alert(colors.toString()); // red,blue,green
alert(colors.valueOf()); // red,blue,green
alert(colors); // red,blue,green 
```
最后一行代码直接将数组传递给了`alert()`。由于`alert()`要接收字符串参数，所以它会在后台调用`toString()`方法，由此会得到与直接调`toString()`方法相同的结果。

`join()`方法只接收一个参数，即用作分隔符的字符串，然后返回包含所有数组项的字符串。
```javascript
var colors = ["red", "green", "blue"];
alert(colors.join(",")); //red,green,blue
alert(colors.join("||")); //red||green||blue
```
## 栈方法

栈是一种LIFO（Last-In-First-Out，后进先出）的数据结构，也就是最新添加的项最早被移除。而栈中项的插入（叫做推入）和移除（叫做弹出），只发生在一个位置——栈的顶部。ECMAScript 为数组专门提供了`push()`和`pop()`方法，以便实现类似栈的行为。

`push()`方法可以接收任意数量的参数，把它们逐个添加到数组末尾，并返回修改后数组的长度。而`pop()`方法则从数组末尾移除最后一项，减少数组的length值，然后返回移除的项。    
```javascript
var colors = new Array(); // 创建一个数组
var count = colors.push("red", "green"); // 推入两项
alert(count); //2
count = colors.push("black"); // 推入另一项
alert(count); //3
var item = colors.pop(); // 取得最后一项
alert(item); //"black"
alert(colors.length); //2
```
## 队列方法
队列数据结构的访问规则是FIFO（First-In-First-Out， 先进先出）。队列在列表的末端添加项，从列表的前端移除项。`shift()`方法移除数组中的第一个项并返回该项，同时将数组长度减1。
```javascript
var colors = new Array(); //创建一个数组
var count = colors.push("red", "green"); //推入两项
alert(count); //2
count = colors.push("black"); //推入另一项
alert(count); //3
var item = colors.shift(); //取得第一项
alert(item); //"red"
alert(colors.length); //2    
```
ECMAScript 还为数组提供了一个`unshift()`方法。顾名思义，`unshift()`与`shift()`的用途相反：它能在数组前端添加任意个项并返回新数组的长度。
```javascript
var colors = new Array(); //创建一个数组
var count = colors.unshift("red", "green"); //推入两项
alert(count); //2
count = colors.unshift("black"); //推入另一项
alert(count); //3
```
## 重排序方法
数组中已经存在两个可以直接用来重排序的方法：`reverse()`和`sort()`。`reverse()`方法会反转数组项的顺序。    
```javascript
var values = [1, 2, 3, 4, 5];
values.reverse();
alert(values); //5,4,3,2,1
```
`sort()`方法按升序排列数组项——即最小的值位于最前面，最大的值排在最后面。为了实现排序，`sort()`方法会调用每个数组项的`toString()`转型方法，然后比较得到的字符串，以确定如何排序。
```javascript
var values = [0, 1, 5, 10, 15];
values.sort();
alert(values); //0,1,10,15,5   
```
`sort()`方法还可以接收一个比较函数作为参数，以便我们指定哪个值位于哪个值的前面。
```javascript
function compare(value1, value2){
    return value2 - value1;
}
var values = [0, 1, 5, 10, 15];
values.sort(compare);
alert(values); // 15,10,5,1,0
```
## 操作方法
`concat()`方法可以基于当前数组中的所有项创建一个新数组。这个方法会先创建当前数组一个副本，然后将接收到的参数添加到这个副本的末尾，最后返回新构建的数组。在没有给concat()方法传递参数的情况下，它只是复制当前数组并返回副本。如果传递给concat()方法的是一或多个数组，则该方法会将这些数组中的每一项都添加到结果数组中。如果传递的值不是数组，这些值就会被简单地添加到结果数组的末尾。    
```javascript
var colors = ["red", "green", "blue"];
var colors2 = colors.concat("yellow", ["black", "brown"]);
alert(colors); //red,green,blue
alert(colors2); //red,green,blue,yellow,black,brown
```
`slice()`方法可以接受一或两个参数，即要返回项的起始和结束位置。在只有一个参数的情况下，`slice()`方法返回从该参数指定位置开始到当前数组末尾的所有项。如果有两个参数，该方法返回起始和结束位置之间的项——但不包括结束位置的项。
```javascript
var colors = ["red", "green", "blue", "yellow", "purple"];
var colors2 = colors.slice(1);
var colors3 = colors.slice(1,4);
alert(colors2); //green,blue,yellow,purple
alert(colors3); //green,blue,yellow
```
`splice()`方法：
```javascript
var colors = ["red", "green", "blue"];
var removed = colors.splice(0,1); // 删除第一项
alert(colors); // green,blue
alert(removed); // red，返回的数组中只包含一项
removed = colors.splice(1, 0, "yellow", "orange"); // 从位置1 开始插入两项
alert(colors); // green,yellow,orange,blue
alert(removed); // 返回的是一个空数组
removed = colors.splice(1, 1, "red", "purple"); // 插入两项，删除一项
alert(colors); // green,red,purple,orange,blue
alert(removed); // yellow，返回的数组中只包含一项
```
## 位置方法
ECMAScript 5 为数组实例添加了两个位置方法：`indexOf()`和`lastIndexOf()`。这两个方法都接收两个参数：要查找的项和（可选的）表示查找起点位置的索引。其中，`indexOf()`方法从数组的开头（位置0）开始向后查找，`lastIndexOf()`方法则从数组的末尾开始向前查找。没有找到返回-1。
```javascript
var numbers = [1,2,3,4,5,4,3,2,1];
alert(numbers.indexOf(4)); //3
alert(numbers.lastIndexOf(4)); //5
alert(numbers.indexOf(4, 4)); //5
alert(numbers.lastIndexOf(4, 4)); //3
```
## 迭代方法
`every()`：对数组中的每一项运行给定函数，如果该函数对每一项都返回true，则返回true。

`filter()`：对数组中的每一项运行给定函数，返回该函数会返回true 的项组成的数组。

`forEach()`：对数组中的每一项运行给定函数。这个方法没有返回值。

`map()`：对数组中的每一项运行给定函数，返回每次函数调用的结果组成的数组。

`some()`：对数组中的每一项运行给定函数，如果该函数对任一项返回true，则返回true。

以上方法都不会修改数组中的包含的值。
```javascript
var numbers = [1,2,3,4,5,4,3,2,1];
var everyResult = numbers.every(function(item, index, array){
    return (item > 2);
});
alert(everyResult); //false
var someResult = numbers.some(function(item, index, array){
    return (item > 2);
});
alert(someResult); //true
```
以上代码调用了`every()`和`some()`，传入的函数只要给定项大于2 就会返回true。对于`every()`，它返回的是false，因为只有部分数组项符合条件。对于`some()`，结果就是true，因为至少有一项是大于2 的。

`filter()`函数：
```javascript
var numbers = [1,2,3,4,5,4,3,2,1];
var filterResult = numbers.filter(function(item, index, array){
    return (item > 2);
});
alert(filterResult); //[3,4,5,4,3]
```
`map()`也返回一个数组，而这个数组的每一项都是在原始数组中的对应项上运行传入函数的结果。例如，可以给数组中的每一项乘以2，然后返回这些乘积组成的数组：
```javascript
var numbers = [1,2,3,4,5,4,3,2,1];
var mapResult = numbers.map(function(item, index, array){
    return item * 2;
});
alert(mapResult); //[2,4,6,8,10,8,6,4,2]
```
`forEach()`用于迭代数组：
```javascript
var numbers = [1,2,3,4,5,4,3,2,1];
numbers.forEach(function(item, index, array){
    //执行某些操作
});
```
## 归并方法
使用`reduce()`方法可以执行求数组中所有值之和的操作，比如：
```javascript
var values = [1,2,3,4,5];
var sum = values.reduce(function(prev, cur, index, array){
    return prev + cur;
});
alert(sum); //15
```
第一次执行回调函数，prev 是1，cur 是2。第二次，prev 是3（1 加2 的结果），cur 是3（数组的第三项）。这个过程会持续到把数组中的每一项都访问一遍，最后返回结果。
`reduceRight()`的作用类似，只不过方向相反而已：
```javascript
var values = [1,2,3,4,5];
var sum = values.reduceRight(function(prev, cur, index, array){
    return prev + cur;
});
alert(sum); //15
```
在这个例子中，第一次执行回调函数，prev 是5，cur 是4。当然，最终结果相同，因为执行的都是简单相加的操作。

使用`reduce()`还是`reduceRight()`，主要取决于要从哪头开始遍历数组。除此之外，它们完全相同。
## 极值
```javascript
var values = [1, 2, 3, 4, 5, 6, 7, 8];
var max = Math.max.apply(Math, values);   //8 
```
> [《JavaScript高级程序设计》](https://book.douban.com/subject/10546125/)读书笔记