---
title: Spring混合装配Bean
date: 2017-01-16 08:58:22
tags: Spring
---
Spring可以通过Java代码以及XML配置来装配Bean，不仅如此，Spring还可以混合这两种装配方法。
## JavaConfig中引入XML配置
去除@ComponentScan注解，让所有的Bean显示配置。

创建一个DriverConfig配置类，里面只装配一个“laosiji”Bean：
```java
@Configuration
public class DriverConfig {
    @Bean(name="laosiji")
    public Driver driver(){
        return new LaoSiJi();
    }
}
```
<!--more-->
创建一个car-config.xml配置，在里面使用xml方式配置Car Bean：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:c="http://www.springframework.org/schema/c"
  xsi:schemaLocation="http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans.xsd">
 
    <bean id="wulinghongguang" class="mrbird.leanote.javaconfig.WuLing"
        c:_-ref="laosiji"/>
</beans>
```
最后创建一个MainConfig配置类，引入CarConfig以及car-config.xml配置：
```java
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.ImportResource;
import org.springframework.test.context.ContextConfiguration;
 
@ContextConfiguration
//导入DriverConfig配置类
@Import(DriverConfig.class)
//JavaConfig中引入XML配置
@ImportResource("classpath:car-config.xml")
public class MainConfig {
	
}
```
测试是否注入成功：
```java
@RunWith(SpringJUnit4ClassRunner.class)
//导入MainConfig配置类
@ContextConfiguration(classes=MainConfig.class)
public class CarTest {
    @Autowired
    @Qualifier("wulinghongguang")
    private Car car;
    @Autowired
    private Driver driver;
    @Test
    public void drive(){
        assertNotNull(car);
        car.drive();
        assertNotNull(driver);
        driver.drive();
    }
}
```
测试通过，页面输出：
```xml
快上车，来不及解释了
快上车，来不及解释了
```
## XML配置中引入JavaConfig
创建一个main-config.xml，里面分别引入DriverConfig以及car-config.xml：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:c="http://www.springframework.org/schema/c"
  xsi:schemaLocation="http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean class="mrbird.leanote.javaconfig.DriverConfig"/>
    <import resource="car-config.xml"/>
</beans> 
```
测试：
```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:main-config.xml")
public class CarTest {
    @Autowired
    @Qualifier("wulinghongguang")
    private Car car;
    @Autowired
    private Driver driver;
    @Test
    public void drive(){
        assertNotNull(car);
        car.drive();
        assertNotNull(driver);
        driver.drive();
    }
}
```
测试通过，输出如上。

