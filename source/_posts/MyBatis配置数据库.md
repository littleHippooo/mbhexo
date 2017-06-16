---
title: MyBatis配置数据库
date: 2017-01-03 15:03:02
tags: MyBatis
---
### xml文件配置    
直接在mybatis-config.xml文件中配置：
```xml
<dataSource type="POOLED">    
    <property name="driver" value="com.mysql.jdbc.Driver" />    
    <property name="url" value="jdbc:mysql://localhost:3306/mybatis"/>    
    <property name="username" value="root" />    
    <property name="password" value="6742530" />    
</dataSource> 
```
<!--more-->
### properties配置文件
为了方便日后维护修改，我们用properties配置文件来配置数据库属性：

db.properties：
```xml
driver:com.mysql.jdbc.Driver
url:jdbc:mysql://localhost:3306/mybatis
username:root
password:123456
```
在mybatis-config.xml文件中引入：
```xml
<properties resource="db.properties"/>
<dataSource type="POOLED">    
    <property name="driver" value="${driver}" />    
    <property name="url" value="${url}"/>    
    <property name="username" value="${username}" />    
    <property name="password" value="${password}" />    
</dataSource>
```
### 参数传递
假如要对db.properties文件中的用户名和密码进行加密，那我们则需要在生成SqlSessionFactory的时候对用户名和密码解密（假设解密方法为`decode()`）：
```java
public class SqlSessionFactoryUtil {
    InputStream cfgStream = null;
    Reader cfgReader = null;
    InputStream proStream = null;
    Reader proReader = null;
    Properties properties = null;
    private static SqlSessionFactory sqlSessionFactory = null;
    //类线程锁
    private static final Class CLASS_LOCK = SqlSessionFactoryUtil.class;
    //私有化构造函数
    private SqlSessionFactoryUtil(){}
    //构建SqlSessionFactory
    public static SqlSessionFactory initSqlSessionFactory(){
        try{
            //读入配置文件流
            cfgStream = Resources.getResourceAsStream("mybatis-config.xml");
            cfgReader = new InputStreamReader(cfgStream);
            //读入属性文件
            proStream = Resources.getResourceAsStream(db.properties);
            proReader = new InputStreamReader(proStream);
            
            properties = new Properties();
            properties.load(proReader);
            properties.setProperty("username",
                decode(properties.getProperty("username")));
            properties.setProperty("password",
                decode(properties.getProperty("password")));
        }catch(IOException e){
            e.printStackTrace();
        }
        synchronized (CLASS_LOCK) {
            if(sqlSessionFactory == null){
                sqlSessionFactory = new SqlSessionFactoryBuilder().build(cfgStream);
            }
        }
        return sqlSessionFactory;
    }
    //创建SqlSession
    public static SqlSession openSqlSession(){
        if(sqlSessionFactory == null){
            initSqlSessionFactory();
        }
        return sqlSessionFactory.openSession();
    }
}
```
### environments配置环境
```xml
<environments default="development">    
    <environment id="development">
        <!-- 采用JDBC事务管理 -->    
        <transactionManager type="JDBC">
            <property name="autoCommit" value="false"/>
        </transactionManager>    
        <dataSource type="POOLED">    
            <property name="driver" value="com.mysql.jdbc.Driver" />    
            <property name="url" value="jdbc:mysql://localhost:3306/mybatis"/>    
            <property name="username" value="root" />    
            <property name="password" value="6742530" />    
        </dataSource>    
    </environment>    
</environments>  
```
`default`属性表明默认选用哪个数据库。

`id`属性为一个数据库配置的标识，可以同时配置多个数据库。

dataSource的`type`属性可选非连接池UNPOOLED，连接池POOLED和JNDI

> [《深入浅出MyBatis技术原理与实战》](https://book.douban.com/subject/26858114/)读书笔记    