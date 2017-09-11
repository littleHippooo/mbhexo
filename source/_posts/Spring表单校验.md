---
title: Spring表单校验
date: 2017-01-22 19:27:05
tags: [Spring]
---
从Spring 3.0开始，Spring对Java校验API（Java Validation API，又称JSR-303）提供了支持。在Spring MVC中要使用Java校验API的话，并不需要什么额外的配置。只要保证在类路径下包含这个Java API的实现即可，比如Hibernate Validator。

引入hibernate-validator：
```xml
<!-- https://mvnrepository.com/artifact/org.hibernate/hibernate-validator -->
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>5.2.4.Final</version>
</dependency>
```
<!--more-->
所有的注解都位于javax.validation.constraints包中。下表列出了这些校验注解。
<table>
        <tr>
            <td>
                
                    注解
                
            </td>
            <td>
                
                    描述
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Null
                
            </td>
            <td>
                
                    限制只能为null
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @NotNull
                
            </td>
            <td>
                
                    限制必须不为null
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @AssertFalse
                
            </td>
            <td>
                
                    限制必须为false
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @AssertTrue
                
            </td>
            <td>
                
                    限制必须为true
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @DecimalMax(value)
                
            </td>
            <td>
                
                    限制必须为一个不大于指定值的数字
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @DecimalMin(value)
                
            </td>
            <td>
                
                    限制必须为一个不小于指定值的数字
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Digits(integer,fraction)
                
            </td>
            <td>
                
                    限制必须为一个小数，且整数部分的位数不能超过integer，
                
                
                    小数部分的位数不能超过fraction
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Future
                
            </td>
            <td>
                
                    限制必须是一个将来的日期
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Max(value)
                
            </td>
            <td>
                
                    限制必须为一个不大于指定值的数字
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Min(value)
                
            </td>
            <td>
                
                    限制必须为一个不小于指定值的数字
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Past
                
            </td>
            <td>
                
                    限制必须是一个过去的日期
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Pattern(value)
                
            </td>
            <td>
                
                    限制必须符合指定的正则表达式
                
            </td>
        </tr>
        <tr>
            <td>
                
                    @Size(max,min)
                
            </td>
            <td>
                
                    限制字符长度必须在min到max之间
                
            </td>
        </tr>
</table>

## 注解实体类
新建一个表单实体类，并加上注解：
```java
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import org.hibernate.validator.constraints.Email;
 
public class Form {
    @NotNull
    @Size(min=5,max=16,message="{name.msg}")
    private String name;
    @NotNull()
    @Email(message="{email.msg}")
    private String email;
    @NotNull
    @Size(min=5,max=16,message="{password.msg}")
    private String password;
    
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
}
```
message属性用于添加国际化支持，接下来需要做的就是创建一个名为ValidationMessages.properties的文件（默认叫这个，不区分大小写，放在src/main/resources路径下）：
```xml
name.msg=\u7528\u6237\u540D\u957F\u5EA6\u4E3A{min}\u5230{max}\u4E2A\u5B57\u7B26
password.msg=\u5BC6\u7801\u957F\u5EA6\u4E3A{min}\u5230{max}\u4E2A\u5B57\u7B26
email.msg=\u90AE\u7BB1\u683C\u5F0F\u4E0D\u5408\u6CD5
```
ValidationMessages.properties文件中每条信息的key值对应于注解中message属性占位符的 值。同时，最小和最大长度在ValidationMessages.properties文件中有自己的占位符——`{min}`和`{max}`——它们会引用`@Size`注解上所设置的min和max属性。
## Spring JSP库    
为了使用Spring JSP库，需要在JSP页首加入：
```html
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf" %>
```
引入依赖：
```xml
<!-- https://mvnrepository.com/artifact/jstl/jstl -->
<dependency>
    <groupId>jstl</groupId>
    <artifactId>jstl</artifactId>
    <version>1.2</version>
</dependency>
```
相关标签如下表所示：
<table>
        <tr>
            <td>
                JSP标签
            </td>
            <td>
                描述
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:checkbox&gt;
            </td>
            <td>
                渲染成一个HTML &lt;input&gt;标签，其中type属性设置为checkbox
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:checkboxes&gt;
            </td>
            <td>
                渲染成多个HTML &lt;input&gt;标签，其中type属性设置为checkbox
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:errors&gt;
            </td>
            <td>
                在一个HTML &lt;span&gt;中渲染输入域的错误
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:form&gt;
            </td>
            <td>
                渲染成一个HTML &lt;form&gt;标签，并为其内部标签暴露绑定路径，用于数据绑定
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:hidden&gt;
            </td>
            <td>
                渲染成一个HTML &lt;input&gt;标签，其中type属性设置为hidden
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:input&gt;
            </td>
            <td>
                渲染成一个HTML &lt;input&gt;标签，其中type属性设置为text
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:label&gt;
            </td>
            <td>
                渲染成一个HTML &lt;label&gt;标签
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:option&gt;
            </td>
            <td>
                渲染成一个HTML &lt;option&gt;标签，其selected属性根据所绑定的值进行设置
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:options&gt;
            </td>
            <td>
                按照绑定的集合、数组或Map，渲染成一个HTML &lt;option&gt;标签的列表
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:password&gt;
            </td>
            <td>
                渲染成一个HTML &lt;input&gt;标签，其中type属性设置为password
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:radiobutton&gt;
            </td>
            <td>
                渲染成一个HTML &lt;input&gt;标签，其中type属性设置为radio
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:radiobuttons&gt;
            </td>
            <td>
                渲染成多个HTML &lt;input&gt;标签，其中type属性设置为radio
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:select&gt;
            </td>
            <td>
                渲染为一个HTML &lt;select&gt;标签
            </td>
        </tr>
        <tr>
            <td>
                &lt;sf:textarea&gt;
            </td>
            <td>
                渲染为一个HTML &lt;textarea&gt;标签
            </td>
        </tr>
</table>
用Spring JSP标签创建一个register.jsp：
```html
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;chartset=utf-8">
    <title>leanote 蚂蚁笔记</title>
</head>
<style>
    input{margin-top:5px;}
    label.error{color:red;}
    span.error{color:red;}
    input.error{border:1px solid red;}
</style>
<body>
    <sf:form method="post" commanName="form"
        action="${pageContext.request.contextPath}/register">
        <sf:label path="name" cssErrorClass="error">用户名：</sf:label>
        <sf:input path="name" cssErrorClass="error"/>
        <sf:errors path="name" cssClass="error"/><br/>
        邮箱：<sf:input path="email"/><sf:errors path="email" cssClass="error"/><br/>
        密码：<sf:password path="password"/><sf:errors path="password" cssClass="error"/><br/>
        <input type="submit" value="注册"/>
    </sf:form>
</body>
</html>
```
`<sf:form>`会渲染为一个HTML`<form>`标签，也可以通过`commandName`属性构建针对某个模型对象的上下文信息。这里设为form（待会在controller中传递到此页面）。

`cssClass`属性可以给标签加上样式Class，用于在CSS中对其选中并修改样式。

`path`属性指向实体类form对应的属性名称。如果将`<sf:errors/>`标签的path属性设置为*的话，其将显示所有不满足校验的提示信息。

`cssErrorClass`属性指定校验不通过时候除了`<sf:errors/>`标签外的标签样式。
## 编写controller  
Regester控制器如下所示： 
```java
import javax.validation.Valid;
import mrbird.mvc.entity.Form;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
 
@Controller
public class LeanoteController {
    @RequestMapping(value="/registerindex",method=RequestMethod.GET)
    public String register(Model model){
        //对应<sf:form/>标签的commandName属性值
        model.addAttribute(new Form());
        return "register";
    }
    @RequestMapping(value="/register",method=RequestMethod.POST)
    //form参数添加了@Valid注解，这会告知Spring，需要确保这个对象满足校验限制。
    //Errors参数要紧跟在带有@Valid注解的参数后面
    public String submit(@Valid Form form,BindingResult result){
        if(result.hasErrors()){
            //出错时回到注册页面，这里不能够用重定向，不然看不到错误提示信息
            return "register";
        }
        //校验通过，重定向到/success/{name}
        return "redirect:/success/"+form.getName();
    }
    @RequestMapping(value="/success/{name}",method=RequestMethod.GET)
    public String success(@PathVariable String name,Model model){
        model.addAttribute(name);
        return "success";
    }
}
```
部署项目，访问：http://localhost:8080/spring/registerindex：   

![65384397-file_1487996138511_af03.gif](img/65384397-file_1487996138511_af03.gif)