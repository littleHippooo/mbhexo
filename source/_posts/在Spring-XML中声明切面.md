---
title: 在Spring XML中声明切面
date: 2016-10-05 11:24:55
tags: Spring
---
在Spring AOP中，需要使用AspectJ的切点表达式语言来定义切点。下表列出了Spring AOP所支持的AspectJ切点指示器：
<table>
        <tr>
            <th>
                    AspectJ指示器
            </th>
            <th>
                    描述
            </th>
        </tr>
        <tr>
            <td>
                arg()
            </td>
            <td>
                限制连接点匹配参数为指定类型的执行方法
            </td>
        </tr>
        <tr>
            <td>
                @args()
            </td>
            <td>
                限制连接点匹配参数由指定注解标注的执行方法
            </td>
        </tr>
        <tr>
            <td>
                execution()
            </td>
            <td>
                用于匹配是连接点的执行方法
            </td>
        </tr>
        <tr>
            <td>
                this()
            </td>
            <td>
                限制连接点匹配AOP代理的Bean引用的指定类型的类
            </td>
        </tr>
        <tr>
            <td>
                target()
            </td>
            <td>
                限制连接点匹配目标对象为执行类型的类
            </td>
        </tr>
        <tr>
            <td>
                @target()
            </td>
            <td>
                限制连接点匹配特定的执行对象，这些对象对应的类要具备指定类型的注解
            </td>
        </tr>
        <tr>
            <td>
                within()
            </td>
            <td>
                限制连接点匹配指定的类型
            </td>
        </tr>
        <tr>
            <td>
                @within()
            </td>
            <td>
                <p>
                    限制连接点匹配指定注解所标注的类型(当使用Spring AOP时，方法定义在由指定的
                </p>
                <p>
                    注解所标注的类里)
                </p>
            </td>
        </tr>
        <tr>
            <td>
                @annotation()
            </td>
            <td>
                限制匹配带有指定注解连接点
            </td>
        </tr>
</table>

<!--more-->
## 编写切点
如下所示的切点表达式表示当Instrument的`play()`方法执行时会触发通知。
```java
execution(* com.spring.entity.Instrument.play(..))    
```
使用`execution()`指示器选择Instrument的`play()`方法。方法表达式以`*`开始，表示返回任意类型的返回值。然后指定了全限定类名和方法名。对于参数列表`(..)`标识切点选择任意的`pay()`方法，无论方法的入参是什么。
## 使用Spring的Bean()指示器
Spring2.5引入了新的bean()指示器。如：
```java
execution(* com.spring.entity.Instrument.play()) and bean(eddie)
```
表示，执行Instrument的`play()`方法时应用通知，并且Bean的ID为eddie。
## XML中配置AOP
在Spring XML中配置AOP使用<aop>元素，下表概述了AOP配置元素。
<table>
        <tr>
            <th>
                    AOP配置元素
            </th>
            <th>
                    描述
            </th>
        </tr>
        <tr>
            <td>
                &lt;aop:advisor&gt;
            </td>
            <td>
                定义AOP通知器
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:after&gt;
            </td>
            <td>
                定义AOP后置通知(不管被通知的方法是否执行成功)
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:after-returning&gt;
            </td>
            <td>
                定义AOP after-returning通知
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:after-throwing&gt;
            </td>
            <td>
                定义AOP after-throwing通知
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:around&gt;
            </td>
            <td>
                定义AOP环绕通知
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:aspect&gt;
            </td>
            <td>
                定义切面
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:aspectj-autoproxy&gt;
            </td>
            <td>
                启用@AspectJ注解驱动切面
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:before&gt;
            </td>
            <td>
                定义AOP前置通知
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:config&gt;
            </td>
            <td>
                顶层的AOP配置元素
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:declare-parents&gt;
            </td>
            <td>
                为被通知的对象引入额外的接口，并透明的实现
            </td>
        </tr>
        <tr>
            <td>
                &lt;aop:pointcut&gt;
            </td>
            <td>
                定义切点
            </td>
        </tr>
</table>

为了演示Spring AOP，现在定义一个观众类 Audience：
```java
public class Audience {
    // 表演之前
    public void takeSeats(){
        System.out.println("观众入座");
    }
    // 表演之前
    public void turnOffCellPhones(){
        System.out.println("关闭手机");
    }
    // 表演之后
    public void applaud(){
        System.out.println("啪啪啪啪啪");
    }
    // 表演失败后
    public void failure(){
        System.out.println("坑爹，退钱！");
    }
}
```
在Spring XML中配置该Bean：
```xml
<bean id="audience" class="com.spring.entity.Audience"/>
```
## 声明前置和后置通知
将audience Bean变成一个切面：
```xml
<aop:config>
    <aop:aspect ref="audience">
        <aop:before pointcut=
            "execution(* com.spring.entity.Performer.perform(..))"
             method="takeSeats"/>
        <aop:before pointcut=
            "execution(* com.spring.entity.Performer.perform(..))"
             method="turnOffCellPhones"/>
        <aop:after-returning pointcut=
            "execution(* com.spring.entity.Performer.perform(..))"
             method="applaud"/>	
        <aop:after-throwing pointcut=
            "execution(* com.spring.entity.Performer.perform(..))"
             method="failure"/>
    </aop:aspect>
</aop:config>
```
四个切点的表达式完全一样，我们可以简化上述写法：
```xml
<aop:config>
    <aop:aspect ref="audience">
        <aop:pointcut id="performance" 
            expression="execution(* com.spring.entity.Performer.perform(..))"/>
        <aop:before pointcut-ref="performance"
            method="takeSeats"/>
        <aop:before pointcut-ref="performance"
            method="turnOffCellPhones"/>
        <aop:after-returning pointcut-ref="performance"
            method="applaud"/>	
        <aop:after-throwing pointcut-ref="performance"
            method="failure"/>
    </aop:aspect>
</aop:config>
```
再次实例化kenny：
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
结果发现报错：
```xml
Exception in thread "main" java.lang.ClassCastException: 
    com.sun.proxy.$Proxy8 cannot be cast to...
```
原因暂时还不晓得...😢解决办法，在`<aop:config>`元素添加`proxy-target-class="true"`：
```xml
<aop:config proxy-target-class="true">
    //...
</aop:config>
```
输出：
```xml
观众入座
关闭手机
唱：May Rain
吹萨克斯
啪啪啪啪啪
```
现在在Instrumentalist的`perform()`方法里制造一个异常：
```java
public void perform() {
    System.out.println("唱："+song+"");
    instrument = null;
    instrument.play();
}
```
实例化kenny输出：
```xml
观众入座
关闭手机
唱：May Rain
坑爹，退钱！
Exception in thread "main" java.lang.NullPointerException
```
## 声明环绕通知
如果不使用成员变量，那么在前置通知和后置通知之间共享信息是非常麻烦的。可以使用环绕通知代替前置通知和后置通知，现在在Audience类里添加一个新的方法：
```java
 public void watch(ProceedingJoinPoint joinpoint){
    try{
        System.out.println("观众入座");
        System.out.println("关闭手机");
        long start=System.currentTimeMillis();
        // 执行被通知的方法！
        joinpoint.proceed();
        
        long end=System.currentTimeMillis();
        System.out.println("啪啪啪啪啪");
        System.out.println("表演耗时："+(end-start)+"milliseconds");
    }catch(Throwable t){
        System.out.println("坑爹，退钱！");
    }
}  
```
对于新的方法，我们使用了ProceedingJoinPoint作为参数，这个对象可以在通知里调用被通知的方法！！我们要把控制转给被通知的方法时，必须调用ProceedingJoinPoint的`proceed()`方法。

修改`<aop:config>`元素：
```xml
<aop:config proxy-target-class="true">
    <aop:aspect ref="audience">
        <aop:pointcut id="performance" 
            expression="execution(* com.spring.entity.Performer.perform(..))"/>
        <aop:around 
            pointcut-ref="performance"
            method="watch"/>
    </aop:aspect>
</aop:config>
```
实例化kenny输出：
```xml
观众入座
关闭手机
唱：May Rain
吹萨克斯
啪啪啪啪啪
表演耗时：20 milliseconds
```
假如不调用ProceedingJoinPoint的`proceed()`方法发现输出为：
```xml
观众入座
关闭手机
啪啪啪啪啪
表演耗时：0 milliseconds
```
这样我们使用AOP就没啥意义了。

我们甚至可以重复调用ProceedingJoinPoint的`proceed()`方法，重复执行`perform()`方法，输出：
```xml
观众入座
关闭手机
唱：May Rain
吹萨克斯
唱：May Rain
吹萨克斯
唱：May Rain
吹萨克斯
啪啪啪啪啪
表演耗时：22 milliseconds
```
## 为通知传递参数
定义一个新的参赛者，他是一个读心者，由MindReader接口所定义：
```java
public interface MindReader {
    void interceptThoughts(String thoughts);
    String getThoughts();
}
```
魔术师Magician实现该接口：
```java
public class Magician implements MindReader{
    private String thoughts;
    public void interceptThoughts(String thoughts) {
        System.out.println("侦听志愿者的心声");
        this.thoughts=thoughts;
    }
    
    public String getThoughts() {
        return thoughts;
    }
}
```
再定义一个Magician所要侦听的志愿者，首先定义一个思考者接口：
```java
public interface Thinker {
    void thinkOfSomething(String thoughts);
}
```
志愿者Volunteer实现该接口：
```java
public class Volunteer implements Thinker{
    private String thoughts;
    public void thinkOfSomething(String thoughts) {
        this.thoughts=thoughts;
    }
    public String getThoughts(){
        return thoughts;
    }
}
```
接下来使用Spring AOP传递Volunteer的thoughts参数，以此实现Magician的侦听。。。:
```xml
<bean id="magician" class="com.spring.entity.Magician"/>
<aop:config proxy-target-class="true">
    <aop:aspect ref="magician">
        <aop:pointcut id="thinking" expression="
            execution(* com.spring.entity.Volunteer.thinkOfSomething(String))
            and args(thoughts)"/>
        <aop:before pointcut-ref="thinking"
            method="interceptThoughts"
            arg-names="thoughts"/>
    </aop:aspect>
</aop:config>
```
`arg-names`属性传递了参数给`interceptThoughts()`方法。

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
## 通过切面引入新的方法
现在假设要给Performer派生类添加一个新的方法，传统做法是找到所有派生类，让后逐个增加新的方法或者实现。这不但很累而且假设第三方实现没有源码的话，这个过程会变得很困难。幸好，通过Spring AOP可以不必入侵性地改变原有地实现。比如，现在要给所有演出者添加一个`receiveAward()`方法：

新增一个接口Contestant：
```java
public interface Contestant {
    void receiveAward();
}
```
由OutstandingContestant实现：
```java
public class OutstandingContestant implements Contestant{
    public void receiveAward() {
        System.out.println("参加颁奖典礼");
    }
}
```
XML：
```xml
<aop:config proxy-target-class="true">
    <aop:aspect>
        <aop:declare-parents 
            types-matching="com.spring.entity.Performer+" 
            implement-interface="com.spring.entity.Constentant"
            default-impl="com.spring.entity.OutstandingContestant"/>
    </aop:aspect>
</aop:config>  
```
或者：
```xml
<bean id="contestantDelegate" class="com.spring.entity.OutstandingContestant"/>
<aop:config proxy-target-class="true">
    <aop:aspect>
        <aop:declare-parents 
            types-matching="com.spring.entity.Performer+" 
            implement-interface="com.spring.entity.Contestant"
            delegate-ref="contestantDelegate"/>
    </aop:aspect>
</aop:config>
```
`types-matching`指定所要添加新方法的派生类实现的接口，`implement-interface`指定要实现新的接口，`default-impl`指定这个接口的实现类。

测试：
```java
public class Play {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        Instrumentalist kenny=(Instrumentalist)ac.getBean("kenny");
        kenny.perform();
        Contestant kenny1=(Contestant) ac.getBean("kenny");
        kenny1.receiveAward();
    }
}
```
输出：
```xml
唱：May Rain
吹萨克斯
参加颁奖典礼
```

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记