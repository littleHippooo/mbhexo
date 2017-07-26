---
title: Servlet Jsp note
date: 2016-02-24 14:08:25
tags: servlet&jsp
password: 465af3ec97365f9e17081f9ea40590e27472f946
---
## 什么是Servlet
sun(oracle)公司制订的一种用来扩展web服务器功能的组件规范。使用Myeclipse创建一个web project，编写一个简单的servlet：src→com.postar.servlet（package）→HiServlet：
```java
public class HiServlet extends HttpServlet{
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter pw = res.getWriter();
        pw.write("<h1 style='color:#42b983'>hello world</h1>");
        pw.close();
    }
}
```
配置文件WebRoot→WEB-INF→web.xml下添加：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5" 
    xmlns="http://java.sun.com/xml/ns/javaee" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
    http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">
    <display-name></display-name>	
    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
    <servlet>
        <servlet-name>hi</servlet-name>
        <servlet-class>com.postar.servlet.HiServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>hi</servlet-name>
        <url-pattern>/hi</url-pattern>
    </servlet-mapping>
</web-app>
```
启动Tomcat，在浏览器中输入：http://localhost:8088/servlet/hi 得到页面：

![b0dde66fad3c3567754137ec57cf7390.png](https://www.tuchuang001.com/images/2017/07/26/b0dde66fad3c3567754137ec57cf7390.png)

程序执行的过程：

![6b441c2e7b01c764e9ca3609e6d00187.md.png](https://www.tuchuang001.com/images/2017/07/26/6b441c2e7b01c764e9ca3609e6d00187.md.png)

## Servlet运行的原理
原理图（执行过程）：

![a506160290d386cbd8113bb4ecc1d02c.png](https://www.tuchuang001.com/images/2017/07/26/a506160290d386cbd8113bb4ecc1d02c.png)

具体过程描述：

1.浏览器依据ip,port建立与容器之间的连接。

2.浏览器将请求数据打包(包含了请求资源路径)。

3.向容器（符合一定规范，提供组件的运行环境的一个程序。）发请求数据包。

4.容器解析请求数据包。

5.将解析的结果封装到request对象上，同时，容器还要创建一个response对象。

6.容器依据请求资源路径找到servlet的配置(web.xml)。

7.8.然后创建该servlet对象，调用servlet对象的service方法(会将request对象,response对象作为参数)。在service方法里面，可以通过request对象获得请求数据并进行相应的处理，然后，处理结果只需要写到response对象上。

9.容器从response对象上获取处理结果，然后打包。

10.发送给浏览器。

11.浏览器从响应数据包中取出处理结果，生成相应的页面。

## get请求和post请求
最常用的两种方式get和post。get/post请求的区别：

**get请求**

1. 如果需要向服务器传递少量数据用get。

2. get请求使用URL传值，即数据会附着在URL上传递给服务器，如：

 ![b6d04a13a7817fd5041763d44d0bf372.png](https://www.tuchuang001.com/images/2017/07/26/b6d04a13a7817fd5041763d44d0bf372.png)

3. 只能传递较少的数据

**post请求**

1. 如果需要提交表单，或者传递大量的数据用post。

2. post请求使用请求数据包的实体内容来传值。

3. 可以传递大量数据。

4. post请求隐私性更好，但是安全级别和get完全相等，不能说它更安全。通过F12都能查看到所有数据。

## 解决get，psot请求中文乱码

服务端Servlet代码：
```java
public class RegistServlet extends HttpServlet{
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // 解决post请求乱码
        req.setCharacterEncoding("utf-8");
        // 使用request接收请求数据
        // 通过框体的name属性值来接收数据
        String code = req.getParameter("code");
        // 解决get请求乱码
        // code = new String(code.getBytes("iso8859-1"), "utf-8");
        String pwd = req.getParameter("pwd");
        String sex = req.getParameter("sex");
        // 值是个数组的时候使用request.getParameterValues()
        String[] favorites = req.getParameterValues("favorites");
        
        System.out.println(code);
        System.out.println(pwd);
        System.out.println(sex);
        for(String f : favorites) {
            System.out.println(f);
        }
        
        //向浏览器输出一些提示信息
        res.setContentType("text/html;charset=utf-8;");
        PrintWriter w = res.getWriter();
        if("admin".equals(code)) {
            w.println("<h1>此账号已存在.</h1>");
        } else {
            w.println("<h1>注册成功.</h1>");
        }
        w.close();

	}
}
```
客户端html代码：
```html
<!doctype html>
<html>
    <head>
        <meta charset="gbk" />
        <title>注册用户</title>
    </head>
    <body>
        <!-- 
        1.想要给服务器提交数据，需要使用表单。
			
        2.传数据时，需要给框设置name属性，该属性将作为传递的数据的名字，服务端
          需要通过此名字来获取数据。
			
        3.表单传递的数据就是框体的value属性值。
            3.1对于文本框、密码框，它的value属性值就是我们在框内输入的内容，因此不必额外设置；
            3.2对于单选、复选、下拉选，需要明确设置value属性的值。
			    
        4.表单上需要通过action属性设置提交的路径，写出URI即可，不需要写出完整的URL。
          通过method属性声明请求的类型。
        -->
        <form action="/servlet/register" method="post">
            <h1>注册用户</h1>
            <p>账号:<input type="text" name="code" /></p>
            <p>密码:<input type="password" name="pwd" /></p>
            <p>性别:
                <input type="radio" name="sex" value="M" />男
                <input type="radio" name="sex" value="F" />女
            </p>
            <p>
                兴趣:
                <input type="checkbox" name="favorites" value="basketball" /> 篮球
                <input type="checkbox" name="favorites" value="football" /> 足球
                <input type="checkbox" name="favorites" value="pingpang" /> 乒乓
                <input type="checkbox" name="favorites" value="running" /> 跑步
            </p>
            <p>
                <!-- submit是专门用于提交表单的按钮 -->
                <input type="submit" value="注册" />
            </p>
        </form>
    </body>
</html>
```
配置xml：
```xml
<servlet>
    <servlet-name>regist</servlet-name>
    <servlet-class>com.postar.servlet.RegistServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>regist</servlet-name>
    <url-pattern>/register</url-pattern>
</servlet-mapping>
```
## 重定向
服务器向浏览器发送一个302状态码及一个Location消息头（该消息头的值是一个地址，称之为重定向地址），浏览器收到后会立即向重定向地址发请求。

如何重定向？
```java
response.sendRedirect(String url);
```
特点：

1. 重定向地址可以是任意的地址。

2. 重定向之后，浏览器地址栏的地址会变。

## 转发
一个web组件（servlet/jsp）将未完成的处理通过容器转交给另外一个web组件继续完成。常见的情况是：一个servlet获得数据之后（比如，通过调用dao），将这些数据转发给一个jsp，由这个jsp来展现这些数据（比如，以表格的方式来展现）。转发的原理图：

转发的过程：

![6070e8ba0fc449e3c63b1f2179da65c3.png](https://www.tuchuang001.com/images/2017/07/26/6070e8ba0fc449e3c63b1f2179da65c3.png)

1.先绑订数据到request对象：
```java
// 变量名name，值obj
request.setAttribute(String name,Object obj);
```
2.获得转发器：
```java
// uri：转发的目的地，比如一个jsp文件。
RequestDispatcher rd = request.getRequestDispatcher(String uri);
```
3.转发：
```java
rd.forward(request,response);
```
转发的特点：

1. 转发之后，浏览器地址栏的地址不变。

2. 转发的目的地必须是同一个应用内部的某个地址。

3. 转发所涉及的各个web组件会共享同一个request对象和response对象。

## 转发和重定向的区别
1. 转发所涉及的各个web组件会共享同一个request对象和response对象，而重定向不行。说明：当请求到达容器，容器会创建request对象和response对象，当响应发送完毕，容器会立即删除request对象和response对象。即request对象和response对象的生存时间是一次请求与响应期间。

2. 转发之后，浏览器地址栏的地址不变，重定向会变。

3. 转发的地址必须是同一个应用内部某个地址，而重定向没有这个限制。

4. 转发是一件事情未做完，调用另外一个组件继续做；而重定向是一件事情已经做完，再调用一个组件做另外一件事情。

## Servlet的生命周期
Servlet容器如何创建Servlet对象、如何为Servlet对象分配、准备资源、如何调用对应的方法来处理请求以及如何销毁Servlet对象的整个过程即Servlet的生命周期。

**阶段一**：实例化，容器调用servlet的构造器，创建一个servlet对象。容器在默认情况下，对于某个类型的servlet,只会创建一个实例。

**阶段二**：初始化，容器在创建好servlet对象之后，会立即调用该对象的init方法。一般情况下，我们不用写init方法，因为GenericServlet已经提供了init方法的实现（将容器传递过来的ServletConfig对象保存来下，并且，提供了getServletConfig方法来获得ServletConfig对象）。

**阶段三**：就绪，容器收到请求之后，调用servlet对象的service方法来处理请求。

**阶段四**：销毁，容器依据自身的算法删除servlet对象，被删除的servlet对象会被垃圾回收机制回收。容器在删除servlet对象之前会调用该对象的destroy方法（只会执行一次）。可以override destroy方法来实现自已的处理逻辑。

例子：
```java
public class LifeServlet extends HttpServlet{
    // 1.Tomcat会自动调用默认构造器创建Servlet
    public LifeServlet(){
        System.out.println("创建LifeServlet");
    }
	
    // 2.Tomcat会自动为当前的Servlet创建一个ServletConfig，用来给它预置一些数据；
    // 3.Tomcat会自动调用init方法，来为此Servlet初始化一些数据；
    // 注意，ServletConfig中预置的数据，可以在init时使用，也可以在service时使用。
    @Override
    public void init(ServletConfig config) throws ServletException {
        System.out.println("初始化Servlet");
    }
	
    // 4.当请求传入时，Tomcat会自动调用该方法来处理本次请求。
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
    	
        System.out.println("调用service()");
        res.setContentType("text/html");
        PrintWriter w = res.getWriter();
        w.println("<h1>LifeServlet</h1>");
        w.close();
    }
	
    // 5.Tomcat在关闭前，会自动调用该方法来销毁该Servlet。通常是将此Servlet所依赖的数据释放（=null）。
    @Override
    public void destroy() {
        // TODO Auto-generated method stub
        super.destroy();
    }
}
```
生命周期相关的几个接口与类：

![0a527e4e2dfd05240703d57cc8ecd578.md.png](https://www.tuchuang001.com/images/2017/07/26/0a527e4e2dfd05240703d57cc8ecd578.md.png)

## ServletContext
Servlet上下文，WEB容器在启动时，它会为每个WEB应用程序都创建一个对应的ServletContext对象，它代表当前web应用，是一个全局的环境变量。该应用中的任何组件，在任何时候都可以访问到该对象，所以Servlet上下文具有唯一性。

在一个web项目中写两个相同的Servlet：
```java
public class FirstServlet extends HttpServlet{
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {
        //1.统计Servlet访问次数：获取ServletContext，它是Servlet公用的
        //数据对象，在Tomcat启动时被Tomcat自动创建，在Tomcat关闭时被Tomcat自动销毁。
        //它是单例的对象，一个项目内只有一份。
        ServletContext ctx = getServletContext();
        //尝试从此对象中读取count变量
        Object count = ctx.getAttribute("count");
        //判断变量是否存在
        if(count == null) {
            //变量不存在，本次访问是第1次，
            //初始化此变量并存入ServletContext。
            ctx.setAttribute("count", 1);
        } else {
            //变量存在，本次访问不是第1次，
            //将变量+1，再次存入ServletContext。
            ctx.setAttribute("count", new Integer(count.toString())+1);
        }
        //2.将统计结果输出到浏览器上
        res.setContentType("text/html;charset=utf-8;");
        PrintWriter w = res.getWriter();
        w.println("<h1>总流量是："+ctx.getAttribute("count")+"</h1>");
        w.close();
    }
}
```
SecondServlet内容和FirstServlet一致。配置略。访问[http://localhost:8080/servlet/first](http://localhost:8080/servlet/first)：

![ce96cf34ec76b9b07b2cf1cf1b8b1c3a.png](https://www.tuchuang001.com/images/2017/07/26/ce96cf34ec76b9b07b2cf1cf1b8b1c3a.png)

访问[http://localhost:8080/servlet/second](http://localhost:8080/servlet/second)：

![704ce84f776ad12cc122184933b2235f.png](https://www.tuchuang001.com/images/2017/07/26/704ce84f776ad12cc122184933b2235f.png)

可见它们获取到的是同一个ServletContext，换句话说ServletContext只有一份。

## JSP
 JSP（Java Server Page）是Sun公司制定的一种服务器端动态页面技术的组件规范，以“.jsp”为后缀的文件中既包含HTML静态标记用于表现页面，也包含特殊的代码，用于生成动态内容。

JSP作为简化Servlet开发的一种技术，实质上最终依然要转变为Servlet才可能运行，只不过这个转变过程由Servlet容器来完成。

## 统一处理异常
将系统异常将给容器来处理，在web.xml中配置异常处理页面：
```xml
<error-page>
    <exception-type>javax.servlet.ServletException</exception-type>
    <location>/error.jsp</location>
</error-page>
```

> 源码地址 [https://git.coding.net/laizhipeng/Servlet.git](https://git.coding.net/laizhipeng/Servlet.git)