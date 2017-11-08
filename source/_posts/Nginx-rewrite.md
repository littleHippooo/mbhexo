---
title: Nginx Rewrite
date: 2017-10-22 09:26:54
tags: Nginx
---
Nginx服务器提供了Rewrite功能，用于实现URL的重写。该功能由ngx_http_rewrite_module模块提供，该模块默认开启。Nginx服务器的Rewrite功能依赖于PCRE(Perl Compatible Regular Expressions，Perl兼容的正则表达式)，所以在编译安装Nginx的时候需要先安装PCRE库。

Rewrite功能就是，使用Nginx提供的全局变量或自己设置的变量，结合正则表达式和标志位实现url重写以及重定向。Rewrite只能对域名后边的除去传递的参数外的字符串起作用，例如[https://mrbird.cc/page/2/search?type=1&value=nginx](https://mrbird.cc/page/2/search?type=1&value=nginx)只对[/page/2/search](/page/2/search)重写。

<!--more-->
## if指令
用于根据不同条件选择不同的Nginx配置，可在server和location块中配置。语法如下：
```nginx
if (condition) { }
```
condition为判断条件（true/false）：

- 变量名。如果变量的值为空字符串或者以0开头的任意字符串，为false。其余为true；

- 比较变量的内容时候，使用`=`或`!=`；

- 使用正则表达式。`~`（大小写敏感），`~*`（大小写不敏感），`!~`和`!~*`。正则表达式一般不加双引号，除非包含`}`或者分号`;`字符；

- `-f`和`!-f`用来判断是否存在文件；

- `-d`和`!-d`用来判断是否存在目录；

- `-e`和`!-e`用来判断是否存在文件或目录；

- `-x`和`!-x`用来判断文件是否可执行。

几个实例：
```stata
if ($request_method = POST) {
    return 405; # 如果请求方法为POST，则直接返回405HTTP状态码。
}
if ($slow) {
    limit_rate 10k;
}
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$ /msie/$1 break; # 如果UA包含"MSIE"，rewrite请求到/msid/目录下
}
if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
    set $id $1; # 如果cookie匹配正则，设置变量$id等于正则引用部分
}
if (!-f $request_filename){
   # 判断请求的文件是否不存在
} 
```
## break指令
该指令用于中断当前相同作用域的Nginx配置。Nginx遇到该指令时，回到上一层作用域继续向下读取配置。该指令可在server，location和if块中使用。语法如下：
```nginx
break;
```
比如：
```stata
location / {
   if ($slow) {
      set $id $1;  
      break;   # 跳出if作用域
      limit_rate 10k; # 无效
   }
   ... # 继续读取
}
```
## return指令
该指令用于完成对请求的处理，直接向客户端返回响应状态码，处于该指令后的所有Nginx配置都是无效的。语法结构如下：
```nginx
return [text];
return code URL;
return URL;
```
比如：
```nginx
location = /404 {
   return 404 "sorry page not found!\n"
}
```
## rewrite指令
该指令通过正则表达式来改变URL，可以同时存在一个或多个指令，按照顺序依次对URL进行匹配处理。该指令可在server，location和if块中配置，语法如下：
```nginx
rewrite regex replacement [flag];
```
1. `regex`用于匹配URL的正则表达式，使用`()`标记要截取的内容。

2. `replacement`匹配成功后用于替换URL中被截取的部分。默认情况下，如果replacement是由`http://`或者`https://`开头的字符串，则直接将重写后的URL返回客户端。

3. `flag`标志位，其值有如下几种：
 - **last**，Nginx遇到含有该标志位的rewrite命令时，停止向下处理，直接使用该rewrite返回的新的URL去和所有的location块重新匹配。

 - **break**，将此处重写的URL作为一个新的URL，在本块中继续进行处理。该标志重写后的URL在当前location块中执行，不会转向到其他的location块。

 - **redirect**将重写后的URL返回给客户端，状态码为302，表示临时重定向URL。

 - **permanent**将重写后的URL返回给客户端，状态码为301，表示永久重定向URL。

举些例子：
```nginx
location / {
   rewrite ^(/myweb/.*)/media/(.*)\..*$ $1/mp3/$2.mp3 last;
   rewrite ^(/myweb/.*)/audio/(.*)\..*$ $1/mp4/$2.ra last;	
}
```
如果某个请求URL在第2行被匹配成功，Nginx不会继续使用第3行配置处理新的URL，而是让所有的location重新匹配新的URL。
```nginx
location /myweb/ {
   rewrite ^(/myweb/.*)/media/(.*)\..*$ $1/mp3/$2.mp3 break;
   rewrite ^(/myweb/.*)/audio/(.*)\..*$ $1/mp4/$2.ra break;	
}
```
如果某个请求URL在第2行被匹配成功，Nginx服务器将新的URL继续使用本块中的第3行配置进行处理，不会将新的URL发送到其他location块。

{% note danger %}如果这里将**break**替换为**last**的话，新的URL包含/myweb/串，本location块可能继续捕获到该新的URL，这样便造成了死循环。Nginx在尝试10次循环之后，返回500 Internal Server Error错误。{% endnote %}

## rewrite_log指令
该指令配置是否开启重写URL日志的输出功能，语法如下：
```nginx
rewrite_log on | off
```
默认值为off。日志将以notice级别输出到`error_log`配置的日志文件中。
## set指令
该指令用于设置一个新的变量，语法如下：
```nginx
set variable value
```
变量名称必须以$开头，且不能和Nginx服务器预设的全局变量同名，变量的作用域为全局。
## uninitialized_variable_warn指令
该指令用于配置实用未初始化的变量时，是否记录警告日志，语法如下：
```nginx
uninitialized_variable_warn on | off
```
默认值为on。
## rewrite常用全局变量
下表列出了在rewrite配置过程中可能会使用到的Nginx全局变量：
<table>
	<tr>
		<th style="width: 170px">变量</th>
		<th>说明</th>
	</tr>
	<tr>
		<td>$args</td>
		<td>请求URL中的请求参数串，如arg1=value1&arg2=value2</td>
	</tr>
	<tr>
		<td>$content_length</td>
		<td>请求头中的Content-length字段</td>
	</tr>
	<tr>
		<td>$content_type</td>
		<td>请求头重的Content-type片段</td>
	</tr>
	<tr>
		<td>$document_root</td>
		<td>当前请求的根路径</td>
	</tr>
	<tr>
		<td>$document_uri</td>
		<td>当前请求的URI，比如[https://mrbird.cc/page/2/search?type=1&value=nginx](https://mrbird.cc/page/2/search?type=1&value=nginx)中的[/page/2/search](/page/2/search)</td>
	</tr>
	<tr>
		<td>$host</td>
		<td>当前URL的主机部分字段，比如[https://mrbird.cc/page/2/search?type=1&value=nginx](https://mrbird.cc/page/2/search?type=1&value=nginx)中的[mrbird.cc](mrbird.cc)。如果为空，则为server块中server_name指令的配置值</td>
	</tr>
	<tr>
		<td>$http_user_agent</td>
		<td>客户端的代理信息</td>
	</tr>
	<tr>
		<td>$http_cookie</td>
		<td>客户端的cookie信息</td>
	</tr>
	<tr>
		<td>$limit_rate</td>
		<td>Nginx服务器对网络连接速率的限制，即Nginx配置中的limit_rate指令的配置值</td>
	</tr>
	<tr>
		<td>$remote_addr</td>
		<td>客户端的IP地址</td>
	</tr>
	<tr>
		<td>$remote_port</td>
		<td>客户端的端口号</td>
	</tr>
	<tr>
		<td>$request_body_file</td>
		<td>发给后端服务器的本地文件资源名称</td>
	</tr>
	<tr>
		<td>$request_method</td>
		<td>客户端的请求方式，如get，post等</td>
	</tr>
	<tr>
		<td>$request_filename</td>
		<td>当前请求的文件路径，由root或alias指令与URI请求生成。</td>
	</tr>
	<tr>
		<td>$request_uri</td>
		<td>包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”</td>
	</tr>
	<tr>
		<td>$query_string</td>
		<td>和$args相同</td>
	</tr>
	<tr>
		<td>$scheme</td>
		<td>HTTP方法（如http，https，ftp）</td>
	</tr>
	<tr>
		<td>$server_protocol</td>
		<td>请求使用的协议，通常是HTTP/1.0或HTTP/1.1</td>
	</tr>
	<tr>
		<td>$server_addr</td>
		<td>服务器的地址</td>
	</tr>
	<tr>
		<td>$server_name</td>
		<td>服务器名称</td>
	</tr>
	<tr>
		<td>$server_port</td>
		<td>请求到达服务器的端口号</td>
	</tr>
	<tr>
		<td>$uri</td>
		<td>同$document_uri</td>
	</tr>
</table>

## rewrite实例
### 域名跳转
```nginx
server {
   listen 80;
   server_name jump.myweb.name;
   rewrite ^/ http://www.myweb.info/;
   ...
}
```
比如客户端访问[http://jump.myweb.name](http://jump.myweb.name)时，URL将被重写为[http://jump.myweb.info](http://jump.myweb.info)。
```nginx
server {
   listen 80;
   server_name jump.myweb.name jump.myweb.info
   if ($host ~ myweb\.info) {
      rewrite ^(.*) http://jump.myweb.name$1 permanent;
   }
   ...
}
```
当客户端访问[http://jump.myweb.info/reqsource](http://jump.myweb.info/reqsource)时，URL将被重写为[http://jump.myweb.name/reqsource](http://jump.myweb.name/reqsource)。
