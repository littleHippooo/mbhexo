---
title: Spring 构造器注入
date: 2016-09-24 09:30:46
tags: Spring
---
从Spring3.0开始，Spring可以通过注解的方式来配置Bean。这里先介绍以传统的XML配置式来配置Bean。

用一场选秀比赛来模拟Spring装备Bean过程。 

一场比赛中，需要一些参赛者来参加比赛，为此我们定义一个Performer接口：
```java
public interface Performer {
    public void perform();
} 
```
<!--more-->

参赛选手都实现了这个Performer接口。

以下为一个典型的Spring XML配置文件(Spring容器，Spring上下文)：
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
    	http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd">
    <!--Bean declarations go here -->
</beans>
```
在`<beans>`元素内，我们可以配置所有Spring配置信息以及`<bean>`元素的声明。除此之外，Spring还自带了包括`<beans>`在内的10大命名空间：
<table>
        <tr>
            <th>
                命名空间
            </th>
            <th>
                用途
            </th>
        </tr>
        <tr>
            <td>
                aop
            </td>
            <td>
                为声明切面以及将@AspectJ注解的类代理为Spring切面提供了配置元素
            </td>
        </tr>
        <tr>
            <td>
                beans&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                支持声明Bean和装配Bean，是Spring最核心也是最原始的命名空间
            </td>
        </tr>
        <tr>
            <td>
                context
            </td>
            <td>
                <p>
                    为配置Spring应用上下文提供了配置元素，包括自动检测和自动装配Bean，注入非Spring直
                </p>
                <p>
                    接管理的对象
                </p>
            </td>
        </tr>
        <tr>
            <td>
                jee&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                提供了与Java EE API的集成，例如JNDI和EJB
            </td>
        </tr>
        <tr>
            <td>
                jms
            </td>
            <td>
                为声明消息驱动的POJO提供了配置元素
            </td>
        </tr>
        <tr>
            <td>
                lang
            </td>
            <td>
                支持配置由Groovy，JRuby或BeanShell等脚本实现的Bean
            </td>
        </tr>
        <tr>
            <td>
                mvc
            </td>
            <td>
                启动Spring MVC的能力，例如面向注解的控制器，视图控制器和拦截器
            </td>
        </tr>
        <tr>
            <td>
                oxm
            </td>
            <td>
                支持Spring的对象到XML映射配置
            </td>
        </tr>
        <tr>
            <td>
                tx
            </td>
            <td>
                提供声明事务配置
            </td>
        </tr>
        <tr>
            <td>
                util
            </td>
            <td>
                提供各种各样的工具类元素，包括把集合配置为Bean，支持属性占位符元素
            </td>
        </tr>
</table>

回归比赛，第一位参赛者是一个Juggler(杂技师)，声明一个Juggler Bean：
```java
public class Juggler implements Performer{
    private int beanBags=3;
    
    public Juggler() {
    	
    }
    public Juggler(int beanBags) {
        this.beanBags = beanBags;
    }
    public void perform() {
        System.out.println("throws "+beanBags+" beanBags");
    }
}
```
Juggler实现了Performer接口，默认可以同时抛出三个豆袋子。也可以通过有参构造器改变袋子数量。

现在有请第一位叫duke的杂技师上场！在applicationContext.xml文件中配置Duke：
```xml
<bean id="duke" class="com.spring.entity.Juggler"/>
```
id表明他叫duke，class表明他是一个juggler。现在让duke上台表演：
```java
public class Show {
    public static void main(String[] args) {
        String conf="applicationContext.xml";
        ApplicationContext ac=new ClassPathXmlApplicationContext(conf);
        Juggler duke=(Juggler)ac.getBean("duke");
        duke.perform(); //扔了 3 个豆袋子
    }
}
```
## 构造器注入
评委觉得这并没有什么难度，于是duke决定一次性扔15个豆袋子！修改duke`<bean>`的配置：
```xml
<bean id="duke" class="com.spring.entity.Juggler">
    <constructor-arg value="15" />
</bean>
```
也可以使用`c-`命名空间代替`<constructor-arg>`标签，要使用它的话，现在XML顶部声明其模式：
```xml
xmlns:c="http://www.springframework.org/schema/c"
```
上面的配置可以改为：
```xml
<bean id="duke" class="com.spring.entity.Juggler" c:beanBags="15">
```
或者：
```xml
<bean id="duke" class="com.spring.entity.Juggler" c:_0="15">
```
像这种只有一个参数的话也可以写为：
```xml
<bean id="duke" class="com.spring.entity.Juggler" c:_="15">
```
Juggler类有两个构造器，无参和有参。当没有声明`<constructor-arg>`的时候，Spring将默认使用无参的构造方法。现在，我们将`<constructor-arg>`的value设置位15的时候，Spring使用有参构造方法来改变属性beanBags的值。

再次表演，输出：
```xml
扔了 15 个豆袋子
掌声雷动。
```
稍等！duke说他还会边扔袋子变朗诵诗歌！为此我们定义一个PoeticJuggler（会朗诵的杂技师）：
```java
public class PoeticJuggler extends Juggler{
    //诗歌属性
    private Poem poem;
    public PoeticJuggler(Poem poem) {
        this.poem = poem;
    }
    
    public PoeticJuggler(int beanBags,Poem poem) {
        //继承豆袋子属性
        super(beanBags);
        this.poem = poem;
    }
    public void perform(){
        //继承扔袋子技能
        super.perform();
        System.out.println("边朗诵...");
        //朗诵诗歌
        poem.recite();
    }
}
```
诗歌接口：
```java
public interface Poem {
    public void recite();
}
```
duke最喜欢的是普希金的《假如生活欺骗了你》，为此我们定义一个DeceivedByLife类，实现Poem接口：
```java
public class DeceivedByLife implements Poem{
    private static String[] LINES = {
        "假如生活欺骗了你，",
        "不要悲伤，不要心急！",
        "忧郁的日子里须要镇静：",
        "相信吧，快乐的日子将会来临！",
        "心儿永远向往着未来；",
        "现在却常是忧郁。",
        "一切都是瞬息，一切都将会过去；",
        "而那过去了的，就会成为亲切的怀恋"};
    public DeceivedByLife(){
    
    }
    //朗诵诗歌
    public void recite() {
        for(int i=0;i<LINES.length;i++){
            System.out.println(LINES[i]);
        }
    }
 
}
```
在Spring容器里配置这首诗歌：
```xml
<bean id="deceivedByLife" class="com.spring.entity.DeceivedByLife"/>
```
现在duke是一个poeticJuggler了，为此我们修改duke的`<bean>`配置：
```xml
<bean id="poeticDuke" class="com.spring.entity.PoeticJuggler">
    <constructor-arg value="15"/>
    <constructor-arg ref="deceivedByLife"/>
</bean>
```
`c-`命名空间写法：
```xml
<bean id="poeticDuke" class="com.spring.entity.PoeticJuggler"
    c:_beanBags="15" 
    c:_poem-ref="deceivedByLife"/>
```
或者：
```xml
<bean id="poeticDuke" class="com.spring.entity.PoeticJuggler"
    c:_0="15" 
    c:_1-ref="deceivedByLife"/>
```
当Sping碰到deceivedByLife和poeticDuke的`<bean>`声明时，它所执行的逻辑本质和下面的Java代码是一样的：
```java
Poem deceivedByLife = new DeceivedByLife();
Performer duke = new PoeticJuggler(15,deceivedByLife);
```
现在，duke再次进行了表演： 
```java
public class Show {
    public static void main(String[] args) {
        String conf="applicationContext.xml";
        ApplicationContext ac=new ClassPathXmlApplicationContext(conf);
        Juggler duke=(PoeticJuggler)ac.getBean("poeticDuke");
        duke.perform();
    }
}
```
输出：
```xml
扔了 15 个豆袋子
边朗诵...
假如生活欺骗了你，
不要悲伤，不要心急！
忧郁的日子里须要镇静：
相信吧，快乐的日子将会来临！
心儿永远向往着未来；
现在却常是忧郁。
一切都是瞬息，一切都将会过去；
而那过去了的，就会成为亲切的怀恋
```
掌声再次雷动。
## 通过工厂方法创建Bean
有时候，一个类没有公开的构造方法，这时候就不能使用构造器注入了。Spring支持`<bean>`元素的`factory-method`方法来装配Bean。

创建一个舞台类：
```java
public class Stage {
    private Stage(){
    	
    }
    //延迟加载实例
    public static class stageSingletonHolder{
        static Stage instance=new Stage();
    }
    //返回实例
    public static Stage getInstance(){
        return stageSingletonHolder.instance;
    }
    public void createStage(){
        System.out.println("创造一个舞台");
    }
}
```
Stage作为一个单例类，没有公开的构造方法，相反，静态方法`getInstance()`每次调用都返回一个相同的Stage实例。

`<bean>`元素的`factory-method`属性允许我们调用一个静态方法，从而代替构造方法来创建一个类的实例。

在Spring上下文中配置Stage`<bean>`：
```xml
<bean id="stage" class="com.spring.entity.Stage" factory-method="getInstance"/>
```
现在从Spring容器中获取这个`<bean>`：
```java
public class CreateStage {
    public static void main(String[] args) {
        String conf="applicationContext.xml";
        ApplicationContext ac=new ClassPathXmlApplicationContext(conf);
        Stage stage=(Stage)ac.getBean("stage");
        stage.createStage();
    }
}
```
输出：
```xml
创造一个舞台
```
## Bean作用域
所有Spring Bean默认都是单例的。如果现在要创建一个"门票"类，每个人的门票肯定是不一样的。为了让Spring每次请求都产生一个新的实例，我们可以定义如下ticket`<bean>`：
```xml
<bean id="ticket" class="com.spring.entity.Ticket" scope="prototype"/>
```
除了prototype，Spring还提供了其他几个作用域选项：
<table>
        <tr>
            <th>
                作用域
            </th>
            <th>
                定义
            </th>
        </tr>
        <tr>
            <td>
                singleton
            </td>
            <td>
                在每一个spring容器中，一个Bean定义只有一个对象实例（默认）
            </td>
        </tr>
        <tr>
            <td>
                prototype
            </td>
            <td>
                允许Bean的定义可以被实例化任意次（每次调用都创建一个新的实例）
            </td>
        </tr>
        <tr>
            <td>
                request
            </td>
            <td>
                在一次HTTP请求中，每个Bean定义对应一个实例。该作用域仅在基于Web的Spring上下文中才有效
            </td>
        </tr>
        <tr>
            <td>
                session
            </td>
            <td>
                在一个HTTP Session中，每个Bean定义对应一个实例。该作用域仅在基于Web的Spring上下文中才有效
            </td>
        </tr>
        <tr>
            <td>
                global-session
            </td>
            <td>
                在一个全局HTTP Session中，每个Bean定义对应一个实例。该作用域仅在Protlet上下文中才有效
            </td>
        </tr>
</table>

Spring的单例Bean只能保证在每个应用上下文中只有一个Bean实例。没有人能够阻止你使用传统的方式实例化同一个Bean，或者你甚至可以定义几个<bean>声明来实例化同一个Bean。
## 初始化和销毁Bean
为Bean定义初始化和销毁操作，只需要使用`init-method`和`destroy-method`参数来配置`<bean>`元素。init-method属性指定了在初始化Bean时要调用的方法。destroy-method属性指定了Bean从容器移除之前要调用的方法。

现在定义一个灯光类Light：
```java
public class Light {
    void turnOnTheLight(){
        System.out.println("开灯");
    }
    void turnOffTheLight(){
        System.out.println("关灯");
    }
} 
```
在容器中配置该Bean：
```xml
<bean id="light" class="com.spring.entity.Light"
        init-method="turnOnTheLight" destroy-method="turnOffTheLight"/>
```
加载容器，以此来实例化light：
```java
public class LightControl {
    public static void main(String[] args) {
        String conf="applicationContext.xml";
        //加载容器
        ApplicationContext ac=new ClassPathXmlApplicationContext(conf);
        //关闭容器
        ((ClassPathXmlApplicationContext)ac).close();
    }
}
```
输出：
```xml
开灯
...
关灯
```
我们还可以定义默认的init-method和destroy-method。如果上下文中Bean定义了名字相同的初始化和销毁方法，我们可以统一配置default-init-method和default-destroy-method：
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
        default-init-method="turnOnTheLight" 
        default-destroy-method="turnOffTheLight">
    <!--Bean declarations go here -->
</beans>
```
为Bean定义初始化和销毁的方法是让Bean实现Spring的InitializingBean和DisposableBean接口。InitializingBean声明了一个afterPropertiesSet()方法作为初始化方法。DisposableBean声明了一个destroy()方法作为销毁方法。在Spring容器中无需任何配置。

修改Light类：
```java
public class Light implements InitializingBean,DisposableBean{
    public void afterPropertiesSet() throws Exception {
        System.out.println("开灯");
    }
    public void destroy() throws Exception {
        System.out.println("关灯");
    }
}﻿​
```

{% note danger%}这种方法的缺点显而易见了：实现Spring的接口意味着Bean与Spring的API产生了耦合。所以这种方法并不推荐！{% endnote %}

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记