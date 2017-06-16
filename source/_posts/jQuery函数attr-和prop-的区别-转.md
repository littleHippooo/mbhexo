---
title: 'jQuery函数attr()和prop()的区别 [转]'
date: 2017-05-19 16:20:12
tags: jQuery
---
在jQuery中，`attr()`函数和`prop()`函数都用于设置或获取指定的属性，它们的参数和用法也几乎完全相同。 但不得不说的是，这两个函数的用处却并不相同。下面我们来详细介绍这两个函数之间的区别。
### 操作对象不同
很明显，attr和prop分别是单词attribute和property的缩写，并且它们均表示"属性"的意思。不过，在jQuery中，attribute和property却是两个不同的概念。attribute表示HTML文档节点的属性，property表示JS对象的属性。
```html
 <!-- 这里的id、class、data_id均是该元素文档节点的attribute -->
<div id="message" class="test" data_id="123"></div>
 
<script type="text/javascript">
// 这里的name、age、url均是obj的property
var obj = { name: "CodePlayer", age: 18, url: "http://www.365mini.com/" };
</script>
```
<!--more-->
在jQuery中，`prop()`函数的设计目标是用于设置或获取指定DOM元素（指的是JS对象，Element类型）上的属性property；`attr()`函数的设计目标是用于设置或获取指定DOM元素所对应的文档节点上的属性attribute。
```html
<!-- attr()函数针对的是该文档节点的attribute -->
<div id="message" class="test" data_id="123"></div>
 
<script type="text/javascript">
// prop()函数针对的是该DOM元素(msg)自身的property
var msg = document.getElementById("message");
var $msg = $(msg);
</script>
```
当然，在jQuery的底层实现中，函数`attr()`和`prop()`的功能都是通过JS原生的Element对象（如上述代码中的msg）实现的。`attr()`函数主要依赖的是Element对象的`getAttribute()`和`setAttribute()`两个方法。`prop()`函数主要依赖的则是JS中原生的对象属性获取和设置方式。
```html
<div id="message" class="test" data_id="123"></div>
<script type="text/javascript">
var msg = document.getElementById("message");
var $msg = $(msg);
 
/* attr()依赖的是Element对象的element.getAttribute( attribute ) 
 *  和 element.setAttribute( attribute, value ) 
 */
 
// 相当于 msg.setAttribute("data_id", 145);
$msg.attr("data_id", 145);
// 相当于 msg.getAttribute("data_id");
var dataId = $msg.attr("data_id"); // 145
 
/* prop()依赖的是JS原生的 element[property] 
 * 和 element[property] = value; 
 */
 
// 相当于 msg["pid"] = "pid值";
$msg.prop("pid", "pid值");
// 相当于 msg["pid"];
var testProp = $msg.prop("pid"); // pid值
</script>
```
当然，jQuery对这些操作方式进行了封装，使我们操作起来更加方便(比如以对象形式同时设置多个属性)，并且实现了跨浏览器兼容。

此外，虽然`prop()`针对的是DOM元素的property，而不是元素节点的attribute。不过DOM元素某些属性的更改也会影响到元素节点上对应的属性。例如，property的id对应attribute的id，property的className对应attribute的class。
```html
<div id="message" class="test" data_id="123"></div>
<script type="text/javascript">
var msg = document.getElementById("message");
var $msg = $(msg);
 
console.log( $msg.attr("class") ); // test
$msg.prop("className", "newTest");
// 修改className(property)导致class(attitude)也随之更改
console.log( $msg.attr("class") ); // newTest
</script>
```
### 应用版本不同
`attr()`是jQuery 1.0版本就有的函数，`prop()`是jQuery 1.6版本新增的函数。毫无疑问，在1.6之前，你只能使用attr()函数；1.6及以后版本，你可以根据实际需要选择对应的函数。
### 用于设置的属性值类型不同
由于`attr()`函数操作的是文档节点的属性，因此设置的属性值只能是字符串类型，如果不是字符串类型，也会调用其`toString()`方法，将其转为字符串类型。 `prop()`函数操作的是JS对象的属性，因此设置的属性值可以为包括数组和对象在内的任意类型。
```html
<input id="uid" type="checkbox" checked="true" value="1">
<script type="text/javascript">
// 当前jQuery版本为1.11.1
var uid = document.getElementById("uid");
var $uid = $(uid);
 
console.log($uid.attr("checked")); // checked
console.log(typeof $uid.attr("checked")); // string
 
console.log($uid.prop("checked")); // true
console.log(typeof $uid.prop("checked")); //boolean
</script>
```
### 其他细节问题
在jQuery 1.6之前，只有`attr()`函数可用，该函数不仅承担了attribute的设置和获取工作，还同时承担了property的设置和获取工作。例如：在jQuery 1.6之前，`attr()`也可以设置或获取tagName、className、nodeName、nodeType等DOM元素的property。

直到jQuery 1.6新增`prop()`函数，并用来承担property的设置或获取工作之后，`attr()`才只用来负责attribute的设置和获取工作。

此外，对于表单元素的checked、selected、disabled等属性，在jQuery 1.6之前，`attr()`获取这些属性的返回值为Boolean类型：如果被选中（或禁用）就返回true，否则返回false。

但是从1.6开始，使用`attr()`获取这些属性的返回值为String类型，如果被选中（或禁用）就返回checked、selected或disabled，否则（即元素节点没有该属性）返回undefined。并且，在某些版本中，这些属性值表示文档加载时的初始状态值，即使之后更改了这些元素的选中（或禁用）状态，对应的属性值也不会发生改变。

因为jQuery认为：attribute的checked、selected、disabled就是表示该属性初始状态的值，property的checked、selected、disabled才表示该属性实时状态的值（值为true或false）。

因此，在jQuery 1.6及以后版本中，请使用`prop()`函数来设置或获取checked、selected、disabled等属性。对于其它能够用`prop()`实现的操作，也尽量使用`prop()`函数。
```html
<input id="uid" type="checkbox" checked="checked" value="1">
 
<script type="text/javascript">
// 当前jQuery版本为1.11.1
var uid = document.getElementById("uid");
var $uid = $(uid);
 
console.log( $uid.attr("checked") ); // checked
console.log( $uid.prop("checked") ); // true
 
// 取消复选框uid的选中(将其设为false即可)
// 相当于 uid.checked = false;
$uid.prop("checked", false);
 
// attr()获取的是初始状态的值，即使取消了选中，也不会改变
console.log( $uid.attr("checked") ); // checked
// prop()获取的值已经发生变化
console.log( $uid.prop("checked") ); // false
</script>
```
> 转自[CodePlayer](http://www.365mini.com/page/jquery-attr-vs-prop.htm)
