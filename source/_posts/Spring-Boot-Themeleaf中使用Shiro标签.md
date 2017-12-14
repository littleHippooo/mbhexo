---
title: Spring Boot Thymeleaf中使用Shiro标签
date: 2017-11-26 10:36:33
tags: [Spring,Spring Boot,Shiro,Thymeleaf]
---
在[《Spring-Boot-shiro权限控制》](/Spring-Boot-Shiro权限控制.html)中，当用户访问没有权限的资源时，我们采取的做法是跳转到403页面，但在实际项目中更为常见的做法是只显示当前用户拥有访问权限的资源链接。配合Thymeleaf中的Shiro标签可以很简单的实现这个目标。

实际上Thymeleaf官方并没有提供Shiro的标签，我们需要引入第三方实现，地址为[https://github.com/theborakompanioni/thymeleaf-extras-shiro](https://github.com/theborakompanioni/thymeleaf-extras-shiro)。
<!--more-->
## 引入thymeleaf-extras-shiro
在pom中引入：
```xml
<dependency>
    <groupId>com.github.theborakompanioni</groupId>
    <artifactId>thymeleaf-extras-shiro</artifactId>
    <version>2.0.0</version>
</dependency>
```
## ShiroConfig配置
引入依赖后，需要在ShiroConfig中配置该方言标签：
```java
 @Bean
public ShiroDialect shiroDialect() {
    return new ShiroDialect();
}
```
## 首页改造
更改index.html，用于测试Shiro标签的使用：
```html
 <!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" 
      xmlns:shiro="http://www.pollix.at/thymeleaf/shiro" >
<head>
    <meta charset="UTF-8">
    <title>首页</title>
</head>
<body>
    <p>你好！[[${user.userName}]]</p>
    <p shiro:hasRole="admin">你的角色为超级管理员</p>
    <p shiro:hasRole="test">你的角色为测试账户</p>
    <div>
        <a shiro:hasPermission="user:user" th:href="@{/user/list}">获取用户信息</a>
        <a shiro:hasPermission="user:add" th:href="@{/user/add}">新增用户</a>
        <a shiro:hasPermission="user:delete" th:href="@{/user/delete}">删除用户</a>
    </div>
    <a th:href="@{/logout}">注销</a>
</body>
</html>
```
值得注意的是，在html页面中使用Shiro标签需要给html标签添加`xmlns:shiro="http://www.pollix.at/thymeleaf/shiro"`。
## 测试
启动项目，使用mrbird（角色为admin，具有user:user，user:add，user:delete权限）账户登录：

![QQ截图20171214150454.png](img/QQ截图20171214150454.png)

使用tester（角色为tester，仅有user:user权限）账户登录：

![QQ截图20171214150617.png](img/QQ截图20171214150617.png)

## 更多标签
The following examples show how to integrate the tags in your Thymeleaf templates.
These are all implementations of the examples given in the [JSP / GSP Tag Library Section](http://shiro.apache.org/web.html#Web-JSP%252FGSPTagLibrary) of the Apache Shiro documentation.

Tags can be written in attribute or element notation:

#### Attribute
```html
<p shiro:anyTag>
  Goodbye cruel World!
</p>
```

#### Element
```html
<shiro:anyTag>
  <p>Hello World!</p>
</shiro:anyTag>
```

#### The `guest` tag
```html
<p shiro:guest="">
  Please <a href="login.html">Login</a>
</p>
```

#### The `user` tag
```html
<p shiro:user="">
  Welcome back John! Not John? Click <a href="login.html">here<a> to login.
</p>
```

#### The `authenticated` tag
```html
<a shiro:authenticated="" href="updateAccount.html">Update your contact information</a>
```

#### The `notAuthenticated` tag
```html
<p shiro:notAuthenticated="">
  Please <a href="login.html">login</a> in order to update your credit card information.
</p>
```

#### The `principal` tag
```html
<p>Hello, <span shiro:principal=""></span>, how are you today?</p>
```
or
```html
<p>Hello, <shiro:principal/>, how are you today?</p>
```

Typed principal and principal property are also supported.

#### The `hasRole` tag
```html
<a shiro:hasRole="administrator" href="admin.html">Administer the system</a>
```

#### The `lacksRole` tag
```html
<p shiro:lacksRole="administrator">
  Sorry, you are not allowed to administer the system.
</p>
```

#### The `hasAllRoles` tag
```html
<p shiro:hasAllRoles="developer, project manager">
  You are a developer and a project manager.
</p>
```

#### The `hasAnyRoles` tag
```html
<p shiro:hasAnyRoles="developer, project manager, administrator">
  You are a developer, project manager, or administrator.
</p>
```

#### The `hasPermission` tag
```html
<a shiro:hasPermission="user:create" href="createUser.html">Create a new User</a>
```

#### The `lacksPermission` tag
```html
<p shiro:lacksPermission="user:delete">
  Sorry, you are not allowed to delete user accounts.
</p>
```

#### The `hasAllPermissions` tag
```html
<p shiro:hasAllPermissions="user:create, user:delete">
  You can create and delete users.
</p>
```

#### The `hasAnyPermissions` tag
```html
<p shiro:hasAnyPermissions="user:create, user:delete">
  You can create or delete users.
</p>
```

源码地址：[https://drive.google.com/open?id=1w4ZeRBkTWuJrulQStuT1SkEgYcurALoF](https://drive.google.com/open?id=1w4ZeRBkTWuJrulQStuT1SkEgYcurALoF)