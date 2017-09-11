---
title: Spring中使用@Scheduled注解任务调度
date: 2017-08-04 11:41:06
tags: Spring
---
spring-context包里提供的@Scheduled注解可以很方便的实现定时任务，在引入spring-context依赖后，在Spring xmlns中加入：
```xml
xmlns:task="http://www.springframework.org/schema/task"
```
然后在xsi:schemaLocation中加入：
```xml
http://www.springframework.org/schema/task
http://www.springframework.org/schema/task/spring-task-4.3.xsd
```
<!--more-->
定义一个类，包含定时执行的方法：
```java
package cc.mrbird.timer;

import java.text.SimpleDateFormat;
import java.util.Date;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class Timer {
	
    @Scheduled(cron="0/5 * * * * ?")
    public void test(){
        System.out.println("SimpleJob,triggered is "+
            new SimpleDateFormat("HH:mm:ss").format((new Date())));
    }
}
```
Timer类用@Component注解标注，以纳入Spring容器中。定时调用的方法使用@Scheduled标志，并用cron表达式定义了定时执行的规则。
接下来在Spring上下文配置中启动扫描，加载定时器：
```xml
<!-- 开启组件扫描 -->
<context:component-scan base-package="cc.mrbird"/>
<!-- spring 定时器 加载 -->
<task:annotation-driven />
```
启动项目，输出：
```xml
SimpleJob,triggered is 14:33:10
SimpleJob,triggered is 14:33:15
SimpleJob,triggered is 14:33:20
SimpleJob,triggered is 14:33:25
SimpleJob,triggered is 14:33:30
SimpleJob,triggered is 14:33:35
SimpleJob,triggered is 14:33:40
SimpleJob,triggered is 14:33:45
SimpleJob,triggered is 14:33:50
SimpleJob,triggered is 14:33:55
SimpleJob,triggered is 14:34:00
SimpleJob,triggered is 14:34:05
...
```