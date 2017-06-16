---
title: 自定义jQuery选择器
date: 2017-05-03 08:46:08
tags: jQuery
---
jQuery自身提供了许多选择器，除此之外其还允许我们自定义选择器。下面这种自定义选择器的方法仅适用于1.8及其以后的版本。考虑有如下html片段：
```html
<ul class="levels">
    <li data-level="1" data-points="1" data-technologies="javascript node grunt">Level 1</li>
    <li data-level="2" data-points="10" data-technologies="jquery requirejs">Level 2</li>
    <li data-level="3" data-points="100" data-technologies="php composer">Level 3</li>
    <li data-level="4" data-points="1000" data-technologies="javascript jquery">Level 4</li>
</ul>
```
假如我们需要选择出data-level属性值大于2，data-points大于100并且data-technologies属性包含"jquery"的li，传统的做法是：
<!--more-->
```javascript
//先筛选出data-technologies属性包含"jquery"的li
var $levels = $('.levels li[data-technologies~="jquery"]');
var matchedLevels = [];
//循环遍历$levels，将符合条件的li塞到matchedLevels数组里
for (var i = 0; i < $levels.length; i++) {
    if ($levels[i].getAttribute('data-level') > 2 && 
        $levels[i].getAttribute('data-points') > 100) 
        {
        matchedLevels.push($levels[i]);
    }
}
console.log(matchedLevels.length); // 1
```
如果需要多次使用，我们可以创建自定义选择器，让代码更优雅：
```javascript
$.expr[':'].requiredLevel = $.expr.createPseudo(function (filterParam) {
    return function (element, context, isXml) {
        return element.getAttribute('data-level') > 2 && 
               element.getAttribute('data-points') > 100 && 
               element.getAttribute('data-technologies').indexOf('jquery') >= 0;
    };
});
```
`createPseudo`方法用于创造自定义选择器，可向其传递参数filterParam，参数名可以另起其名，这里需求固定，所以不必传参。element表示当前处理的元素，isXML用于指定是否为XML文本，默认为false。context默认为整个document，可以指定范围来增强性能：

比如查找div内的p元素：
```javascript
$("div p") 或
$("p","div")
```
结果一致，第二种写法效率更高。

言归正传，使用上述定义的选择器来查询满足条件的li：
```javascript
var $requiredLevels = $('li:requiredLevel','.levels ');
console.log($requiredLevels.length); // 1
console.log($requiredLevels.html()); // Level 4
```
### 传递参数
假如将需求改为，查找出data-points大于某个整数值的li，要怎么做呢？这时候就可以用上filterParam了：
```javascript
$.expr[':'].pointsHigherThan = $.expr.createPseudo(function (filterParam) {
    // 缓存参数，以供闭包使用
    var points = parseInt(filterParam, 10);
    return function (element, context, isXml) {
        return element.getAttribute('data-points') > points;
    };
});
```
测试：
```javascript
var $higherPointsLevels = $('li:pointsHigherThan(50)','.levels ');
console.log($higherPointsLevels.length); // 2
```
> [《jQuery实战 第三版》](https://www.manning.com/books/jquery-in-action-third-edition?a_bid=bdd5b7ad&a_aid=141d9491)读书笔记