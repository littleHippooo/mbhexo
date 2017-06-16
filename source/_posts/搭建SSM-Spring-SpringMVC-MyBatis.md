---
title: 搭建SSM (Spring+SpringMVC+MyBatis)
date: 2017-03-03 10:19:29
tags: [Spring,SpringMVC,MyBatis]
---
Spring+SpingMVC的搭建参考博文 —— [搭建SpringMVC](http://mrbird.leanote.com/post/%E6%90%AD%E5%BB%BASpring-MVC)。

这里主要记录SpringMVC与MyBatis的整合。
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
<!-- spring jdbc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>4.3.5.RELEASE</version>
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
<!-- mybatis -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.4.1</version>
</dependency>
<!-- mybaits-spring -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>1.3.0</version>
</dependency>
```
## Spring配置文件
在applicationContext.xml文件中配置数据库：
```xml
<!-- 属性占位符 -->
<context:property-placeholder location="classpath:/config.properties" />
<!--配置数据源-->
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource" 
    destroy-method="close">
    <property name="driverClass" value="${jdbc.driver}" /> 
    <property name="jdbcUrl" value="${jdbc.url}" /> 
    <property name="user" value="${jdbc.username}" />  
    <property name="password" value="${jdbc.password}" /> 
    <property name="maxPoolSize" value="40" />
    <property name="minPoolSize" value="1" />  
    <property name="initialPoolSize" value="10" />      
</bean> 
```
配置SqlSessionFactory以及sqlSessionTemplate：
```xml
<!-- mybatis 的SqlSessionFactory -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean" scope="prototype">
    <property name="dataSource" ref="dataSource"/>
    <!-- 指定mybaits配置文件路径 -->
    <property name="configLocation" value="classpath:mybatis-config.xml"/>
</bean>
<!-- sqlSessionTemplate -->
<bean id="sqlSessionTemplate" class="org.mybatis.spring.SqlSessionTemplate" scope="prototype">
    <constructor-arg index="0" ref="sqlSessionFactory"/>
</bean>
```
配置事务：
```xml
<!-- 事物管理器配置  -->
<bean id="transactionManager"
    class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource"/>
</bean>
<!-- 开启注解事务 -->
<tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true"/>
```
配置扫描mapper：
```xml
<!-- 采用自动扫描的方式创建mapper bean -->
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage" value="ssm"/>
    <property name="sqlSessionTemplateBeanName" value="sqlSessionTemplate"/>
    <property name="annotationClass" value="org.springframework.stereotype.Repository"/>
</bean>
```
## MyBatis配置文件
mybaits-config.xml：
```xml
 <?xml version="1.0" encoding="UTF-8" ?>       
<!DOCTYPE configuration       
    PUBLIC "-//mybatis.org//DTD Config 3.0//EN"       
    "http://mybatis.org/dtd/mybatis-3-config.dtd">    
<configuration>  
    <settings>
        <setting name="cacheEnabled" value="true"/>
        <setting name="useGeneratedKeys" value="true"/>
        <setting name="defaultExecutorType" value="REUSE"/>
        <setting name="lazyLoadingEnabled" value="true"/>
        <setting name="defaultStatementTimeout" value="25000"/>
    </settings>  
    <typeAliases>    
        <!--给实体类起一个别名 -->    
        <typeAlias type="ssm.mrbird.entity.Emp" alias="emp" />    
    </typeAliases>    
    <mappers>    
        <!--RoleMapper.xml装载进来  同等于把'mapper'的实现装载进来 -->    
        <mapper resource="ssm/mrbird/mapper/EmpMapper.xml" />    
    </mappers>    
</configuration>  
```
## 创建实体
创建库表对应实体Emp：
```java
import java.io.Serializable;
import java.sql.Date;
 
public class Emp implements Serializable{
    private long id;
    private String name;
    private int age;
    private Date birthday;
    // get set 略
}
```
## 接口与映射 
创建一个包含基本CRUD的接口EmpMapper：
```java
import org.springframework.stereotype.Repository;
import ssm.mrbird.entity.Emp;
 
@Repository
public interface EmpMapper {
    public void insertEmp(Emp emp);
    public void updateEmp(Emp emp);
    public void deleteEmp(long id);
    public Emp getEmp(long id);
}
```
其对应的映射文件EmpMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="ssm.mrbird.mapper.EmpMapper">  
    <insert id="insertEmp" parameterType="emp">
        insert into emp(name,age,birthday) values (#{name},#{age},#{birthday})
    </insert>
    <update id="updateEmp" parameterType="emp">
        update emp 
        <set>
            <if test="name != null">name = #{name},</if>
            <if test="age != null">age = #{age},</if>
            <if test="birthday != null">birthday = #{birthday}</if>
        </set>
        where id = #{id}
    </update>
    <delete id="deleteEmp" parameterType="long">
        delete from emp where id = #{id}
    </delete>
    <select id="getEmp" parameterType="long" resultType="emp">
        select id,name,age,birthday from emp where id = #{id}
    </select>
</mapper>  
```
## 配置服务层
首先创建接口EmpService：
```java
import ssm.mrbird.entity.Emp;
 
public interface EmpService {
    public void insertEmp(Emp emp);
    public void updateEmp(Emp emp);
    public void deleteEmp(long id);
    public Emp getEmp(long id); 
} 
```
其实现类EmpServiceImpl：
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
 
import ssm.mrbird.entity.Emp;
import ssm.mrbird.mapper.EmpMapper;
@Service
@Transactional(propagation=Propagation.SUPPORTS,readOnly=true)
public class EmpServiceImpl implements EmpService{
    @Autowired
    private EmpMapper empMapper;
    
    @Override
    @Transactional(propagation=Propagation.REQUIRED,readOnly=false)
    public void insertEmp(Emp emp) {
        this.empMapper.insertEmp(emp);
    }
    
    @Override
    @Transactional(propagation=Propagation.REQUIRED,readOnly=false)
    public void updateEmp(Emp emp) {
        this.empMapper.updateEmp(emp);
    }
    
    @Override
    @Transactional(propagation=Propagation.REQUIRED,readOnly=false)
    public void deleteEmp(long id) {
        this.empMapper.deleteEmp(id);
    }
    
    @Override
    public Emp getEmp(long id) {
        return this.empMapper.getEmp(id);
    }
}
```
这里采用注解的方式配置事务。关于事务，可参考博文 —— [Spring事务管理](http://mrbird.leanote.com/post/Spring-%E4%BA%8B%E5%8A%A1%E7%AE%A1%E7%90%86)。   
## 测试
最终，工程的目录结构为：

![89189315-file_1488546005738_6d3f.png](https://www.tuchuang001.com/images/2017/06/12/89189315-file_1488546005738_6d3f.png)

测试创建Emp：
```java
@Controller
public class TestController {
    @Autowired
    private EmpService empService;
    
    @RequestMapping(value="/insert",method=RequestMethod.GET)
    @ResponseBody
    public String insertEmp(){
        try {
            Emp emp = new Emp();
            emp.setName("mrbird");
            emp.setAge(100);
            this.empService.insertEmp(emp);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }
}
```
启动项目，访问：http://localhost:8080/ssm/insert

![32476822-file_1488545104560_1069.png](https://www.tuchuang001.com/images/2017/06/12/32476822-file_1488545104560_1069.png)

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
插入成功。

测试getEmp：
```java
@RequestMapping(value="/get",method=RequestMethod.GET)
@ResponseBody
public String getEmp(){
    try {
        return this.empService.getEmp(1l).getName();
    } catch (Exception e) {
        e.printStackTrace();
        return "fail";
    }
}
```
访问：http://localhost:8080/ssm/get

![84649163-file_1488545236002_ea32.png](https://www.tuchuang001.com/images/2017/06/12/84649163-file_1488545236002_ea32.png)

测试updateEmp：
```java
@RequestMapping(value="/update",method=RequestMethod.GET)
@ResponseBody
public String updateEmp(){
    try {
        Emp emp = this.empService.getEmp(1l);
        emp.setAge(250);
        this.empService.updateEmp(emp);
        return "success";
    } catch (Exception e) {
        e.printStackTrace();
        return "fail";
    }
}
```
访问：http://localhost:8080/ssm/update

![3565206-file_1488545321451_16da5.png](https://www.tuchuang001.com/images/2017/06/12/3565206-file_1488545321451_16da5.png)

查询数据库：
```sql
mysql> select * from emp;
+----+--------+------+----------+
| ID | NAME   | AGE  | BIRTHDAY |
+----+--------+------+----------+
|  1 | mrbird |  250 | NULL     |
+----+--------+------+----------+
1 row in set (0.00 sec)
```
更新成功。

测试deleteEmp：
```java
@RequestMapping(value="/delete",method=RequestMethod.GET)
@ResponseBody
public String deleteEmp(){
    try {
        this.empService.deleteEmp(1l);
        return "success";
    } catch (Exception e) {
        e.printStackTrace();
        return "fail";
    }
}
```
访问：http://localhost:8080/ssm/delete

![43281827-file_1488545421908_7d93.png](https://www.tuchuang001.com/images/2017/06/12/43281827-file_1488545421908_7d93.png)

查询数据库：
```sql
mysql> select * from emp;
Empty set (0.00 sec)
```
删除成功。