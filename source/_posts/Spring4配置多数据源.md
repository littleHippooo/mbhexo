---
title: Spring4配置多数据源
date: 2017-10-09 14:27:55
tags: Spring
---
Spring在每次操作数据库的时候都会通过AbstractRoutingDataSource类中的determineTargetDataSource()方法获取当前数据源，所以可以通过继承AbstractRoutingDataSource并重写determineTargetDataSource()方法来实现多数据源的配置。

定义一个DynamicDataSource类，继承AbstractRoutingDataSource：
```java
package cc.mrbird.datasource;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

public class DynamicDataSource extends AbstractRoutingDataSource {   
    @Override  
    protected Object determineCurrentLookupKey() {  
        return DatabaseContextHolder.getCustomerType();   
    }  
}
```
<!--more-->
其中DatabaseContextHolder用于保存当前使用的数据库名称：
```java
package cc.mrbird.datasource;

public class DatabaseContextHolder {
    private static final ThreadLocal<String> contextHolder = new ThreadLocal<String>();  
    
    public static void setCustomerType(String customerType) {  
        contextHolder.set(customerType);  
    }  
    
    public static String getCustomerType() {  
        return contextHolder.get();  
    }  
    
    public static void clearCustomerType() {  
        contextHolder.remove();  
    }  
}
```
定义一个数据库名常量类：
```java
package cc.mrbird.datasource;

public class DataSourceConst {

    public static final String DB1 = "dataSource1"; 
    public static final String DB2 = "dataSource2"; 
}
```
dataSource1和dataSource2为在Spring上下文配置文件applicationContext.xml中配置的两个数据源：
```xml
<bean id="dataSource1" class="com.mchange.v2.c3p0.ComboPooledDataSource">
    <property name="driverClass" value="oracle.jdbc.driver.OracleDriver" />
    <property name="jdbcUrl" value="jdbc:oracle:thin:@192.168.140.139:1521:orcl"></property>
    <property name="user" value="test"></property>
    <property name="password" value="test_123"></property>
    <property name="maxPoolSize" value="150" />
    <property name="minPoolSize" value="5" />
    <property name="initialPoolSize" value="10" />
    <property name="maxIdleTime" value="60" />
    <property name="acquireIncrement" value="3" />
    <property name="maxStatements" value="0" />
    <property name="idleConnectionTestPeriod" value="60" />
</bean>
	
<bean id="dataSource2" class="com.mchange.v2.c3p0.ComboPooledDataSource">
    <property name="driverClass" value="oracle.jdbc.driver.OracleDriver" />
    <property name="jdbcUrl" value="jdbc:oracle:thin:@192.168.140.148:1521:PISDATA"></property>
    <property name="user" value="test"></property>
    <property name="password" value="test_456"></property>
    <property name="maxPoolSize" value="150" />
    <property name="minPoolSize" value="5" />
    <property name="initialPoolSize" value="10" />
    <property name="maxIdleTime" value="60" />
    <property name="acquireIncrement" value="3" />
    <property name="maxStatements" value="0" />
    <property name="idleConnectionTestPeriod" value="60" />
</bean>
```
接着配置动态数据源，类型为上面定义的DynamicDataSource类：
```xml
<bean id="dynamicDataSource" class="cc.mrbird.datasource.DynamicDataSource">  
    <property name="targetDataSources">  
        <map key-type="java.lang.String">  
            <entry value-ref="dataSource1" key="dataSource1"></entry>  
            <entry value-ref="dataSource2" key="dataSource2"></entry>  
        </map>
    </property>  
    <property name="defaultTargetDataSource" ref="dataSource1" /> 
</bean> 
```
默认的数据源为dataSource1。

## 测试

使用Spring提供的jdbcTemplate进行测试，完整的applicationContext.xml配置如下：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context" 
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:tx="http://www.springframework.org/schema/tx"
    xmlns:p="http://www.springframework.org/schema/p" 
    xmlns:task="http://www.springframework.org/schema/task"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.3.xsd
        http://www.springframework.org/schema/tx 
        http://www.springframework.org/schema/tx/spring-tx-4.3.xsd
        http://www.springframework.org/schema/mvc
        http://www.springframework.org/schema/mvc/spring-mvc-4.3.xsd
        http://www.springframework.org/schema/task
        http://www.springframework.org/schema/task/spring-task-4.3.xsd" 
        default-autowire="byName" >
    <!-- 开启组件扫描 -->
    <context:component-scan base-package="cc.mrbird"/>
	   
    <bean id="dataSource1" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <property name="driverClass" value="oracle.jdbc.driver.OracleDriver" />
        <property name="jdbcUrl" value="jdbc:oracle:thin:@192.168.140.139:1521:orcl"></property>
        <property name="user" value="test"></property>
        <property name="password" value="test_123"></property>
        <property name="maxPoolSize" value="150" />
        <property name="minPoolSize" value="5" />
        <property name="initialPoolSize" value="10" />
        <property name="maxIdleTime" value="60" />
        <property name="acquireIncrement" value="3" />
        <property name="maxStatements" value="0" />
        <property name="idleConnectionTestPeriod" value="60" />
    </bean>
	
    <bean id="dataSource2" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <property name="driverClass" value="oracle.jdbc.driver.OracleDriver" />
        <property name="jdbcUrl" value="jdbc:oracle:thin:@192.168.140.148:1521:PISDATA"></property>
        <property name="user" value="test"></property>
        <property name="password" value="test_456"></property>
        <property name="maxPoolSize" value="150" />
        <property name="minPoolSize" value="5" />
        <property name="initialPoolSize" value="10" />
        <property name="maxIdleTime" value="60" />
        <property name="acquireIncrement" value="3" />
        <property name="maxStatements" value="0" />
        <property name="idleConnectionTestPeriod" value="60" />
    </bean> 
	
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate"
        abstract="false" lazy-init="false" autowire="default">
        <property name="dataSource">
            <ref bean="dynamicDataSource" />
        </property>
    </bean>
	
    <bean id="dynamicDataSource" class="cc.mrbird.datasource.DynamicDataSource">  
        <property name="targetDataSources">  
            <map key-type="java.lang.String">  
                <entry value-ref="dataSource1" key="dataSource1"></entry>  
                <entry value-ref="dataSource2" key="dataSource2"></entry>  
            </map>
        </property>  
        <property name="defaultTargetDataSource" ref="dataSource1"/>  
    </bean> 
    
    <!-- 事物注解开启 -->
    <bean id="transactionManager"
        class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dynamicDataSource" />
    </bean>
	
    <tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true"/>
</beans>
```
编写TestDynamicDataSourceDao接口：
```java
package cc.mrbird.dao;

public interface TestDynamicDataSourceDao {
    String getDataSource1Name();
    String getDataSource2Name();
}
```
其实现类：
```java
package cc.mrbird.dao.impl;

import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;

import cc.mrbird.dao.TestDynamicDataSourceDao;
import cc.mrbird.datasource.DataSourceConst;
import cc.mrbird.datasource.DatabaseContextHolder;

@Repository("testDynamicDataSourceDao")
public class TestDynamicDataSourceDaoImpl extends JdbcDaoSupport implements TestDynamicDataSourceDao{

    public String getDataSource1Name() {
        String sql = "";
        try {
            sql = "select SYS_CONTEXT('USERENV','INSTANCE_NAME') from dual";
            return this.getJdbcTemplate().queryForObject(sql, String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getDataSource2Name() {
        String sql = "";
        try {
            // 切换到数据源datasource2
            DatabaseContextHolder.setCustomerType(DataSourceConst.DB2);
            sql = "select SYS_CONTEXT('USERENV','INSTANCE_NAME') from dual";
            return this.getJdbcTemplate().queryForObject(sql, String.class);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 恢复到默认数据源datasource1
            DatabaseContextHolder.clearCustomerType();
        }
        return null;
    }
}
```
编写Service接口及其实现类：
```java
package cc.mrbird.service;

public interface TestDynamicDataSourceService {
	
    String getDataSource1Name();	
    String getDataSource2Name();
}
```
```java
package cc.mrbird.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cc.mrbird.dao.TestDynamicDataSourceDao;
import cc.mrbird.service.TestDynamicDataSourceService;

@Service("testDynamicDataSourceService")
public class TestDynamicDataSourceServiceImpl implements TestDynamicDataSourceService{

    @Autowired
    private TestDynamicDataSourceDao dao;
    
    public String getDataSource1Name() {
        return dao.getDataSource1Name();
    }
    
    public String getDataSource2Name() {
        return dao.getDataSource2Name();
    }
}
```
在控制器中测试：
```java
package cc.mrbird.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import cc.mrbird.service.TestDynamicDataSourceService;

@Controller
public class IndexController {
	
    @Autowired
    private TestDynamicDataSourceService service;
    
    @RequestMapping("/test")
    public void test(){
        String dataSource1Name = service.getDataSource1Name();
        String dataSource2Name = service.getDataSource2Name();
        
        System.out.println(dataSource1Name);
        System.out.println(dataSource2Name);
    }
}
```
页面访问/test路径，控制台输出：
```xml
orcl
pisdata
```