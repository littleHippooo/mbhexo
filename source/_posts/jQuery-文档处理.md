---
title: jQuery 文档处理
date: 2016-10-11 15:25:15
tags: jQuery
---
## 内部插入    
### append(content|fn)
向每个匹配的元素内部追加内容。

示例：

向所有段落中追加一些HTML标记：

HTML 代码：
```html
<p>I would like to say: </p>
```
jQuery 代码：
```javascript
$("p").append("<b>Hello</b>")
```
结果：
```html
<p>I would like to say: <b>Hello</b></p>​
```
<!--more-->
### appendTo(content)
把所有匹配的元素追加到另一个指定的元素元素集合中。 实际上，使用这个方法是颠倒了常规的`$(A).append(B)`的操作，即不是把B追加到A中，而是把A追加到B中。

示例1：

把所有段落追加到div元素中。

HTML 代码：
```html
<p>I would like to say: </p>
<div></div><div></div>﻿​
```
jQuery 代码：
```javascript
$("p").appendTo("div")
```
结果：
```html
<div><p>I would like to say: </p></div>
<div><p>I would like to say: </p></div>﻿​
```
示例2：

新建段落追加div中并加上一个class

HTML 代码：
```html
<div></div><div></div>﻿​
```
jQuery 代码：
```javascript
 $("<p/>")
   .appendTo("div")
   .addClass("test")
   .end()
   .addClass("test2");﻿​
```
结果：
```html
<div><p class="test test2"></p></div>
<div><p class="test"></p></div>
```
### prepend(content)
向每个匹配的元素内部前置内容。

示例1：

向所有段落中前置一些HTML标记代码。      

HTML 代码：
```html
<p>I would like to say: </p>
```
jQuery 代码：
```javascript
$("p").prepend("<b>Hello</b>");
```
结果：
```html
<p><b>Hello</b>I would like to say: </p> 
```
示例2：

将一个DOM元素前置入所有段落。    

HTML 代码：
```html
<p>I would like to say: </p>
<p>I would like to say: </p>
<b class="foo">Hello</b>
<b class="foo">Good Bye</b>
```
jQuery 代码：
```javascript
$("p").prepend( $(".foo")[0] );
```
结果：
```html
<p><b class="foo">Hello</b>I would like to say: </p>
<p><b class="foo">Hello</b>I would like to say: </p>
<b class="foo">Good Bye</b>﻿​
```
### prependTo(content)    
把所有匹配的元素前置到另一个、指定的元素元素集合中。实际上，使用这个方法是颠倒了常规的`$(A).prepend(B)`的操作，即不是把B前置到A中，而是把A前置到B中。

示例1：    

HTML 代码：
```html
<p>I would like to say: </p><div id="foo"></div>
```
jQuery 代码：
```javascript
$("p").prependTo("#foo");
```
结果：
```html
<div id="foo"><p>I would like to say: </p></div>﻿​
```
## 外部插入
### after(content|fn)
在每个匹配的元素之后插入内容。

示例1：    

在所有段落之后插入一些HTML标记代码。

HTML 代码：
```html
<p>I would like to say: </p>
```
jQuery 代码：
```javascript
$("p").after("<b>Hello</b>");
```
结果：
```html
<p>I would like to say: </p><b>Hello</b>﻿​
```
示例2：    

在所有段落之后插入一个DOM元素。

HTML 代码：
```html
<b id="foo">Hello</b><p>I would like to say: </p>
```
jQuery 代码：
```javascript
$("p").after( $("#foo")[0] );
```
结果：
```html
<p>I would like to say: </p><b id="foo">Hello</b>﻿​
```
示例3：    

在所有段落中后插入一个jQuery对象(类似于一个DOM元素数组)。

HTML 代码：
```html
<b>Hello</b><p>I would like to say: </p>
```
jQuery 代码：
```javascript
$("p").after( $("b") );
```
结果：
```html
<p>I would like to say: </p><b>Hello</b>﻿​
```
### insertAfter(content)    
把所有匹配的元素插入到另一个、指定的元素元素集合的后面。实际上，使用这个方法是颠倒了常规的`$(A).after(B)`的操作，即不是把B插入到A后面，而是把A插入到B后面。

示例：   

把所有段落插入到一个元素之后。与 `$("#foo").after("p")`相同

HTML 代码：
```html
<p>I would like to say: </p><div id="foo">Hello</div>
```
jQuery 代码：
```javascript
$("p").insertAfter("#foo");
```
结果：
```html
<div id="foo">Hello</div><p>I would like to say: </p>﻿​
```
### before(content|fn)
在每个匹配的元素之前插入内容。

示例：    

在所有段落之前插入一些HTML标记代码。

HTML 代码：
```html
<p>I would like to say: </p>
```
jQuery 代码：
```javascript
$("p").before("<b>Hello</b>");
```
结果：
```html
<b>Hello</b><p>I would like to say: </p> 
```
### insertBefore(content)    
把所有匹配的元素插入到另一个、指定的元素元素集合的前面。实际上，使用这个方法是颠倒了常规的`$(A).before(B)`的操作，即不是把B插入到A前面，而是把A插入到B前面。

示例：   

把所有段落插入到一个元素之前。与 `$("#foo").before("p")`相同。

HTML 代码：
```html
<div id="foo">Hello</div><p>I would like to say: </p>
```
jQuery 代码：
```javascript
$("p").insertBefore("#foo");
```
结果：
```html
<p>I would like to say: </p><div id="foo">Hello</div>﻿​ 
```
## 包裹 
### wrap(html|element|fn)
把所有匹配的元素用其他元素的结构化标记包裹起来。

示例：     

**html参数描述：**

把所有的段落用一个新创建的div包裹起来

jQuery 代码：
```javascript
$("p").wrap("<div class='wrap'></div>");
```
**elem参数描述：**

用ID是"content"的div将每一个段落包裹起来

jQuery 代码：
```javascript
$("p").wrap(document.getElementById('content'));
```
**回调函数描述：**

用原先div的内容作为新div的class，并将每一个元素包裹起来

HTML 代码：
```html
<div class="container">
  <div class="inner">Hello</div>
  <div class="inner">Goodbye</div>
</div>
```
jQuery 代码：
```javascript
$('.inner').wrap(function() {
  return '<div class="' + $(this).text() + '" />';
});
```
结果：
```html
<div class="container">
  <div class="Hello">
    <div class="inner">Hello</div>
  </div>
  <div class="Goodbye">
    <div class="inner">Goodbye</div>
  </div>
</div>﻿​
```
### unwrap()
这个方法将移出元素的父元素。这能快速取消 `.wrap()`方法的效果。匹配的元素（以及他们的同辈元素）会在DOM结构上替换他们的父元素。

示例：  

HTML 代码：
```html
<div>
    <p>Hello</p>
    <p>cruel</p>
    <p>World</p>
</div>
```
jQuery 代码：
```javascript
 $("p").unwrap()
```
结果：
```html
<p>Hello</p>
<p>cruel</p>
<p>World</p>﻿​
```
### wrapAll(html|ele)
将所有匹配的元素用单个元素包裹起来。

示例：    

**html描述：**

用一个生成的div将所有段落包裹起来。

HTML代码：
```html
<p>Hello</p>
<p>cruel</p>
<p>World</p> ﻿​
```
jQuery 代码：
```javascript
$("p").wrapAll("<div></div>");
```
结果：
```html
<div>
    <p>Hello</p>
    <p>cruel</p>
    <p>World</p>
</div>﻿​
```
**elem描述：**

用一个生成的div将所有段落包裹起来

jQuery 代码：
```javascript
$("p").wrapAll(document.createElement("div"));﻿​
```
### wrapInner(htm|ele|fn)
将每一个匹配的元素的子内容(包括文本节点)用一个HTML结构包裹起来。

示例：    

**参数html描述：**

把所有段落内的每个子内容加粗

jQuery 代码：
```javascript
$("p").wrapInner("<b></b>");
```
**参数elem描述：**

把所有段落内的每个子内容加粗

jQuery 代码：
```javascript
$("p").wrapInner(document.createElement("b"));
```
**回调函数描述：**

用原先div的内容作为新div的class，并将每一个元素包裹起来

HTML 代码：
```html
<div class="container">
  <div class="inner">Hello</div>
  <div class="inner">Goodbye</div>
</div>
```
jQuery 代码：
```javascript
$('.inner').wrapInner(function() {
  return '<div class="' + $(this).text() + '" />';
});
```
结果：
```html
<div class="container">
  <div class="inner">
    <div class="Hello">Hello</div>
  </div>
  <div class="inner">
    <div class="Goodbye">Goodbye</div>
  </div>
</div>
```
## 替换 
### replaceWith(content|fn)
将所有匹配的元素替换成指定的HTML或DOM元素。

示例1：    

把所有的段落标记替换成加粗的标记。

HTML 代码：
```html
<p>Hello</p><p>cruel</p><p>World</p>
```
jQuery 代码：
```javascript
$("p").replaceWith("<b>Paragraph. </b>");
```
结果：
```html
<b>Paragraph. </b><b>Paragraph. </b><b>Paragraph. </b>﻿​
```
示例2：   

用第一段替换第三段，你可以发现他是移动到目标位置来替换，而不是复制一份来替换。

HTML 代码：
```html
<div class="container">
  <div class="inner first">Hello</div>
  <div class="inner second">And</div>
  <div class="inner third">Goodbye</div>
</div>
```
jQuery 代码：
```javascript
$('.third').replaceWith($('.first'));
```
结果：
```html
<div class="container">
  <div class="inner second">And</div>
  <div class="inner first">Hello</div>
</div>﻿​
```
### replaceAll(selector)
用匹配的元素替换掉所有 selector匹配到的元素。和	`replaceWith()` 相反。

示例：    

把所有的段落标记替换成加粗标记

HTML 代码：
```html
<p>Hello</p><p>cruel</p><p>World</p>
```
jQuery 代码：
```javascript
$("<b>Paragraph. </b>").replaceAll("p");
```
结果：
```html
<b>Paragraph. </b><b>Paragraph. </b><b>Paragraph. </b>﻿​ 
```
## 删除
### empty()
删除匹配的元素集合中所有的子节点。

示例：    

把所有段落的子元素（包括文本节点）删除

HTML 代码：
```html
<p>Hello, <span>Person</span> <a href="#">and person</a></p>
```
jQuery 代码：
```javascript
$("p").empty();
```
结果：
```html
<p></p>﻿​
```
### remove([expr])

从DOM中删除所有匹配的元素。这个方法不会把匹配的元素从jQuery对象中删除，因而可以在将来再使用这些匹配的元素。但除了这个元素本身得以保留之外，其他的比如绑定的事件，附加的数据等都会被移除。

示例1：   

从DOM中把所有段落删除

HTML 代码：
```html
<p>Hello</p> how are <p>you?</p>
```
jQuery 代码：
```javascript
$("p").remove();
```
结果：
```html
how are
```
示例2：

从DOM中把带有hello类的段落删除。

HTML 代码：
```html
<p class="hello">Hello</p> how are <p>you?</p>
```
jQuery 代码：
```javascript
$("p").remove(".hello");
```
结果：
```html
how are <p>you?</p>﻿​
```
### detach([expr])
从DOM中删除所有匹配的元素。 这个方法不会把匹配的元素从jQuery对象中删除，因而可以在将来再使用这些匹配的元素。与`remove()`不同的是，所有绑定的事件、附加的数据等都会保留下来。
## 复制
### clone([Even[,deepEven]])
克隆匹配的DOM元素并且选中这些克隆的副本。

示例1：   

克隆所有b元素（并选中这些克隆的副本），然后将它们前置到所有段落中。

HTML 代码:
```html
<b>Hello</b><p>, how are you?</p>
```
jQuery 代码:
```javascript
$("b").clone().prependTo("p");
```
结果:
```html
<b>Hello</b><p><b>Hello</b>, how are you?</p>
```
示例2：

创建一个按钮，他可以复制自己，并且他的副本也有同样功能。

HTML 代码:
```html
<button>Clone Me!</button>
```
jQuery 代码:
```javascript
$("button").click(function(){
    $(this).clone(true).insertAfter(this);
});﻿​
```