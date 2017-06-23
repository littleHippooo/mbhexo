---
title: Java代码装配Bean
date: 2017-01-14 10:02:25
tags: Spring
---
除了可以使用XML配置Bean外，还可以使用Java代码来装配Bean。
## 准备工作
创建Maven项目，加入如下依赖：
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-core</artifactId>
        <version>4.3.5.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>4.3.2.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-test</artifactId>
        <version>4.3.5.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>com.github.stefanbirkner</groupId>
        <artifactId>system-rules</artifactId>
        <version>1.16.0</version>
    </dependency>
</dependencies>
```
<!--more-->
## 创建Bean
创建Driver接口：
```java
public interface Driver {
    public void drive();
} 
```
其实现类LaoSiJi：
```java
public class LaoSiJi implements Driver{
    public void drive() {
        System.out.println("快上车，来不及解释了");
    }
}
```
给老司机分配一辆车，定义Car接口：
```java
public interface Car {
    public void drive();
}
```
其实现类五菱宏光：
```java
public class WuLing implements Car{
    private Driver driver;
    // 通过构造器注入老司机
    @Autowired
    public WuLing(Driver driver) {
        this.driver = driver;
    }
    public void drive() {
        driver.drive();
    }
}
```
## 创建配置类
配置类中可以显示的配置Bean，也可以采用自动扫描的方法来简化配置。
### 显示配置：
```java
import mrbird.leanote.javaconfig.Car;
import mrbird.leanote.javaconfig.CarConfig;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
 
@Configuration
public class CarConfig {
    //显示配置driver和car
    @Bean
    public Driver driver(){
        return new LaoSiJi();
    }
    @Bean
    public Car car(Driver driver){
        return new WuLing(driver);
    }
}
```
### 自动扫描：
自动扫描的话稍微修改配置类：
```java
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
 
@Configuration
@ComponentScan
public class CarConfig {
}
```
然后在上面创建的Bean类上添加@Component注解，让Spring发现并注入到配置类中。
## 测试
测试是否注入成功：
```java
import mrbird.leanote.javaconfig.Car;
import mrbird.leanote.javaconfig.CarConfig;
import static org.junit.Assert.*;
import org.junit.Rule;
import org.junit.Test;
import org.junit.contrib.java.lang.system.StandardOutputStreamLog;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
 
@RunWith(SpringJUnit4ClassRunner.class)
//加载配置类
@ContextConfiguration(classes=CarConfig.class)
public class CarTest {
    @Rule
    public final StandardOutputStreamLog log = new StandardOutputStreamLog();
    @Autowired
    private Car car;
    @Test
    public void drive(){
        assertNotNull(car);
        car.drive();
    }
}
```
输出：
```xml
快上车，来不及解释了
```
