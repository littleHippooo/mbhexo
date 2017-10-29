---
title: Spring条件化装配Bean
date: 2017-01-16 09:51:29
tags: Spring
---
Spring4引入了@Conditional注解，可配合@Bean或者@Component注解一起使用。

用CET4考试来演示@Conditional注解。

新建考试结果Result接口：
```java
public interface Result {
    public void getResult();
}
```
<!--more-->
实现类CET4：
```java
public class CET4 implements Result{
    public void getResult() {
        System.out.println("恭喜你通过CET4");
    }
}
```
定义学生接口：
```java
public interface Student {
    public void exam();
}
```
实现类XiaoMing：
```java
public class XiaoMing implements Student{
    //注入result
    @Autowired(required=false)
    private Result result;
    
    public void exam() {
        if(result == null) System.out.println("抱歉，CET4未通过");
        else result.getResult();
    }
}
```
配置JavaConfig：
```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Conditional;
import org.springframework.context.annotation.Configuration;
 
@Configuration
public class ConditionConfig {
    @Bean
    @Conditional(ResultCondition.class)
    public Result result(){
        return new CET4();
    }
    @Bean(name="xiaoming")
    public Student student(){
        return new XiaoMing();
    }
}
```
可以看到，@Conditional中给定了一个Class，它指明了条件——在本例中，也就是ResultCondition：
```java
import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;
 
public class ResultCondition implements Condition{
 
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        Environment env = context.getEnvironment();
        //获取环境变量中的result属性
        String result = env.getProperty("result");
        if("success".equals(result)) return true;
        else return false;
    }
}
```
设置给`@Conditional`的类可以是任意实现了Condition接口的类型。可以看出来，这个接口实现起来很简单直接，只需提供matches()方法的实现即可。如果matches()方法返回 true，那么就会创建带有@Conditional注解的bean。如果matches()方法返回false，将不会创建这些bean。

ConditionContext是一个接口，大致如下所示：
```java
public interface conditioncontext{
    BeanDefinitionRegistry getRegistry();
    ConfigurableListableBeanFactory getBeanFactory();
    ResourceLoader getResourceLoader();
    Environment getEnvironment();
    ClassLoder getClassLoader();
}
```
通过ConditionContext，我们可以做到如下几点：

1.借助getRegistry()返回的BeanDefinitionRegistry检查bean定义；

2.借助getBeanFactory()返回的ConfigurableListableBeanFactory检查bean是否存在，甚至探查bean的属性；

3.借助getEnvironment()返回的Environment检查环境变量是否存在以及它的值是什么；

4.读取并探查getResourceLoader()返回的ResourceLoader所加载的资源；

5.借助getClassLoader()返回的ClassLoader加载并检查类是否存在。

AnnotatedTypeMetadata则能够让我们检查带有@Bean注解的方法上还有什么其他的注解。像ConditionContext一样，AnnotatedTypeMetadata也是一个接口。它如下所示：
```java
public interface AnnotatedTypeMetadata{
    boolean isAnnotated(String annotationType);
    Map<String,Object> getAnnotationAttributes(String annotationType);
    Map<String,Object> getAnnotationAttributes(
            String annotationType,boolean classValuesAsString);
    MutilValueMap<String,Object> getAllAnnotationAttributes(
            String annotationType);
    MutilValueMap<String,Object> getAllAnnotationAttributes(
            String annotationType,boolean classValuesAsString);
}    
```
借助isAnnotated()方法，我们能够判断带有@Bean注解的方法是不是还有其他特定的注解。借助其他的那些方法，我们能够检查@Bean注解的方法上其他注解的属性。

现在测试@Conditional注解的作用：
```java
public class TestConditional {
    public static void main(String[] args) {
        System.setProperty("result", "fail");
        ApplicationContext ac = new AnnotationConfigApplicationContext(ConditionConfig.class); 
        Student xiaoming = (Student) ac.getBean("xiaoming");
        xiaoming.exam();
    }
}
```
这里设置result为fail，ResultCondition的matches()方法返回false，所以CET4 Bean并不会被创建，结果应该输出“抱歉，CET4未通过”，测试结果：
```xml
抱歉，CET4未通过
```