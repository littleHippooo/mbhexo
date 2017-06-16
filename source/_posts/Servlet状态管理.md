---
title: Servlet状态管理
date: 2017-03-02 10:44:13
tags: servlet&jsp
---
Servlet状态管理：将客户端(浏览器)与服务器之间多次交互（一次请求，一次响应）当做一个整体来看待，并且将多次交互所涉及的数据（即状态）保存下来。

如何进行状态管理？

1.客户端状态管理技术：即将状态保存在客户端，有代表性的是cookie技术。

2.服务器端状态管理技术：即将状态保存在服务器端，有代表性的是session技术。
<!--more-->
## cookie    
浏览器向web服务器发送请求时，服务器会将少量的数据以set-cookie消息头的方式发送给浏览器，浏览器会将这些数据保存下来。当浏览器再次访问服务器时，会将这些数据以cookie消息头的方式发送给服务器。
### 创建cookie：  
```java
Cookie c = new Cookie(String name,String value);
response.addCookie(c);
```
### 查询cookie：
```java
Cookie[] cookies =  request.getCookies();
if(cookies != null){
    for(Cookie c : cookies){
        String cookieName = c.getName();
        String cookieValue = c.getValue();
    }
} 
```
### 编码问题：
cookie只能保存合法的ascii字符，如果要保存中文，需要将中文转换成合法的ascii字符（编码）。
```java
String str = URLEncoder.encode("北京","utf-8");
```
encode方法先将"北京"按照"utf-8”进行编码（编码之后会得到一个字节数组），然后将字节数组转换成一个字符串。类似于%AD%EF%88%DD%AF%48%。
```java
// 将字符串还原
String decodeValue = URLDecoder.decode(str,"utf-8");
```
### 生存时间：
默认情况下，浏览器会将cookie保存在内存里面，只要浏览器不关闭，cookie会一直存在。也可以用代码指定其生存时间：
```java
cookie.setMaxAge(int seconds);
```
注意seconds单位是秒。seconds取值有三种情况：

1.`seconds > 0`：浏览器保存cookie的最长时间为设置的参数值，如果超过指定的时间，浏览器会删除这个cookie。浏览器会将cookie保存在硬盘上。

2.`seconds = 0`：删除cookie。比如，要删除一个名称为"addr"的cookie：
```java
Cookie c = new Cookie("addr","");
c.setMaxAge(0);
response.addCookie(c); 
```
3.`sencods < 0`：缺省值,浏览器会将cookie放到内存里面。
### 修改cookie：
所谓Cookie的修改，本质是获取到要变更值的Cookie，通过`setValue`方法将新的数据存入到cookie中，然后由response响应对象发回到客户端，对原有旧值覆盖后即实现了修改。
## session
服务器为不同的客户端在内存中创建了用于保存数据的Session对象，并将用于标识该对象的唯一Id发回给与该对象对应的客户端。当浏览器再次发送请求时，SessionId也会被发送过来，服务器凭借这个唯一Id找到与之对应的Session对象。在服务器端维护的这些用于保存与不同客户端交互时的数据的对象叫做Session。 

Session对象可以保存更复杂的对象类型数据了，不像Cookie只能保存字符串。
### 获得session对象：   
1.方式一：
```java
HttpSession session = request.getSession(boolean flag);
```
flag为`true`时：先查看请求当中有没有sessionId，如果没有，服务器要创建一个session对象；如果有sessionId，服务器会依据sessionId查找对应的session对象，如果找到了则返回，找不到服务器会创建一个新的session对象。

flag为`false`时：先查看请求当中有没有sessionId，如果没有，服务器不会创建session对象，返回`null`。如果有sessionId，服务器会依据sessionId查找对应的session对象，如果找到了则返回，找不到返回`null`。

2.方式二：
```java
HttpSession session = request.getSession();
// 等价于 request.getSession(true)。
```
使用session对象绑定数据：
```java
void session.setAttribute(String name,Object obj);
```
获取绑定数据或移除绑定数据的代码如下：
```java
void session.getAttribute(String name);
void session.removeAttribute(String name);
```
### session超时：
什么是session超时？web服务器会将空闲时间过长的session对象删除掉（为了节省内存空间资源）。web服务器缺省的超时时间限制，一般是30分。可以修改缺省的超时时间限制，比如，可以修改tomcat的web.xml：
```xml
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```
使用编程的方式来修改：
```java
session.setMaxInactiveInterval(int seconds);  
```
立即删除session对象：
```java
session.invalidate();  
```
### session优缺点：

session对象的数据由于保存在服务器端，并不在网络中进行传输，所以安全一些，并且能够保存的数据类型更丰富，同时Session也能够保存更多的数据，Cookie只能保存大约4kb的字符串。

session的安全性是以牺牲服务器资源为代价的，如果用户量过大，会严重影响服务器的性能。               