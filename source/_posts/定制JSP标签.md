---
title: 定制JSP标签
date: 2016-11-15 13:10:57
tags:  servlet&jsp
---
当JSTL自带标签无法满足我们的开发需求的时候，我们可以自定义标签。定制标签可以通过实现SimpleTag接口或者继承SimpleTagSupport类（SimpleTagSupport提供了SimpleTag接口默认实现）。

标签的具体实现功能逻辑写在doTag()方法中，定制JSP标签的大致步骤分为两步：
<!--more-->

1.编写标签处理器

2.注册标签
## SimpleTag
### 标签处理器
编写一个Java类，实现SimpleTag接口：
```java
public class MyFirstTag implements SimpleTag{
    JspContext jspContext;
    @Override
    public void doTag() throws JspException, IOException {
         System.out.println("doTag");
         jspContext.getOut().print("This is my first tag.");
    }
    
    @Override
    public JspTag getParent() {
        return null;
    }
    
    @Override
    public void setJspBody(JspFragment body) {
        System.out.println(body);
    }
    
    @Override
    public void setJspContext(JspContext jspContext) {
        this.jspContext=jspContext;
    }
    
    @Override
    public void setParent(JspTag parent) {
    	
    }
}          
```
`doTag`方法中编写了定制标签要实现的功能。`getParent`，`setParent`方法只有标签嵌套在另一个标签的时候才被调用。`setJspContext`方法传递了一个`JspContext`对象，`JspContext`对象的g`etOut`方法返回一个`JspWriter`。
### 注册标签
在WEB-INF文件夹下新建一个tlds文件夹，然后在该文件夹下新建一个mytags.tld文件：

![61698718-file_1487995283924_450a.png](https://www.tuchuang001.com/images/2017/06/14/61698718-file_1487995283924_450a.png)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<taglib xmlns="http://java.sun.com/xml/ns/j2ee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee web-jsptaglibrary_2_1.xsd"
  version="2.1">
    
    <description>Simple tag examples</description>
    <tlib-version>1.0</tlib-version>
    <short-name>My First Taglib Example</short-name>
    <tag>
        <name>firstTag</name>
        <tag-class>MyTags.MyFirstTag</tag-class>
        <body-content>empty</body-content>
    </tag>
</taglib>
```
最主要的为tag标签，name标签名，tag-class为标签java类路径。        

在jsp页面中使用该标签：
```html
<%@ taglib uri="/WEB-INF/tlds/mytags.tld" prefix="mt"%>
<html>
<head>
    <title>Testing my first tag</title>
</head>
<body>
    <mt:firstTag/>
</body>
</html>
```
启动tomcat访问该jsp，页面显示This is my first tag. 控制台输出doTag。
## SimpleTagSupport
另一种方法为继承SimpleTagSupport类，重写doTag方法，这里模拟一个时间格式化标签：
```java
public class DateFormatTag extends SimpleTagSupport{
    private String fmt;
    
    public void setFmt(String fmt) {
        this.fmt = fmt;
    }
    public void doTag() throws IOException, JspException {
        JspContext jspContext = getJspContext();
        JspWriter out = jspContext.getOut();
        SimpleDateFormat sdf = new SimpleDateFormat(fmt);
        out.print(sdf.format(new Date()));
    }
}
```
`fmt`为标签的属性，这里为时间格式化的格式。通过静态方法`getJspContext`可以获取`JspContext`对象。

编写好便签处理器后，注册它：
```xml
<tag>
     <name>DateFormat</name>
     <tag-class>MyTags.DateFormatTag</tag-class>
     <body-content>empty</body-content>
     <attribute>
         <name>fmt</name>
         <required>true</required>
     </attribute>
</tag> 
```
`﻿​attribute`标签定义了标签的属性。

在jsp页面中进行测试：
```html
<%@ taglib uri="/WEB-INF/tlds/mytags.tld" prefix="mt"%>
<html>
<head>
    <title>test dateformat</title>
</head>
<body>
    <mt:DateFormat fmt="yyyy-MM-dd HH:mm:ss"/><br/>
    <mt:DateFormat>
        <jsp:attribute name="fmt">
            yyyy-MM-dd
        </jsp:attribute>
    </mt:DateFormat>
</body>
</html>  
```
两种方式给fmt属性赋值，启动tomcat访问该jsp页面，页面显示：

![45952923-file_1487995311914_bed9.png](https://www.tuchuang001.com/images/2017/06/14/45952923-file_1487995311914_bed9.png)
## JspFragment    
JspFragment就是一段不包含scriplet的jsp代码段，JspFragment类有两个方法：`getJspContext`和`invoke`。

`getJspContext`方法返回与这个`JspFragment`相关的`JspContext`，`invoke`方法用来执行片段，如果片段不含标签无需执行的话，则传递`null`。

现定制一个select标签，任务是根据传入的以逗号分隔的字符串转为对应的下拉选框。select标签里的`JspFragment`内容为： 
```xml
<option value="${value}">${text}</option> 
```
编写标签处理器：
```java
public class SelectTag extends SimpleTagSupport{
    private String values;
    
    public void setValues(String values) {
        this.values = values;
    }
    public void doTag() throws IOException, JspException {
        JspContext jspContext = getJspContext();
        JspWriter out = jspContext.getOut();
        String[] arr= values.split(",");
        out.print("<select>\n");
        for(int i=0;i<arr.length;i++){
            jspContext.setAttribute("value", i+1);
            jspContext.setAttribute("text", arr[i]);
            getJspBody().invoke(null);
        }
        out.print("</select>\n");
    }
}
```
注册该标签：
```xml
<tag>
    <name>select</name>
    <tag-class>MyTags.SelectTag</tag-class>
    <body-content>scriptless</body-content>
    <attribute>
        <name>values</name>
        <required>true</required>
    </attribute>
</tag>  
```
因为标签包含JspFragment，所以body-content标签配置为scriptless。

在jsp页面中测试该标签：
```html
<%@ taglib uri="/WEB-INF/tlds/mytags.tld" prefix="mt"%>
<html>
<head>
    <title>test selecttag</title>
</head>
<body>
    <mt:select values="fuzhou,xiamen,longyan">
        <option value="${value}">${text}</option>
    </mt:select>
</body>
</html>
```
启动tomcat，访问该jsp页面，页面显示：

![55526526-file_1487995334267_a4a6.png](https://www.tuchuang001.com/images/2017/06/14/55526526-file_1487995334267_a4a6.png)

查看源码：
```html
<select>
    <option value="1">fuzhou</option>
    <option value="2">xiamen</option>
    <option value="3">longyan</option>
</select>
```
## 函数
假如JSTL中的函数标签不能满足我们的实际需求，我们也可以自己编写。

新建Function包，在包下创建StringFunction类：
```java
public class StringFunction {
    public static String reverseString(String value){
        return new StringBuffer(value).reverse().toString();
    }
}   
```
注册该标签：

在WEB-INF下的tlds下新建function.tld：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<taglib xmlns="http://java.sun.com/xml/ns/j2ee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee web-jsptaglibrary_2_1.xsd"
  version="2.1">
    
    <description>Function tag examples</description>
    <tlib-version>1.0</tlib-version>
    
    <function>
        <description>Reverses a String</description>
        <name>reverseString</name>
        <function-class>Functions.StringFunction</function-class>
        <function-signature>
            java.lang.String reverseString(java.lang.String)
        </function-signature>
    </function>    
</taglib>
```
name表示函数名。

function-class为实现该函数的Java类的全类名。

function-signature表示该函数的静态Java方法签名。

在jsp中测试该EL函数：
```html
<%@ taglib uri="/WEB-INF/tlds/function.tld" prefix="fn"%>
<html>
<head>
    <title>Testing reverseString function</title>
</head>
<body>
    ${fn:reverseString("Hello World")}
</body>
</html>
```
启动tomcat，访问该jsp，页面显示：

![76202290-file_1487995364195_6063.png](https://www.tuchuang001.com/images/2017/06/14/76202290-file_1487995364195_6063.png)

> [《Servlet和JSP学习指南》](https://book.douban.com/subject/22994746/)学习笔记 