---
title: Start Spring Boot
date: 2017-02-17 17:35:04
tags: [Spring,Spring Boot]
---
Spring Boot是在Spring框架上创建的一个全新的框架，其设计目的是简化Spring应用的搭建和开发过程，不但具有Spring的所有优秀特性，而且具有如下显著特点：

1.为Spring开发提供更加简单的使用和快速开发的技巧。

2.具有开箱即用的默认配置功能，能根据项目依赖自动配置。

3.具有功能更加强大的服务体系，包括嵌入式服务，安全，性能指标和健康检查等。

4.绝对没有代码生成，可以不再需要XML配置，即可让应用更加轻巧灵活。

使用IntelliJ IDEA开发第一个Spring Boot程序！
<!--more-->
## 配置依赖
新建一个Maven项目，JDK选择1.8，然后在pom.xml中加入依赖：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
        http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>spring-boot</groupId>
    <artifactId>hello</artifactId>
    <version>1.0-SNAPSHOT</version>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.5.1.RELEASE</version>
    </parent>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
</project>
```
使用spring-boot-starter-web以来配置和parent配置spring-boot-starter-parent。

等IntelliJ IDEA下载好依赖后，在External Libraries中可以看到这些依赖：

![7895607-file_1487997043797_184f3.png](img/7895607-file_1487997043797_184f3.png)

可以看出，Spring Boot已经导入整个springframework依赖，以及autoconfigure，logging，slf4j，jackson和tomcat插件等，非常方便。
## 编写控制器
一个简单的控制器如下：
```java
package mrbird.springboot.web;
 
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
 
@SpringBootApplication
@RestController
public class Application {
    @RequestMapping(value="/")
    public String home(){
        return "hello world";
    }
    
    public static void main(String[] args) {
        SpringApplication.run(Application.class,args);
    }
}   
```
`@SpringBootApplication`注解标注它是一个Spring Boot应用，main方法用于测试主程序。`@RestController`同时标注这个程序是一个控制器。
## 测试运行
在IntelliJ IDEA中选择Run → Edit Configurations → Spring Boot：

![77518425-file_1487997066981_ba04.png](img/77518425-file_1487997066981_ba04.png)

选择Main class和Working directory。

配置好，点击Run运行程序，控制台输出：
```bash
"C:\Program Files\Java\jdk1.8.0_31\bin\java"...
 
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v1.5.1.RELEASE)
 ...
Tomcat started on port(s): 8080 (http)
Started Application in 6.685 seconds (JVM running for 8.385) 
```
在浏览器中输入http://localhost:8080/页面显示如下：

![32461988-file_1487997084955_130a2.png](img/32461988-file_1487997084955_130a2.png)
## 打包发布
在pom.xml中增加打包插件:spring-boot-maven-plugin，并增加一行打包配置<packaging>jar</packaging>：
```xml
...
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
...
```
然后打开Run → Edit Configurations → Maven：   

![83857571-file_1487997110796_178de.png](img/83857571-file_1487997110796_178de.png)

点击run生成jar包：
```bash
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building hello 1.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ hello ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ hello ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory D:\Spring-Boot\hello\src\test\resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ hello ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-surefire-plugin:2.18.1:test (default-test) @ hello ---
[INFO] No tests to run.
[INFO] 
[INFO] --- maven-jar-plugin:2.6:jar (default-jar) @ hello ---
[INFO] 
[INFO] --- spring-boot-maven-plugin:1.5.1.RELEASE:repackage (default) @ hello ---
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 14.009 s
[INFO] Finished at: 2017-02-17T23:36:10+08:00
[INFO] Final Memory: 27M/263M
[INFO] ------------------------------------------------------------------------ 
```
生成jar包后，cd到target目录下，执行以下命令：
```bash
C:\Users\Dell>d:
 
D:\>cd Spring-Boot/hello/target
D:\Spring-Boot\hello\target>java -jar hello-1.0-SNAPSHOT.jar
 
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v1.5.1.RELEASE)
...
```
访问[http://localhost:8080/](http://localhost:8080/)可看到hello world。
## Spring Boot配置
在resources目录下新建application.yml文件：
```xml
server:
  port: 8081
  tomcat:
    uri-encoding: utf-8 
```
这里配置了tomcat的端口号以及uri编码。

更多配置请参考：http://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html

> [《深入实践Spring Boot》](https://book.douban.com/subject/26968640/)读书笔记