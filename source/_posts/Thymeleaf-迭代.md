---
title: Thymeleaf 迭代
date: 2017-09-13 09:21:18
tags: Thymeleaf
---
在Thymeleaf中，使用`th:each`标签可对集合类型进行迭代，支持的类型有：

1.任何实现了`java.util.List`的对象；

2.任何实现了`java.util.Iterable`的对象；

3.任何实现了`java.util.Enumeration`的对象；

4.任何实现了`java.util.Iterator`的对象;

5.任何实现了`java.util.Map`的对象。当迭代maps时，迭代变量是`java.util.Map.Entry`类型；
<!--more-->

6.任何数组。

一个简单的例子：
```html
<tr th:each="prod : ${prods}">
   <td th:text="${prod.name}">Onions</td>
   <td th:text="${prod.price}">2.41</td>
</tr>
```
其中`${prods}`为迭代值，prod为迭代变量。除此之外，我们还可以通过状态变量获取迭代的状态信息，比如：
```html
<tr th:each="prod,stat : ${prods}"> ...
```
其中stat就是状态变量。默认为迭代变量加上Stat后缀，在本例中，不直接申明stat，则状态变量名称为prodStat。状态变量包含以下信息：

1.`index`，当前迭代下标，从0开始；

2.`count`，当前迭代位置，从1开始；

3.`size`，迭代变量中的总计数量；

4.`current`，每次迭代的迭代变量；

5.`even/odd`，当前迭代是偶数还是奇数；

6.`first`，当前迭代的是不是第一个；

7.`last`，当前迭代的是不是最后一个；

例子：
```html
<div th:each="habbits,stat : ${user.habbit}">
   <span th:text="${habbits}"></span>
   <span th:text="${stat.index}"></span>
   <span th:text="${stat.count}"></span>
   <span th:text="${stat.size}"></span>
   <span th:text="${stat.current}"></span>
   <span th:text="${stat.even}"></span>
   <span th:text="${stat.first}"></span>
   <span th:text="${stat.last}"></span>
</div>
```
页面显示如下：

![mrbird_photo_20170928093943.png](img/mrbird_photo_20170928093943.png)