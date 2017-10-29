---
title: Spring Setter方法注入
date: 2016-09-25 07:18:17
tags: Spring
---
Spring除了构造器注入，还可以通过类的set()方法注入。为了演示这个过程，现在有请下一位参赛者kenny。kenny是一位天赋异禀的乐器演奏者，现定义一个乐器演奏师类：

<!--more-->
```java
public class Instrumentalist implements Performer{
    private String song;
    private Instrument instrument;
    
    public Instrumentalist() {
    	
    }
    public void perform() {
        System.out.println("唱："+song+"");
        instrument.play();
    }
    public String screamSong(){
        return song;
    }
    public String getSong() {
        return song;
    }
    //注入歌曲
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
乐器Instrument接口：
```java
public interface Instrument{
    public void play();
}
```
## setter注入简单值
可以通过InstrumentList类的默认构造器来实例化该Bean，但没有给song和instrument属性赋值的话显然没有什么意义。Spring可以用`<property>`元素给属性Song注入值：
```xml
<bean id="kenny" class="com.spring.entity.Instrumentalist">
    <property name="song" value="May Rain"/>
</bean>
```
name为属性名，value为属性值。
## 引用其他的Bean
有了歌曲，kenny现在还差乐器。定义一个piano类，实现Instrument接口：
```java
public class Piano implements Instrument{
    public void play() {
        System.out.println("钢琴声响起");
    }
}
```
有了piano类，现在我们在Spring容器中定义这个钢琴类：
```xml
<bean id="piano" class="com.spring.entity.Piano"/>
```
有了钢琴，现在我们把钢琴交给kenny，修改kenny的`<bean>`配置：
```xml
<bean id="kenny" class="com.spring.entity.Instrumentalist">
    <property name="song" value="May Rain"/>
    <property name="piano" ref="piano"></property>
</bean>
```
ref属性指向之前定义的piano`<bean>`。

现在我们让kenny正式上台表演：
```java
public class Play {
    public static void main(String[] args) {
        ApplicationContext ac=new ClassPathXmlApplicationContext("applicationContext.xml");
        Instrumentalist kenny=(Instrumentalist)ac.getBean("kenny");
        kenny.perform();
    }
}
```
输出：
```xml
开灯
唱：May Rain
钢琴声响起
```
## 注入内部Bean
kenny是一个占有欲很强的人，他不希望自己的钢琴被别人使用。这时候我们不能像上面那样引用piano`<bean>`了，因为这样任何一个`<bean>`都可以引用它。

现在修改kenny的`<bean>`：
```xml
<bean id="kenny" class="com.spring.entity.Instrumentalist">
    <property name="song" value="May Rain"/>
    <property name="instrument" >
        <bean class="com.spring.entity.Piano"/>
    </property>
</bean>
```
如你所见，内部Bean是直接声明一个`<bean>`元素作为`<property>`元素的子节点而定义的。同样，构造器注入也支持内部Bean的声明。 细心的你 会发现内部Bean没有定义id属性，实际上在这里定义id属性是完全合法的，只不过对于内部Bean，id属性显然不重要了。
## 使用Spring P装配属性
`<property>`元素的写法可以更简略，只需在`<beans>`加入如下代码：
```xml
xmlns:p="http://www.springframework.org/schema/p" 
```
通过这段代码，我们可以使用p:作为`<bean>`元素的所有属性的前缀来装配Bean的属性。现修改kenny的`<bean>`配置：
```xml
<bean id="kenny" class="com.spring.entity.Instrumentalist"
    p:song="May Rain"
    p:instrument-ref="piano"/>
```
## 装配集合
当配置集合类型的Bean属性时，Spring提供了相应的集合配置元素：
<table>
        <tr>
            <th>
                集合元素
            </th>
            <th>
                用途
            </th>
        </tr>
        <tr>
            <td>
                &lt;list&gt;
            </td>
            <td>
                装配list类型的值，允许重复
            </td>
        </tr>
        <tr>
            <td>
                &lt;set&gt;
            </td>
            <td>
                装配set类型的值，不允许重复
            </td>
        </tr>
        <tr>
            <td>
                &lt;map&gt;
            </td>
            <td>
                装配map类型的值，名称和值可以是任意类型
            </td>
        </tr>
        <tr>
            <td>
                &lt;props&gt;
            </td>
            <td>
                装配properties类型的值，名称和值都必须是String类型
            </td>
        </tr>
</table>

为了展示Spring装配集合，现在有请下一位参赛者hank。hank是一位才华横溢的一人乐队，可以同时演奏多种乐器。现定义一个OneManBan类：
```java
public class OneManBan implements Performer{
    private Collection<Instrument> instruments;
    
    //注入instruments集合
    public void setInstruments(Collection<Instrument> instruments) {
        this.instruments = instruments;
    }
    
    public void perform() {
        for(Instrument ins:instruments){
            ins.play();
        }
    }
}
```
### 装配List,Set和Array
现在再定义两个乐器类，并在Spring容器中定义它：
```xml
<bean id="saxophone" class="com.spring.entity.Saxophone"/>
<bean id="guitar" class="com.spring.entity.Guitar"/>
```
现在把所有乐器都装配给hank：
```xml
<bean id="hank" class="com.spring.entity.OneManBan">
    <property name="instruments">
        <list>
            <ref bean="saxophone"/>
            <ref bean="piano"/>
            <ref bean="guitar"/>
        </list>
    </property>
</bean>	
```
还可以使用其他的Spring设置元素设置`<list>`的成员。包括`<value>`，`<bean>`，`</null>`甚至`<list>`。

实际上，instruments属性只要是`java.util.collection`的实现类型都可以使用`<list>`，如：
```java
java.util.List<Instrument> instruments;
```
或者：
```java
Instrument[] instruments;
```
`<set>`元素的使用与`<list>`完全一致，唯一区别在于`<set>`元素的成员都是唯一的。

现在实例化hank查看输出：
```xml
开灯
吹萨克斯
钢琴声响起
弹奏吉他
```
### 装配Map集合
如果instruments属性是一个Map集合的话，我们又该如何装配呢？现修改OneManBan类：
```java
public class OneManBan implements Performer{
    private Map<String,Instrument> instruments;
    public OneManBan() {
    	
    }
    
    public void perform() {
        for(String key:instruments.keySet()){
            System.out.print(key+": ");
            Instrument ins=instruments.get(key);
            ins.play();
        }
    }
    public void setInstruments(Map<String, Instrument> instruments) {
        this.instruments = instruments;
    }
}
```
hank`<bean>`修改如下：
```xml
<bean id="hank" class="com.spring.entity.OneManBan">
    <property name="instruments">
        <map>
            <entry key="saxophone" value-ref="saxophone"/>
            <entry key="piano" value-ref="piano"/>
            <entry key="guitar" value-ref="guitar"/>
        </map>
    </property>
</bean>	
```
`<map>`的`<entry>`由key和value组成：
<table>
        <tr>
            <th>
                属性
            </th>
            <th>
                用途
            </th>
        </tr>
        <tr>
            <td>
                key
            </td>
            <td>
                键为String
            </td>
        </tr>
        <tr>
            <td>
                key-ref
            </td>
            <td>
                键为Spring容器中其他Bean的引用
            </td>
        </tr>
        <tr>
            <td>
                value
            </td>
            <td>
                值为String
            </td>
        </tr>
        <tr>
            <td>
                value-ref
            </td>
            <td>
                值为Spring容器中其他Bean的引用
            </td>
        </tr>
</table>

### 装配Properties集合
当key和value都是String类型的时候，我们可以使用Properties来代替Map

修改OneManBan：
```java
public class OneManBan implements Performer{
    private Properties instruments;
    public OneManBan() {
    	
    }
    public void perform() {
        for(Object key:instruments.keySet()){
            System.out.print(key+": ");
            String ins=instruments.getProperty(key.toString());
            System.out.println(ins);
        }
    }
    public void setInstruments(Properties instruments) {
        this.instruments = instruments;
    }
}
```
修改`<bean>`:
```xml
<bean id="hank" class="com.spring.entity.OneManBan">
    <property name="instruments">
        <props>
            <prop key="saxophone" >play the saxophone</prop>
            <prop key="piano">play the piano</prop>
            <prop key="guitar">play the guitar</prop>
        </props>
    </property>
</bean>	
```

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记