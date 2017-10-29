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
## main全局设置
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

