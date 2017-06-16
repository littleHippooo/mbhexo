---
title: JSP 标签文件
date: 2016-11-27 16:36:49
tags: servlet&jsp
---
[定制JSP标签](https://mrbird.cc/定制JSP标签.html)可以实现一些JSTL和EL没有提供的功能，基本步骤就是编写标签处理器然后注册标签。从JSP2.0以后，可以直接编写标签文件（.tag）来代替定制JSP标签。        

相比定制JSP标签，标签文件无需编写Java代码，无需注册标签，只需要在tag文件中写代码逻辑即可。

一个简单的例子：

在WEB-INF下创建tags文件夹，然后在里面新建一个firstTag.tag文件：
```html
<%@tag import="java.util.Date"%>
<%@tag import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    out.print(sdf.format(new Date()));
%>
```
<!--more-->
然后在firstTagTest.jsp页面中使用它：
```html
<%@ taglib prefix="mt" tagdir="/WEB-INF/tags"%>
Today is:<mt:firstTag/>
```
部署到Tomcat中，启动服务，访问该jsp，页面显示：

![outputImagefileId58e623fcab6441770f003177.png](https://www.tuchuang001.com/images/2017/06/14/outputImagefileId58e623fcab6441770f003177.png)

That' all.

标签文件中的隐式对象：
<table>
        <tr>
            <td>
                对象
            </td>
            <td>
                类型
            </td>
        </tr>
        <tr>
            <td>
                request
            </td>
            <td>
                javax.servlet.http.HttpServletRequest
            </td>
        </tr>
        <tr>
            <td>
                response
            </td>
            <td>
                javax.servlet.http.HttpServletResponse
            </td>
        </tr>
        <tr>
            <td>
                out
            </td>
            <td>
                javax.servlet.jsp.JspWriter
            </td>
        </tr>
        <tr>
            <td>
                session
            </td>
            <td>
                javax.servlet.http.HttpSession
            </td>
        </tr>
        <tr>
            <td>
                application
            </td>
            <td>
                javax.servlet.ServletContext
            </td>
        </tr>
        <tr>
            <td>
                config
            </td>
            <td>
                javax.servlet.ServletConfig
            </td>
        </tr>
        <tr>
            <td>
                jspContext
            </td>
            <td>
                javax.servlet.jsp.JspContext
            </td>
        </tr>
</table>

和Jsp的隐式对象类似。
## 标签文件指令
### tag指令
tag指令常用属性：
<table>
        <tr>
            <td>
                属性
            </td>
            <td>
                描述
            </td>
        </tr>
        <tr>
            <td>
                display-name
            </td>
            <td>
                通过XML工具显示的简称，默认为标签名
            </td>
        </tr>
        <tr>
            <td>
                body-content
            </td>
            <td>
                标签主体内容的信息，可以为empty，tagdependent或scriptless（默认）
            </td>
        </tr>
        <tr>
            <td>
                import
            </td>
            <td>
                导入Java类型
            </td>
        </tr>
        <tr>
            <td>
                pageEncoding
            </td>
            <td>
                指定编码
            </td>
        </tr>
        <tr>
            <td>
                isELIgnoreds
            </td>
            <td>
                是否使用EL表达式
            </td>
        </tr>
</table>

### include指令
该指令可以引入静态文件（HTML文件）或动态文件（另一个标签文件）。

如有静态HTML文件included.html：
```html
<table border=1>
    <tbody>
        <tr>
            <td style="text-align: center;"><strong>object</strong></td>
            <td style="text-align: center;"><strong>type</strong></td>
        </tr>
        <tr>
            <td>request</td>
            <td>javax.servlet.http.HttpServletRequest</td>
        </tr>
        <tr>
            <td>response</td>
            <td>javax.servlet.http.HttpServletResponse</td>
        </tr>
        <tr>
            <td>out</td>
            <td>javax.servlet.jsp.JspWriter</td>
        </tr>
        <tr>
            <td>session</td>
            <td>javax.servlet.http.HttpSession</td>
        </tr>
        <tr>
            <td>application</td>
            <td>javax.servlet.ServletContext</td>
        </tr>
        <tr>
            <td>config</td>
            <td>javax.servlet.ServletConfig</td>
        </tr>
        <tr>
            <td>jspContext</td>
            <td>javax.servlet.jsp.JspContext</td>
        </tr>
    </tbody>
</table>
```
included.tag文件：
```html
<%@tag pageEncoding="utf-8" %>
<%
    out.print("和Jsp的隐式对象类似。");
%>
```
在include.tag标签中引用included.html和included.tag：
```html
<%@tag pageEncoding="utf-8"%>
标签文件中的隐式对象：</br></br>
<%@include file="/WEB-INF/tags/included.html"%></br>
<%@include file="/WEB-INF/tags/included.tag"%>
```
在jsp页面中测试：
```html
<%@taglib prefix="mt" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" %>
<mt:include/>
```
启动访问，页面显示：

![12953061-file_1487995461665_125ce.png](https://www.tuchuang001.com/images/2017/06/14/12953061-file_1487995461665_125ce.png)

### taglib指令
该指令的作用就是在一个标签文件中使用另外一个标签，如现有taglibDemo.tag：
```html
<%@ taglib prefix="mt" tagdir="/WEB-INF/tags" %>
Today's date  : <mt:firstTag/>
```
该标签调用了第一个例子中创建的firstTag标签。
### attribute指令
该指令在标签中使用属性，attribute常用的属性有：
<table>
        <tr>
            <td>
                属性
            </td>
            <td>
                描述
            </td>
        </tr>
        <tr>
            <td>
                name
            </td>
            <td>
                属性名
            </td>
        </tr>
        <tr>
            <td>
                required
            </td>
            <td>
                是否式必须的，默认为false
            </td>
        </tr>
        <tr>
            <td>
                type&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                类型，默认为String
            </td>
        </tr>
</table>
编写一个时间格式化标签formatDate.tag：
```html
<%@tag import="java.util.Date"%>
<%@tag import="java.text.SimpleDateFormat"%>
<%@ attribute name="fmt" required="true"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat(fmt);
    out.print(sdf.format(new Date()));
%>
```
jsp中测试：
```html
<%@ taglib prefix="mt" tagdir="/WEB-INF/tags" %>
<mt:dateFormat fmt="yyyy-MM-dd HH:mm:ss"/></br>
<mt:dateFormat fmt="yyyyMMdd"/>
```
页面显示：

![17067936-file_1487995485314_d54.png](https://www.tuchuang001.com/images/2017/06/14/17067936-file_1487995485314_d54.png)
### variable指令
用于定义标签文件的变量，常用的属性有：
<table>
        <tr>
            <td>
                属性
            </td>
            <td>
                描述
            </td>
        </tr>
        <tr>
            <td>
                name-given
            </td>
            <td>
                变量名
            </td>
        </tr>
        <tr>
            <td>
                scope
            </td>
            <td>
                范围
            </td>
        </tr>
        <tr>
            <td>
                description
            </td>
            <td>
                描述
            </td>
        </tr>
</table>
如下标签，它有两个变量：longDate和shortDate：
```html
<%@tag import="java.text.SimpleDateFormat"%>
<%@tag import="java.util.Date"%>
<%@ variable name-given="longDate" %>
<%@ variable name-given="shortDate" %>
<%
    Date date = new Date();
    SimpleDateFormat longFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
    SimpleDateFormat shortFormat = new SimpleDateFormat("yyyy-MM-dd");
    jspContext.setAttribute("longDate", longFormat.format(date));
    jspContext.setAttribute("shortDate", shortFormat.format(date));
%>
<jsp:doBody/>
```
jsp页面引用：
```html
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
Today's date:
<br/>
<tags:varDemo>
In long format: ${longDate}
<br/>
In short format: ${shortDate}
</tags:varDemo>
```
测试，页面显示：

![71683354-file_1487995510634_89ad.png](https://www.tuchuang001.com/images/2017/06/14/71683354-file_1487995510634_89ad.png)