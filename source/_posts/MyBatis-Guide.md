---
title: MyBatis Guide
date: 2016-12-31 15:08:34
tags: MyBatis
---
## 准备工作
创建表t_role：
```sql
create table T_ROLE(
    id INT(20) not null auto_increment COMMENT '编号',
    role_name VARCHAR(60) not null comment '角色名称',
    note varchar(1024) comment '备注',
    PRIMARY KEY (id)
);
```
添加MyBatis jar包和mySql连接驱动：
<!--more-->

> [MyBatis-jar](http://pan.baidu.com/s/1hsDju1Q)

eclipse文件路径：  

![12570185-file_1487995631058_e4f2.png](https://www.tuchuang001.com/images/2017/06/14/12570185-file_1487995631058_e4f2.png)

各文件说明：
<table>
        <tr>
            <td>
                <strong>
                    文件
                </strong>
            </td>
            <td>
                <strong>
                    作用
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                MyBatisMain.java
            </td>
            <td>
                运行MyBatis程序的入口，包含main方法
            </td>
        </tr>
        <tr>
            <td>
                RoleMapper.java
            </td>
            <td>
                映射器
            </td>
        </tr>
        <tr>
            <td>
                RoleMapper.xml
            </td>
            <td>
                映射器配置文件
            </td>
        </tr>
        <tr>
            <td>
                Role.java
            </td>
            <td>
                POJO
            </td>
        </tr>
        <tr>
            <td>
                SqlSessionFactoryUtil.java
            </td>
            <td>
                构建SqlSessionFactory，并创建SqlSession
            </td>
        </tr>
        <tr>
            <td>
                mybatis-config.xml
            </td>
            <td>
                MyBatis配置
            </td>
        </tr>
</table>
## 配置mybatis-config.xml
```xml
<?xml version="1.0" encoding="UTF-8" ?>       
<!DOCTYPE configuration       
    PUBLIC "-//mybatis.org//DTD Config 3.0//EN"       
    "http://mybatis.org/dtd/mybatis-3-config.dtd">    
<configuration>    
    <typeAliases>    
        <!--给实体类起一个别名 role -->    
        <typeAlias type="mrbird.leanote.pojo.Role" alias="role" />    
    </typeAliases>    
    <!--数据源配置 -->    
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
    <mappers>    
        <!--RoleMapper.xml装载进来  同等于把'dao'的实现装载进来 -->    
        <mapper resource="mrbird/leanote/mapper/RoleMapper.xml" />    
    </mappers>    
</configuration>      
```
## 构建SqlSessionFactory  
利用mybatis-config.xml完成SqlSessionFactory的构建，并创建SqlSession。采用单例的形式构建SqlSessionFactory。
```java
package mrbird.leanote.util;
 
import java.io.IOException;
import java.io.InputStream;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
 
public class SqlSessionFactoryUtil {
    private static SqlSessionFactory sqlSessionFactory = null;
    //类线程锁
    private static final Class CLASS_LOCK = SqlSessionFactoryUtil.class;
    //私有化构造函数
    private SqlSessionFactoryUtil(){}
    //构建SqlSessionFactory
    public static SqlSessionFactory initSqlSessionFactory(){
        String resource = "mybatis-config.xml";
        InputStream in = null;
        try {
            in = Resources.getResourceAsStream(resource);
        } catch (IOException e) {
            e.printStackTrace();
        }
        synchronized (CLASS_LOCK) {
            if(sqlSessionFactory == null){
                sqlSessionFactory = new SqlSessionFactoryBuilder().build(in);
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
## POJO 
创建一个与库表对应的POJO：
```java
package mrbird.leanote.pojo;
 
public class Role {
    private Long id;
    private String roleName;
    private String note;
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public String getRoleName() {
        return roleName;
    }
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
    public String getNote() {
        return note;
    }
    public void setNote(String note) {
        this.note = note;
    }	
}
```
## 接口与映射文件
新建一个RoleMapper接口，包含简单的CRUD抽象方法：
```java
package mrbird.leanote.mapper;
 
import mrbird.leanote.pojo.Role;
 
public interface RoleMapper {
    public Role getRole(Long id);
    public int deleteRole(Long id);
    public int createRole(Role role);
}
```
编写RoleMapper.xml映射文件，让其自动映射RoleMapper interface：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<!--和接口路径和名称保持一致，MyBatis会自动帮我们找到这个 Mapper-->  
<mapper namespace="mrbird.leanote.mapper.RoleMapper">  
    <!-- id与接口方法名一致，参数类型与接口方法参数类型一致，返回值类型与接口方法一致
         'role'为mybatis-config.xml中定义的别名 -->
    <select id="getRole" parameterType="long" resultType="role">
        <![CDATA[
            select id,role_name as roleName,note from t_role where id = #{id}
        ]]>
    </select>
    <insert id="createRole" parameterType="role">
        <![CDATA[
            insert into t_role(role_name,note) values (#{roleName},#{note})
        ]]>
    </insert>
        <delete id="deleteRole" parameterType="long">
        <![CDATA[
            delete from t_role where id = #{id}
        ]]>
    </delete>
</mapper> 
```
## 测试
测试插入数据：
```java
package mrbird.leanote.mian;
 
import mrbird.leanote.mapper.RoleMapper;
import mrbird.leanote.pojo.Role;
import mrbird.leanote.util.SqlSessionFactoryUtil;
import org.apache.ibatis.session.SqlSession;
 
public class MyBatisMain {
    public static void main(String[] args) {
        SqlSession sqlSession = null;
        try {
            sqlSession = SqlSessionFactoryUtil.openSqlSession();
            RoleMapper roleMapper = sqlSession.getMapper(RoleMapper.class);
            Role role = new Role();
            role.setRoleName("mrbird");
            role.setNote("the fun of code");
            roleMapper.createRole(role);
            sqlSession.commit();
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
        }finally{
            if(sqlSession != null){
                sqlSession.close();
            }
        }
    }
}
```
运行后查询数据库：
```sql
mysql> select * from t_role;
+----+-----------+-----------------+
| id | role_name | note            |
+----+-----------+-----------------+
|  1 | mrbird    | the fun of code |
+----+-----------+-----------------+
1 row in set (0.00 sec)
```
创建成功。

测试删除：
```java
public class MyBatisMain {
    public static void main(String[] args) {
        SqlSession sqlSession = null;
        try {
            sqlSession = SqlSessionFactoryUtil.openSqlSession();
            RoleMapper roleMapper = sqlSession.getMapper(RoleMapper.class);
            roleMapper.deleteRole(1L);
            sqlSession.commit();
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
        }finally{
            if(sqlSession != null){
                sqlSession.close();
            }
        }
    }
}
```
运行后查询数据库：
```sql
mysql> select * from t_role;
Empty set (0.00 sec)
```
删除成功。

> [《深入浅出MyBatis技术原理与实战》](https://book.douban.com/subject/26858114/)读书笔记    