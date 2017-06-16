---
title: maven生命周期和插件
date: 2016-10-25 09:52:39
tags: maven
---
maven生命周期（lifecycle）对构建的过程进行了抽象和统一，实际的工作是由对应的插件（plugins）来完成的。
## maven生命周期
maven生命周期可以分为三个部分：
### clean生命周期
该周期的任务是清理项目，包含三个阶段：

<!--more-->
<table>
        <tr>
            <td>
                pre-clean
            </td>
            <td>
                执行清理前需要完成的工作
            </td>
        </tr>
        <tr>
            <td>
                clean
            </td>
            <td>
                清理上一次构建生成的文件
            </td>
        </tr>
        <tr>
            <td>
                post-clean
            </td>
            <td>
                    执行清理后需要完成的工作
            </td>
        </tr>
</table>

### default生命周期  
default生命周期定义了真正构建时需要的所有步骤。
<table>
        <tr>
            <td>
                validate
            </td>
            <td>
                验证项目是正确的，所有必要的信息是可用的
            </td>
        </tr>
        <tr>
            <td>
                initialize
            </td>
            <td>
                初始化构建状态，例如：设置属性或创建目录
            </td>
        </tr>
        <tr>
            <td>
                generate-sources
            </td>
            <td>
                生成编译期的源代码。
            </td>
        </tr>
        <tr >
            <td >
                process-sources
                <br>
            </td>
            <td>
                    处理项目主资源文件。一般来说是对src/main/resources目录内容</br>
                    进行变量替换等工作后，复制到项目输出的主目录classpath目录中
            </td>
        </tr>
        <tr>
            <td>
                generate-resources
            </td>
            <td>
                生成包含在打包过程中的资源
            </td>
        </tr>
        <tr>
            <td>
                process-resources
                <br>
            </td>
            <td>
                复制和处理资源到目标目录，准备打包
            </td>
        </tr>
        <tr>
            <td>
                compile
            </td>
            <td>
                编译项目的源代码
            </td>
        </tr>
        <tr>
            <td>
                process-classes
            </td>
            <td>
                处理编译后生成的class文件
            </td>
        </tr>
        <tr>
            <td>
                generate-test-sources
            </td>
            <td>
                生成编译期内的测试源代码
            </td>
        </tr>
        <tr>
            <td>
                process-test-sources
            </td>
            <td>
                处理测试源代码，如过滤一些值
            </td>
        </tr>
        <tr>
            <td>
                generate-test-resources
            </td>
            <td>
                创建测试资源
            </td>
        </tr>
        <tr>
            <td>
                process-test-resources
            </td>
            <td>
                复制测试资源到目标目录并处理
            </td>
        </tr>
        <tr>
            <td>
                test-compile
            </td>
            <td>
                编译测试源代码到测试目标目录
            </td>
        </tr>
        <tr>
            <td>
                process-test-classes
            </td>
            <td>
                处理编译测试代码后生成的class文件
            </td>
        </tr>
        <tr>
            <td>
                test
            </td>
            <td>
                    使用合适的单元测试框架运行测试。 这些测试代码不会被打包和
                    部署
            </td>
        </tr>
        <tr>
            <td>
                prepare-package
            </td>
            <td>
                执行打包前需要的任何工作
            </td>
        </tr>
        <tr>
            <td>
                package
            </td>
            <td>
                接收编译好的代码，打包成可发布的格式，如jar，war等
            </td>
        </tr>
        <tr>
            <td>
                pre-integration-test
            </td>
            <td>
                执行集成测试之前所需的操作
            </td>
        </tr>
        <tr>
            <td>
                integration-test
            </td>
            <td>
                如果需要，可以将软件包处理和部署到可以运行集成测试的环境中
            </td>
        </tr>
        <tr>
            <td>
                post-integration-test
            </td>
            <td>
                执行集成测试之后所需的操作
            </td>
        </tr>
        <tr>
            <td>
                verify
            </td>
            <td>
                运行任何检查以验证程序包是否有效并符合质量标准
            </td>
        </tr>
        <tr>
            <td>
                install
            </td>
            <td>
                将程序包安装到maven本地仓库，供本地其他maven项目使用
            </td>
        </tr>
        <tr>
            <td>
                deploy
            </td>
            <td>
                将最终包复制到远程仓库，供其它开发人员和maven项目使用
            </td>
        </tr>
</table>

### site生命周期
site生命周期的作用是建立和发布项目站点。 
<table>
        <tr>
            <td>
                pre-site
            </td>
            <td>
                执行一些在生成项目站点之前所需要完成的工作
            </td>
        </tr>
        <tr>
            <td>
                site
            </td>
            <td>
                生成项目站点文档
            </td>
        </tr>
        <tr>
            <td>
                post-site
            </td>
            <td>
                执行一些在生成项目站点之后需要完成的工作
            </td>
        </tr>
        <tr>
            <td>
                site-deploy
            </td>
            <td>
                将生成的项目站点发布到服务器上
            </td>
        </tr>
</table>  

> maven生命周期是相互依赖的关系，如执行 `mvn clean`命令时，会执行pre-clean，clean阶段；执行`mvn deploy`会执行default生命周期前面的所有阶段。

## 插件目标
maven生命周期的各个阶段是和插件绑定在一起的，一个插件可以包含多个功能，每个功能对应生命周期的一个阶段，并称其为插件目标。如：`maven-dependency-plugin`包含插件目标：dependency：tree，dependency：list，dependency：analyze等。  

## 内置绑定插件
maven在核心为一些主要的生命周期绑定了许多插件目标：

clean生命周期阶段与插件绑定情况：
<table>
        <tr>
            <th>
                生命周期阶段
            </th>
            <th>
                插件目标
            </th>
        </tr>
        <tr>
            <td>
                pre-clean
            </td>
            <td rowspan="3">
                    maven-clean-plugin:clean
            </td>
        </tr>
        <tr>
            <td>
                clean
            </td>
        </tr>
        <tr>
            <td>
                post-clean
            </td>
        </tr>
</table>

default生命周期阶段与插件绑定情况及具体任务：
<table>
        <tr>
            <th>
                生命周期阶段
            </th>
            <th>
                插件目标
            </th>
            <th>
                执行任务
            </th>
        </tr>
        <tr>
            <td>
                process-resources
            </td>
            <td>
                maven-resources-plugin:resources
            </td>
            <td>
                
                    复制主资源文件到输出
                
                
                    目录
                
            </td>
        </tr>
        <tr>
            <td>
                compile
            </td>
            <td>
                maven-compiler-plugin:compile
            </td>
            <td>
                
                    编译主代码到输出目录
                
            </td>
        </tr>
        <tr>
            <td>
                process-test-resources
            </td>
            <td>
                maven-resources-plugin:testResources
            </td>
            <td>
                
                    复制测试资源文件到输
                
                
                    出目录
                
            </td>
        </tr>
        <tr>
            <td>
                test-compile
            </td>
            <td>
                maven-compiler-plugin:testCompile
            </td>
            <td>
                
                    编译测试代码到输出目
                
                
                    录
                
            </td>
        </tr>
        <tr>
            <td>
                test
            </td>
            <td>
                maven-surefire-plugin:test
            </td>
            <td>
                执行测试用例
            </td>
        </tr>
        <tr>
            <td>
                package
            </td>
            <td>
                maven-jar-plugin:jar
            </td>
            <td>
                创建项目jar包
            </td>
        </tr>
        <tr>
            <td>
                install
            </td>
            <td>
                maven-install-plugin:install
            </td>
            <td>
                
                    将项目输出构件安装到
                
                
                    本地仓库
                
            </td>
        </tr>
        <tr>
            <td>
                deploy
            </td>
            <td>
                maven-deploy-plugin:deploy
            </td>
            <td>
                
                    将项目输出构件部署到
                
                
                    远程仓库
                
            </td>
        </tr>
</table>

site生命周期阶段与插件绑定情况：
<table>
        <tr>
            <th>
                生命周期阶段
            </th>
            <th>
                插件目标
            </th>
        </tr>
        <tr>
            <td>
                pre-site
            </td>
            <td rowspan="3">
                    maven-site-plugin:site
            </td>
        </tr>
        <tr>
            <td>
                site
            </td>
        </tr>
        <tr>
            <td>
                post-site
            </td>
        </tr>
        <tr>
            <td>
                site-deploy
            </td>
            <td>
                maven-site-plugin:deploy
            </td>
        </tr>
</table>

如，对项目执行 `mvn clean install` 命令：
```xml
--- maven-clean-plugin:2.5:clean (default-clean) @ viswcm-project ---
[INFO] Deleting D:\workspace\viswcm-project\target
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ viswcm-project ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:2.5.1:compile (default-compile) @ viswcm-project ---
[INFO] Compiling 20 source files to D:\workspace\viswcm-project\target\classes
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ viswcm-project ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory D:\workspace\viswcm-project\src\test\resources
[INFO] 
[INFO] --- maven-compiler-plugin:2.5.1:testCompile (default-testCompile) @ viswcm-project ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ viswcm-project ---
[INFO] No tests to run.
[INFO] 
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ viswcm-project ---
[INFO] Building jar: D:\workspace\viswcm-project\target\viswcm-project-0.0.1-SNAPSHOT.jar
[INFO] 
[INFO] --- maven-install-plugin:2.4:install (default-install) @ viswcm-project ---
[INFO] Installing D:\workspace\viswcm-project\target\viswcm-project-0.0.1-SNAPSHOT.jar to D:\64\m2\repository\com\visgreat\viswcm-project\0.0.1-SNAPSHOT\viswcm-project-0.0.1-SNAPSHOT.jar
[INFO] Installing D:\workspace\viswcm-project\pom.xml to D:\64\m2\repository\com\visgreat\viswcm-project\0.0.1-SNAPSHOT\viswcm-project-0.0.1-SNAPSHOT.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```
其输出结果和上面的表格描述一致。
## 自定义插件绑定
除了maven内置绑定，我们还可以自行绑定某个插件到某个生命周期的某个阶段。

比如要生成项目源码jar包，我们可以将maven-source-plugin插件配置到default生命周期的verify阶段：
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-source-plugin</artifactId>
            <version>2.1.1</version>
            <executions>
                <execution>
                    <id>attach-sources</id>
                    <phase>verify</phase>
                    <goals>
                        <goal>jar-no-fork</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```
上述配置描述了maven-source-plugin插件坐标外，还有插件执行配置executions元素下的每个execution子元素可以用来配置执行一个任务。这里配置了一个id为attach-sources的任务，通过phase元素，将其绑定到verify阶段上，再通过goals配置指定执行的插件目标。

运行`mvn verify`：
```xml
[INFO] --- maven-source-plugin:2.1.1:jar-no-fork (attach-sources) @ viswcm-project ---
﻿[INFO] Building jar: D:\workspace\viswcm-project\target\viswcm-project-0.0.1-SNAPSHOT-sources.jar
```
## 获取插件信息
maven官方插件：[http://maven.apache.org/plugins/index.html](http://maven.apache.org/plugins/index.html)

maven官方插件下载地址：[http://repo1.maven.org/maven2/org/apache/maven/plugins/](http://repo1.maven.org/maven2/org/apache/maven/plugins/)
## 配置插件仓库
```xml
<pluginRepositories>
    <pluginRepository>
        <id>central</id>
        <name>Maven.Plugin.Repository</name>
        <url>http://repo1.maven.org/maven2</url>
        <layout>default</layout>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
        <releases>
            <updatePolicy>never</updatePolicy>
        </releases>
    </pluginRepository>
</pluginRepositories>
```

> [《Maven实战》](https://book.douban.com/subject/5345682/)读书笔记  