---
title: 腾讯云部署Java Web项目小记
date: 2018-03-01 09:29:49
tags: [Liunx,云服务器]
---
近期[腾讯云](https://cloud.tencent.com/act/campus/)推出云服务器团购优惠，刚好打算搭建个[FEBS](http://111.230.157.133/febs)的演示环境，于是买了台120/年的云服务器，配置为1核2G、1M带宽，加赠50GB对象存储空间，系统为Ubuntu 16.04。部署过程中遇到一些新的问题，在这记录一下。
<!--more-->
## 工具准备
搭建前先准备好远程登录软件，这类软件很多，这里推荐的是[MobaXterm](https://mobaxterm.mobatek.net/)；文件的上传下载推荐使用[FileZilla](https://filezilla-project.org/)；数据库连接推荐使用Navicat Premium。

## Java环境搭建
Java环境的搭建可参考（包括安装JDK，MySQL）：[ubuntu16-04搭建Java开发环境](/ubuntu16-04搭建Java开发环境.html)。Tomcat下载后解压即可。

## 远程连接MySQL
开启MySQL远程连接的前提是在安装MySQL初始化的时候允许远程连接，然后输入以下命令：
```sql
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY '123456' WITH GRANT OPTION;
```
这段话的意思是允许任何IP以root账户远程访问，密码为123456。这里的密码设定只是为了演示，实际必须满足在初始化MySQL时密码强度的设定，即`validate_password_policy`：

<table >
<thead>
<tr><th scope="col">Policy</th><th scope="col">Tests Performed</th></tr>
</thead>
<tbody>
<tr>
<td scope="row"><code bigint(20)>0</code>&nbsp;or&nbsp;<code bigint(20)>LOW</code></td>
<td>Length</td>
</tr>
<tr>
<td scope="row"><code bigint(20)>1</code>&nbsp;or&nbsp;<code bigint(20)>MEDIUM</code></td>
<td>Length; numeric, lowercase/uppercase, and special characters</td>
</tr>
<tr>
<td scope="row"><code bigint(20)>2</code>&nbsp;or&nbsp;<code bigint(20)>STRONG</code></td>
<td>Length; numeric, lowercase/uppercase, and special characters; dictionary file</td>
</tr>
</tbody>
</table>

当密码强度和设定的不一致时，MySQL提示<span style="color:red"> Your password does not satisfy the current policy requirements</span>错误。

然后执行一下语句，使得设定生效：
```sql
mysql> FLUSH PRIVILEGES;
```

接下来使用Navicat远程连接MySQL，打开Navicat，新建MySQL连接：

![QQ截图20180322105626.png](img/QQ截图20180322105626.png)

IP填云服务器的公网IP地址，用户名和密码为上面设定的root和123456。除此之外，还得填写SSH连接信息：

![QQ截图20180322105848.png](img/QQ截图20180322105848.png)

IP填云服务器的公网IP地址，用户名和密码为云服务器的用户名和密码。

点击连接测试和发现Navicat报错：

{% note danger %}
`Lost connection to MySQL server at 'reading initial communication packet', system error: 0`
{% endnote %}

打开MySQL配置：
```
 vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
找到`[mysqld]`，添加`skip-name-resolve`，并将`bind-address= 127.0.0.1`配置注释掉即可，如下所示：

![QQ截图20180322110744.png](img/QQ截图20180322110744.png)

然后再次点击Navicat连接测试即可成功。

## 项目部署
在本地将项目打包后，使用FileZilla将项目上传到Tomcat的webapp目录下，运行bin目录下的startup.sh脚本即可。

## 域名绑定
如下新增域名解析：

![QQ截图20180322111531.png](img/QQ截图20180322111531.png)

记录值为云服务器的公网IP地址。配置解析后，就可使用 `域名:端口号/项目名` 的形式访问了。比如`http://demo.mrbird.cc:80/febs/login`，端口号默认就是80，所以可以简写为[http://demo.mrbird.cc/febs/login](http://demo.mrbird.cc/febs/login)。


