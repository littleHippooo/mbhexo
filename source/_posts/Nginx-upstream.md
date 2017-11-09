---
title: Nginx upstream
date: 2017-10-21 10:17:00
tags: Nginx
---
upstream指令用于配置Nginx后端服务器组。Nginx支持设置一组服务器作为后端服务器，由标准的HTTP模块ngx_http_upstream_module进行解析和处理。服务器组的设置涉及以下几个指令：
## upstream指令
该指令为设置后端服务器组的主要指令，其他的指令都在该指令中进行配置，语法结构如下：
```nginx
upstream name { }
```
<!--more-->
其中name为后端服务器组的名称，`{}`中包含服务器。

某个服务器组收到请求后，按照权重的大小依次选择组内的服务器处理请求。如果出现错误，则顺次交给组内的下一个服务器进行处理，以此类推直到正常响应。如果都出错，则返回最后一个服务器处理的结果。

## server指令
该指令用于设置组内的服务器，语法如下：
```nginx
server address [parameters];
```
1. `address`服务器的地址，支持IP，域名和unix地址；

2. `parameters`设置更多的属性，包括：
 
 - **weight=number**用于设置权重，权重高的优先处理。默认值为1。

 - **max_fails=number**设置请求失败的次数。在**fail_timeout**时间范围内，服务器请求失败的次数超过该值时，则将该服务器置为down（无效）状态。

 - **fail_timeout=time**除了用在**max_fails**外，该属性还用于设置某个down状态服务器的持续时间，在这个时间段内不再检查该服务器的状态，一直认为它是down状态。默认值为10s。

 - **backup**设置服务器为备用服务器。当正常的服务器处于down或者busy状态时，该服务器才被用来处理请求。

 - **down**将服务器标记为永久down状态。

举个例子：
```nginx
upstream backend {
   server www.example.com weight=5;
   server 127.0.0.1:8080 max_fails=3 fail_timeout=30s;
   server unix:/tmp/backend3;
}
```
上述指令设置了一个名为backend的服务器组，包含三台服务器。

第一台服务器是基于域名的，并且权重为5，将优先处理客户端请求；

第二台服务器基于IP地址，并且设置如果30s内连续产生3次请求失败，则该服务器在之后的30s内被认为是down状态；

第三台服务器基于unix地址。

## ip_hash指令
该指令用于保障客户端和服务器建立稳定的会话。只有当该服务器处于down状态时，客户端请求才会被下一个服务器接收和处理。语法如下：
```nginx
ip_hash;
```

{% note danger %}`ip_hash`指令不能和weight一起使用；Nginx服务器应为最前端的服务器。{% endnote %}

比如：
```nginx
upstream backend {
   ip_hash;
   server myback1.proxy.com;
   server myback2.proxy.com;
}
```
上述配置会使得客户端的请求都由第一台服务器处理（前提是没有出错），如果去掉`ip_hash`，则组内的两台服务器轮流响应请求。

## keep_alive指令
该指令用于控制Nginx服务器的工作进程为服务器打开一定范围的网络连接，语法如下：
```nginx
keepalive connections;
```
connections用于限定该范围的上限值。如果超过该值，工作进程将采用LRU（最近最少使用）算法来关闭网络连接。

## least_conn指令
该指令用于控制服务器组处理客户端请求时，除了考虑权重的大小之外，每次选择的服务器都是当前网络连接最少的那台。语法如下：
```nginx
least_conn;
```
