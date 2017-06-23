---
title: 搭建SSH (Spring+SpringMVC+Hibernate)
date: 2017-03-03 08:35:32
tags: [Spring,SpringMVC,Hibernate]
---
Spring+SpingMVC的搭建参考博文 —— [搭建SpringMVC](http://mrbird.leanote.com/post/%E6%90%AD%E5%BB%BASpring-MVC)。

这里主要记录SpringMVC与Hibernate的整合。
## 准备工作
数据库使用MySql，创建一张测试表：
```sql
CREATE TABLE `emp` (
    `ID` int(4) NOT NULL AUTO_INCREMENT,
    `NAME` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
    `AGE` int(11) DEFAULT NULL,
    `BIRTHDAY` date DEFAULT NULL,
    PRIMARY KEY (`ID`)
)
```
<!--more-->
引入依赖：
```xml
<!-- spring事务 -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-tx</artifactId>
    <version>4.3.5.RELEASE</version>
</dependency> 
<!-- spring orm -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-orm</artifactId>
    <version>4.3.5.RELEASE</version>
</dependency>
<!-- hibernate -->
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>4.3.5.Final</version>
</dependency>
<!-- mysql数据库连接包-->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.6</version>
</dependency>
 
<!-- 数据库连接池-->
<dependency>
    <groupId>c3p0</groupId>
    <artifactId>c3p0</artifactId>
    <version>0.9.1.2</version>
</dependency>
```
## 配置数据库
在applicationContext.xml中配置数据库：
```xml
<!-- 属性占位符 -->
<context:property-placeholder location="classpath:/config.properties" />
    
<!--配置数据源-->
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource" destroy-method="close">
    <!--数据库连接驱动-->
    <property name="driverClass" value="${jdbc.driver}" /> 
    <!--数据库地址--> 
    <property name="jdbcUrl" value="${jdbc.url}" /> 
    <!--用户名-->   
    <property name="user" value="${jdbc.username}" />  
    <!--密码-->
    <property name="password" value="${jdbc.password}" /> 
    <!--最大连接数--> 
    <property name="maxPoolSize" value="40" />
    <!--最小连接数-->     
    <property name="minPoolSize" value="1" />  
    <!--初始化连接池内的数据库连接-->    
    <property name="initialPoolSize" value="10" />      
</bean> 
```
其中，config.properties配置文件内容如下：
```xml
#database connection config
jdbc.driver = com.mysql.jdbc.Driver
jdbc.url = jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=UTF-8
jdbc.username = root
jdbc.password = 123456
 
#hibernate config
hibernate.dialect = org.hibernate.dialect.MySQLDialect
hibernate.show_sql = true
hibernate.format_sql = true
```
## 配置sessionFactory 
在applicationContext.xml中配置sessionFactory：
```xml
<!--配置session工厂-->
<bean id="sessionFactory" class="org.springframework.orm.hibernate4.LocalSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <!-- 指定实体类扫描路径 -->
    <property name="packagesToScan" value="ssh.mrbird.entity" />
    <property name="hibernateProperties">
        <props>
            <!--指定数据库方言-->
            <prop key="hibernate.dialect">${hibernate.dialect}</prop> 
            <!--在控制台显示执行的数据库操作语句-->  
            <prop key="hibernate.show_sql">${hibernate.show_sql}</prop> 
            <!--在控制台显示执行的数据库操作语句（格式）-->    
            <prop key="hibernate.format_sql">${hibernate.format_sql}</prop>     
        </props>
    </property>
</bean> 
```
使用spring的事务管理机制：
```xml
<!-- 事物管理器配置  -->
<bean id="transactionManager" class="org.springframework.orm.hibernate4.HibernateTransactionManager">
    <property name="sessionFactory" ref="sessionFactory" />
</bean>
<!-- 开启注解事务 -->
<tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true"/>
```
## 创建库表实体 
```java  
import java.io.Serializable;
import java.sql.Date;
 
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
 
@Entity
@Table(name = "Emp")
public class Emp implements Serializable{
    private static final long serialVersionUID = 1L;
 
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID")
    private long id;
    
    @Column(name = "NAME")
    private String name;
    
    @Column(name = "AGE")
    private int age;
    
    @Column(name = "BIRTHDAY")
    private Date birthday;
    // get set 略
}
```
## 数据库访问层  
创建EmpDao接口，包含基本的CRUD方法：
```java
import ssh.mrbird.entity.Emp;
 
public interface EmpDao {
    Emp findEmpById(long id);
    void deleteEmpById(long id);
    void updateEmp(Emp emp);
    void saveEmp(Emp emp);
}
```
其实现类EmpDaoImpl：
```java
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
 
import ssh.mrbird.entity.Emp;
 
@Repository
@Transactional(propagation=Propagation.SUPPORTS,readOnly=true)
public class EmpDaoImpl implements EmpDao{
    //注入SessionFactory
    @Autowired
    private SessionFactory sessionFactory;
    //获取session
    private Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    public Emp findEmpById(long id) {
        return (Emp) getCurrentSession().get(Emp.class, id);
    }
    @Transactional(propagation=Propagation.REQUIRED,readOnly=false)
    public void deleteEmpById(long id) {
        Emp emp = findEmpById(id);
        getCurrentSession().delete(emp);
    }
    @Transactional(propagation=Propagation.REQUIRED,readOnly=false)
    public void updateEmp(Emp emp) {
        getCurrentSession().update(emp);
    }
    @Transactional(propagation=Propagation.REQUIRED,readOnly=false)
    public void saveEmp(Emp emp) {
        getCurrentSession().save(emp);
    }
}
```
使用注解的方式控制事务，关于事务，可参考博文 —— [Spring事务管理](http://mrbird.leanote.com/post/Spring-%E4%BA%8B%E5%8A%A1%E7%AE%A1%E7%90%86)。
## 测试
最终，工程的目录结构为：

![88573480-file_1488531143826_15b09.png](https://www.tuchuang001.com/images/2017/06/12/88573480-file_1488531143826_15b09.png)

applicationContext.xml完整配置如下：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context" 
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:p="http://www.springframework.org/schema/p" 
    xmlns:tx="http://www.springframework.org/schema/tx"
    xsi:schemaLocation="
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx-4.3.xsd
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.3.xsd
        http://www.springframework.org/schema/mvc
        http://www.springframework.org/schema/mvc/spring-mvc-4.3.xsd">
    <!-- 开启组件扫描 -->
    <context:component-scan base-package="ssh"/>
    <!-- 启用Spring mvc -->
    <mvc:annotation-driven/>
    <!-- 配置viewResolver -->
    <bean id="viewResolver"
    class="org.springframework.web.servlet.view.InternalResourceViewResolver" 
        p:prefix="/WEB-INF/views/" 
        p:suffix=".jsp">
    </bean>
    <!-- 属性占位符 -->
    <context:property-placeholder location="classpath:/config.properties" />
    
    <!--配置数据源-->
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource" destroy-method="close">
        <property name="driverClass" value="${jdbc.driver}" /> 
        <property name="jdbcUrl" value="${jdbc.url}" /> 
        <property name="user" value="${jdbc.username}" />  
        <property name="password" value="${jdbc.password}" /> 
        <property name="maxPoolSize" value="40" />
        <property name="minPoolSize" value="1" />  
        <property name="initialPoolSize" value="10" />      
    </bean>
    
    <!--配置session工厂-->
    <bean id="sessionFactory" class="org.springframework.orm.hibernate4.LocalSessionFactoryBean">
        <property name="dataSource" ref="dataSource" />
            <!-- 指定实体类扫描路径 -->
            <property name="packagesToScan" value="ssh.mrbird.entity" />
            <property name="hibernateProperties">
            <props>
                <prop key="hibernate.dialect">${hibernate.dialect}</prop> 
                <prop key="hibernate.show_sql">${hibernate.show_sql}</prop> 
                <prop key="hibernate.format_sql">${hibernate.format_sql}</prop>     
            </props>
        </property>
    </bean>
    <!-- 事物管理器配置  -->
    <bean id="transactionManager" 
        class="org.springframework.orm.hibernate4.HibernateTransactionManager">
        <property name="sessionFactory" ref="sessionFactory" />
    </bean>
    <!-- 开启注解事务 -->
    <tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true"/>
</beans>
```
编写测试Controller：
```java
@Controller
public class TestController {
    @Autowired
    private EmpDaoImpl empDao;
    
    @RequestMapping(value="/saveEmp",method=RequestMethod.GET)
    @ResponseBody
    public String saveEmp(){
        //直接模拟数据
        try{
            Emp emp = new Emp();
            emp.setName("mrbird");
            emp.setAge(100);
            empDao.saveEmp(emp);
            return "success";
        }catch(Exception e){
            e.printStackTrace();
            return "fail";
        }
    }	
    @RequestMapping(value="/findEmp",method=RequestMethod.GET)
    @ResponseBody
    public String findEmp(){
        Emp emp = empDao.findEmpById(1);
        return emp.getName();
    }
    @RequestMapping(value="/updateEmp",method=RequestMethod.GET)
    @ResponseBody
    public String updateEmp(){
        Emp emp = empDao.findEmpById(1l);
        emp.setAge(250);
        empDao.updateEmp(emp);
        return "success";
    }
    @RequestMapping(value="/deleteEmp",method=RequestMethod.GET)
    @ResponseBody
    public String deleteEmp(){
        empDao.deleteEmpById(1l);
        return "success";
    }
}
```
启动工程，访问：http://localhost:8080/ssh/saveEmp

![63449431-file_1488531700557_18429.png](https://www.tuchuang001.com/images/2017/06/12/63449431-file_1488531700557_18429.png)

查询数据库：
```sql
mysql> select * from emp;
+----+--------+------+----------+
| ID | NAME   | AGE  | BIRTHDAY |
+----+--------+------+----------+
|  1 | mrbird |  100 | NULL     |
+----+--------+------+----------+
1 row in set (0.00 sec)
```
数据插入成功，剩下的测试略。