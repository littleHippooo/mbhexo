---
title: SpEL表达式
date: 2016-09-25 08:52:43
tags: Spring
---
Spring3引入了Spring表达式语言(Spring Expression Language，**SpEL**)。前面介绍的注入都是编写Spring配置文件的时候就确定了的。而SpEL它通过运行期间执行的表达式将值装配到Bean的属性或者构造器参数中。

SpEL有许多特性：

1.使用Bean的ID来引用Bean

2.调用方法和访问对象的属性

3.对值进行算数，关系和逻辑运算

4.正则表达式匹配

5.集合操作

<!--more-->
## SpEL的基本使用
### 字面值
最简单的SpEL表达式仅包含一个字面值。假设现在某个类的count属性的值为5，我们用SpEL表达式表示：
```xml
<property name="count" value="#{5}"/>
```
`#{ }`符号会提醒Spring，里面的内容是一个SpEL表达式。它们还可以与非SpEL表达式混用：
```xml
<property name="message" value="the value is #{5}"/>
```
Java基本数据类型都可以出现在SpEL表达式中。表达式中的数字也可以使用科学记数法：
```xml
<property name="salary" value="#{1e4}"/>
```
### 引用Bean , Properties和方法
SpEL表达式能够通过其他Bean的ID进行引用。如：
```xml
<constructor-arg value="#{deceivedByLife}"/>
```
其等价于：
```xml
<constructor-arg ref="deceivedByLife"/>
```
carl参赛者是一位模仿高手，kenny唱什么歌，弹奏什么乐器，他就唱什么歌，弹奏什么乐器：
```xml
<bean id="kenny" class="com.spring.entity.Instrumentalist"
    p:song="May Rain"
    p:instrument-ref="piano"/>
<bean id="carl" class="com.spring.entity.Instrumentalist">
    <property name="instrument" value="#{kenny.instrument}"/>
    <property name="song" value="#{kenny.song}"/>
</bean>
```
As you can see，属性的值由key和value组成。key指定kenny`<bean>` 的id，value指定kenny`<bean>`的song属性。其等价于执行下面的代码：
```java
Instrumentalist carl = new Instrumentalist();
carl.setSong(kenny.getSong());
```
除了访问类的属性，SpEL表达式还可以访问类的方法。假设现在有个SongSelector类，该类有个`selectSong()`方法，这样的话carl就可以不用模仿别人，开始唱songSelector所选的歌了：
```xml
 <property name="song" value="#{SongSelector.selectSong()}"/>
```
carl有个癖好，歌曲名不是大写的他就浑身难受，我们现在要做的就是仅仅对返回的歌曲调用`toUpperCase()`方法：
```xml
 <property name="song" value="#{SongSelector.selectSong().toUpperCase()}"/>
```
注意：这里我们不能确保不抛出`NullPointerException`，为了避免这个讨厌的问题，我们可以使用SpEL的`null-safe`存取器
```xml
 <property name="song" value="#{SongSelector.selectSong()?.toUpperCase()}"/>
```
yes，就是这么简单。`?.`符号会确保左边的表达式不会为`null`，如果为`null`的话就不会调用`toUpperCase()`方法了。
### 操作类
在SpEL表达式中，使用`T()`运算符会调用类的作用域和方法。例如，我们要调用`java.lang.Math`的PI值：
```xml
 <property name="pi" value="#{T(java.lang.Math).PI}"/>
```
获取0~1随机数：
```xml
 <property name="random" value="#{T(java.lang.Math).random()}"/>
```
## 在SpEL值上执行操作
SpEL提供了几种运算符：
<table>
        <tr>
            <th>
                    运算符类型
            </th>
            <th>
                    运算符
            </th>
        </tr>
        <tr>
            <td>
                算数运算
            </td>
            <td>
                +, -, *, /, %, ^
            </td>
        </tr>
        <tr>
            <td>
                关系运算
            </td>
            <td>
                &lt;, &gt;, ==, &lt;=, &gt;=, lt, gt, eq, le, ge
            </td>
        </tr>
        <tr>
            <td>
                逻辑运算
            </td>
            <td>
                and, or, not, !
            </td>
        </tr>
        <tr>
            <td>
                条件运算
            </td>
            <td>
                ?:(ternary), ?:(Elvis)
            </td>
        </tr>
        <tr>
            <td>
                正则表达式
            </td>
            <td>
                matches
            </td>
        </tr>
</table>

### 算数运算
加法运算：
```xml
 <property name="add" value="#{counter.total+42}"/>
```
加号还可以用于字符串拼接：
```xml
 <property name="blogName" value="#{my blog name is+' '+mrBird }"/>
```
`^`运算符执行幂运算，其余算数运算符和Java一毛一样，这里不再赘述。
### 关系运算
判断一个Bean的某个属性是否等于100：
```xml
 <property name="eq" value="#{counter.total==100}"/>
```
返回值是boolean类型。关系运算符唯一需要注意的是：在Spring XML配置文件中直接写>=和<=会报错。因为这"<"和">"两个符号在XML中有特殊的含义。所以实际使用时，最号使用文本类型代替符号：
<table class="mce-item-table">
    <tbody>
            <th >
                
                    运算符
                
            </th>
            <th >
                
                    符号
                
            </th>
            <th >
                
                    文本类型
                
            </th>
        </tr>
        <tr>
            <td >
                等于
            </td>
            <td >
                ==
            </td>
            <td >
                eq
            </td>
        </tr>
        <tr>
            <td >
                小于
            </td>
            <td >
                &lt;
            </td>
            <td >
                lt
            </td>
        </tr>
        <tr>
            <td >
                小于等于
            </td>
            <td >
                &lt;=
            </td>
            <td >
                le
            </td>
        </tr>
        <tr>
            <td >
                大于
            </td>
            <td >
                &gt;
            </td>
            <td >
                gt
            </td>
        </tr>
        <tr>
            <td >
                大于等于
            </td>
            <td >
                &gt;=
            </td>
            <td >
                ge
            </td>
        </tr>
</table>

如：
```xml
 <property name="eq" value="#{counter.total le 100}"/>
```
### 逻辑运算
SpEL表达式提供了多种逻辑运算符，其含义和Java也是一毛一样，只不过符号不一样罢了。

使用and运算符：
```xml
 <property name="largeCircle" value="#{shape.kind == 'circle' and shape.perimeter gt 10000}"/>
```
两边为true时才返回true。

其余操作一样，只不过非运算有`not`和`!`两种符号可供选择。非运算：
```xml
<property name="outOfStack" value="#{!product.available}"/>
```
### 条件运算
条件运算符类似于Java的三目运算符：
```xml
<property name="instrument"
        value="#{songSelector.selectSong() == 'May Rain' ? piano:saxphone}"/>
```
当选择的歌曲为"May Rain"的时候，一个id为piano的Bean将装配到instrument属性中，否则一个id为saxophone的Bean将装配到instrument属性中。注意区别piano和字符串“piano”！

一个常见的三目运算符的使用场合是判断是否为null值：
```xml
<property name="song" value="#{kenny.song !=null ? kenny.song:'Jingle Bells'}"/>
```
这里，kenny.song引用重复了两次，SpEL提供了三目运算符的变体来简化表达式：
```xml
<property name="song" value="#{kenny.song !=null ?:'Jingle Bells'}"/>  
```
在以上示例中，如果kenny.song不为null，那么表达式的求值结果是kenny.song否则就是“Jingle Bells”。
### 正则表达式
验证邮箱：
```xml
<property name="email"
        value="#{admin.email matches '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.com'}"/>
```
虽然这个邮箱正则不够健壮，但对于演示matches来说足够啦。
## 在SpEL中筛选集合
为了展示SpEL操作集合的方法，我们创建一个City类：
```java
public class City {
    private String name;
    private String state;
    private int population;
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getState() {
        return state;
    }
    public void setState(String state) {
        this.state = state;
    }
    public int getPopulation() {
        return population;
    }
    public void setPopulation(int population) {
        this.population = population;
    }
}  
```
同样，我们在Spring容器中使用`<util:list>`元素配置一个包含City对象的List集合：
```xml
<util:list id="cities">
    <bean class="com.spring.entity.City" p:name="Chicago"
        p:state="IL" p:population="2853114"/>
    <bean class="com.spring.entity.City" p:name="Atlanta"
        p:state="GA" p:population="537958"/>
    <bean class="com.spring.entity.City" p:name="Dallas"
        p:state="TX" p:population="1279910"/>
    <bean class="com.spring.entity.City" p:name="Houston"
        p:state="TX" p:population="2242193"/>
    <bean class="com.spring.entity.City" p:name="Odessa"
        p:state="TX" p:population="90943"/>
    <bean class="com.spring.entity.City" p:name="El Paso"
        p:state="TX" p:population="613190"/>
    <bean class="com.spring.entity.City" p:name="Jal"
        p:state="NM" p:population="1996"/>
    <bean class="com.spring.entity.City" p:name="Las Cruces"
        p:state="NM" p:population="91865"/>
</util:list>
```
### 访问集合成员
定义一个ChoseCity类：
```java
public class ChoseCity {
    private City city;
    public void setCity(City city) {
        this.city = city;
    }
    public City getCity() {
        return city;
    }
}
```
选取集合中的某一个成员，并赋值给city属性中：
```xml
<bean id="choseCity" class="com.spring.entity.ChoseCity">
    <property name="city" value="#{cities[0]}"/>
</bean>
```
实例化这个Bean：
```java
public class ChoseaCity {
    public static void main(String[] args) {
        String conf="applicationContext.xml";
        ApplicationContext ac=new ClassPathXmlApplicationContext(conf);
        ChoseCity c=(ChoseCity)ac.getBean("choseCity");
        System.out.println(c.getCity().getName());
    }
}
```
输出：
```xml
Chicago
```
随机的选择一个city：
```xml
<bean id="choseCity" class="com.spring.entity.ChoseCity">
    <property name="city" value="#{cities[T(java.lang.Math).random()*cities.size()]}"/>
</bean>
```
中括号`[]`运算符始终通过索引访问集合中的成员。

`[]`运算符同样可以用来获取java.util.Map集合中的成员。例如，假设City对象以其名字作为键放入Map集合中，在这种情况下，我们可以像下面那样获取键为Dallas的entry：
```xml
<property name="chosenCity" value="#{cities['Dallas']}"/>
```
`[]`运算符的另一种用法是从java.util.Properties集合中取值。例如，假设我们需要通过`<util:properties>`元素在Spring中加载一个properties配置文件：
```xml
<util:properties id="settings" loaction="classpath:settings.properties"/>
```
现在要在这个配置文件Bean中访问一个名为twitter.accessToken的属性：
```xml
<property name="accessToken" value="#{settings['twitter.accessToken']}"/>
```
`[]`运算符同样可以通过索引来得到某个字符串的某个字符，例如下面的表达式将返回s：
```xml
'This is a test'[3]
```
### 查询集合成员
如果我们想从城市cities集合中查询出人口大于10000的城市，在SpEL中只需要用一个查询运算符 `.?[]`就可以简单做到。修改choseCity类：
```java
public class ChoseCity {
    private List<City> city;
    
    public List<City> getCity() {
        return city;
    }
    public void setCity(List<City> city) {
        this.city = city;
    }
}
```
修改Bean：
```xml
<bean id="choseCity" class="com.spring.entity.ChoseCity">
    <property name="city" value="#{cities.?[population gt 100000]}"/>
</bean>
```
实例化该Bean：
```java
public class ChoseCitys {
    public static void main(String[] args) {
        String conf="applicationContext.xml";
        ApplicationContext ac=new ClassPathXmlApplicationContext(conf);
        ChoseCity c=(ChoseCity)ac.getBean("choseCity");
        for(City city:c.getCity()){
            System.out.println(city.getName());
        }
    }
}
```
输出：
```xml
Chicago
Atlanta
Dallas
Houston
El Paso
```
SpEL还提供了其他两种查询运算符：`.^[]`和`.$[]`，从集合查询中查出第一个匹配项和最后一个匹配项。例如查询第一个符合查询条件的城市：
```xml
<property name="firstBigCity" value="#{cities.^[population gt 100000]}"/>
```
### 投影集合
集合投影就是从集合的每一个成员中选择特定的属性放入到一个新的集合中。SpEL的投影运算符`.![]`完全可以做到这一点。

例如，我们仅需要包含城市名称的一个String类型的集合：
```xml
<property name="cityNames" value="#{cities.![name]}"/>
```
再比如，得到城市名字加州名的集合：
```xml
<property name="cityNames" value="#{cities.![name+','+state]}"/>
```
把符合条件的城市的名字和州名作为一个新的集合：
```xml
<property name="cityNames" value="#{cities.?[population gt 100000].![name+','+state]}"/>
```
总之SpEL非常强大，但SpEL最终也只是一个字符串，不易于测试，也没IDE语法检查的支持。所以：建议不要把过多的逻辑放入SpEL表达式中。

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记