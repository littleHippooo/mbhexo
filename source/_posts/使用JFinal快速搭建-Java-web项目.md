---
title: 使用JFinal快速搭建 Java web项目
date: 2016-03-19 19:20:43
tags: JFinal
---
JFinal是一个基于Java的极速Web开发框架，其核心设计目标是开发迅速、代码量少、学习简单、功能强大、轻量级、易扩展、Restful，在拥有Java语言所有优势的同时再拥有Ruby、Python等动态语言的开发效率。

1.在eclipse中新建Jfinal项目 导入jfinal-1.8-bin.jar 和 jfinal-2.2-bin-with-src.jar；

2.新建JfinalConfig类，用来配置Jfinal：
<!--more-->
```java
public class JfinalConfig extends JFinalConfig{
  /*
   * 配置常量值
   */
  @Override
  public void configConstant(Constants arg0) {
    //设置开发模式为true
    arg0.setDevMode(true);
    //设置编码格式
    arg0.setEncoding("utf-8");
    //设置视图类型
    arg0.setViewType(ViewType.JSP);
  }
  /*
   * 配置处理器
   */
  @Override
  public void configHandler(Handlers arg0) {
    //配置项目contextPath,以便在jsp页面直接获取项目访问路径
    arg0.add(new ContextPathHandler("basepath"));
  }
  /*
   * 配置拦截器，项目里需要拦截器的话在这里配置
   */
  @Override
  public void configInterceptor(Interceptors arg0) {
    // TODO Auto-generated method stub
  }
  /*
   * 配置插件，通常用来配置对数据库的支持
   */
  @Override
  public void configPlugin(Plugins arg0) {
    // TODO Auto-generated method stub
  }
  /*
   * 配置路由，类似于struts的action
   */
  @Override
  public void configRoute(Routes arg0) {
    //访问路径为项目根路径时，调用JfinalController
    arg0.add("/", JfinalController.class);		
  }	
}	
```
3.在web.xml中配置JfinalConfig，以此在启动Tomcat的时候初始化JfinalConfig这个入口：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns="http://java.sun.com/xml/ns/javaee" 
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
        http://java.sun.com/xml/ns/javaee/web-ap.xsd" version="2.5">
  <filter>
    <filter-name>jfinal</filter-name>
    <filter-class>com.jfinal.core.JFinalFilter</filter-class>
    <init-param>
      <param-name>configClass</param-name>
      <param-value>com.vis.config.JfinalConfig</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>jfinal</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
  <welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
  </welcome-file-list>
</web-app>  
```
4.创建登陆页面 login.jsp 和主页 index.jsp：

login.jsp：
```html
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <title>login page</title>
 </head>
 <body>
    <!-- 跳转到JfinalController login方法 -->
    <form action="${basepath }/login" id="body">
        <p>input userName:</p>
        <input type="text" name="userName" id="userName"/>
        <input type="submit" value="login"/>
    </form>
 </body>
</html>  
```
index.jsp：
```html
 <%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>my index</title>
</head>
<body>
    <!-- 获取userName -->
    <h3>welcome back,${userName }</h3>
</body>
</html>   
```
5.创建JfinalController，用来响应jsp页面的请求：
```java
public class JfinalController extends Controller{
  //设置默认访问页面
  public void index(){
     this.render("login.jsp");
  }
  //访问路径为 basepath/login时调用此方法
  public void login(){
     String userName=this.getPara("userName");
     this.setAttr("userName", userName);
     //取到userName后跳转到index.jsp
     this.render("index.jsp");
  }
}    
```
至此，一个简单的Java web项目搭建完了，将项目部署到Tomcat中，并启动，在浏览器中输入访问路径：localhost:8080/Jfinal/：

![20673055.gif](https://www.tuchuang001.com/images/2017/06/11/20673055.gif)