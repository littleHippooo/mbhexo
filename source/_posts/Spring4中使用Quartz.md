---
title: Spring4中使用Quartz
date: 2017-08-02 11:40:58
tags: [Quartz,Spring]
---
Spring提供了几个类用于简化在Spring中使用Quartz任务调度。这里使用的Spring版本为4.3.5，Quartz版本为2.2.1。

除了搭建Spring MVC的几个依赖外，还需引入：
```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-support</artifactId>
    <version>4.3.5.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-tx</artifactId>
    <version>4.3.5.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz</artifactId>
    <version>2.2.1</version>
</dependency>
```
<!--more-->
## 在Quartz Scheduler中配置Job
新建一个quartz-context.xml，用于配置Job，触发器等信息。通常使用MethodInvokingJobDetailFactoryBean来配置Job：
```xml
<bean id="simpleJobDetail" class="org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean">
    <property name="targetObject" ref="simpleJob" />
    <property name="targetMethod" value="printMessage" />
</bean>
```
`targetObject`制定调用的Bean，`targetMethod`指定调用的方法。

simpleJob Bean如下：
```java
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Component;

@Component("simpleJob")
public class SimpleJob {
    public void printMessage() {
        System.out.println("SimpleJob,triggered is "+
            new SimpleDateFormat("HH:mm:ss").format((new Date())));
    }
}
```
## 在Quartz Scheduler中配置触发规则
两种方式配置触发规则：

**SimpleTrigger**
```xml
<bean id="simpleTrigger"  class="org.springframework.scheduling.quartz.SimpleTriggerFactoryBean">
    <property name="jobDetail" ref="simpleJobDetail" />
    <property name="startDelay" value="1000" />
    <property name="repeatInterval" value="2000" />
</bean>
```
**CronTrigger**
```xml
<bean id="cronTrigger"  class="org.springframework.scheduling.quartz.CronTriggerFactoryBean">
    <property name="jobDetail" ref="simpleJobDetail" />
    <property name="cronExpression" value="0/5 * * * * ?" />
</bean>
```
## 配置SchedulerFactoryBean
使用SchedulerFactoryBean将jobDetails和triggers配置在一起：
```xml
<bean  class="org.springframework.scheduling.quartz.SchedulerFactoryBean">
    <property name="jobDetails">
        <list>
            <ref bean="simpleJobDetail" />
        </list>
    </property>
 
    <property name="triggers">
        <list>
            <ref bean="simpleTrigger" />
        </list>
    </property>
</bean> 
```
完整的quartz-context.xml配置如下：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
        http://www.springframework.org/schema/context 
        http://www.springframework.org/schema/context/spring-context-4.0.xsd">
    <context:component-scan base-package="cc.mrbird.scheduling" />
                           
    <bean id="simpleJobDetail" class="org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean">
        <property name="targetObject" ref="simpleJob" />
        <property name="targetMethod" value="printMessage" />
    </bean>                           
<!--     <bean id="simpleTrigger"  class="org.springframework.scheduling.quartz.SimpleTriggerFactoryBean"> -->
<!-- 	    <property name="jobDetail" ref="simpleJobDetail" /> -->
<!-- 	    <property name="startDelay" value="1000" /> -->
<!-- 	    <property name="repeatInterval" value="2000" /> -->
<!-- 	</bean> -->
    
    <bean id="cronTrigger" class="org.springframework.scheduling.quartz.CronTriggerFactoryBean">
        <property name="jobDetail" ref="simpleJobDetail" />
        <property name="cronExpression" value="0/5 * * * * ?" />
    </bean>     
    
    <bean class="org.springframework.scheduling.quartz.SchedulerFactoryBean">
        <property name="jobDetails">
            <list>
                <ref bean="simpleJobDetail" />
            </list>
        </property>
    
        <property name="triggers">
            <list>
                <ref bean="cronTrigger" />
            </list>
        </property>
    </bean>     
</beans>
```
在web.xml中加入quartz-context.xml启动项：
```xml
...
<init-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:applicationContext.xml,classpath:quartz-context.xml</param-value>
</init-param>
...
```
部署项目，启动后控制台输出：
```xml
SimpleJob,triggered is 17:43:35
SimpleJob,triggered is 17:43:40
SimpleJob,triggered is 17:43:45
SimpleJob,triggered is 17:43:50
SimpleJob,triggered is 17:43:55
SimpleJob,triggered is 17:44:00
SimpleJob,triggered is 17:44:05
SimpleJob,triggered is 17:44:10
SimpleJob,triggered is 17:44:15
SimpleJob,triggered is 17:44:20
SimpleJob,triggered is 17:44:25
SimpleJob,triggered is 17:44:30
SimpleJob,triggered is 17:44:35
SimpleJob,triggered is 17:44:40
...
```
> 参考自[http://websystique.com/spring/spring-4-quartz-scheduler-integration-example/](http://websystique.com/spring/spring-4-quartz-scheduler-integration-example/)