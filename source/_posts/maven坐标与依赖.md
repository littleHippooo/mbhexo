---
title: maven坐标与依赖
date: 2016-10-18 15:00:14
tags: maven
---
## 坐标
在maven中，任何构件都有明确定义的坐标。这些坐标是通过一些元素定义的，下面是nexus-indexer的坐标定义：
```xml
<groupId>org.sonatype.nexus</groupId>
<artifactId>nexus-indexer</artifactId>
<version>2.0.0</version>
<packing>jar</packing>
```
<!--more-->
`groupId`：定义当前maven项目隶属的实际项目，一般由公司前缀+隶属项目名称组成

`artifactId`：定义当前maven项目模块，一般由隶属项目名称+当前maven模块名称组成

`version`：版本号

`packing`：打包方式。有jar，war等，默认为jar classifier：定义构件输出的一些附属构件。本例主构件输出nexus-indexer-2.0.0.jar，附属构件比如有：nexus-indexer-2.0.0-javadoc.jar，nexus-indexer-2.0.0-source.jar等
## 依赖配置
除了上面的基本坐标定义，依赖还可以包含：
```xml
<project>
    ...
    <dependency>
        <dependency>
            <groupId>... </groupId>
            <artifactId>... </artifactId>
            <version>... </version>
            <type>... </type>
            <scope>... </scope>
            <optional>... </optional>
            <exclusions>
                <exclusion>
                ...
                </exclusion>
            ...    
            </exclusions>
        </dependency>
        ...
    </dependency>
    ...
</project>
```
`type`：依赖的类型，对应坐标中的packing，默认为jar，一般不用声明

`scope`：依赖的范围

`optional`：标记依赖是否可选，若为true则为可选依赖。可选依赖不能传递

`exclusions`：用来排除传递性依赖
## 依赖范围
在一个maven项目中主要有三个classpath：编译classpath，测试classpath，运行时classpath。下表列出了依赖范围和classpath的关系：
<table>
        <tr>
            <td >
                
                    依赖范围</br>
                
                
                    （Scope）
                
            </td>
            <td >
                
                    对于编译</br>
                
                
                    classpath有效
                
            </td>
            <td >
                
                    对于测试</br>
                
                
                    classpath有效
                
            </td>
            <td >
                
                    对于运行时</br>
                
                
                    classpath有效
                
            </td>
            <td >
                例子
            </td>
        </tr>
        <tr>
            <td >
                compile
            </td>
            <td >
                √
            </td>
            <td >
                √
            </td>
            <td >
                √
            </td>
            <td >
                spring-core
            </td>
        </tr>
        <tr>
            <td >
                test
            </td>
            <td >
                ×
            </td>
            <td >
                √
            </td>
            <td >
                ×
            </td>
            <td >
                JUnit
            </td>
        </tr>
        <tr>
            <td >
                provided
            </td>
            <td >
                √
            </td>
            <td >
                √
            </td>
            <td >
                ×
            </td>
            <td >
                servlet-api
            </td>
        </tr>
        <tr>
            <td >
                runtime
            </td>
            <td >
                ×
            </td>
            <td >
                √
            </td>
            <td >
                √
            </td>
            <td >
                JDBC驱动实现
            </td>
        </tr>
        <tr>
            <td >
                system
            </td>
            <td >
                √
            </td>
            <td >
                √
            </td>
            <td >
                ×
            </td>
            <td >
                
                    本地的，Maven仓库外的
                
                
                    类库文件
                
            </td>
        </tr>
</table>

`compile`：编译依赖范围

`test`：测试依赖范围

`provided`：已提供依赖范围

`runtime`：运行时依赖范围

`system`：系统依赖范围

`import`：导入依赖范围
## 传递性依赖
现有pom如下：
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.juven.mvnbook.account</groupId>
    <artifactId>account-email</artifactId>
    <name>Account Email</name>
    <version>1.0.0-SNAPSHOT</version>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>4.3.3.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>4.3.3.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>4.3.3.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context-support</artifactId>
            <version>4.3.3.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>javax.mail</groupId>
            <artifactId>mail</artifactId>
            <version>1.4.7</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.7</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>com.icegreen</groupId>
            <artifactId>greenmail</artifactId>
            <version>1.5.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-resources-plugin</artifactId>
                <configuration>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```
上面的xml中有一个org.springframework：spring-core.4.3.3.RELEASE.jar依赖。在中央仓库查看其xml，会发现其还包含了：
```xml
<dependency>
    <groupId>commons-logging</groupId>
    <artifactId>commons-logging</artifactId>
    <version>1.2</version>
    <scope>compile</scope>
</dependency>
```
该依赖的范围为compile，而spring-core依赖没有直接声明依赖范围，默认为compile。现在account-email有一个compile范围的spring-core依赖，spring-core有一个compile范围的comms-logging依赖，所以comms-logging会成为account-email的compile范围的**传递性依赖**。

现假设A依赖于B，B依赖于C，那么A相对于B是第一直接依赖，B相对于C是第二直接依赖，A相对于C是传递性依赖，其依赖范围按下表定义：
<table>
        <tr>
            <td >
                <br>
            </td>
            <td >
                compile
            </td>
            <td >
                test
            </td>
            <td >
                provided
            </td>
            <td >
                runtime
            </td>
        </tr>
        <tr>
            <td >
                compile
            </td>
            <td >
                compile
            </td>
            <td >
                —
            </td>
            <td >
                —
            </td>
            <td >
                compile
            </td>
        </tr>
        <tr>
            <td >
                test
            </td>
            <td >
                test
            </td>
            <td >
                —
            </td>
            <td >
                —
            </td>
            <td >
                test
            </td>
        </tr>
        <tr>
            <td >
                provided
            </td>
            <td >
                provided
            </td>
            <td >
                —
            </td>
            <td >
                provided
            </td>
            <td >
                provided
            </td>
        </tr>
        <tr>
            <td >
                runtime
            </td>
            <td >
                runtime
            </td>
            <td >
                —
            </td>
            <td >
                —
            </td>
            <td >
                runtime
            </td>
        </tr>
</table>

表中，第一列是第一直接依赖范围，第一行是第二直接依赖范围，交叉部分是最终传递性依赖范围。
## 依赖调解
依赖调解有两个原则：

1.路径最近的优先

现在有如下两个依赖：

A → B → C → X（1.0.0）

A → B → X（1.2.1）

A有两个版本的传递性依赖X，因为X（1.2.1）路径较短，所以最终X（1.2.1）会被解析使用。

2.第一声明者优先

现在有如下两个依赖：

A → B → X（1.0.0）

A → B → X（1.2.1）

两个版本X的依赖路径一样长，这时候谁被解析取决于谁先定义！
## 排除依赖
使用`compile:tree`查看依赖树：
```xml
[INFO] --- maven-dependency-plugin:2.8:tree (default-cli) @ account-email ---
[INFO] com.juven.mvnbook.account:account-email:jar:1.0.0-SNAPSHOT
[INFO] +- org.springframework:spring-core:jar:4.3.3.RELEASE:compile
[INFO] |  \- commons-logging:commons-logging:jar:1.2:compile
[INFO] +- org.springframework:spring-beans:jar:4.3.3.RELEASE:compile
[INFO] +- org.springframework:spring-context:jar:4.3.3.RELEASE:compile
[INFO] |  +- org.springframework:spring-aop:jar:4.3.3.RELEASE:compile
[INFO] |  \- org.springframework:spring-expression:jar:4.3.3.RELEASE:compile
[INFO] +- org.springframework:spring-context-support:jar:4.3.3.RELEASE:compile
[INFO] +- javax.mail:mail:jar:1.4.7:compile
[INFO] |  \- javax.activation:activation:jar:1.1:compile
[INFO] +- junit:junit:jar:4.7:test
[INFO] \- com.icegreen:greenmail:jar:1.5.2:test
[INFO]    +- com.sun.mail:javax.mail:jar:1.5.6:test
[INFO]    \- org.slf4j:slf4j-api:jar:1.7.21:test  
```
如上所述的，spring-core隐式依赖于commons-logging，如果不想传递此依赖，可以为spring-core添加exclusions元素：
```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
    <version>4.3.3.RELEASE</version>
    <exclusions>
        <exclusion>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```
再次执行`dependency:tree`命令：
```xml
[INFO] --- maven-dependency-plugin:2.8:tree (default-cli) @ account-email ---
[INFO] com.juven.mvnbook.account:account-email:jar:1.0.0-SNAPSHOT
[INFO] +- org.springframework:spring-core:jar:4.3.3.RELEASE:compile
[INFO] +- org.springframework:spring-beans:jar:4.3.3.RELEASE:compile
[INFO] +- org.springframework:spring-context:jar:4.3.3.RELEASE:compile
[INFO] |  +- org.springframework:spring-aop:jar:4.3.3.RELEASE:compile
[INFO] |  \- org.springframework:spring-expression:jar:4.3.3.RELEASE:compile
[INFO] +- org.springframework:spring-context-support:jar:4.3.3.RELEASE:compile
[INFO] +- javax.mail:mail:jar:1.4.7:compile
[INFO] |  \- javax.activation:activation:jar:1.1:compile
[INFO] +- junit:junit:jar:4.7:test
[INFO] \- com.icegreen:greenmail:jar:1.5.2:test
[INFO]    +- com.sun.mail:javax.mail:jar:1.5.6:test
[INFO]    \- org.slf4j:slf4j-api:jar:1.7.21:test
```
可发现spring-core已经不依赖于commons-logging了，当然这里只是单纯演示排除依赖，commons-logging对于Spring框架是必须的。
## 归类依赖
在上述的pom中，spring的版本都为4.3.3.RELEASE版本，而且对于一个框架来说，其各个模块的版本一般都是一样的，这里我们可以统一声明其版本，然后引用即可：
```xml
<properties>
    <springframework.version>4.3.3.RELEASE</springframework.version>
</properties>
...
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
```
这样在以后更新spring版本的时候，只需要修改properties即可。
## 优化依赖
除了使用`dependency:tree`命令外，还可使是`dependency:list`查看所有依赖：

dependency:list
```xml
[INFO] --- maven-dependency-plugin:2.8:list (default-cli) @ account-email ---
[INFO] 
[INFO] The following files have been resolved:
[INFO]    org.springframework:spring-beans:jar:4.3.3.RELEASE:compile
[INFO]    org.springframework:spring-context-support:jar:4.3.3.RELEASE:compile
[INFO]    org.slf4j:slf4j-api:jar:1.7.21:test
[INFO]    junit:junit:jar:4.7:test
[INFO]    com.sun.mail:javax.mail:jar:1.5.6:test
[INFO]    com.icegreen:greenmail:jar:1.5.2:test
[INFO]    commons-logging:commons-logging:jar:1.2:compile
[INFO]    org.springframework:spring-aop:jar:4.3.3.RELEASE:compile
[INFO]    javax.activation:activation:jar:1.1:compile
[INFO]    javax.mail:mail:jar:1.4.7:compile
[INFO]    org.springframework:spring-core:jar:4.3.3.RELEASE:compile
[INFO]    org.springframework:spring-context:jar:4.3.3.RELEASE:compile
[INFO]    org.springframework:spring-expression:jar:4.3.3.RELEASE:compile
```
使用`dependency:analyze`分析依赖：
```xml
[INFO] <<< maven-dependency-plugin:2.8:analyze (default-cli) @ account-email <<<
[INFO] 
[INFO] --- maven-dependency-plugin:2.8:analyze (default-cli) @ account-email ---
[WARNING] Unused declared dependencies found:
[WARNING]    org.springframework:spring-core:jar:4.3.3.RELEASE:compile
[WARNING]    org.springframework:spring-beans:jar:4.3.3.RELEASE:compile
[INFO] ------------------------------------------------------------------------
```

> [《Maven实战》](https://book.douban.com/subject/5345682/)读书笔记  