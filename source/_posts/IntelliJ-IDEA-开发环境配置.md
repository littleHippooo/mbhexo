---
title: IntelliJ IDEA 开发环境配置
date: 2017-02-17 14:59:17
tags: [IntelliJ IDEA]
---
IntelliJ IDEA 主要用于支持 Java、Scala、Groovy 等语言的开发工具，同时具备支持目前主流的技术和框架，擅长于企业应用、移动应用和 Web 应用的开发。

最近使用后觉得比eclipse强太多。初次使用要配置各种开发环境，所以记之。
## 配置Git
1.在官网[https://git-scm.com/](https://git-scm.com/)下载Git for windows并安装。

2.打开IntelliJ IDEA的设置界面，选择Version Control → Git：  
<!--more--> 

![52448752-file_1487996960325_16c4d.png](img/52448752-file_1487996960325_16c4d.png)

将Path to Git executable设置为Git安装路径。
## 配置GitHub
1.打开IntelliJ IDEA的设置界面，选择Version Control → GitHub。

2.填写账号密码，并测试是否登陆成功： 

![88866569-file_1487996981862_5d9d.png](img/88866569-file_1487996981862_5d9d.png)
## 配置Maven
1.首先配置Maven本地资源库存放路径(拷贝Maven自带settings.xml，打开修改存放路径)：
```xml
<localRepository>D:\MyMaven\repository</localRepository> 
```
2.打开IntelliJ IDEA的设置界面，选择Build,Execution,Deployment → Build Tools → Maven：

![26342026-file_1487997004200_5258.png](img/26342026-file_1487997004200_5258.png)

选择相应settings.xml文件即可。  