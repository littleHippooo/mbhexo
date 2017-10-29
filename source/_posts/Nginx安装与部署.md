---
title: Nginx安装与部署
date: 2017-10-15 09:51:45
tags: Nginx
---
## 下载Nginx
Nginx官网：[http://nginx.org/en/download.html](http://nginx.org/en/download.html)。网页提供了Nginx三种版本下载：开发版（Mainline Version）、稳定版（Stable Version）和过期版（Legacy Version）。Nignx提供Linux和Windows版本，这里使用的是Linux版本。此外，[http://nginx.org/download/](http://nginx.org/download/)提供了所有版本的Nginx下载。

Nginx源码的编译需要GCC编译器：
```bash
# gcc --version
gcc (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
<!--more-->
截止2017年10月15日，Nginx最新稳定版为1.12.2，下载并解压：
```bash
# mkdir nginx-download
# cd nginx-download/
# wget http://nginx.org/download/nginx-1.12.2.tar.gz
# tar -zxvf nginx-1.12.2.tar.gz 
# cd nginx-1.12.2
# ll
total 732
drwxr-xr-x 8 1001 1001   4096 Oct 17 21:16 ./
drwxr-xr-x 3 root root   4096 Oct 26 14:05 ../
-rw-r--r-- 1 1001 1001 278202 Oct 17 21:16 CHANGES
-rw-r--r-- 1 1001 1001 423948 Oct 17 21:16 CHANGES.ru
-rw-r--r-- 1 1001 1001   1397 Oct 17 21:16 LICENSE
-rw-r--r-- 1 1001 1001     49 Oct 17 21:16 README
drwxr-xr-x 6 1001 1001   4096 Oct 26 14:05 auto/
drwxr-xr-x 2 1001 1001   4096 Oct 26 14:05 conf/
-rwxr-xr-x 1 1001 1001   2481 Oct 17 21:16 configure*
drwxr-xr-x 4 1001 1001   4096 Oct 26 14:05 contrib/
drwxr-xr-x 2 1001 1001   4096 Oct 26 14:05 html/
drwxr-xr-x 2 1001 1001   4096 Oct 26 14:05 man/
drwxr-xr-x 9 1001 1001   4096 Oct 26 14:05 src/
```
- **src**目录下存放了Nginx的源代码；
- **man**目录下存放了Nginx的帮助文档；
- **html**目录存放了两个HTML文件，分别为Nginx欢迎页和异常页面；
- **logs**目录用于存放Nginx运行日志；
- **auto**目录存放了大量的脚本文件，和configure脚本有关；
- **configure**文件为Nginx的自动脚本程序。

## Nginx编译与安装
在解压路径下，运行命令`./configure --prefix=/nginx`（`configure`脚本支持的选项可参考附录）配置Nginx的安装目录并生成Makefile文件：
```bash
# ./configure --prefix=/nginx
...
Configuration summary
  + using system PCRE library
  + OpenSSL library is not used
  + using system zlib library

  nginx path prefix: "/nginx"
  nginx binary file: "/nginx/sbin/nginx"
  nginx modules path: "/nginx/modules"
  nginx configuration prefix: "/nginx/conf"
  nginx configuration file: "/nginx/conf/nginx.conf"
  nginx pid file: "/nginx/logs/nginx.pid"
  nginx error log file: "/nginx/logs/error.log"
  nginx http access log file: "/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"

```
过程中可能出现一些依赖库缺失问题，可参考下面的常见问题。生成了Makefile文件后，使用`make`命令进行编译：
```bash
# make
make -f objs/Makefile
make[1]: Entering directory '/temp/nginx-download/nginx-1.12.2'
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/os/unix -I objs \
	-o objs/src/core/nginx.o \
	src/core/nginx.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/os/unix -I objs \
...
objs/src/http/modules/ngx_http_upstream_keepalive_module.o \
objs/src/http/modules/ngx_http_upstream_zone_module.o \
objs/ngx_modules.o \
-ldl -lpthread -lcrypt -lpcre -lz \
-Wl,-E
sed -e "s|%%PREFIX%%|/nginx|" \
	-e "s|%%PID_PATH%%|/nginx/logs/nginx.pid|" \
	-e "s|%%CONF_PATH%%|/nginx/conf/nginx.conf|" \
	-e "s|%%ERROR_LOG_PATH%%|/nginx/logs/error.log|" \
	< man/nginx.8 > objs/nginx.8
make[1]: Leaving directory '/temp/nginx-download/nginx-1.12.2'
```
编译顺利完成后，接着使用`make install`命令进行安装：
```bash
# make install
make -f objs/Makefile install
make[1]: Entering directory '/temp/nginx-download/nginx-1.12.2'
test -d '/nginx' || mkdir -p '/nginx'
test -d '/nginx/sbin' \
	|| mkdir -p '/nginx/sbin'
...
test -d '/nginx/logs' \
	|| mkdir -p '/nginx/logs'
make[1]: Leaving directory '/temp/nginx-download/nginx-1.12.2'
```
将目录切换到/nginx下，并查看：
```bash
# cd /nginx/
# ll
total 24
drwxr-xr-x  6 root root 4096 Oct 26 14:30 ./
drwxr-xr-x 26 root root 4096 Oct 26 14:30 ../
drwxr-xr-x  2 root root 4096 Oct 26 14:30 conf/
drwxr-xr-x  2 root root 4096 Oct 26 14:30 html/
drwxr-xr-x  2 root root 4096 Oct 26 14:30 logs/
drwxr-xr-x  2 root root 4096 Oct 26 14:30 sbin/
# ls *
conf:
fastcgi.conf            koi-win             scgi_params
fastcgi.conf.default    mime.types          scgi_params.default
fastcgi_params          mime.types.default  uwsgi_params
fastcgi_params.default  nginx.conf          uwsgi_params.default
koi-utf                 nginx.conf.default  win-utf

html:
50x.html  index.html

logs:

sbin:
nginx
```
## Nginx的启停
### Nginx常用命令
nginx命令所支持的选项有：
```bash
# ./sbin/nginx -h
nginx version: nginx/1.12.2
Usage: nginx [-?hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]

Options:
  -?,-h         : this help
  -v            : show version and exit
  -V            : show version and configure options then exit
  -t            : test configuration and exit
  -T            : test configuration, dump it and exit
  -q            : suppress non-error messages during configuration testing
  -s signal     : send signal to a master process: stop, quit, reopen, reload
  -p prefix     : set prefix path (default: /nginx/)
  -c filename   : set configuration file (default: conf/nginx.conf)
  -g directives : set global directives out of configuration file
```
`-v`选项用来显示Nginx服务器的版本号，`-V`选项除了显示版本号，还显示其编译情况：
```bash
# ./sbin/nginx -v
nginx version: nginx/1.12.2
# ./sbin/nginx -V
nginx version: nginx/1.12.2
built by gcc 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) 
configure arguments: --prefix=/nginx
```
`-t`选项用于检查Nginx服务器配置文件是否有语法错误：
```bash
# ./sbin/nginx -t
nginx: the configuration file /nginx/conf/nginx.conf syntax is ok
nginx: configuration file /nginx/conf/nginx.conf test is successful
```
等。
### Nginx启动
启动Nginx服务器很简单，只需要运行sbin下的nginx脚本就行了：
```bash
# ./sbin/nginx 
# ps -ef|grep nginx
root      74808   1308  0 14:47 ?        00:00:00 nginx: master process ./sbin/nginx
nobody    74809  74808  0 14:47 ?        00:00:00 nginx: worker process
root      74811  71675  0 14:47 pts/4    00:00:00 grep --color=auto nginx
```
可看到Nginx已经启动，包含了一个主进程（master process）和一个工作进程（worker process），主进程号为74808。启动Nginx服务后，也可以通过查看logs目录下的nginx.pid来查看主进程号：
```bash
# cat logs/nginx.pid 
74808
```
Nginx的默认端口号为80，在浏览器中输入[localhost/index.html](localhost/index.html)查看是否启动成功：

![mrbird_photo_20171026150431.png](img/mrbird_photo_20171026150431.png)

### Nginx停止
停止Nginx服务可分为两种类型：

1.快速停止：立即停止当前Nginx服务正在处理的所有网络请求，马上丢弃连接，停止工作。相关命令为：`kill -TERM 进程号`或者`kill -INT 进程号`；

2.平缓停止：允许Nginx服务将当前的网络请求处理完毕，但不再接受新请求，之后关闭连接，停止工作。相关的命令为：`kill -QUIT 进程号`；

还有一种更为暴力的方法，即Linux下的强制停止进程命令：`kill -9 进程号`。

停止Nginx服务，采用快速停止方式：
```bash
# kill -TERM 74808
# ps -ef|grep nginx
root      74998  71675  0 15:03 pts/4    00:00:00 grep --color=auto nginx
```
### Nginx重启
Nginx重启采用平滑重启的方式。Nginx服务进程号接收到重启信号后，先读取新的Nginx配置文件，如果配置语法正确，则启动新的Nginx服务，然后平缓的关闭旧的服务。如果配置语法错误，则继续采用旧的Nginx进程提供服务。

有两种方式进行平滑重启：

1.检查配置文件是否正确，如果正确进行重启：
```bash
# ./sbin/nginx -t
nginx: the configuration file /nginx/conf/nginx.conf syntax is ok
nginx: configuration file /nginx/conf/nginx.conf test is successful
# ./sbin/nginx -s reload
```
2.`kill -HUP 主进程号`:
```bash
# cat logs/nginx.pid 
75011
# kill -HUP 75011
```
## 常见问题
### 缺少依赖库
**缺少PCRE依赖库**
{% note danger %}./configure: error: the HTTP rewrite module requires the PCRE library.
You can either disable the module by using --without-http_rewrite_module
option, or install the PCRE library into the system, or build the PCRE library
statically from the source with nginx by using --with-pcre=<path> option.
{% endnote %}
解决办法：
```bash
sudo apt-get install libpcre3 libpcre3-dev
```
**缺少zlib依赖库**
{% note danger %}./configure: error: the HTTP gzip module requires the zlib library.
You can either disable the module by using --without-http_gzip_module
option, or install the zlib library into the system, or build the zlib library
statically from the source with nginx by using --with-zlib=<path> option.
{% endnote %}
解决办法：
```bash
sudo apt-get install zlib1g-dev
```
### 其他问题
**apt-get命令被占用**
{% note danger %}E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?
{% endnote %}
解决办法：找到占用进程，然后kill：
```bash
ps -A|grep apt
 61213 ?        00:00:02 aptd
kill -9 61213
```
## 附录
*注：由于渲染原因--实际为 `--`，如--prefix=...实际为 `--prefix=...`*
### configure开关选项
<table> 
 <tbody> 
  <tr> 
   <td style="word-break: break-all;"><strong>选项&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong></td> 
   <td style="word-break: break-all;"><strong>用法&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong></td> 
   <td style="word-break: break-all;"><strong>默认值</strong></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;width:200px;">--prefix=...</td> 
   <td style="word-break: break-all;">指定安装Nginx的基础目录</td> 
   <td style="word-break: break-all;">/usr/local/nginx, 注意：如果你在配置时使用了相对路径，则连接到基础目录。示例：指定--conf-path=conf/nginx.conf 则配置文件会在目录：/usr/local/nginx/conf/nginx.conf</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--sbin-path=... </td> 
   <td style="word-break: break-all;">Nginx二进制文件安装的路径</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/sbin/nginx</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--conf-path=...</td> 
   <td style="word-break: break-all;">主要配置文件放置目录</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/conf/nginx.conf</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--error-log-path=...</td> 
   <td style="word-break: break-all;">错误日志存放的路径。错误日志在配置文件中须配置得非常正确，该路径只应用于你在配置文件中没有指定任何错误的日志指令时</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/logs/error.log</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--pid-path=...</td> 
   <td style="word-break: break-all;">指定Nginx的pid文件的路径。可以在配置文件中指定pid文件的路径，如果没有具体的指定，则使用在这里对该选项指定的该路径</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/logs/nginx.pid注意：该pid文件是一个简单的文件文件，它包含进程的标识符。该文件应该放置在一个清晰可见的位置，以便其他应用程序能够很容易找到运行该程序的pid</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--lock-path=...</td> 
   <td style="word-break: break-all;">锁文件（lock file）的存放路径。同样，该文件也可以在配置文件中指定，但是，如果在配置文件中没有指定，则使用该值</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/logs/nginx.lock注意：锁文件允许其他应用程序确定是否一个程序在运行，就Nginx来说，它用于确定该进程没有被启动两次</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-perl_modules_path=...</td> 
   <td style="word-break: break-all;">定义Perl模块的路径。如果需要包含另外的Perl模块，必须定义该参数</td> 
   <td></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-perl=...</td> 
   <td style="word-break: break-all;">Perl二进制文件的路径。用于执行Perl脚本。如果想执行一个Perl脚本，必须设置该路径</td> 
   <td></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--http-log-path=...</td> 
   <td style="word-break: break-all;">定义被访问文件的日志文件存放路径。该路径只用于在配置文件中没有定义访问日志的情况</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/logs/access.log</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--http-client-body-temp-path=...</td> 
   <td style="word-break: break-all;">该目录用于存储客户端请求产生的临时文件</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/client_body_temp</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--http-proxy-temp-path=...</td> 
   <td style="word-break: break-all;">该目录用于代理存储临时文件</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/proxy_temp</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--http-fastcgi-temp-path=...</td> 
   <td style="word-break: break-all;">指定用于HTTP FastCGI模块使用的临时文件的存放路径</td> 
   <td style="word-break: break-all;">&lt;prefix&gt;/fastcgi_temp</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--builddir=...</td> 
   <td style="word-break: break-all;">指定创建应用程序的位置</td> 
   <td></td> 
  </tr> 
 </tbody> 
</table>

### configure先決条件选项

<table> 
 <tbody> 
  <tr> 
   <td style="word-break: break-all;width:200px"><strong>编译选项</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-cc=...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td> 
   <td style="word-break: break-all;">指定一个备用的C编译器的位置</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-cpp=...</td> 
   <td style="word-break: break-all;">指定一个备用的C预处理器的位置</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-cc-opt=...</td> 
   <td style="word-break: break-all;">定义额外的选项，然后在命令行传递给C编译器</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-ld-opt=...</td> 
   <td style="word-break: break-all;">定义额外的选项，然后在命令行传递给C连接器</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-cpu-opt=...</td> 
   <td style="word-break: break-all;">指定不同的目标处理器结构，可以是下列值：pentium，pentiumpro，pentium3，pentium4，athlon，opteron，sparc32，sparc64和ppc64</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>PCRE选项</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-pcre</td> 
   <td style="word-break: break-all;">不使用PCRE库。这个设置不推荐使用，因为它会移除对正则表达式的支持，从而使Rewrite模块失去作用。</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-pcre</td> 
   <td style="word-break: break-all;">强制作用PCRE库</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-pcre=...</td> 
   <td style="word-break: break-all;">允许指定PCRE库的源代码</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-pcre-opt=...</td> 
   <td style="word-break: break-all;">用于建立PCRE库的另外的选项</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>MD5选项</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-md5=...</td> 
   <td style="word-break: break-all;">指定MD5库源代码的路径</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-md5-opt=...</td> 
   <td style="word-break: break-all;">用于建立MD5库的另外选项</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-md5-asm</td> 
   <td style="word-break: break-all;">为建MD5库使用汇编语言源代码</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>SHA1选项</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-sha1=...</td> 
   <td style="word-break: break-all;">指定SHA1库的源代码</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-sha1-opt=...</td> 
   <td style="word-break: break-all;">用于建立SHA1库的另外选项</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-sha1-asm</td> 
   <td style="word-break: break-all;">为建立SHA1库使用汇编语言源代码</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>zlib选项</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-zlib=...</td> 
   <td style="word-break: break-all;">指定zlib库的源代码</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-zlib-opt=...</td> 
   <td style="word-break: break-all;">用于建立zlib库的另外的选项</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-zlib-asm=...</td> 
   <td style="word-break: break-all;">使用汇编语言最大限度地优化下列目标结构：Pentium, pentiumpro</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>OpenSSL选项</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-openssl=...</td> 
   <td style="word-break: break-all;">指定OpenSSL库的源代码路径</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-openssl-opt=...</td> 
   <td style="word-break: break-all;">为建立OpenSSL库的另外的选项</td> 
  </tr> 
 </tbody> 
</table>

### configure模块选项

<table> 
 <tbody> 
  <tr> 
   <td style="word-break: break-all;width:336px"><strong>默认开启的模块&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong></td> 
   <td style="word-break: break-all;"><strong>描述</strong></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http-charset_module</td> 
   <td style="word-break: break-all;">禁用Charset模块，该模块用于对网页重新编码</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http-gzip_module</td> 
   <td style="word-break: break-all;">禁用Gzip压缩模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_ssi_module</td> 
   <td style="word-break: break-all;">禁用服务器端包含模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_access_module</td> 
   <td style="word-break: break-all;">禁用访问模块，对于指定的IP段，允许访问配置</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_userid_module</td> 
   <td style="word-break: break-all;">禁用用户ID模块。该模块为用户通过cookie验证身份</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_auth_basic_module</td> 
   <td style="word-break: break-all;">禁用基本的认证模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_autoindex_module</td> 
   <td style="word-break: break-all;">禁用自动索引模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_geo_module</td> 
   <td style="word-break: break-all;">禁用Geo模块，该模块允许你定义依赖于IP地址段的变量</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_map_module</td> 
   <td style="word-break: break-all;">禁用Map模块，该模块允许你声明map区段</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_referer_module</td> 
   <td style="word-break: break-all;">禁用Referer控制模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_rewrite_module</td> 
   <td style="word-break: break-all;">禁用Rewrite模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_proxy_module</td> 
   <td style="word-break: break-all;">禁用代理模块。该模块用于向其他服务器传输请求</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_fastcgi_module</td> 
   <td style="word-break: break-all;">禁用FastCGI模块。该模块是用于与FastCGI进程配合工作</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_memcached_module&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td> 
   <td style="word-break: break-all;">禁用Memcached模块。该模块是用于与memcached守护进程配合工作</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_limit_zone_module</td> 
   <td style="word-break: break-all;">禁用Limit Zone模块。该模块是用于根据定义的zone来限制约束对资源的使用。</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_limit_req_module</td> 
   <td style="word-break: break-all;">禁用Limit Requests模块。该模块允许你限制每个用户请求的总数</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_empty_gif_module</td> 
   <td style="word-break: break-all;">禁用Empty Gif模块。该模块用于在内存中提供一个空白的GIF图像</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_browser_module</td> 
   <td style="word-break: break-all;">禁用Browser模块。该模块用于解释用户代理字符串</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http_upstream_ip_hash_module</td> 
   <td style="word-break: break-all;">禁用Upstream模块。该模块用于配置负载均衡结构</td> 
  </tr> 
 </tbody> 
</table>

<table> 
 <tbody> 
  <tr> 
   <td style="word-break: break-all;width:336px"><strong>默认禁用的模块&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong></td> 
   <td style="word-break: break-all;"><strong>描述 </strong></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_ssl_module</td> 
   <td style="word-break: break-all;">开启SSL模块，支持使用HTTPS协议的网页</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_realip_module</td> 
   <td style="word-break: break-all;">开启Real IP的支持，该模块用于从客户请求的头数据中读取real IP地址</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_addition_module</td> 
   <td style="word-break: break-all;">开启Addition模块，该模块允许你追加或前置数据（prepend data）到响应的主体部分</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_xslt_module</td> 
   <td style="word-break: break-all;">开启XSLT模块的支持，该模块实现XSLT转化为XML文档</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_image_filter_module</td> 
   <td style="word-break: break-all;">开启Image Filter模块，该模块是让你修改图像。注意：如果想编译该模块，需要在系统中安装libgd库</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_geoip_module</td> 
   <td style="word-break: break-all;">开启GeoIP模块，该模块通过使用MaxMind's GeoI 二进制数据库来获取客户端在地理上的分布。注意：如果希望编译该模块，需要在系统中安装libgeoip库。</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_sub_module</td> 
   <td style="word-break: break-all;">开启Substitution模块，该模块用于在网页中替换文本</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_dav_module</td> 
   <td style="word-break: break-all;">开启WebDAV模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_flv_module</td> 
   <td style="word-break: break-all;">开启FLV模块，该模块用于专门处理.flv(flash视频)文件</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_gzip_static_module </td> 
   <td style="word-break: break-all;">开启Gzip静态模块，该模块用于发送预压缩的文件</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_random_index_module </td> 
   <td style="word-break: break-all;">开启Random Index模块。该模块用于挑选一个随机的文件作为该目录的index</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_secure_link_module</td> 
   <td style="word-break: break-all;">开启Secure Link模块，该模块用于在URL中检测关键字的存在</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-http_stub_status_module</td> 
   <td style="word-break: break-all;">开启Stub Status模块，该模块会产生一个服务器状态和信息页</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-google_perftools_module&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; </td> 
   <td style="word-break: break-all;">开启google性能工具模块</td> 
  </tr> 
 </tbody> 
</table>

### 其它configure选项

<table> 
 <tbody> 
  <tr> 
   <td style="word-break: break-all;width:336px"><strong>邮件服务代理</strong> </td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-mail</td> 
   <td style="word-break: break-all;">开启邮件服务代理（mail server proxy）模块，支持POP3，IMAP4和SMTP。该功能默认禁用</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-mail_ssl_module</td> 
   <td style="word-break: break-all;">开启邮件代理服务对SSL的支持。该功能默认禁用</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-mail_pop3_module</td> 
   <td style="word-break: break-all;">在邮件代理下禁用POP3功能。在开启邮件代理模块后该功能默认启用</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-mail_imap_module</td> 
   <td style="word-break: break-all;">对邮件代理服务器禁用IMAP4模块，在开启邮件代理模块后该功能默认启用</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-mail_smtp_module</td> 
   <td style="word-break: break-all;">对于邮件代理服务器禁用SMTP模块，在开启邮件代理模块后该功能默认启用</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>事件管理</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-rtsig_module</td> 
   <td style="word-break: break-all;">开启rtsig模块，使用rtsig作为事件通知机制</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-select_module</td> 
   <td style="word-break: break-all;">开启select模块，使用select作为事件通知机制。默认情况下，该模块是开启的，除非系统有一种更好的方式发现——kqueue, epoll, rtsig 或 poll</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-select_module</td> 
   <td style="word-break: break-all;">禁用select模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-poll_module</td> 
   <td style="word-break: break-all;">开启poll模块，该模块使用poll作为事件通知机制。默认情况下，如果有效，该模块是开启的，除非系统上有一种更好的方式发现——kqueue, epoll或rtsig</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-poll_module</td> 
   <td style="word-break: break-all;">禁用poll模块</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>用户和组选项</strong></td> 
   <td style="word-break: break-all;"></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--user=...</td> 
   <td style="word-break: break-all;">指定启动Nginx进程的默认用户。这个设置仅用于在配置文件中省略user指令来指定用户的情况</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--group=...</td> 
   <td style="word-break: break-all;">指定启动Nginx进程默认的用户组。这个设置仅用于在配置文件中省略使用group指令来指定用户的情况</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;"><strong>其它选项</strong></td> 
   <td></td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-ipv6</td> 
   <td style="word-break: break-all;">开启对IPv6的支持</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http</td> 
   <td style="word-break: break-all;">禁用HTTP服务</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--without-http-cache</td> 
   <td style="word-break: break-all;">禁用HTTP缓冲功能</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--add-module=PATH</td> 
   <td style="word-break: break-all;">通过指定的路径编译添加第三方模块。如果希望编译多个模块，那么该选项可以无限次使用</td> 
  </tr> 
  <tr> 
   <td style="word-break: break-all;">--with-debug</td> 
   <td style="word-break: break-all;">开启记录额外的调试信息</td> 
  </tr> 
 </tbody> 
</table>