---
title: Nginx的基本配置
date: 2017-10-18 10:18:08
tags: Nginx
---
Nginx配置文件主要分成四部分：main（全局设置）、http（HTTP的通用设置）、server（虚拟主机设置）、location（匹配URL路径）。还有一些其他的配置段，如event，upstream等。

一个完整的Nginx配置如下：

<!--more-->
```
user       www www;  ## Default: nobody
worker_processes  5;  ## Default: 1
error_log  logs/error.log;
pid        logs/nginx.pid;
worker_rlimit_nofile 8192;

events {
  worker_connections  4096;  ## Default: 1024
  multi_accept on;
  use epoll;
}

http {
  include    conf/mime.types;
  include    /etc/nginx/proxy.conf;
  include    /etc/nginx/fastcgi.conf;
  index    index.html index.htm index.php;

  default_type application/octet-stream;

  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
                    '"$request" $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

  access_log   logs/access.log  main;
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  server { # php/fastcgi
    listen       80;
    server_name  domain1.com www.domain1.com;
    access_log   logs/domain1.access.log  main;
    root         html;

    location ~ \.php$ {
      fastcgi_pass   127.0.0.1:1025;
    }
  }

  server { # simple reverse-proxy
    listen       80;
    server_name  domain2.com www.domain2.com;
    access_log   logs/domain2.access.log  main;

    # serve static files
    location ~ ^/(images|javascript|js|css|flash|media|static)/  {
      root    /var/www/virtual/big.server.com/htdocs;
      expires 30d;
    }

    # pass requests for dynamic content to rails/turbogears/zope, et al
    location / {
      proxy_pass      http://127.0.0.1:8080;
    }
  }

  upstream big_server_com {
    server 127.0.0.3:8000 weight=5;
    server 127.0.0.3:8001 weight=5;
    server 192.168.0.1:8000;
    server 192.168.0.1:8001;
  }

  server { # simple load balancing
    listen          80;
    server_name     big.server.com;
    access_log      logs/big.server.access.log main;

    location / {
      proxy_pass      http://big_server_com;
    }
  }
}
```
## Nginx基础配置指令
### user
用于指定运行Nginx的用户和组：
```bash
user user [group]
```
只有被设置的用户或者用户组成员才有权限启动Nginx服务。如果希望所有用户都可以启动Nginx，则只需将其注释掉或者指定为：
```bash
user nobody nobody
```
### worker_processes
指定Nginx的工作进程的个数，可以设置为与 CPU 数量相同，基本语法：
```bash
worker_processes number|auto
```
设置为auto时，Nginx进程将自动检测。当worker_processes设置为1时：
```bash
# sbin/nginx 
# ps -ef|grep nginx
root      5882  1326  0 13:07 ?        00:00:00 nginx: master process sbin/nginx
nobody    5883  5882  0 13:07 ?        00:00:00 nginx: worker process
root      5885  5430  0 13:07 pts/1    00:00:00 grep --color=auto nginx
```
将worker_processes设置为3时：
```bash
# ps -ef|grep nginx
root      5919  1326  0 13:09 ?        00:00:00 nginx: master process sbin/nginx
nobody    5920  5919  0 13:09 ?        00:00:00 nginx: worker process
nobody    5921  5919  0 13:09 ?        00:00:00 nginx: worker process
nobody    5922  5919  0 13:09 ?        00:00:00 nginx: worker process
root      5924  5430  0 13:09 pts/1    00:00:00 grep --color=auto nginx
```
worker_processes进程数变成了3个。
### error_log
用于配置错误日志的存放路径。http，server和location块也可配置error_log，区别在于级别不一样。基本语法：
```bash
error_log files|stderr [ debug | info | notice | warn | error | crit | alert | emerg ]
```
debug级别最高，emerg级别最低。比如设置级别为warn后，warn，error，crit，alert和emerg级别的日志都会被记录。Nginx默认日志存放路径为：`logs/error.log`。
### pid
pid指令用于指定存放Nginx主进程号存放文件的路径。默认的路径为：
```bash
# ./sbin/nginx 
# cat logs/nginx.pid 
101106
```
### worker_rlimit_nofile
设置毎个进程的最大文件打开数。如果不设的话上限就是系统的ulimit –n的数字（1024）。
### worker_connections
设定一个worker进程的最大连接数。默认为512，按自己系统的硬件配置调整，不能超过worker_rlimit_nofile。
### include
include指令用于引入第三方配置文件，比如常见的MIME类型等。
### accept_mutex
该条指令目的是为了解决“惊群”的问题。“惊群”大致意思是：当某个时刻只有一个网络连接时，多个进程会被同时唤醒，但最终实际上只有一个进程可以获得连接，由于唤醒了别的不必要的进程，造成了性能的浪费。

accept_mutex语法如下：
```bash
accept_mutex on | off
```
默认为开启（on）状态，只能在events块中进行设置。
### multi_accept
用于设置是否允许worker_process同时接受多个网络连接。语法如下：
```bash
multi_accept on | off
```
其默认为关闭（off）状态，也就是说每个worker_process一次只能接收一个新到达的网络连接。

该指令只能在events模块中设置。
### use
use指令用于选择事件的驱动模型。语法如下：
```bash
use method
```
Nginx提供了多种事件驱动模型来处理网络消息，method可选的内容有：select，poll，kqueue，epoll，rtsig，/dev/poll和eventport。

该指令只能在events模块中设置。
### worker_connentions
用于设置每个worker_process最大的连接数。语法如下：
```bash
worker_process number
```
该指令只能在events模块中设置。
### 指定MIME
在配置文件中，可以看到如下两条配置：
```bash
include    conf/mime.types;
default_type application/octet-stream;
```
include指令引入了mime.types文件，其中mime.types内容如下：
```xml
types {
    text/html                             html htm shtml;
    text/css                              css;
    text/xml                              xml;
    image/gif                             gif;
    image/jpeg                            jpeg jpg;
    application/javascript                js;
    application/atom+xml                  atom;
    application/rss+xml                   rss;

    text/mathml                           mml;
    text/plain                            txt;
    text/vnd.sun.j2me.app-descriptor      jad;
    text/vnd.wap.wml                      wml;
    text/x-component                      htc;
    ...

    video/3gpp                            3gpp 3gp;
    video/mp2t                            ts;
    video/mp4                             mp4;
    video/mpeg                            mpeg mpg;
    video/quicktime                       mov;
    video/webm                            webm;
    video/x-flv                           flv;
    video/x-m4v                           m4v;
    video/x-mng                           mng;
    video/x-ms-asf                        asx asf;
    video/x-ms-wmv                        wmv;
    video/x-msvideo                       avi;
}

```
`default_type application/octet-stream`指定了默认类型为二进制流。如果不指定的话，默认值为text/plain。

该指令可以在http，server或location模块中设置。
### 自定义服务日志
error_log用于记录Nginx运行时的常规日志，而access_log（服务日志）是指Nginx服务器在响应各种前端请求的日志。包含两个指令：access_log和log_format。

access_log的语法如下：
```bash
access_log ptah[format[buffer=size]]
```
`path`用于指定该日志的存放路径，`format`为可选项，代指自定义服务日志的格式字符串。`size`为可选项，用于配置临时存放日志的内存缓存区大小。

log_format的语法如下：
```bash
log_format name string ...
```
`name`用于为该格式定义一个变量名，供access_log指令使用。`string`为格式字符串，比如：`$remote_addr - $remote_user [$time_local]  $status`其中`$remote_addr`等为Nginx预设的一些变量，常用的变量有：

<table>

<tr>
<td><strong>参数</strong></td>
<td><strong>说明</strong></td>
<td><strong>示例</strong></td>

</tr>
<tr>
<td width="192" height="29">$remote_addr</td>
<td width="246">客户端地址</td>
<td width="289">211.28.65.253</td>

</tr>
<tr>
<td width="192" height="29">$remote_user</td>
<td width="246">客户端用户名称</td>
<td width="289">--</td>

</tr>
<tr>
<td width="192" height="29"><span lang="EN-US">$time_local</span></td>
<td width="246">访问时间和时区</td>
<td width="289">18/Jul/2012:17:00:01 +0800</td>

</tr>
<tr>
<td width="192" height="29">$request</td>
<td width="246">请求的URI和HTTP协议</td>
<td width="289">"GET /article-10000.html HTTP/1.1"</td>

</tr>
<tr>
<td width="192" height="50">$http_host</td>
<td width="246">请求地址，即浏览器中你输入的地址（IP或域名）</td>
<td  width="289">www.it300.com<br>192.168.100.100</td>

</tr>
<tr>
<td width="192" height="29">$status</td>
<td width="246">HTTP请求状态</td>
<td width="289">200</td>

</tr>
<tr>
<td width="192" height="29">$upstream_status</td>
<td width="246">upstream状态</td>
<td width="289">200</td>

</tr>
<tr>
<td width="192" height="29">$body_bytes_sent</td>
<td width="246">发送给客户端文件内容大小</td>
<td width="289">1547</td>

</tr>
<tr>
<td width="192" height="29"><span lang="EN-US">$http_referer</span></td>
<td width="246">url跳转来源</td>
<td width="289">https://www.baidu.com/</td>

</tr>
<tr>
<td width="192" height="62">$http_user_agent</td>
<td width="246">用户终端浏览器等信息</td>
<td width="289">"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SV1; GTB7.0; .NET4.0C;</td>

</tr>
<tr>
<td width="192" height="29"><span lang="EN-US">$ssl_protocol</span></td>
<td width="246">SSL协议版本</td>
<td width="289">TLSv1</td>

</tr>
<tr>
<td width="192" height="29">$ssl_cipher</td>
<td width="246">交换数据中的算法</td>
<td width="289">RC4-SHA</td>

</tr>
<tr>
<td width="192" height="48">$upstream_addr</td>
<td width="246">后台upstream的地址，即真正提供服务的主机地址</td>
<td width="289">10.10.10.100:80</td>

</tr>
<tr>
<td width="192" height="29">$request_time</td>
<td width="246">整个请求的总时间</td>
<td width="289">0.205</td>

</tr>
<tr>
<td width="192" height="29">$upstream_response_time</td>
<td width="246">请求过程中，upstream响应时间</td>
<td width="289">0.002</td>

</tr>


</table>

该指令只能在http模块中设置。
### sendfile & sendfile_max_chunk
sendfile用于开启或关闭使用sendfile()传输文件。语法如下：
```bash
sendfile on | off
```
可以在http，server或location中进行配置。

sendfile_max_chunk用于设置Nginx进程中的每个worker_process每次调用sendfile()传输的数据量的最大值。默认值为0，表示没有限制。比如：
```bash
sendfile_max_chunk 128k
```
该指令可以在http，server或location块中配置。
### keepalive_timeout
用于设置Nginx服务器与用户建立会话连接保持的时间，语法如下：
```bash
keepalive_timeout timeout[header_timeout]
```
`timeout`用于设置服务器端保持连接的时间；`header_timeout`为可选项，用于配置应答报文头部的Keep-Alive域的值。

该指令可以在http，server和location块中配置。
### keepalive_requests
用于限制用户通过某一连接向服务器发送请求的次数，语法如下：
```bash
keepalive_requests number
```
默认值为100，可以在http，server和location块中配置。
### listen
该指令用于配置监听。配置方法主要有三种：

1、配置监听的IP地址：
```bash
listen address[:port] [default_server] [setfib=number] [backlog=number] [rcvbuf=size] [sndbuf=size] [deferred] [accept_filter=filter] [bind] [ssl]
```
2、配置监听端口
```bash
listen port [default_server] [setfib=number] [backlog=number] [rcvbuf=size] [sndbuf=size] [deferred] [accept_filter=filter] [bind] [ipv6only=on|off] [ssl]
```
3、配置UNIX Domain Socket
```bash
listen unix:path [default_server] [setfib=number] [backlog=number] [rcvbuf=size] [sndbuf=size] [deferred] [accept_filter=filter] [bind] [ssl]
```
- `address`，IP地址，如果是IPv6的地址，需使用[]，比如[fe80
::1]。

- `port`，端口号。

- `path`，socket文件路径，如/var/run/nginx.sock等。

- `default_server`，标识符，表示设置为默认主机。

- `rcvbuf=size`，设置监听socket接收缓存区大小。

- `sndbuf=size`，设置监听socket发送缓存区大小。

- `deferred`，标识符，将accept()设置为Deferred模式。

- `accept_filter=filter`，设置监听端口对请求的过滤
，被过滤的内容不能被接收和处理。

- `ssl`，标识符，设置会话连接使用SSL模式进行。

一些例子：
```bash
listen *:80 | *:8080;  #监听所有80端口和8080端口
listen 192.168.1.10:8080; 　#监听具体IP和具体端口上的连接
listen 8000;  #监听所有IP地址的8000端口，等同于 listen *:8000
listen 192.168.1.10 default_server;  #设置192.168.1.10的连接请求默认由此虚拟主机处理
```
### server_name
Nginx配置文件中的每个server块对于一个虚拟主机配置，server_name用于指定虚拟主机的名称，用户可通过这个名称来向此虚拟主机发送请求。server_name的配置分为名称和IP两种方式。

**基于名称的虚拟主机配置**

基于名称的虚拟主机配置时，server_name的语法如下：
```bash
server_name name ...
```
name可以有一个或多个名称并列，用空格隔开。每个名称对应一个域名，由两段或者三段组成，之间由`.`隔开。比如：
```bash
server_name www.mrbird.cc mrbird.cc;
```
1、在name中可以使用通配符`*`，通配符可用在三段式域名的头或尾，或两段式域名的尾部，比如：
```bash
server_name *.mrbird.cc mrbird.*;
```
2、在name中还可以使用正则表达式。使用`~`作为正则表达式开始的标记，比如：
```bash
server_name ~^www\d+\.mrbird\.cc$;
```
此时比如通过`www1.mrbird.cc`可以访问Nginx服务，而`www.mrbird.cc`不可以。

name中的正则表达式支持字符串捕获功能，字符串捕获通过`( )`来拾取后面不紧跟其他的正则表达式的字符。一个正则表达式中可以存在多个不嵌套的小括号，这些内容会从左到右依次存放在变量`$1`、`$2`、`$3`......中。下文使用时就可直接使用这些变量，作用域为当前的server块。

比如有如下的server_name配置：
```bash
server_name ~^www\.(.+)\.cc$;
```
当通过`www.mrbird.cc`访问Nginx服务器时，将会被上面的正则表达式匹配成功，mrbird将会被捕获，并且赋值给$1。

由于有两种匹配的方式，所以有可能出现两种情况都匹配的时候，这时候Nginx按照以下的优先级进行选择：

1. 准确匹配server_name。

2. 通配符在开始时匹配server_name成功。

3. 通配符在结束时匹配server_name成功。

4. 正则表达式匹配server_name成功。

此外，如果server_name被处于同一优先级的匹配方式多次匹配成功，则以首先匹配成功的为主。

**基于IP的虚拟主机配置**

Linux操作系统支持IP别名的添加，配置基于IP的虚拟主机，即为Nginx服务器提供的每台虚拟主机配置一个不同的IP。

查看当前网络配置：
```bash
# ifconfig
ens33     Link encap:Ethernet  HWaddr 00:0c:29:25:f3:bb  
          inet addr:192.168.112.128  Bcast:192.168.112.255  Mask:255.255.255.0
          inet6 addr: fe80::4fe4:f0e0:9e9b:7ec/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:360100 errors:0 dropped:0 overruns:0 frame:0
          TX packets:89081 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:504446360 (504.4 MB)  TX bytes:7347923 (7.3 MB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:35127 errors:0 dropped:0 overruns:0 frame:0
          TX packets:35127 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:2931450 (2.9 MB)  TX by
```
ens33为正在使用的网卡，IP为`192.168.112.128`，给其添加两个IP别名`192.168.112.130`和`192.168.112.131`：
```bash
# ifconfig ens33:0 192.168.112.130 Mask 255.255.255.0 up 
# ifconfig ens33:1 192.168.112.131 Mask 255.255.255.0 up 
# ifconfig
ens33     Link encap:Ethernet  HWaddr 00:0c:29:25:f3:bb  
          inet addr:192.168.112.128  Bcast:192.168.112.255  Mask:255.255.255.0
          inet6 addr: fe80::4fe4:f0e0:9e9b:7ec/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:360100 errors:0 dropped:0 overruns:0 frame:0
          TX packets:89081 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:504446360 (504.4 MB)  TX bytes:7347923 (7.3 MB)

ens33:0   Link encap:Ethernet  HWaddr 00:0c:29:25:f3:bb  
          inet addr:192.168.112.130  Bcast:192.168.112.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

ens33:1   Link encap:Ethernet  HWaddr 00:0c:29:25:f3:bb  
          inet addr:192.168.112.131  Bcast:192.168.112.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:221 errors:0 dropped:0 overruns:0 frame:0
          TX packets:221 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:16787 (16.7 KB)  TX bytes:16787 (16.7 KB)
```
关于给网卡添加多个IP别名可以参考[http://www.cnblogs.com/biaopei/p/7730517.html](http://www.cnblogs.com/biaopei/p/7730517.html)

这时候就可以在Nginx配置文件中配置两台基于IP配置的虚拟主机了：
```bash
...
  http {
  	...
  	server {
  		listen: 80;
  		server_name: 192.168.112.130;
  		...
  	}
  	server {
  		listen: 80;
  		server_name: 192.168.112.131;
  	}
  }
```
### location块
location语法如下：
```bash
location [ = | ~ | ~* | ^~ ] uri { ... }
```
uri是待匹配的请求字符串，可以是标准uri（不含正则表达式）和正则uri。

- `=`用于标准uri前，要求请求字符串与uri严格匹配，如果成功，则停止搜索并立即处理此请求。

- `~`用于表示uri含正则表达式，区分大小写。

- `~*`用于表示uri包含正则表达式，不区分大小写。

- `^~`用于标准uri前，要求Nginx服务器找到和请求字符串匹配度最高的标准uri对应的location后，立即用此location处理请求，而不再使用location块中的正则uri和

### root
root用于配置根目录，比如有如下location配置：
```bash
location /data/ {
   root /locationtest1;
}
```
当location块接收到`/data/index.html`的请求后，将在`/locationtest1/data/`目录下找到index.html。

该指令可在http，server或location块中配置。
### alias
alias用于改变location接收到的URI请求路径。比如：
```bash
location ~ ^/data/(.+\.html)$ {
   alias /locationtest1/other/$1;
}
```
当location块接收到`/data/index.html`的请求后，通过alias，Nginx到`/locationtest1/other/`目录下搜寻index.html。相当于请求从`/data/index.html`更改为了`/locationtest1/other/index.html`。

### index
index用于设置网站的默认首页。比如：
```bash
location ~ ^/data/(.+)/web/ $ {
   index index.$1.html index.html myindex.html
}
```
当请求为/data/locationtest1/web/时，Nginx依次搜寻index.locationtest1.html、index.html和myindex.html页面，先找到哪个就用哪个。
### error_page
该指令用于设置网站的错误页面。语法如下：
```bash
error_page code ... [=[response]] uri
```
- `code`，要处理的HTTP错误码。

- `response`，可选项，将code指定的错误码转化为新的错误代码response。

- `uri`，错误页面的路径或者网站地址。

比如：
```bash
error_page 404 /404.html;
```
Nginx使用`Nginx安装目录/html/404.html`页面响应404错误。
```bash
error_page 403 http://somewebsite.com/forbidden.html;
```
Nginx使用`http://somewebsite.com/forbidden.html`页面响应403错误。
```bash
error_page 410 =301 /empty.gif;
```
Nginx服务器产生410的HTTP消息时，使用`Nginx安装目录/html/empty.gif`返回给用户，HTTP的状态码为301。

加入想要改变`Nginx安装目录/html/`这个默认的路径，可以添加一个locaiton块：
```bash
location /404.html {
   root /myserver/errorpages/;
}
```
该指令可在http，server和location块中配置。
### 基于IP配置Nginx访问权限
allow指令用于配置允许访问Nginx的客户端IP，语法如下：
```bash
allow address | CIDR | all
```
- `address`，指定允许访问的IP，不支持多个值，如需要有多个IP设置，需要重复使用allow命令。

- `CIDR`，允许访问的客户端的CIDR地址。

- `all`，代表允许所有的客户端访问。

deny指令用于配置禁止访问Nginx的客户端IP，语法如下：
```bash
deny address | CIDR | all
```
这两个指令可在http，server和location块中配置。
### 配置Nginx密码
auth_basic指令用于开启或者关闭认证功能，语法如下：
```bash
auth_basic string | off
```
- `stirng`，开启认证功能，并配置了验证时的信息。

- `off`，关闭认证。

auth_basic_user_file指令指定了包含用户名和密码的信息文件路径，语法结构为：
```bash
auth_basic_user_file file
```
如，在nignx.conf里配置如下：

![mrbird_photo_20171101112512](img/mrbird_pohto_20171101114239.png)

生产htpasswd文件：
```bash
# printf "mrbird:$(openssl passwd -crypt 123456)\n" >>conf/htpasswd
# cat conf/htpasswd
mrbird:vdV.OwMSzfJrQ
```
重启Nginx后，访问[http://localhost/index.html](http://localhost/index.html)，页面显示如下：

![mrbird_photo_20171101112838](img/mrbird_photo_20171101112838.png)

## 配置实例
将conf/nginx.conf配置成如下：
```bash
worker_processes  1;

error_log  logs/error.log;
events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
    
    sendfile        on;
    keepalive_timeout  65;
    # 配置server1
    server {
        listen       8081;
        server_name  localhost;
        
        charset utf-8;
        
        access_log  /myweb/server1/log/access.log  main;
        
        error_page  404 /myweb/error/404.html;
        # 配置/server1/location1/请求的location
        location /server1/location1 {
            root   /myweb;
            index  index.html;
        }
        # 配置/server1/location2请求的location
        location /server1/location2 {
            root   /myweb;
            index  index.html;
        }
    
    }
    # 配置server2
    server {
        listen       8082;
        server_name  192.168.112.130;
        
        charset utf-8;
        
        access_log  /myweb/server2/log/access.log  main;
        
        error_page  404 /404.html;
        # 配置/server2/location1/请求的locaiton
        location /server2/location1 {
            root   /myweb;
            index  index.html;
        }
        # 配置/server2/location2/请求的location
        location /svr2/loc2 {
            alias   /myweb/server2/location2; # 对location的uri进行更改
            index  index.html;
        }
        # 重定向404页面地址
        location = /404.html {
            root /myweb/error;
            index 404.html;
        }
    }
}

```
构建一个静态网站，目录结构如下：
```bash
/myweb/
├── error
│   └── 404.html
├── server1
│   ├── location1
│   │   └── index.html
│   ├── location2
│   │   └── index.html
│   └── log
│       └── access.log
└── server2
    ├── location1
    │   └── index.html
    ├── location2
    │   └── index.html
    └── log
        └── access.log
```
启动Nginx服务：
```bash
# /nginx/sbin/nginx -t
nginx: the configuration file /nginx/conf/nginx.conf syntax is ok
nginx: configuration file /nginx/conf/nginx.conf test is successful
# /nginx/sbin/nginx
```
访问[http://localhost:8081/server1/location1/](http://localhost:8081/server1/location1/)：

![mrbird_photo_20171101151244.png](img/mrbird_photo_20171101151244.png)

访问[http://localhost:8081/server1/location2/](http://localhost:8081/server1/location2/)：

![QQ截图20171101151332.png](img/QQ截图20171101151332.png)

访问[http://192.168.112.130:8082/server2/location1/](http://192.168.112.130:8082/server2/location1/)：

![QQ截图20171101151521.png](img/QQ截图20171101151521.png)

访问[http://192.168.112.130:8082/svr2/loc2/](http://192.168.112.130:8082/svr2/loc2/)：

![QQ截图20171101151607.png](img/QQ截图20171101151607.png)

访问[http://192.168.112.130:8082/svr2/loc3/](http://192.168.112.130:8082/svr2/loc3/)：

![QQ截图20171101151711.png](img/QQ截图20171101151711.png)

结果证明，上述配置正确。








