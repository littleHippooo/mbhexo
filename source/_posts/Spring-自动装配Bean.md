---
title: Spring 自动装配Bean
date: 2016-10-02 18:56:35
tags: Spring
---
为了简化XML配置，Spring提供了自动装配（autowiring）。
## 四种类型自动装配
### byName自动装配
byName自动装配遵循约定：为属性自动装配ID与该属性的名字相同的Bean。例如，将先前的kenny例子：
```xml
<bean id="kenny" class="com.spring.entity.Instrumentalist">
    <property name="instrument" ref="saxophone"></property>
    <property name="song" value="May Rain"/>
</bean>
```
<!--more-->
改为：
```xml
<bean id="kenny" class="com.spring.entity.Instrumentalist" autowire="byName">
    <property name="song" value="May Rain"/>
</bean> 
```
通过`autowire`属性，Spring就可以利用此信息自动装配kenny的剩下的instrument属性了。

配置一个id为"instrument"的Bean：
```xml
<bean id="instrument" class="com.spring.entity.Saxophone"/>
```
这样，saxophone就自动装配给kenny的instrument属性了。当找不到时，则该属性不进行装配。

如果多个Instrumentalist Bean都被配置为byName自动装配，那他们将会演奏同一个乐器。
### byType自动装配
byType自动装配通过寻找哪一个Bean的类型与属性的类型相匹配。如果找到多个与需要装配的属性类型相匹配的Bean，Spring会直接抛出异常。所以，应用只允许存在一个类型相匹配的Bean。但在实际中，XML中可能存在多个类型一样的Bean，为了解决这种情况，Spring提供了两种解决方法：

① 为自动装配标识一个首选Bean

使用`<bean>`元素的primary属性。如果只有一个自动装配的候选Bean的primary属性设置为true，那么其将被优先选择。比如设置saxophone为首选Bean：
```xml
<bean id="saxophone" class="com.spring.entity.Saxophone" primary="true"/>
```
也可以使用`@Primary`注解。
② 取消某个Bean自动装配的候选资格

使用方法为设置Bean的`autowire-candidate`属性为false即可：
```xml
<bean id="saxophone" class="com.spring.entity.Saxophone" autowire-candidate="false"/>
```
### constructor自动装配
如果通过构造器注入配置Bean，那么可以移除`<constructor-arg>`元素。如将先前的duke配置：
```xml
<bean id="duke" class="com.spring.entity.Juggler" autowire="constructor"/>
```
通过`autowire="constructor"`声明，Spring会去获取Juggler某个构造器的所有参数类型，然后再XML中寻找与其类型匹配的Bean。so，constructor自动装配与byType自动装配具有相同的局限性。
### autodetect自动装配
> detect 英[dɪˈtekt] 美[dɪˈtɛkt] vt. 查明，发现; 洞察; 侦察，侦查; [电子学] 检波

```xml
<bean id="duke" class="com.spring.entity.Juggler" autowire="autodetect"/> 
```
通过该声明，Spring首次尝试使用constructor自动装配，失败的话再次尝试使用byType自动装配。
## 默认自动装配
通过配置`<beans>`元素上增加一个`default-autowire`属性：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context" 
	xmlns:util="http://www.springframework.org/schema/util"  
	xmlns:jee="http://www.springframework.org/schema/jee" 
	xmlns:tx="http://www.springframework.org/schema/tx"
	xmlns:jpa="http://www.springframework.org/schema/data/jpa" 
	xmlns:mvc="http://www.springframework.org/schema/mvc"
	xsi:schemaLocation="
    	http://www.springframework.org/schema/beans
    	http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
    	http://www.springframework.org/schema/context
    	http://www.springframework.org/schema/context/spring-context-3.2.xsd
    	http://www.springframework.org/schema/util
    	http://www.springframework.org/schema/util/spring-util-3.2.xsd
    	http://www.springframework.org/schema/jee
    	http://www.springframework.org/schema/jee/spring-jee-3.2.xsd
    	http://www.springframework.org/schema/tx
    	http://www.springframework.org/schema/tx/spring-tx-3.2.xsd
    	http://www.springframework.org/schema/data/jpa
    	http://www.springframework.org/schema/data/jpa/spring-jpa-1.3.xsd
    	http://www.springframework.org/schema/mvc
    	http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd"
        default-autowire="byType">
    <!--Bean declarations go here -->
</beans> 
```
这样的话，Spring配置文件里的所有Bean都将使用byType自动装配，除非Bean自己配置了autowire属性。
## 混合装配
一个Bean可以同时使用自动装配和显示装配，如：
```xml
<bean id="kenny" 
    class="com.spring.entity.Instrumentalist" autowire="byType">
    <property name="song" value="May Rain"/>
    <property name="instrument" ref="saxophone"></property>
</bean>
```
混合使用可以避免当自动装配失败的时候，使用显示装配覆盖自动装配。
{% note danger %}使用constructor自动装配时，不能混合使用constructor自动装配策略和<constructor-arg>元素。{% endnote %}
## 使用注解装配
```xml
<context:annotation-config/>
```
> annotation 英[ˌænə'teɪʃn] 美[ˌænə'teɪʃn] n. 注释;

`<context:annotation-config/>`可以消除Spring中的`<property>`和`<constructor-arg>`元素。注意，我们还是得使用`<bean>`元素显示定义Bean。
### @Autowired
例如，在Instrumentalist的`setInstrument()`方法进行标注：
```java
//注入乐器
@Autowired
public void setInstrument(Instrument instrument) {
    this.instrument = instrument;
}
```
这样，我们可以移除用来定义Instrumentalist的instrument属性所对应的`<property>`元素了。通过`@Autowired`注解，Spring会通过byType自动装配。

假如`@Autowired`注解标注于属性，我们可以删除setter方法：
```java
@Autowired
private Instrument instrument;
```
`@Autowired`也可以标注于构造器，这样XML文件中可以省去`<constructor-arg>`元素配置Bean：
```java
@Autowired
public Instrumentalist(Instrument instrument) {
    this.instrument=instrument;
}
```
当多个构造器都通过@Autowired注解的时候，Spring就会从所有满足装配条件的构造器中选择出参数最多的那个。

**可选的自动装配：**

通过`@Autowired`标注的属性或者参数必须是可装配的。假如匹配失败，则抛出`NoSuchBeanDefinitionException`异常。假如属性不一定要装配，`null`值也可以接收的话，我们可以设置`required=fasle`来让自动装配变为可选：
```java
@Autowired(required=false)
private Instrument instrument;
```
当使用构造器装配时，只有一个构造器可以将`@Autowired`的quruired属性设置为true，其余的只能设置为false。

**限定歧义性依赖：**

如果通过`@Autowired`注解匹配到好几个Bean，为了鉴别哪一个是我们需要的，我们可以在`@Autowired`注解下添加`@Qualifier`注解：

> qualifier 英[ˈkwɒlɪfaɪə(r)] 美[ˈkwɑ:lɪfaɪə(r)] n. 合格者，已取得资格的人; [语] 修饰语; 预选赛，资格赛

```java
@Autowired
@Qualifier("guitar")
private Instrument instrument;
```
如上所示，`@Qualifier`注解将尝试注入ID为"guitar"的Bean。

除了通过Bean的ID来匹配，我们还可以修改guitar Bean配置：
```xml
<bean class="com.spring.entity.Guitar">
    <qualifier value="Stringed"/>
</bean>
```
`<qualifier>`元素限定了guitar Bean是一个弦乐器(stringed)。这时候可以将上面的注解修改为：
```java
@Autowired
@Qualifier("Stringed")
private Instrument instrument;
```
创建自定义的限定器：

首先，通过如下代码创建自定义的限定器：
```java
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.springframework.beans.factory.annotation.Qualifier;
 
@Target({ElementType.FIELD,ElementType.PARAMETER,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface StringedInstrument {
 
}   
```
这样，我们在guitar类上添加此限定器：
```java
@StringedInstrument
public class Guitar implements Instrument{
    public void play() {
        System.out.println("弹奏吉他");
    }	
}  
```
在自动装配的instrument属性进行限定：
```java
@Autowired
@StringedInstrument
private Instrument instrument;
```
这样guitar就会被装配的instrument属性里！

假如匹配到多个Bean，需要进一步的缩小范围，继续定义自定义限定器即可！
### @Inject
Maven依赖：
```xml
<!-- https://mvnrepository.com/artifact/javax.inject/javax.inject -->
<dependency>
    <groupId>javax.inject</groupId>
    <artifactId>javax.inject</artifactId>
    <version>1</version>
</dependency>
```
为了规范各种依赖注入框架的编程模型，JCP(Java Community Process)发布了Java依赖注入规范，简称为JCR-330。Spring 3.0开始兼容该依赖注入模型。`@Inject`注解几乎可以完全替代`@Autowired`。如：
```java
@Inject
private Instrument instrument;
```
`@Inject`也可以标注于属性，方法和构造器，不过`@Inject`没有required属性，所以`@Inject`注解所标注的依赖关系必须存在，否则抛出异常。

**限定@Inject所标注的属性**

类似于前面的`@Qualifier`，`@Inject`所对应的是`@Named`注解：
```java
@Inject
@Named("piano")
private Instrument instrument;
```
**创建自定义的JSR-330 Qualifier**

通过下面的代码创建一个新的`@NewStringedInstrument`注解：
```java
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import javax.inject.Qualifier;
 
@Target({ElementType.FIELD,ElementType.PARAMETER,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface NewStringedInstrument {
 
}
```
和前面的自定义限定器唯一的区别就是@Qualifier注解的导入声明。

**在注解中使用SpEL表达式**

Spring3.0 引入了`@Value`，其可以注解装配String类型和基本类型的值。比如，我们通过`@Value`注解传入一个String类型的值：
```java
@Value("May Rain")
private String song;
```
这样"May Rain"就被注入到song属性中了。

我们还可以结合SpEL表达式：
```java
@Value("#{systemProperties.myFavoriteSong}")
private String song;
```
### @Resource
Maven依赖：
```xml
<!-- https://mvnrepository.com/artifact/javax.annotation/jsr250-api -->
<dependency>
    <groupId>javax.annotation</groupId>
    <artifactId>jsr250-api</artifactId>
    <version>1.0</version>
</dependency>
```
`@Resource`注解是JSR-250发布的注解。与`@Autowired`和`@Inject`不同的是，`@Resource`注解不能用于构造器！`@Resource`注解默认使用byName自动装配！

`@Resource`有两个中重要的属性：name和type ，而Spring将`@Resource`注解的name属性解析为bean的 名字，而type属性则解析为bean的类型。所以如果使用name属性，则使用byName的自动注入策略，而使用type属性时则使用 byType自动注入策略。如果既不指定name也不指定type属性，这时将通过反射机制使用byName自动注入策略。

byName：
```java
@Resource(name="piano")
private Instrument instrument;
```
byType：
```java
@Resource(type=Instrument.class)
private Instrument instrument;
```

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记
  