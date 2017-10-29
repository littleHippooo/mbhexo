---
title: Thymeleaf 模板布局
date: 2017-09-18 15:35:36
tags: Thymeleaf
---
## th:include,th:insert和th:replace
在模板的编写中，通常希望能够引入别的模板片段，比如通用的头部和页脚。Thymeleaf模板引擎的`th:include`，`th:insert`和`th:replace`属性可以轻松的实现该需求。不过从Thymeleaf 3.0版本后， 不再推荐使用`th:include`属性。

在index.html页面路径下创建一个footer.html：
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
 <body>
   <footer th:fragment="copy">
     &copy; 2016 - 2017  MrBird Powered by Hexo
   </footer>
 </body>
</html> 
```
<!--more-->
在footer.html中，使用`th:fragment`属性定义了`<footer>`片段，然后在index.html中引用它：
```html
<div th:include="~{footer :: copy}"></div> 
<div th:insert="~{footer :: copy}"></div> 
<div th:replace="~{footer :: copy}"></div> 
```
其中footer为被引用的模板名称（templatename），copy为`th:fragment`标记的片段名称（selector），`~{...}`称为片段表达式，由于其不是一个复杂的片段表达式，所以可以简写为：
```html
<div th:include="footer :: copy"></div>
```
页面显示如下：

![mrbird_photo_20170928160743.png](img/mrbird_photo_20170928160743.png)

通过观察渲染出的源码可发现`th:include`，`th:insert`和`th:replace`的区别所在：
```html
<div>
    &copy; 2016 - 2017  MrBird Powered by Hexo
</div> 
<div>
    <footer>
        &copy; 2016 - 2017  MrBird Powered by Hexo
    </footer>
</div> 
<footer>
    &copy; 2016 - 2017  MrBird Powered by Hexo
</footer> 
```
引用本页面的片段可以略去templatename，或者使用this来代替。
## 引用没有th:fragment的片段
如果片段不包含`th:fragment`属性，我们可以使用CSS选择器来选中该片段，如：
```html
<div id="copy-section">
  &copy; 2011 The Good Thymes Virtual Grocery
</div>
```
引用方式：
```html
<div th:insert="~{footer :: #copy-section}"></div>
```
## 在th:fragment中使用参数
使用th:fragment定义的片段可以指定一组参数：
```html
<div th:fragment="frag (onevar,twovar)">
	<p th:text="${onevar} + ' - ' + ${twovar}">...</p>
</div> 
```
然后在引用的时候给这两个参数赋值，有如下两种方式：
```html
<div th:replace="this :: frag ('value1','value2')"></div>
<div th:replace="this :: frag (onevar='value_one',twovar='value_two')"></div>
```
对于第二种方式，onevar和twovar的顺序不重要，并且使用第二种方式引用片段时，片段可以简写为：
```html
<div th:fragment="frag">
   <p th:text="${onevar} + ' - ' + ${twovar}">...</p>
</div> 
```
## th:remove
`th:remove`用于删除片段，支持的属性值有：

- all：删除标签及其所有子标签。

- body：不删除包含的标签，但删除其所有子代。

- tag：删除包含的标签，但不要删除其子标签。

- all-but-first：删除除第一个之外的所有包含标签的子标签。

- none。

比如有如下片段：
```html
<table border="1">
   <tr>
      <th>NAME</th>
      <th>PRICE</th>
      <th>IN STOCK</th>
      <th>COMMENTS</th>
   </tr>
   <tr th:remove="value">
      <td>Mild Cinnamon</td>
      <td>1.99</td>
      <td>yes</td>
      <td>
         <span>3</span> comment/s
         <a href="comments.html">view</a>
      </td>
   </tr>
</table>
```
当value为all时，页面渲染为：
```html
<table border="1">
   <tr>
      <th>NAME</th>
      <th>PRICE</th>
      <th>IN STOCK</th>
      <th>COMMENTS</th>
   </tr>
</table>
```
当value为body时，页面渲染为：
```html
<table border="1">
   <tr>
      <th>NAME</th>
      <th>PRICE</th>
      <th>IN STOCK</th>
      <th>COMMENTS</th>
   </tr>
   <tr>
   </tr>
</table>
```
当value为tag时，页面渲染为：
```html
<table border="1">
   <tr>
      <th>NAME</th>
      <th>PRICE</th>
      <th>IN STOCK</th>
      <th>COMMENTS</th>
   </tr>
      <td>Mild Cinnamon</td>
      <td>1.99</td>
      <td>yes</td>
      <td>
         <span>3</span> comment/s
         <a href="comments.html">view</a>
      </td>
</table>
```
当value为all-but-first时，页面渲染为：
```html
<table border="1">
   <tr>
      <th>NAME</th>
      <th>PRICE</th>
      <th>IN STOCK</th>
      <th>COMMENTS</th>
   </tr>
   <tr th:remove="value">
      <td>Mild Cinnamon</td>
   </tr>
</table>
```