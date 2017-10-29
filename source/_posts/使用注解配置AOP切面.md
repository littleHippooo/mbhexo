---
title: 使用注解配置AOP切面
date: 2016-10-05 17:45:51
tags: Spring
---
## 注解切面    
除了使用XML配置AOP切面，我们还可以使用更简洁的注解配置。

现使用注解修改Audience类：

<!--more-->
```java
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
@Component
@Aspect
public class Audience {
    // 声明切点
    @Pointcut("execution(* com.spring.entity.Performer.perform(..))")
    public void performance(){
    	
    }
    // 表演之前
    @Before("performance()")
    public void takeSeats(){
    	System.out.println("观众入座");
    }
    // 表演之前
    @Before("performance()")
    public void turnOffCellPhones(){
    	System.out.println("关闭手机");
    }
    // 表演之后
    @AfterReturning("performance()")
    public void applaud(){
    	System.out.println("啪啪啪啪啪");
    }
    // 表演失败后
    @AfterThrowing("performance()")
    public void failure(){
    	System.out.println("坑爹，退钱！");
    }
}
```
`@Aspect`使得Audience成为了切面。

为了让Spring识别改注解，我们还需在XML中添加`<aop:aspectj-autoproxy/>`。`<aop:aspectj-autoproxy/>`将在Spring应用上下文中创建一个`AnnotationAwareAspectJAutoProxyCreator`类，它会自动代理`@Aspect`标注的Bean：
```xml
<aop:aspectj-autoproxy proxy-target-class="true" />
```
实例化kenny，输出：
```xml
观众入座
关闭手机
唱：May Rain
吹萨克斯
啪啪啪啪啪
和XML配置AOP效果一样。
```
在这途中遇到错误：
```xml
：error at ::0 can't find referenced pointcut XXX
```
网络上的说法是JDK不匹配造成的，

我原来用的JDK1.7匹配的是aspectjrt.1.6和aspectjweaver.1.6,因此会报错。 如果要使用AspectJ完成注解切面需要注意下面的JDK与AspectJ的匹配：

JDK1.6 —— aspectJ1.6

JDK1.7 —— aspectJ1.7.3+

> aspectJ1.7下载链接：[密码：6wd7](http://pan.baidu.com/s/1pLrlXTD)

## 注解环绕通知
使用@Around注解环绕通知：
```java
@Component
@Aspect
public class Audience {
    // 声明切点
    @Pointcut("execution(* com.spring.entity.Performer.perform(..))")
    public void performance(){
    	
    }
    @Around("performance()")
    public void watch(ProceedingJoinPoint joinpoint){
        try{
            System.out.println("观众入座");
            System.out.println("关闭手机");
            long start=System.currentTimeMillis();
            // 执行被通知的方法！
            joinpoint.proceed();
            long end=System.currentTimeMillis();
            System.out.println("啪啪啪啪啪");
            System.out.println("表演耗时："+(end-start)+" milliseconds");
        }catch(Throwable t){
            System.out.println("坑爹，退钱！");
        }
    }
}
```
实例化kenny，输出：
```xml
观众入座
关闭手机
唱：May Rain
吹萨克斯
啪啪啪啪啪
表演耗时：30 milliseconds   
```
## 注解传递参数
修改Magician类： 
```java
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
@Component
@Aspect
public class Magician implements MindReader{
    private String thoughts;
    // 声明参数化切点
    @Pointcut("execution(* com.spring.entity."
    	      + "Thinker.thinkOfSomething(String)) && args(thoughts)")
    public void thinking(String thoughts) {
    	
    }
    // 把参数传递给通知
    @Before("thinking(thoughts)")
    public void interceptThoughts(String thoughts) {
    	System.out.println("侦听志愿者的心声");
    	this.thoughts=thoughts;
    }	
    public String getThoughts() {
    	return thoughts;
    }
}  
```
`<aop:pointcut>`变为`@Pointcut`注解，`<aop:before>`变为`@Before`注解。

测试：
```java
public class TestIntercept {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        Volunteer volunteer = (Volunteer) ac.getBean("volunteer");
        volunteer.thinkOfSomething("演出真精彩！");
        Magician magician = (Magician) ac.getBean("magician");
        System.out.println("志愿者心里想的是："+magician.getThoughts());
    }
}   
```
输出：
```xml
侦听志愿者的心声
志愿者心里想的是：演出真精彩！
```
## 通过注解引入新的方法
之前通过在XML中配置AOP切面的方法为Bean引入新的方法，现在改用注解的方式来实现：

新建一个ContestantIntroducer类：
```java
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.DeclareParents;
import org.springframework.stereotype.Component;
@Component
@Aspect
public class ContestantIntroducer {
 
    @DeclareParents(
      value = "com.spring.entity.Performer+", 
      defaultImpl = OutstandingContestant.class)
    public static Contestant contestant;
}  
```
`@DeclareParents`注解代替了之前的`<aop:declare-parents>`标签。 `@DeclareParents`注解由三个部分组成：

1.value属性等同于`<aop:declare-parents>`的types-matching属性。它标识应该被引入指定接口的Bean。

2.defaultImpl属性等同于`<aop:declare-parents>`的default-impl属性。它标识该类所引入接口的实现。

3.由`@DeclareParents`注解所标注的static属性制订了将被引入的接口。

测试：
```java
public class Play {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        Instrumentalist kenny = (Instrumentalist)ac.getBean("kenny");
        kenny.perform();
        Contestant kenny1=(Contestant) ac.getBean("kenny");
        kenny1.receiveAward();
    }
}  
```
输出：
```xml
观众入座
关闭手机
唱：May Rain
吹萨克斯
啪啪啪啪啪
表演耗时：27 milliseconds
参加颁奖典礼
```

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记