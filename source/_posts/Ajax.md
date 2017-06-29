---
title: Ajax
date: 2016-12-13 15:24:14
tags: Ajax
---
## JavaScript Ajax
### XMLHttpRequest对象
```javascript
function getXHR() {
    //根据对象判断浏览器
    if(window.XMLHttpRequest) {
        //不是IE
        return new XMLHttpRequest();
    }else{
        //IE
        return new ActiveXObject("Microsoft.XMLHttp");
    }
}
var xhr = getXHR();
```
<!--more-->
### get请求
打开请求：
```javascript
xhr.open("get", "example.php?name1=value1&name2=value2", true);
```
`true`表示发送异步请求。

下面这个函数可以辅助向现有URL 的末尾添加查询字符串参数：
```javascript
function addURLParam(url, name, value) {
    url += (url.indexOf("?") == -1 ? "?" : "&");
    url += encodeURIComponent(name) + "=" + encodeURIComponent(value);
    return url;
}
```
`addURLParam()`函数接受三个参数：要添加参数的URL、参数的名称和参数的值。

下面是使用这个函数来构建请求URL 的示例。
```javascript
var url = "example.php";

//添加参数
url = addURLParam(url, "name", "Nicholas");
url = addURLParam(url, "book", "Professional JavaScript");

//初始化请求
xhr.open("get", url, false);
```
发送请求：
```javascript
xhr.send(null);
```
这里的`send()`方法接收一个参数，即要作为请求主体发送的数据。如果不需要通过请求主体发送数据，则必须传入`null`，因为这个参数对有些浏览器来说是必需的。调用`send()`之后，请求就会被分派到服务器。

回调函数：

XHR 对象的`readyState` 属性可取的值：

 0：未初始化。尚未调用open()方法。

 1：启动。已经调用open()方法，但尚未调用send()方法。

 2：发送。已经调用send()方法，但尚未接收到响应。

 3：接收。已经接收到部分响应数据。

 4：完成。已经接收到全部响应数据，而且已经可以在客户端使用了。

只要readyState 属性的值由一个值变成另一个值，都会触发一次readystatechange 事件。可以利用这个事件来检测每次状态变化后readyState 的值。

```javascript
xhr.onreadystatechange = function(){callback(xhr);};
//回调函数
function callback(xhr) {
     //当请求结束且没报错时
     if(xhr.readyState==4 && xhr.status==200) {
         var txt = xhr.responseText;
         console.log(txt);
     }
}﻿​
```
在收到响应后，响应的数据会自动填充XHR 对象的属性，相关的属性简介如下。

`responseText`：作为响应主体被返回的文本。

`responseXML`：如果响应的内容类型是"text/xml"或"application/xml"，这个属性中将保存包含着响应数据的XML DOM 文档。

`status`：响应的HTTP 状态。

`statusText`：HTTP 状态的说明。
### post请求
```javascript
xhr.open("post", "postexample.php", true);
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

//发送form表单数据
var form = document.getElementById("form");
xhr.send(serialize(form));

//发送普通数据
xhr.send("name = Nicholas");
xhr.send("book = Professional JavaScript");
```
## jQuery Ajax
### load()
`load()` 方法通过 AJAX 请求从服务器加载数据，并把返回的数据放置到指定的元素中。

语法：
```javascript
load(url,data,function(response,status,xhr));
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                url
            </td>
            <td>
                规定要将请求发送到哪个 URL。
            </td>
        </tr>
        <tr>
            <td>
                data
            </td>
            <td>
                可选。规定连同请求发送到服务器的数据。
            </td>
        </tr>
        <tr>
            <td>
                function(response,status,xhr)
            </td>
            <td>
                    可选。规定当请求完成时运行的函数。</br>
                    额外的参数：</br>

                        `response&nbsp` - 包含来自请求的结果数据</br>

                        `status&nbsp` - 包含请求的状态（"success", "notmodified", "error", "timeout" 或 "parsererror"）</br>

                        `xhr&nbsp` - 包含 XMLHttpRequest 对象</br>

            </td>
        </tr>
</table>

如在id为result的div中加载test.html页面：
```javascript
$("#result").load("test.html");
```
### $.get()和$.post()

`$.get()`方法使用 HTTP GET 请求从服务器加载数据。

语法：
```javascript
$.get(URL,data,function(data,status,xhr),dataType);
```
参数：
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                URL
            </td>
            <td>
                必需。规定您需要请求的 URL。
            </td>
        </tr>
        <tr>
            <td>
                data
            </td>
            <td>
                可选。规定连同请求发送到服务器的数据。
            </td>
        </tr>
        <tr>
            <td>
                function(data,status,xhr)
            </td>
            <td>
                可选。规定当请求成功时运行的函数。</br>

                额外的参数：</br>

                        `data&nbsp` - 包含来自请求的结果数据</br>

                        `status&nbsp` - 包含请求的状态（"success"、"notmodified"、"error"、"timeout"、"parsererror"）</br>

                        `xhr&nbsp` - 包含 XMLHttpRequest 对象</br>

            </td>
        </tr>
        <tr>
            <td>
                dataType
            </td>
            <td>
                可选。规定预期的服务器响应的数据类型。</br>

                默认地，jQuery 会智能判断。</br>

                可能的类型：</br>

                        `xml` - 一个 XML 文档</br>

                        `html` - HTML 作为纯文本</br>

                        `text` - 纯文本字符串</br>

                        `script` - 以 JavaScript 运行响应，并以纯文本返回</br>

                        `json` - 以 JSON 运行响应，并以 JavaScript 对象返回</br>

                        `jsonp` - 使用 JSONP 加载一个 JSON 块，将添加一个 "?callback=?" 到 URL 来规定回调</br>

            </td>
        </tr>
</table>

如：
```javascript
$.get("get.php",{
        userName : $("#userName").val().trim(),
        content : $("#content").val().trim()
    },function(data){
        // do something
},"json");
```
`$.post()`和`$.get()`类似，区别在于`$.post()`可发送的数据量更大。
### $.ajax()
语法：
```javascript
$.ajax({name:value, name:value, ... })
```
下面的表格中列出了可能的名称/值：
<table>
        <tr>
            <th>
                名称
            </th>
            <th>
                值/描述
            </th>
        </tr>
        <tr>
            <td>
                async
            </td>
            <td>
                布尔值，表示请求是否异步处理。默认是 true。
            </td>
        </tr>
        <tr>
            <td>
                beforeSend(
                <em>
                    xhr
                </em>
                )
            </td>
            <td>
                发送请求前运行的函数。
            </td>
        </tr>
        <tr>
            <td>
                cache
            </td>
            <td>
                布尔值，表示浏览器是否缓存被请求页面。默认是 true。
            </td>
        </tr>
        <tr>
            <td>
                complete(
                <em>
                    xhr,status
                </em>
                )
            </td>
            <td>
                请求完成时运行的函数（在请求成功或失败之后均调用，即在 success 和 error 函数之后）。
                <br>
            </td>
        </tr>
        <tr>
            <td>
                contentType
            </td>
            <td>
                发送数据到服务器时所使用的内容类型。默认是："application/x-www-form-urlencoded"。
            </td>
        </tr>
        <tr>
            <td>
                context
            </td>
            <td>
                为所有 AJAX 相关的回调函数规定 "this" 值。
            </td>
        </tr>
        <tr>
            <td>
                data
            </td>
            <td>
                规定要发送到服务器的数据。
            </td>
        </tr>
        <tr>
            <td>
                dataFilter(
                <em>
                    data
                </em>
                ,
                <em>
                    type
                </em>
                )
            </td>
            <td>
                用于处理 XMLHttpRequest 原始响应数据的函数。
            </td>
        </tr>
        <tr>
            <td>
                dataType
            </td>
            <td>
                预期的服务器响应的数据类型。
            </td>
        </tr>
        <tr>
            <td>
                error(
                <em>
                    xhr,status,error
                </em>
                )
            </td>
            <td>
                如果请求失败要运行的函数。
            </td>
        </tr>
        <tr>
            <td>
                global
            </td>
            <td>
                布尔值，规定是否为请求触发全局 AJAX 事件处理程序。默认是 true。
                <br>
            </td>
        </tr>
        <tr>
            <td>
                ifModified
            </td>
            <td>
                布尔值，规定是否仅在最后一次请求以来响应发生改变时才请求成功。默认是 false。
            </td>
        </tr>
        <tr>
            <td>
                jsonp
            </td>
            <td>
                在一个 jsonp 中重写回调函数的字符串。
            </td>
        </tr>
        <tr>
            <td>
                jsonpCallback
            </td>
            <td>
                在一个 jsonp 中规定回调函数的名称。
            </td>
        </tr>
        <tr>
            <td>
                password
            </td>
            <td>
                规定在 HTTP 访问认证请求中使用的密码。
            </td>
        </tr>
        <tr>
            <td>
                processData
            </td>
            <td>
                布尔值，规定通过请求发送的数据是否转换为查询字符串。默认是 true。
            </td>
        </tr>
        <tr>
            <td>
                scriptCharset
            </td>
            <td>
                规定请求的字符集。
            </td>
        </tr>
        <tr>
            <td>
                success(
                <em>
                    result,status,xhr
                </em>
                )
            </td>
            <td>
                当请求成功时运行的函数。
            </td>
        </tr>
        <tr>
            <td>
                timeout
            </td>
            <td>
                设置本地的请求超时时间（以毫秒计）。
            </td>
        </tr>
        <tr>
            <td>
                traditional
            </td>
            <td>
                布尔值，规定是否使用参数序列化的传统样式。
            </td>
        </tr>
        <tr>
            <td>
                type
            </td>
            <td>
                规定请求的类型（GET 或 POST）。
            </td>
        </tr>
        <tr>
            <td>
                url
            </td>
            <td>
                规定发送请求的 URL。默认是当前页面。
                <br>
            </td>
        </tr>
        <tr>
            <td>
                username
            </td>
            <td>
                规定在 HTTP 访问认证请求中使用的用户名。
            </td>
        </tr>
        <tr>
            <td>
                xhr
            </td>
            <td>
                用于创建 XMLHttpRequest 对象的函数。
            </td>
        </tr>
</table>
