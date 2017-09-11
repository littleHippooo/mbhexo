---
title: 使用m2eclipse创建maven项目
date: 2016-10-17 15:13:37
tags: maven
---
## 新建maven项目
新建一个maven project，填写Group Id，Artifact Id：   

![16134997-file_1487994560154_1694e.png](img/16134997-file_1487994560154_1694e.png)

点击finish后项目目录下自动生成了pom.xml文件（Project Object Model，项目对象模型）：
<!--more-->
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>mrbird.leanote.com</groupId>
  <artifactId>hello_maven</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>jar</packaging>
 
  <name>hello_maven</name>
  <url>http://maven.apache.org</url>
 
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>
 
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.7</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
</project>
```
`<groupId>`定义了项目属于哪个组，一般为公司域名加组名。

`<artifactId>`定义了当前maven项目在组中的唯一id。

`<version>`定义了当前项目的版本。

`<name>`定义了更为友好的项目名称。

`<dependencies>`包含一个或多个`<dependency>`，上面代码添加了一个依赖——groupId为junit，artifactId为junit，version为4.7。通过这段声明，maven能够自动下载junit-4.7.jar。
## 编写主代码
在src/main/java目录下的mrbird.leanote.com.hello_maven包下新建HelloMaven.java：
```java
public class HelloMaven {
 
    public String sayHello(){
        return "Hello Maven";
    }
    
    public static void main(String[] args){
        System.out.print( new HelloMaven().sayHello() );
    }
}
```
进行maven进行编译，右击项目→Run As→Maven build...：    

![96208298-file_1487994585491_62a8.png](img/96208298-file_1487994585491_62a8.png)

然后点击run：
```xml
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building hello_maven 0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ hello_maven ---
[INFO] Deleting F:\workspaces\Spring\hello_maven\target
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello_maven ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory F:\workspaces\Spring\hello_maven\src\main\resources
[INFO] 
[INFO] --- maven-compiler-plugin:2.5.1:compile (default-compile) @ hello_maven ---
[INFO] Compiling 1 source file to F:\workspaces\Spring\hello_maven\target\classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.443s
[INFO] Finished at: Mon Oct 17 13:12:43 CST 2016
[INFO] Final Memory: 11M/115M
[INFO] ------------------------------------------------------------------------
```
clean告诉maven清理输出目录target/，compile告诉maven编译项目主代码。从上面的输出可以看出，maven首先执行了celan任务，删除target/目录。接着执行resource任务，将项目主代码编译至F:\workspaces\Spring\hello_maven\target\classes目录。  
## 编写测试代码  
在src/test/java目录下的mrbird.leanote.com.hello_maven包下新建HelloMavenTest.java：
```java
public class HelloMavenTest{
    @Test
    public void testSayHello()
    {
        HelloMaven helloMaven = new HelloMaven();
        String result = helloMaven.sayHello();
        assertEquals( "Hello Maven", result );
    }
}
```
调用maven执行测试，右击项目→Run As→Maven build...输入clean test→run：
```xml
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building hello_maven 0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ hello_maven ---
[INFO] Deleting F:\workspaces\Spring\hello_maven\target
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ hello_maven ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory F:\workspaces\Spring\hello_maven\src\main\resources
[INFO] 
[INFO] --- maven-compiler-plugin:2.5.1:compile (default-compile) @ hello_maven ---
[INFO] Compiling 1 source file to F:\workspaces\Spring\hello_maven\target\classes
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ hello_maven ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory F:\workspaces\Spring\hello_maven\src\test\resources
[INFO] 
[INFO] --- maven-compiler-plugin:2.5.1:testCompile (default-testCompile) @ hello_maven ---
[INFO] Compiling 1 source file to F:\workspaces\Spring\hello_maven\target\test-classes
[INFO] 
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ hello_maven ---
[INFO] Surefire report directory: F:\workspaces\Spring\hello_maven\target\surefire-reports
 
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running mrbird.leanote.com.hello_maven.HelloMavenTest
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.056 sec
 
Results :
 
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.794s
[INFO] Finished at: Mon Oct 17 13:32:08 CST 2016
[INFO] Final Memory: 13M/151M
[INFO] ------------------------------------------------------------------------
```
测试通过。
## 打包运行
compile和test之后，执行package。右击项目→Run As→Maven build...输入clean package→run：
```xml
...
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running mrbird.leanote.com.hello_maven.HelloMavenTest
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.078 sec
 
Results :
 
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
 
[INFO] 
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ hello_maven ---
[INFO] Building jar: F:\workspaces\Spring\hello_maven\target\hello_maven-0.0.1-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 4.254s
[INFO] Finished at: Mon Oct 17 13:53:15 CST 2016
[INFO] Final Memory: 13M/139M
[INFO] ------------------------------------------------------------------------
```
打包成功，已经生成了jar包。

如果要让别的maven项目能够引用HelloMaven，则还需执行 clean install：
```xml
...
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running mrbird.leanote.com.hello_maven.HelloMavenTest
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.064 sec
 
Results :
 
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
 
[INFO] 
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ hello_maven ---
[INFO] Building jar: F:\workspaces\Spring\hello_maven\target\hello_maven-0.0.1-SNAPSHOT.jar
[INFO] 
[INFO] --- maven-install-plugin:2.4:install (default-install) @ hello_maven ---
[INFO] Installing F:\workspaces\Spring\hello_maven\target\hello_maven-0.0.1-SNAPSHOT.jar to C:\Users\Administrator\.m2\repository\mrbird\leanote\com\hello_maven\0.0.1-SNAPSHOT\hello_maven-0.0.1-SNAPSHOT.jar
[INFO] Installing F:\workspaces\Spring\hello_maven\pom.xml to C:\Users\Administrator\.m2\repository\mrbird\leanote\com\hello_maven\0.0.1-SNAPSHOT\hello_maven-0.0.1-SNAPSHOT.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 4.486s
[INFO] Finished at: Mon Oct 17 14:01:13 CST 2016
[INFO] Final Memory: 14M/138M
[INFO] ------------------------------------------------------------------------
```
该操作会将该项目打包后的jar和pom文件拷贝到本地maven仓库。

因为主方法中有main方法，默认打包生成的jar包是不能运行的，如：
```xml
F:\workspaces\Spring\hello_maven>java -jar target/hello_maven-0.0.1-SNAPSHOT.jar
target/hello_maven-0.0.1-SNAPSHOT.jar中没有主清单属性
```
为了生成可执行的jar，需要借助maven-shade-plugin，在pom中配置：
```xml
<build>
<plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-shade-plugin</artifactId>
      <version>1.2.1</version>
      <executions>
        <execution>
          <phase>package</phase>
          <goals>
            <goal>shade</goal>
          </goals>
          <configuration>
            <transformers>
              <transformer 
              implementation="org.apache.maven.plugins.shade.
                              resource.ManifestResourceTransformer">
               <mainClass>mrbird.leanote.com.hello_maven.HelloMaven</mainClass>
              </transformer>
            </transformers>
          </configuration>
        </execution>
      </executions>
    </plugin>
</plugins>
</build>
```
配置mainClass为mrbird.leanote.com.hello_maven.HelloMaven。再次执行clean install操作，然后执行jar：
```xml
F:\workspaces\Spring\hello_maven>java -jar target/hello_maven-0.0.1-SNAPSHOT.jar
Hello Maven
```

> [《Maven实战》](https://book.douban.com/subject/5345682/)读书笔记  