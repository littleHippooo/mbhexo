---
title: Thymeleaf 条件语句
date: 2017-09-15 10:13:48
tags: Thymeleaf
---
## if 与 unless
假如现在有一个商品列表，当商品有评论时，显示view按钮，否则不显示。这时候就可以使用Thymeleaf的`th:if`标签来实现:
```html
<a href="comments.html"
   th:href="@{/product/comments(prodId=${prod.id})}" 
   th:if="${not #lists.isEmpty(prod.comments)}">view</a> 
```
当prod.comments不为空时，页面将渲染出该`<a>`标签。

另外，`th:if`有一个反向属性`th:unless`，用于代替上面的not：
```html
<a href="comments.html"
   th:href="@{/comments(prodId=${prod.id})}" 
   th:unless="${#lists.isEmpty(prod.comments)}">view</a> 
```
<!--more-->
## switch
Thymeleaf中的`th:switch`和其他语言的switch case语句差不多：
```html
<div th:switch="${user.role}">
  <p th:case="'admin'">User is an administrator</p>
  <p th:case="'manager'">User is a manager</p>
</div> 
```
`th:case="*"`表示默认选项，相当于default：
```html
<div th:switch="${user.role}">
  <p th:case="'admin'">User is an administrator</p>
  <p th:case="'manager'">User is a manager</p>
  <p th:case="*">User is some other thing</p>
</div> 
```