---
title: Java Server Pages
date: 2016-11-07 08:58:18
tags: servlet&jsp
---
## scriplet
JSP页面可以直接书写Java 代码，Java代码要用<% %>包裹起来，<% %>代码块也被成为scriplet。可以使用page指令的import导入Java类型，否则scriplet里的Java类必须使用全类名。

如：
```html
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DataFormat"%>
<html>
    <head><title>Today's date</title></head>
    <body>
    <%
        DateFormat df = DateFormat.getDateInstance(DateFormat.LONG);
        String s = df.format(new Date());
        out.println("Today is " + s);
    %>
    </body>
</html>
```
<!--more-->
## 隐式对象
<table>
        <tr>
            <th>
                对象
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                request
            </td>
            <td>
                HttpServletRequest类的实例
            </td>
        </tr>
        <tr>
            <td>
                response
            </td>
            <td>
                HttpServletResponse类的实例
            </td>
        </tr>
        <tr>
            <td>
                out
            </td>
            <td>
                PrintWriter类的实例，用于把结果输出至网页上
            </td>
        </tr>
        <tr>
            <td>
                session
            </td>
            <td>
                HttpSession类的实例
            </td>
        </tr>
        <tr>
            <td>
                application
            </td>
            <td>
                ServletContext类的实例，与应用上下文有关
            </td>
        </tr>
        <tr>
            <td>
                config
            </td>
            <td>
                ServletConfig类的实例
            </td>
        </tr>
        <tr>
            <td>
                pageContext
            </td>
            <td>
                PageContext类的实例，提供对JSP页面所有对象以及命名空间的访问
            </td>
        </tr>
        <tr>
            <td>
                page
            </td>
            <td>
                类似于Java类中的this关键字
            </td>
        </tr>
        <tr>
            <td>
                Exception
            </td>
            <td>
                Exception类的对象，代表发生错误的JSP页面中对应的异常对象
            </td>
        </tr>
</table>

获取`HttpServletRequest`对象的userName参数：
```xml
<%
    String userName = request.getParameter("userName");
%>    
```
`PageContext`实用方法为存取属性：`setAttribute()`和`getAttribute()`。

setAttribute方法签名：
```java
public abstract void setAttribute(String name, Object value, int scope);
```
scope值可以取：PAGE_SCOPE, REQUEST_SCOPE, SESSION_SCOPE, APPLICATION_SCOPE。

如，下面scriplet在ServletRequset中保存了一个属性：
```xml
<%
    //product is a Java object
    pageContext.setAttribute("product",product,pageContext.REQUEST.SCOPE);
%>
```
等价于：
```xml
<%
    request.setAttribute("product",product);
%>
```
`out`对象类似于在`HttpServletResponse`中调用`getWritter()`之后得到的`java.io.PrintWriter`，如在页面输出Welcome：
```xml
<%
    out.println("Welcome");
%>
```
## 指令
### page指令
常用指令表： 
<table>
        <tr>
            <th>
                    属性
                
            </th>
            <th>
                    定义
                
            </th>
        </tr>
        <tr>
            <td>
                
                    language="ScriptLanguage"
                
            </td>
            <td>
                
                    指定JSP Container用什么语言来编译，目前只支持JAVA语言。默认为JAVA
                
            </td>
        </tr>
        <tr>
            <td>
                
                    extends="className"
                
            </td>
            <td>
                
                    定义此JSP网页产生的Servlet是继承哪个
                
            </td>
        </tr>
        <tr>
            <td>
                
                    import="importList"
                
            </td>
            <td >
                
                    定义此JSP网页要使用哪些Java API
                
            </td>
        </tr>
        <tr>
            <td>
                
                    session="true|false"
                
            </td>
            <td>
                
                    决定此页面是否使用session对象。默认为true
                
            </td>
        </tr>
        <tr>
            <td>
                
                    buffer="none|size in kb"
                
            </td>
            <td>
                
                    决定输出流(Input stream)是否又缓冲区。默认为8kb
                
            </td>
        </tr>
        <tr>
            <td>
                
                    autoFlush="true|false"
                
            </td>
            <td>
                
                    决定输出流的缓冲区慢了后是否需要自动清除，缓冲区慢了后会产生异常错误(Exception).默认为true
                
            </td>
        </tr>
        <tr>
            <td>
                
                    isThreadSafe="true|false"
                
            </td>
            <td>
                
                    是否支持线程。默认为true
                
            </td>
        </tr>
        <tr>
            <td>
                
                    errorPage="url"
                
            </td>
            <td>
                
                    如果此页发生异常，网页会重新指向一个url
                
            </td>
        </tr>
        <tr>
            <td>
                
                    isErrorPage="true|false"
                
            </td>
            <td>
                
                    表示此页面是否为错误处理页面。默认为false
                
            </td>
        </tr>
        <tr>
            <td>
                
                    contentType="text/html;charset=gb2312"
                
            </td>
            <td>
                
                    表示MIME类型和JSP的编码方式。笔者使用例左
                
            </td>
        </tr>
        <tr>
            <td>
                
                    pageEncoding="ISO-8859-1"
                
            </td>
            <td>
                
                    编码方式。
                
            </td>
        </tr>
        <tr>
            <td>
                
                    isELLgnored="true|false"
                
            </td>
            <td>
                
                    表示是否在此JSP页面中EL表达式。true则忽略，反之false则支持。默认为false &nbsp; &nbsp;
                
            </td>
        </tr>
</table>   

设置jsp中用到的语言,用到的是java，也是目前唯一有效的设定：
```xml
<%@ page language="java"%>
```
jsp页面所用到的类：
```xml
<%@ page import="java.sql.*"% > 
```
设置该jsp页面出现异常时所要转到的页面,如果没设定，容器将使用当前的页面显示错误信息：
```xml
<%@ page errorPage="error.jsp"%> 
```
设置该jsp页面是否作为错误显示页面,默认是false,如果设置为true,容器则会在当前页面生成一个exception对象：
```xml
<%@ page isErrorPage="true"%> 
```
设置页面文件格式和编码方式：
```xml
<%@ page contentType="text/html;charset=utf-8"%>
```
设置容器以多线程还是单线程运行该jsp页面，默认是true,是多线程。设置为false,则以单线程的方式运行该jsp页面：
```xml
<%@ page isThreadSafe="true"% >
```
设置该jsp页面是否可以用到session对象(jsp内置对象，为web容器创建),默认是true,能用到session.设置为false,则用不到：
```xml
<%@ page session="true"% > 
```
### include指令
语法：
```xml
<%@ include file="url"%>    
```
被引用的文件扩展名为jspf(JSP fragment)。
## 脚本元素
scriplet前面介绍了，这里不在赘述。
### 表达式
以<%=开头，%>结束：
```xml
Today is <%=java.util.Calendar.getInstance().getTime()%>
```
等价于：
```xml
Today is
<%
    out.println(java.util.Calendar.getInstance().getTime());
%>
```
### 声明
可以声明能够在JSP页面中实用的变量和方法，声明用<%!%>包裹起来，比如在JSP页面中声明一个getTodaysDate的方法：
```html
<%!
    public String getTodaysDate() {
        return new java.util.Date();   
    }    
%>
<html>
    <head><title>Declarations</title></head>
    <body>
        Today is <%=getTodayDate()%>
    </body>
</html>
```
我们可以利用声明覆盖实现类中的init和destory方法：
```html
<%!
    public void jspInit() {
        System.out.println("jspInit ...");
    }
    public void jspDestory() {
        System.out.println("jspDestory ...");
    }
%>
```
### 关闭脚本    
为了页面的整洁性，现在一般用EL，JSTL取代脚本元素，我们可以设置关闭脚本元素：
```xml
<jsp-config>
    <jsp-property-group>
        <url-pattern>*.jsp</url-pattern>
        <scripting-invalid>true</scripting-invalid>
    </jsp-property-group>      
</jsp-config>
```
## 动作
动作会被编译为执行某个操作的Java代码，例如访问某个Java对象，或者调用某个方法。
### useBean
如：
```html
<html>
    <head>
        <title>useBean</title>
    </head>
    <body>
        <jsp:useBean id="today" class="java.util.Date"/>
        <%=today%>
    </body>
</html>
```
运行页面后，会在浏览器输出当前日期和时间。
### 存取属性
有Employee JavaBean，现在页面中存取属性值：
```html
<html>
    <head>
        <title>getProperty and setProperty</title>
    </head>
    <body>
        <jsp:useBean id="employee" class="com.mrbird.entity.Employee"/>
        <jsp:setProperty name="employee" property="firstName" value="Mrbird"/>
        First Name:<jsp:getProperty name="employee" property="firstName"/>
    </body>
</html>
```
### include
include动作用于动态地包含另一个资源，它可以包含另一个JSP页面，一个Servlet，一个静态HTML页面。
```html
 <html>
    <head>
        <title>Include Action</title>
    </head>
    <body>
       <jsp:include page="jspf/menu.jsp"/>
            <jsp:param name="text" value="How are you?"/>
       </jsp:include>
    </body>
</html>  
```
include动作和include指令区别：

① 使用include指令所引用的东东是发生在页面转换的时候，include动作包含是发生在请求的时候。

② 使用include指令时，被包含的文件扩展名是什么并不重要，而使用include动作时，文件扩展名必须为jsp，以便它能够作为一个JSP页面进行处理。
### forward
forward动作是将当前页面跳转到另外一个页面，比如：
```xml
<jsp:forward page="jspf/login.jsp">
    <jsp:param name="text" value="Please login"/>
</jsp:forward>
```
### 错误处理
在可能发生异常的jsp页面设置异常页面路径：
```xml
<%@ page errorPage="errorHandler.jsp"%>
```
errorHandler.jsp：
```html
<%@ page isErrorPage="true"%>
<html>
    <head><title>Error</title></head>
    <body>
        An error occurred.<br/>
        Error message:
        <%
            out.println(exception.toString);
        %>
    </body>
</html>
```
> [《Servlet和JSP学习指南》](https://book.douban.com/subject/22994746/)学习笔记

