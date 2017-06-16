---
title: Spring 事务管理
date: 2016-10-15 15:28:40
tags: Spring
---
在[SimpleJdbcTemplate](https://mrbird.cc/Spring-SimpleJdbcTemplate.html)的UserDaoImpl中的addUser()方法中手动制造一个NullPointerException异常：
```java
public void addUser(User user) {
    Map<String, Object> params=new HashMap<String, Object>();
    params.put("name", user.getName());
    params.put("age", user.getAge());
    params.put("pwd", user.getPassword());
    jdbcTemplate.update(SQL_INSERT_USER, params);
    String a = null;
    a.toString();
}
```
<!--more-->
测试addUser()方法：
```java
public class TestJdbc {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserDao dao=ac.getBean("userDao",UserDao.class);
        User u=new User();
        u.setName("testUser");
        u.setAge("24");
        u.setPassword("123456");
        dao.addUser(u);
    }
}
```
执行时，控制台抛出`NullPointerException`异常，但是数据插入成功了么？查询数据库：
```sql
SQL> select * from lzp.userinfo;
 
USERI NAME       AGE PWD
----- ---------- --- ----------
8     testUser   24  123456
4     SCOTT      25  123456 
```
发现虽然`addUser()`方法抛出了异常，但是数据还是被成功的插入，这违背了事务的ACID原则。

Spring提供了对事务管理的支持。这里仅介绍声明式事务。
## 选择事务管理器
### JDBC事务管理器
如果应用程序中直接使用JDBC来进行持久化，那么应该选择`DataSourceTransactionManager`作为事务管理器：
```xml
<bean id="transactionManager"
      class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource" />
</bean>
```
### Hibernate事务管理器
如果应用程序的持久化是通过Hibernate来实现的，那么应该选择HibernateTransactionManager作为事务管理器：
```xml
<bean id="transactionManager" 
      class="org.springframework.orm.hibernate3.HibernateTransactionManager">
    <property name="sessionFactory" ref="sessionFactory" />
</bean>
```
## 事务五大属性    
### 传播行为
传播行为（propagation behavior）定义了客户端与被调用方法之间的事务边界。即何时要创建一个事务，或者何时使用已有的事务：
<table>
        <tr>
            <td>
                传播行为
            </td>
            <td>
                含义
            </td>
        </tr>
        <tr>
            <td>
                PROPAGATION_MANDATORY
            </td>
            <td>
                
                    表示该方法必须在事务中进行，如果当前事务不存在，则会
                
                
                    抛出一个异常
                
            </td>
        </tr>
        <tr>
            <td>
                PROPAGATION_NESTED
            </td>
            <td>
                
                    如果当前已存在一个事务，那么该方法在嵌套事务中运行。
                
                
                    嵌套事务可以独立于当前事务进行单独地提交或回滚。如
                
                
                    果当前事务不存在，那么行为和
                
                
                    PROPAGATION_REQUIRED一样
                
            </td>
        </tr>
        <tr>
            <td>
                PROPAGATION_NEVER
            </td>
            <td>
                
                    表示当前方法不运行在事务上下文中。如果当前正有一个
                
                
                    事务在运行，则会抛出异常
                
            </td>
        </tr>
        <tr>
            <td>
                PROPAGATION_NOT_SUPPORTED
            </td>
            <td>
                
                    表示该方法不应该运行在事务上下文中，如果存在当前事
                
                
                    务，在该方法运行期间，当前事务会被挂起
                
            </td>
        </tr>
        <tr>
            <td>
                PROPAGATION_REQUIRED
            </td>
            <td>
                
                    表示当前方法必须运行在事务中，如果事务不存在，则启
                
                
                    动一个新的事务
                
            </td>
        </tr>
        <tr>
            <td>
                PROPAGATION_REQUIRED_NEW
            </td>
            <td>
                
                    表示当前方法必须运行在它自己的事务中。一个新的事务
                
                
                    将启动。如果存在当前事务，当前事务会被挂起
                
            </td>
        </tr>
        <tr>
            <td>
                PROPAGATION_SUPPORTS
            </td>
            <td>
                
                    表示当前方法不需要事务上下文，但是如果存在当前事务
                
                
                    的话，那么该方法会在这个事务中运行&nbsp;&nbsp;
                
            </td>
        </tr>
</table>

### 隔离级别
隔离级别（isolation level）定义了一个事务可能受其他并发事务的影响程度。并发操作相同的数据可能产生一些问题：

1.脏读（Dirty reads）—— 发生在一个事务读取了另一个事务改写后但未提交的数据，如果改写被回滚了，那么第一个事务获取的数据就是“脏”的。

2.不可重复读（Nonrepeatable read）—— 一个事务执行两次以上相同查询得到不同的数据。这通常是另外一个事务在此期间更新了数据。

3.幻读（Phantom read）—— 一个事务读取了几行数据，另一个事务插入了几条数据，当第一个事务再次读取时发现多了几条原本没有的数据。

隔离级别如下表所示：
<table>
        <tr>
            <td>
                隔离级别
            </td>
            <td>
                含义
            </td>
        </tr>
        <tr>
            <td>
                ISOLATION_DEFAULT
            </td>
            <td>
                使用后端数据库默认的隔离级别
            </td>
        </tr>
        <tr>
            <td>
                ISOLATION_READ_UNCOMMITTED
            </td>
            <td>
                
                    允许读取尚未提交的数据表更。可能导致脏读，不可重复
                
                
                    读，幻读
                
            </td>
        </tr>
        <tr>
            <td>
                ISOLATION_READ_COMMITTED
            </td>
            <td>
                
                    允许读取并发事务已经提交的数据，可以阻止脏读，但不
                
                
                    可重复读，幻读仍可能发生
                
            </td>
        </tr>
        <tr>
            <td>
                ISOLATION_REPEATABLE_READ
            </td>
            <td>
                
                    对同一字段的多次读取结果一致，除非数据是本事务自己
                
                
                    修改的。可以阻止脏读，不可重复读，但仍可能发生幻读
                
            </td>
        </tr>
        <tr>
            <td>
                REPEATABLE_SERIALIZABLE
            </td>
            <td>
                完全服从事务的ACID原则，避免脏读，不可重复读，幻读
            </td>
        </tr>
</table>

可以看出，`ISOLATION_READ_UNCOMMITTED`隔离级别是最低的，可能导致脏读，不可重复读，幻读。`REPEATABLE_SERIALIZABLE`隔离级别最高，但是这会降低数据读取速率，它通常是通过完全锁定事务相关的数据库表来实现的。
### 只读
只读（read-only） 如果事务只读数据库进行读操作，那么设置该属性为true可以给数据库执行优化措施。

因为只读是在事务启动，由数据库实施的，所以对那些具备启动一个新的事务的传播行为（`PROPAGATION_REQUIRED`，`PROPAGATION_REQUIRED_NEW`和`PROPAGATION_NESTED`）才有意义。

设置只读还会使Hibernate的flush模式被设置为FLUSH_NEVER。
### 事务超时  
超时（timeout）假如事务运行时间过长，则会影响效率，所以可以设置超时属性，超时后执行自动回滚。因为超时时钟会在事务开启时启动，所以只有对那些具备启动一个新的事务的传播行为（`PROPAGATION_REQUIRED`，`PROPAGATION_REQUIRED_NEW`和`PROPAGATION_NESTED`）才有意义。
### 回滚原则
默认情况遇到运行期异常就回滚。回滚原则可以定义遇到哪些异常不回滚。
## XML中定义事务
使用`tx`命名空间配置：
```xml
<tx:advice id="txAdvice" transaction-manager="transactionManager">
    <tx:attributes>
        <tx:method name="add*" propagation="REQUIRED"/>
        <tx:method name="*" propagation="SUPPORTS" read-only="true"/>
    </tx:attributes>
</tx:advice>
```
`transaction-manager`为上述的事务管理器。

`<tx:method>`元素为某个（某些）name属性指定的方法定义事务参数。

`<tx:method>`有多个属性来帮助定义方法的事务策略，这些属性对于上述的事务五大属性：
<table>
        <tr>
            <td>
                属性
            </td>
            <td>
                含义
            </td>
        </tr>
        <tr>
            <td>
                isolation
            </td>
            <td>
                指定隔离级别
            </td>
        </tr>
        <tr>
            <td>
                propagation
            </td>
            <td>
                指定传播原则
            </td>
        </tr>
        <tr>
            <td>
                read-only
            </td>
            <td>
                指定事务为只读
            </td>
        </tr>
        <tr>
            <td>
                
                    回滚原则：</br>
                
                
                    rollback-for</br>
                
                
                    no-rollback-for
                
            </td>
            <td>
                
                    rollback-for指定事务为哪些检查型异常回滚</br>
                
                
                    no-rollback-for指定事务对哪些异常继续运行而不回滚
                
            </td>
        </tr>
        <tr>
            <td>
                timeout
            </td>
            <td>
                设定事务超时时间
            </td>
        </tr>
</table>

我们还需设定哪些Bean应该被通知，使用aop定义一个通知器（`advisor`）：
```xml
<aop:config>
    <aop:advisor
        pointcut="execution(* *..UserDaoImpl.*(..))"	
        advice-ref="txAdvice"/>
</aop:config>
```
`advice-ref`属性引用了名为txAdvice的通知。

现在测试添加事务后的`addUser()`方法：
```java
public class TestTransaction {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserDao dao=ac.getBean("userDao",UserDao.class);
        User u=new User();
        u.setName("testTx");
        u.setAge("30");
        u.setPassword("123456");
        dao.addUser(u);
    }
}
```
控制台抛出异常：
```xml
Exception in thread "main" java.lang.NullPointerException
	at com.spring.dao.UserDaoImpl.addUser(UserDaoImpl.java:51)
```
查询数据：
```sql
SQL> select * from lzp.userinfo;
 
USERI NAME       AGE PWD
----- ---------- --- ----------
8     testUser   24  123456
4     SCOTT      25  123456
```
可以发现testTx并没有被插入。
## 注解事务
除了使用XML定义事务，我们还可以注解事务，通过声明：
```xml
<tx:annotation-driven transaction-manager="transactionManager"/>
```
`<tx:annotation-driven>`告诉Spring检查上下文中所有使用`@Transaction`注解的Bean，不管这个注解是在类级别上还是方法级别上。

使用注解修改UserDaoImpl：
```java
@Repository("userDao")
@Transactional(propagation=Propagation.SUPPORTS,readOnly=true)
public class UserDaoImpl implements UserDao {
    //...
    @Transactional(propagation=Propagation.REQUIRED,readOnly=false)
    public void addUser(User user) {
        Map<String, Object> params=new HashMap<String, Object>();
        params.put("name", user.getName());
        params.put("age", user.getAge());
        params.put("pwd", user.getPassword());
        jdbcTemplate.update(SQL_INSERT_USER, params);
        String a=null;
        a.toString();
    }
    //...
}   
```
再次运行testTransaction()方法，抛出异常后查询数据库：
```sql
SQL> select * from lzp.userinfo;
 
USERI NAME       AGE PWD
----- ---------- --- ----------
8     testUser   24  123456
4     SCOTT      25  123456
```
可发现和XML配置事务效果是一样的。

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记