---
title: maven聚合与继承
date: 2016-10-26 10:24:20
tags: maven
---
maven中聚合和继承是两个概念，两者的目的是不一样的。聚合是为了方便的快速构建项目，而继承是为了消除一些重复的配置。

对于聚合模块来说，它知道有哪些模块被聚合了，但是那些被聚合的模块并不知道这个聚合模块的存在。

对于继承关系的父pom来说，它不知道哪些被聚合的模块，但那些被聚合的模块必须知道自己的父pom是什么。

<!--more-->
## 聚合
开发中，一个项目一般被分为多个模块，通过maven的聚合特性，我们可以创建一个父maven项目来管理所有的子模块。

现有account-email和account-persist两个maven项目，我们创建一个account-parent项目将其聚合在一起。

聚合有两种结构方式：

1.父子结构：   

![65436941-file_1487995000866_7921.png](img/65436941-file_1487995000866_7921.png)

2.平行结构      

![87140417-file_1487995026804_10b90.png](img/87140417-file_1487995026804_10b90.png)

下面例子以平行结构为例。

account-parent配置如下：
```xml
<groupId>com.juvenxu.mvnbook.account</groupId>
<artifactId>account-parent</artifactId>
<version>1.0.0-SNAPSHOT</version>
<packaging>pom</packaging>
<name>Account Parent</name>
 
<modules>
    <module>../account-email</module>
    <module>../account-persist</module>
</modules>
```
modules元素用于聚合子模块，packaging元素声明其打包方式为pom。对于一个聚合子模块的父模块，其打包方式必须为pom。对于平行结构来说，父模块的内容仅为一个pom文件。

对父模块执行 `mvn clean install`命令： 
```xml
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] Account Parent .................................... SUCCESS [0.447s]
[INFO] Account Email ..................................... SUCCESS [3.334s]
[INFO] Account Persist ................................... SUCCESS [1.582s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 5.489s
[INFO] Finished at: Wed Oct 26 16:59:05 CST 2016
[INFO] Final Memory: 17M/160M
[INFO] ------------------------------------------------------------------------   
```
## 继承
如果需要继承父模块pom中的一些配置，我们只需要在子模块pom中添加如下配置
```xml
<parent>
    <groupId>com.juvenxu.mvnbook.account</groupId>
    <artifactId>account-parent</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <relativePath>../account-parent/pom.xml</relativePath>
</parent>
```
通过parent元素指定其父模块，relativePath指向父模块的pom路径，其默认值为../pom.xml。
 
父模块pom中声明的一些元素可以被子模块继承，常用的有：

■ `groupId`：项目id，项目坐标的核心元素

■ `version`：项目版本，项目坐标的核心元素

■ `description`：项目的描述信息

■ `organization`：项目的组织信息

■ `distributionManagement`：项目的部署信息

■ `properties`：自定义的maven属性

■ `dependencies`：依赖

■ `dependencyManagement`：依赖管理配置

■ `repositories`：项目的仓库配置

■ `build`：项目的源码目录配置，输出目录配置，插件配置，插件管理配置等  
### 依赖继承
对于子模块共用的依赖，可以统一在父模块中声明，比如在父模块account-parent中配置dependencyManagement： 
```xml
<properties>
    <springframework.version>2.5.6</springframework.version>
    <junit.version>4.7</junit.version>
</properties>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>${springframework.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>${springframework.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>${springframework.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context-support</artifactId>
            <version>${springframework.version}</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```
子模块使用这些依赖的时候，只需要简单的配置，如account-email的pom配置：
```xml
<properties>
    <javax.mail.version>1.4.1</javax.mail.version>
    <greenmail.version>1.3.1b</greenmail.version>
</properties>
 
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-core</artifactId>		
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-beans</artifactId>			
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>			
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context-support</artifactId>			
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
    </dependency>
    <dependency>
        <groupId>javax.mail</groupId>
        <artifactId>mail</artifactId>
        <version>${javax.mail.version}</version>
    </dependency>		
    <dependency>
        <groupId>com.icegreen</groupId>
        <artifactId>greenmail</artifactId>
        <version>${greenmail.version}</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```
可发现，account-email的dependencies配置省去了version，对于junit还省去了scope。省去这些信息是因为account-email继承了父模块的dependencyManagement配置，完整的依赖声明已经包含在父pom中，子模块只需要声明简单的groupId和artifactId就可以找到对应的依赖。

{% note danger %}注意：虽然完整的依赖已经包含在父模块pom中了，但并不是说子模块完全不需要声明依赖了。比如子模块不声明spring-context-support依赖，那么该依赖不会被引入。{% endnote %}

### 插件继承
在父模块account-parent的pom中配置pluginManagement元素：
```xml
<build>
    <pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>1.5</source>
                    <target>1.5</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-resources-plugin</artifactId>
                <configuration>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
        </plugins>
    </pluginManagement>
</build>
```
子模块需要用到这些插件的时候，只需要简单的配置：
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-resources-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```
只需要在子模块中指定插件的groupId和artifactId就可以在父模块pom中找到对应的插件配置。

> [《Maven实战》](https://book.douban.com/subject/5345682/)读书笔记  