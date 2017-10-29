---
title: Spring注入外部值
date: 2017-01-17 09:33:56
tags: Spring
---
Spring注入外部文件的值有几种方式：   
## Spring Environment  
在Spring中，处理外部值的最简单方式就是声明属性源并通过Spring的Environment来检索属性。

声明一个Phone接口：
```java
public interface Phone {
    public void phoneMsg();
}
```
<!--more-->
实现类GooglePixel：
```java
public class GooglePixel implements Phone{
    private String name;
    private String cpu;
    private String battery;
	
    public GooglePixel(String name, String cpu, String battery) {
        this.name = name;
        this.cpu = cpu;
        this.battery = battery;
    }
 
    public void phoneMsg() {
        System.out.println(name+"，cpu型号："+cpu+"，电池容量："+battery);
    }
}
```
创建一个外部配置类：googlePixel.properties：
```xml
phone.name=Google Pixel
phone.battery=2770mAh
phone.cpu=Qualcomm Xiaolong 821
```
在JavaConfig中加载外部配置，并用Spring的Environment对象获取：
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
 
@Configuration
//加载外部配置文件
@PropertySource("classpath:/mrbird/leanote/properties/googlePixel.properties")
public class PhoneConfig {
    //注入Spring环境对象
    @Autowired
    private Environment env;
    @Bean(name="googlePixel")
    public Phone phone(){
        return new GooglePixel(
            env.getProperty("phone.name"),
            env.getProperty("phone.cpu"),
            env.getProperty("phone.battery"));
    }
}
```
测试是否注入成功：
```java
public class Test {
    public static void main(String[] args) {
        ApplicationContext ac = new AnnotationConfigApplicationContext(PhoneConfig.class); 
        Phone googlePixel = (Phone) ac.getBean("googlePixel");
        googlePixel.phoneMsg();
    }
}
```
控制台输出：
```xml
Google Pixel，cpu型号：Qualcomm Xiaolong 821，电池容量：2770mAh
```
getProperty()方法并不是获取属性值的唯一方法，getProperty()方法有四个重载的变种形式：
```java
String getProperty(String key)
String getProperty(String key,String defaultValue)
T getProperty(String key,Class<T> type)
T getProperty(Stirng key,Class<T> type,T defaultValue)
```
前两种形式的getProperty()方法都会返回String类型的值。上面的栗子使用第一种getProperty()方法。稍微对@Bean方法进行一下修改，这样在指定属性不存在的时候，会使用一个默认值：
```java
@Bean(name="googlePixel")
    public Phone phone(){
        return new GooglePixel(
            env.getProperty("phone.name","谷歌Pixel"),
            env.getProperty("phone.cpu","高通枭龙821"),
            env.getProperty("phone.battery","2770毫安时"));
    }
```
剩下的两种getProperty()方法与前面的两种非常类似，但是它们可以传入类型。

Environment还提供了几个与属性相关的方法，如果你在使用getProperty()方法的时候 没有指定默认值，并且这个属性没有定义的话，获取到的值是null。如果你希望这个属性必须要定义，那么可以使用getRequiredProperty()方法，如下所示：
```java
@Bean(name="googlePixel")
    public Phone phone(){
        return new GooglePixel(
            env.getRequiredProperty("phone.name"),
            env.getRequiredProperty("phone.cpu"),
            env.getRequiredProperty("phone.battery"));
    }
```
在这里，如果phone.name或phone.cpu或phone.battery属性没有定义的话，将会抛出 IllegalStateException异常。

如果想检查一下某个属性是否存在的话，那么可以调用Environment的 containsProperty()方法：
```java
boolean nameExists = env.containsProperty("phone.name");
```
## 属性占位符  
创建一个phone-config.xml文件，使用Spring context命名空间中的<context:propertyplaceholder>元素生成`PropertySourcesPlaceholderConfigurer bean`：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:c="http://www.springframework.org/schema/c"
    xmlns:context="http://www.springframework.org/schema/context" 
    xmlns:util="http://www.springframework.org/schema/util" 
    xsi:schemaLocation="http://www.springframework.org/schema/beans 
            http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
            http://www.springframework.org/schema/context
            http://www.springframework.org/schema/context/spring-context-4.3.xsd">
	<context:property-placeholder 
	    location="classpath:/mrbird/leanote/properties/googlePixel.properties"/>
	<bean id="googlePixel" class="mrbird.leanote.javaconfig.GooglePixel" 
            c:name="${phone.name}" 
            c:cpu="${phone.cpu}" 
            c:battery="${phone.battery}"/>
</beans>
```
测试：
```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:phone-config.xml")
public class Test {
    @Autowired
    @Qualifier("googlePixel")
    private Phone phone;
    @Test
    public void drive(){
        assertNotNull(phone);
        phone.phoneMsg();
    }
}
```
输出结果同上。

或者不用XML显示配置Bean，开启自动扫描，使用注解注入属性值：
```xml
<!-- 开启扫描 -->
<context:component-scan base-package="mrbird.leanote.javaconfig"/>
```
GooglePixel类属性注入：
```java
@Component
public class GooglePixel implements Phone{
    @Value("${phone.name}")
    private String name;
    @Value("${phone.cpu}")
    private String cpu;
    @Value("${phone.battery}")
    private String battery;
    
    public GooglePixel(String name, String cpu, String battery) {
        this.name = name;
        this.cpu = cpu;
        this.battery = battery;
    }
    
    public void phoneMsg() {
        System.out.println(name+"，cpu型号："+cpu+"，电池容量："+battery);
    }
}
```
或者构造器注入：
```java
...
public GooglePixel(
    @Value("${phone.name}")String name,
    @Value("${phone.cpu}")String cpu, 
    @Value("${phone.battery}")String battery) {
        this.name = name;
        this.cpu = cpu;
        this.battery = battery;
}
...
```
## util:properties

在phone-config.xml文件中：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:c="http://www.springframework.org/schema/c"
    xmlns:context="http://www.springframework.org/schema/context" 
    xmlns:util="http://www.springframework.org/schema/util" 
    xsi:schemaLocation="http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.3.xsd
        http://www.springframework.org/schema/util
        http://www.springframework.org/schema/util/spring-util-4.3.xsd">
    <util:properties id="p" 
        location="classpath:/mrbird/leanote/properties/googlePixel.properties"/>
    <bean id="googlePixel" class="mrbird.leanote.javaconfig.GooglePixel" 
            c:name="#{p['phone.name']}" 
            c:cpu="#{p['phone.cpu']}" 
            c:battery="#{p['phone.battery']}"/>
</beans>
```
{% note danger %}和占位符区别是，这里需要用spEL表达式获取属性的值，并且不能写为："#{p.phone.name}"，这样Spring读取不到属性值，将会抛出异常。{% endnote %}

使用注解配置和占位符类似，比如set注入：
```java
...
@Value("#{p['phone.name']}")
private String name;
@Value("#{p['phone.cpu']}")
private String cpu;
@Value("#{p['phone.battery']}")
private String battery;
...
```
或者使用systemProperties来代替p：
```java
...
@Value("#{systemProperties['phone.name']}")
private String name;
@Value("#{systemProperties['phone.cpu']}")
private String cpu;
@Value("#{systemProperties['phone.battery']}")
private String battery;
...
```
## some：
XML
```xml
<context:property-placeholder location="classpath:....properties"/>  
<context:component-scan base-package=""/> 
<import resource="classpath:....xml"/>
```
注解：
```java
@PropertySource(value = "classpath:....properties")
@ComponentScan(basePackages = "")
@ImportResource(value = {"classpath:....xml"})
```
