---
title: Spring 自动检测Bean
date: 2016-10-03 18:41:52
tags: Spring
---
## 开启自动检测
开启自动检测Bean有两种方式：
### XML配置
`<context:annotation-config>`虽然消除了`<property>`和`<constructor-arg>`元素，但我们仍需使用`<bean>`元素显示定义Bean。

`<context:component-scan>`除了完成与`<context:annotation-config>`一样的工作还可以自动检测Bean和定义Bean。在Spring XML中配置：
```xml
<context:component-scan base-package="com.spring.entity">
</context:component-scan>﻿
```
<!--more-->
base-package指定了扫描的路径。
### Java配置
```java
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
 
@Configuration
@ComponentScan
public class InstrumentConfig{
}   
```
`@ComponentScan`会扫描与该类相同包下的所有带有`@Component`注解的类。

如果想明确指出扫描路径，可以配置value：
```java
@ComponentScan(basePackages="com.spring")
```
也可以配置多个扫描路径：
```java
@ComponentScan(basePackages={"com.spring.entity","com.spring.dao"})
```
除了指定扫描路径，我们也可以指定扫描的类型：
```java
@ComponentScan(basePackageClasses={Piano.class,Guitar.class})
```
为自动检测标注Bean    
## 注解类型：
`@Component` —— 通用的构造型注解，标识该类为Spring组件。

`@Controller` —— 标识将该类定义为Spring MVC Controller组件。

`@Repository` —— 标识将该类定义为数据仓库。

`@Service` —— 标识将该类定义为服务。

通过标注这些注解，Spring才知道哪些类要被注册为Spring Bean。如，使用`@Component`标注Guitar类：
```java
@Component
public class Guitar implements Instrument{
    public void play() {
        System.out.println("弹奏吉他");
    }	
}
```
Spring扫描`com.spring.entity`包时，会发现使用`@Component`注解所标注的Guitar，并自动将其注册为Spring Bean。Bean的ID默认为无限定首字母小写类名，也就是guitar。

我们也可以显式设定ID：
```java
@Component("kenny")
public class Instrumentalist implements Performer{
    @Value("May Rain")
    private String song;
    @Autowired
    @Qualifier("guitar")
    private Instrument instrument;
    public Instrumentalist() {
    	
    }
    public void perform() {
        System.out.println("唱："+song+"");
        instrument.play();
    }
    //注入歌曲
    public String getSong() {
        return song;
    }
    public void setSong(String song) {
        this.song = song;
    }
    public Instrument getInstrument() {
        return instrument;
    }
    //注入乐器
    public void setInstrument(Instrument instrument) {
        this.instrument = instrument;
    }
}
```
也可以使用`@Named("kenny")`代替`@Component("kenny")`，但一般我们还是使用`@Component("kenny")`比较直观。

然后实例化kenny Bean：
```java
public class Play {
    public static void main(String[] args) {
        ApplicationContext ac
                = new ClassPathXmlApplicationContext("applicationContext.xml");
        Instrumentalist kenny=(Instrumentalist)ac.getBean("kenny");
        kenny.perform();
    }
}
```
输出：
```xml
唱：May Rain
弹奏吉他
```
现在在XML中没有任何`<bean>`元素，也实现了和先前一样的效果。在这个过程中，遇到了两个问题：
```xml
Exception in thread "main" org.springframework.beans.factory.BeanDefinitionStoreException:
    Failed to read candidate component class:
    file [F:\workspaces\Spring\Spring2\build\classes\com\spring\entity\Guitar.class];
    nested exception is org.springframework.core.NestedIOException: 
    ASM ClassReader failed to parse class file - 
    probably due to a new Java class file version that isn't supported yet: 
    file [F:\workspaces\Spring\Spring2\build\classes\com\spring\entity\Guitar.class];
    nested exception is java.lang.IllegalArgumentException  
```
通过查阅资料，发现有位老外给出了解释：
{% note danger %}Note that the Java 8 bytecode level (-target 1.8, as required by -source 1.8) is only fully supported as of Spring Framework 4.0. In particular, Spring 3.2 based applications need to be compiled with a maximum of Java 7 as the target, even if they happen to be deployed onto a Java 8 runtime. Please upgrade to Spring 4 for Java 8 based applications.{% endnote %}

于是将jdk改为1.7版本。修改后又遇到异常：
```xml
Exception in thread "main" java.lang.UnsupportedClassVersionError:
    ...
```
原来是jdk版本和jvm版本不一致所致。右键项目-->properties-->java compiler --> Enable project specific settings -->将compiler compliance level设置为1.7，至此问题都解决了。
## 过滤组件扫描
`<context:component-scan>`默认扫描指定路径下通过`@Component`标注的Bean。假如现在我们只要把Instrument所派生的类注册为Spring Bean，我们不得不去查看所有java代码，一个一个的给Instrument派生类添加`@Component`注解，假如有第三方实现了Instrument，其源码我们还看不到，这时候添加`@Component`注解就变得非常困难甚至不可能。幸好，我们还可以给`<context:component-scan>`元素添加过滤行为：通过为其配置`<context:include-filter>`和`<context:exclude-filter>`子元素。比如：
```xml
<context:component-scan base-package="com.spring.entity">
    <context:include-filter type="assignable" 
        expression="com.spring.entity.Instrument"/>
    <context:exclude-filter type="annotation" 
        expression="com.spring.entity.SkipIt"/>
</context:component-scan>
```
其中，过滤器类型有5种：
<table>
        <tr>
            <th>
                
                    过滤器类型
                
            </th>
            <th>
                
                    描述
                
            </th>
        </tr>
        <tr>
            <td>
                annotation
            </td>
            <td>
                过滤器扫描使用指定注解所标注的那些类，通过expression属性指定要扫描的注解
            </td>
        </tr>
        <tr>
            <td>
                assignable
            </td>
            <td>
                过滤器扫描派生于expression属性所指定类型的那些类
            </td>
        </tr>
        <tr>
            <td>
                aspectj
            </td>
            <td>
                过滤器扫描与expression属性所指定的AspectJ表达式所匹配的那些类
            </td>
        </tr>
        <tr>
            <td>
                custom
            </td>
            <td>
                
                    使用自定义的org.springframework.core.type.TypeFilter实现类，该类由expression
                
                
                    属性指定
                
            </td>
        </tr>
        <tr>
            <td>
                regex
            </td>
            <td>
                过滤器扫描类的名称与expression属性所指定的正则表达式所匹配的类
            </td>
        </tr>
</table>

`com.spring.entity.SkipIt`自定义限定器：
```java
@Target({ElementType.FIELD,ElementType.PARAMETER,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface SkipIt {
 
}
```
`com.spring.entity`目录下有三个类派生于Instrument：Piano，Saxophone，Guitar。现在用`@SkipIt`标注Piano和Guitar类：
```java
@SkipIt
public class Piano implements Instrument{
    public void play() {
        System.out.println("钢琴声响起");
    }
}
```
```java
@SkipIt
public class Guitar implements Instrument{
    public void play() {
        System.out.println("弹奏吉他");
    }	
}
```
Saxophone不做任何标注：
```java
public class Saxophone implements Instrument{
    public void play() {
        System.out.println("吹萨克斯");
    }
}
```
实例化kenny，输出：
```html
唱：May Rain
吹萨克斯
```
非常方便！

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记
