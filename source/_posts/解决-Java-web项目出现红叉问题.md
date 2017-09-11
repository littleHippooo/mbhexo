---
title: 解决 Java web项目出现红叉问题
date: 2016-03-18 11:13:25
tags: Java
---
Java web出现红叉有好几种情况所致，最基本的代码编写错误以及jar包问题这里不再赘述。

1.查看web项目 Java Resources/Libraries目录下Apache Tomcat版本是否为当前Tomcat版本；
<!--more-->

![91613780-file_1487993810122_dc52.png](img/91613780-file_1487993810122_dc52.png)

2.查看web项目 Java Resources/Libraries目录下JRE System Library jre版本是否为当前系统所安装版本；

![52222063-file_1487993832666_170d0.png](img/52222063-file_1487993832666_170d0.png)

3.在修改完上面两项还是没有解决问题的时候，我们再去eclipse workspace目录下找到</br>项目名
/.settings/org.eclipse.wst.common.project.facet.core.xml文件，用编辑器打开：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<faceted-project>
  <runtime name="Apache Tomcat v8.0"/>
  <fixed facet="jst.web"/>
  <fixed facet="java"/>
  <fixed facet="wst.jsdt.web"/>
  <installed facet="java" version="1.8"/>
  <installed facet="jst.web" version="3.0"/>
  <installed facet="wst.jsdt.web" version="1.0"/>
</faceted-project>
```
修改Tomcat和jre版本为当前系统版本，再回到eclipse中Refresh项目就行了。