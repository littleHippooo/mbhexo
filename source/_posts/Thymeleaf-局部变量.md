---
title: Thymeleaf 局部变量
date: 2017-09-30 10:30:01
tags: Thymeleaf
---
在Thymeleaf模板引擎中，使用	`th:with`属性来声明一个局部变量：
```html
<div th:with="firstPer=${persons[0]}">
  <p>The name of the first person is <span th:text="${firstPer.name}">Julius Caesar</span>.</p>
</div> 
```
在上面div中，`th:width`属性声明了一个名为firstPer的局部变量，内容为`${persons[0]}`。该局部变量的作用域为整个div内。
<!--more-->

也可以一次性定义多个变量：
```html
<div th:with="firstPer=${persons[0]},secondPer=${persons[1]}">
  <p>
    The name of the first person is <span th:text="${firstPer.name}">Julius Caesar</span>.
  </p>
  <p>
    But the name of the second person is 
    <span th:text="${secondPer.name}">Marcus Antonius</span>.
  </p>
</div> 
```
`th:with`属性允许重用在同一个属性中定义的变量：
```html
<div th:with="company=${user.company + ' Co.'},account=${accounts[company]}">...</div> 
```