---
title: jQuery操作文档新姿势
date: 2017-05-03 09:41:48
tags: jQuery
---
现要在body下插入一张包含一些属性的图片，使用jQuery操作document传统的做法是：
```javascript
var html = ' <img src="../images/little.bear.png" alt="Little Bear"'+
           ' title="I woof in your general direction" '+
           ' onclick="showTitle($(this));"><img/>'
$(html).appendTo('body');
function showTitle(val){
    var $this = val;
    alert($this.attr('title'));
}
```
<!--more-->

现使用更优雅的方法来实现这个操作：
```javascript
$('<img>',
{
    src: '../images/little.bear.png',
    alt: 'Little Bear',
    title:'I woof in your general direction',
    click: function() {
        alert($(this).attr('title'));
    }
}).appendTo('body');
```

{% note danger %}注：`$('<img>')`等同于`$('<img></img>')`或`$('<img/>')`{% endnote %}

> [《jQuery实战 第三版》](https://www.manning.com/books/jquery-in-action-third-edition?a_bid=bdd5b7ad&a_aid=141d9491)读书笔记