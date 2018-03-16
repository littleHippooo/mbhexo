---
title: Spring Boot项目打包成war包
date: 2017-11-23 10:03:18
tags: Spring Boot
---
在pom.xml文件中，将打包方式改为war：
```xml
<packaging>war</packaging>
```
然后添加如下的Tomcat依赖配置，覆盖Spring Boot自带的Tomcat依赖：
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <scope>provided</scope>
</dependency>
```
<!--more-->
在`<build></build>`标签内配置项目名（该配置类似于server.context-path=mrbird）：
```xml
...
<build>
    ...
    <finalName>mrbird</finalName>
</build>
...
```
添加启动类ServletInitializer：
```java
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;

public class ServletInitializer extends SpringBootServletInitializer {
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }
}
```
其中Application为Spring Boot的启动类。

准备完毕后，运行`mvn clean package`命令即可在target目录下生产war包：

![QQ截图20180315191017.png](img/QQ截图20180315191017.png)