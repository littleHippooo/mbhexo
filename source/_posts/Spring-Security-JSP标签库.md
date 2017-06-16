---
title: Spring Security JSP标签库
date: 2017-02-13 11:31:41
tags: [Spring,Spring Security]
---
Spring Security提供了一套JSP标签库用于保护JSP视图。该库比较小，只提供了三个标签。

要使用这个库，先在JSP页首加入：
```xml
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
```
该库包含的三个标签如下：

`<security:accesscontrollist>`：如果用户通过访问控制列表授予了指定的权限，那么渲染该标签体中的内容。

`<security:authentication>`：渲染当前用户认证对象的详细信息。

`<security:authorize>`：如果用户被授予了特定的权限或者SpEL表达式的计算结果为true，那么渲染该标签体中的内容。
<!--more-->
## 认证用户信息
使用`<security:authentication>` JSP标签可以访问用户的认证详情：
### principal：用户的基本信息对象。
使用admin登陆，查看其用户认证详情：
```xml
<sec:authentication property="principal"/>
```
页面显示内容如下：
```xml
org.springframework.security.core.userdetails.User@586034f: 
Username: admin; 
Password: [PROTECTED]; 
Enabled: true; 
AccountNonExpired: true; 
credentialsNonExpired: true; 
AccountNonLocked: true; 
Granted Authorities: ROLE_ADMIN,ROLE_USER
```
还可以将其赋值给变量，并指定作用域：
```xml
<sec:authentication property="principal" var="principal" scope="request"/>
```
### details：认证的附加信息（IP地址、证件序列号、会话ID等）。
查看admin用户的details属性：
```xml
<sec:authentication property="details"/>
```
页面显示内容如下：
```xml
org.springframework.security.web.authentication.WebAuthenticationDetails@21a2c: 
RemoteIpAddress: 0:0:0:0:0:0:0:1; 
SessionId: D45BA834E227E0DA5596FF8C56FB9CA1
```
### authorities：一组用于表示用户所授予权限的GrantedAuthority对象。
查看admin用户的authorities属性：
```xml
<sec:authentication property="authorities"/>
```
页面显示内容如下：
```bash
[ROLE_ADMIN, ROLE_USER]
```
### credentials：用于核实用户的凭证（通常，这会是用户的密码）。
## 根据权限展示
JSP页面的内容也可以根据用户的权限进行有条件的展示，比如只让admin看到admin I love u信息：
```xml
<sec:authorize access="hasRole('ROLE_ADMIN')">
    admin i love u
</sec:authorize>  
```
测试过程中发现程序报错：`No WebApplicationContext found: no ContextLoaderListener registered?`。

修改web.xml加入ContextLoaderListener配置：
```xml
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>
        classpath:applicationContext.xml
     </param-value>
</context-param>
<listener>  
    <listener-class>
        org.springframework.web.context.ContextLoaderListener
    </listener-class>  
</listener>     
<servlet>
    <servlet-name>spring</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
    <servlet-name>spring</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
...
```
结果抛出新异常：`Could not open ServletContext resource [/WEB-INF/spring-servlet.xml]`。

在WEB-INF下创建一个spring-servlet.xml文件即可：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context" 
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.3.xsd">
    <!-- some tags -->
</beans>
```
