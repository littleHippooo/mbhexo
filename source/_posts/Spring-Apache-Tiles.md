---
title: Spring & Apache Tiles
date: 2017-01-23 19:20:51
tags: [Spring,Apache Tiles]
---
假设我们想为应用中的所有页面定义一个通用的头部和底部。最原始的方式就是查找每个JSP模板，并为其添加头部和底部的HTML。但是这种方法的扩展性并不好，也难以维护。更好的方式是使用布局引擎，如Apache Tiles，定义适用于所有页面的通用页面布局。Spring MVC以视图解析器的形式为Apache Tiles提供了支持。
<!--more-->
## 配置Tiles视图解析器
首先引入依赖：
```xml
<dependency>
    <groupId>org.apache.tiles</groupId>
    <artifactId>tiles-jsp</artifactId>
    <version>3.0.7</version>
</dependency>
<dependency>
    <groupId>org.apache.tiles</groupId>
    <artifactId>tiles-core</artifactId>
    <version>3.0.7</version>
</dependency>
<dependency>
    <groupId>org.apache.tiles</groupId>
    <artifactId>tiles-api</artifactId>
    <version>3.0.7</version>
</dependency>    
```
配置：
```xml
<!-- 指定tiles.xml -->
<bean id="tilesConfigurer" 
    class="org.springframework.web.servlet.view.tiles3.TilesConfigurer">
    <property name="definitions">
    <list>
        <value>/WEB-INF/views/tiles.xml</value>
    </list>
</property>
</bean>
<!-- 代替InternalResourceViewResolver -->
<bean id="viewResolver" 
    class="org.springframework.web.servlet.view.tiles3.TilesViewResolver"/>
<!-- 配置静态资源路径 -->
<mvc:resources location="/images/" mapping="/images/**"/>
```
tiles.xml见下文。
## tiles.xml
```xml
<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE tiles-definitions PUBLIC
    "-//Apache Software Foundation//DTD Tiles Configuration 3.0//EN"
    "http://tiles.apache.org/dtds/tiles-config_3_0.dtd">
<tiles-definitions>
    <!-- 设置基本tile，定义了header,body,footer -->
    <definition name="base" template="/WEB-INF/views/page.jsp">
        <put-attribute name="header" value="/WEB-INF/views/header.jsp" />
        <put-attribute name="footer" value="/WEB-INF/views/footer.jsp" />
    </definition>
    <!-- 拓展tile，name对应controller中的视图名，body指定页面主体内容 -->
    <definition name="index" extends="base">
        <put-attribute name="body" value="/WEB-INF/views/index.jsp" />
    </definition>
    
    <definition name="register" extends="base">
        <put-attribute name="body" value="/WEB-INF/views/register.jsp" />
    </definition>
 
</tiles-definitions>  
```
每个<definition>元素都定义了一个Tile，它最终引用的是一个JSP模板。名为base的Tile中，模板为page.jsp，还定义了页首和页脚的模板JSP：

header.jsp：
```html
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<a href="<s:url value="/index/" />">
    <img src='<c:url value="/images/leanote.png"/>' border="0"/>
</a>
```
footer.jsp：
```html
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
Copyright © Leanote 
```
page.jsp：
```html
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ page session="false" %>
<html>
    <head>
        <title>leanote 蚂蚁笔记</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    </head>
    <body>
        <!-- 头部  -->
        <div id="header">
            <t:insertAttribute name="header" />
        </div>
        <!-- 主体内容，对应tiles.xml中继承base的Tile  -->
        <div id="content">
            <t:insertAttribute name="body" />
        </div>
        <!-- 尾部  -->
        <div id="footer">
            <t:insertAttribute name="footer" />
        </div>
    </body>
</html>
```
名为index和register的Tile各自都继承了base Tile，还定义了body，分别引用index.jsp和register.jsp：

index.jsp：
```html
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<p>蚂蚁笔记，有极客范的云笔记！</p>
<p>前所未有的文档体验，近乎完美的平台覆盖，支持团队协同，企业级私有云</p>
<p>蚂蚁笔记 = 笔记 + 博客 + 协作 + 私有云</p>
```
register.jsp：
```html
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf" %>
 
<h3>注册leanote</h3>
<sf:form method="post" commandName="form"
    action="${pageContext.request.contextPath}/register">
    <sf:label path="name" cssErrorClass="error">用户名：</sf:label>
    <sf:input path="name" cssErrorClass="error"/>
    <sf:errors path="name" cssClass="error"/><br/>
    邮箱：<sf:input path="email"/><sf:errors path="email" cssClass="error"/><br/>
    密码：<sf:password path="password" /><sf:errors path="password" cssClass="error"/><br/>
    <input type="submit" value="注册" />
</sf:form>
```
## 测试

访问http://localhost:8080/spring/index/：

![90459534-file_1487996599483_17008.png](https://www.tuchuang001.com/images/2017/06/13/90459534-file_1487996599483_17008.png)

访问http://localhost:8080/spring/registerindex/

![27916834-file_1487996620195_6f6b.png](https://www.tuchuang001.com/images/2017/06/13/27916834-file_1487996620195_6f6b.png)

可以看到，头部和尾部是固定的，变的只是body部分。