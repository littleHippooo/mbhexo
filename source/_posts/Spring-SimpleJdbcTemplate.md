---
title: Spring SimpleJdbcTemplate
date: 2016-10-12 14:29:31
tags: Spring
---
Spring提供了JDBC模板，代替了JDBC繁琐操作。使用Spring JDBC模板我们不再需要手动去关闭连接，抛出的异常也更为明确。
## 准备工作
数据库创建表：
```sql
create table userinfo (
    userid varchar2(5) not null,
    name varchar2(10),
    age varchar2(3),
    pwd varchar2(10)
)
```
<!--more-->
创建序列：
```sql
create sequence user_seq start with 1 increment by 1;
```
## 配置数据源连接池    
新建一个数据库配置文件db.properties：
```xml
username=oracle
password=123456
url=jdbc:oracle:thin:/localhost:1521/orcl
```
在Spring配置文件读取db.properties
```xml
<util:properties id="db" location="classpath:db.properties" /> 
```
配置连接池：
```xml
<bean id="dataSource" 
    class="org.apache.commons.dbcp.BasicDataSource">
    <property name="driverClassName" 
        value="oracle.jdbc.OracleDriver"/>
    <!-- SpEL读取 -->
    <property name="url" value="#{db.url}"/>
    <property name="username" value="#{db.username}"/>
    <property name="password" value="#{db.password}"/>
    <property name="initialSize" value="5"/>
    <property name="maxActive" value="10"/>
</bean>
```
除了上述配置属性，下表列出了BasicDataSource的一些常用属性：
<table>
        <tr>
            <th>
                池配置属性
            </th>
            <th>
                所指定的内容
            </th>
        </tr>
        <tr>
            <td>
                initialSize
            </td>
            <td>
                池启动时创建的连接数量
            </td>
        </tr>
        <tr>
            <td>
                maxActive
            </td>
            <td>
                同一时间可以从池中分配的最多连接数，如果设置为0，表示无限制
            </td>
        </tr>
        <tr>
            <td>
                maxIdle
            </td>
            <td>
                池里不会被释放的最多空闲连接数。如果设置为0，表示无限制
            </td>
        </tr>
        <tr>
            <td>
                maxOpenPreparedStatements
            </td>
            <td>
                
                    在同一时间能够从语句池中分配的预处理语句的最大数量。如果设置
                
                
                    为0，表示无限制
                
            </td>
        </tr>
        <tr>
            <td>
                maxWait
            </td>
            <td>
                
                    在抛出异常之前，池等待连接回收的最大时间 (当没有可用连接时)。
                
                
                    如果设置为-1，表示无限等待
                
            </td>
        </tr>
        <tr>
            <td>
                minEvictableIdleTimeMillis
            </td>
            <td>
                连接在池中保持空闲而不被回收的最大时间
            </td>
        </tr>
        <tr>
            <td>
                minIdle
            </td>
            <td>
                在不创建新连接的情况下，池中保持空闲的最小连接数
            </td>
        </tr>
        <tr>
            <td>
                poolPreparedStatements
            </td>
            <td>
                是否对预处理语句进行池管理（布尔类型）
            </td>
        </tr>
</table>

## 使用JdbcTemplate
在Spring配置文件中配置JdbcTemplate：
```xml
<bean id="jdbcTemplate" 
    class="org.springframework.jdbc.core.simple.SimpleJdbcTemplate">
    <constructor-arg ref="dataSource"/>
</bean>
```
新建一个User类，用于存储查询结果：
```java
public class User {
    private Integer userId;
    private String name;
    private String age;
    private String password;
    // get,set略
}	
```
新建UserDao interface，定义基本的增删改查方法：
```java
public interface UserDao {
    void addUser(User user);
    void deleteUser(Integer userId);
    void updateUser(User user);
    User selectUser(Integer userId);
    List<User> selectAll();
}
```
新建UserDao实现类UserDaoImpl：
```java
// DAO注解
@Repository("userDao")
public class UserDaoImpl implements UserDao {
    // 注入JdbcTemplate
    @Resource
    private SimpleJdbcTemplate jdbcTemplate;
    // ......
}	
```
### 增加用户
实现addUser()方法：
```java
private static final String SQL_INSERT_USER
        = "insert into userinfo (userid,name,age,pwd) "
        + "values (user_seq.nextval,?,?,?)";
public void addUser(User user) {
    Object[] params = { 
        user.getName(), 
        user.getAge(), 
        user.getPassword() };
    jdbcTemplate.update(SQL_INSERT_USER, params);
}
```
上述SQL使用了索引参数，这使得我们不得不严格按照参数的顺序来定义参数。SimpleJdbcTemplate支持使用命名参数的SQL。修改addUser()方法：
```java
private static final String SQL_INSERT_USER
        = "insert into userinfo (userid,name,age,pwd) "
        + "values (user_seq.nextval,:name,:age,:pwd)";
public void addUser(User user) {
    Map<String, Object> params=new HashMap<String, Object>();
    params.put("name", user.getName());
    params.put("age", user.getAge());
    params.put("pwd", user.getPassword());
    jdbcTemplate.update(SQL_INSERT_USER, params);
}
```
现在，参数的顺序已经不重要了，只要参数名称对应上就行。

测试：
```java
public class TestJdbc {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserDao dao=ac.getBean("userDao",UserDao.class);
        User user=new User();
        user.setName("SCOTT");
        user.setAge("25");
        user.setPassword("123456");
        dao.addUser(user);
    }
}
```
查询数据库：
```sql
SQL> select * from lzp.userinfo where name='SCOTT';
 
USERI NAME       AGE PWD
----- ---------- --- ----------
5     SCOTT      25  123456
```
### 删除用户
实现deleteUser()方法：
```java
private static final String SQL_DELETE_USER = 
        "delete from userinfo where userid=?";
public void deleteUser(Integer userId) {
    jdbcTemplate.update(SQL_DELETE_USER, userId);
}
```
测试：
```java
public class TestJdbc {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserDao dao=ac.getBean("userDao",UserDao.class);
        dao.deleteUser(5);
    }
}
```
查询数据库，SCOTT已被删除：
```sql
SQL> select * from lzp.userinfo;
 
USERI NAME       AGE PWD
----- ---------- --- ----------
6     JANE       24  123456
7     MIKE       28  123456
```
### 查询单个用户
实现selectUser()方法：
```java
private static final String SQL_SELECT_USER = 
        "select * from userinfo where userid = ?";
public User selectUser(Integer userId) {
    return jdbcTemplate.queryForObject(
        SQL_SELECT_USER,
        new ParameterizedRowMapper<User>() {
            public User mapRow(ResultSet rs, int rowNum) 
                throws SQLException {
                User user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setName(rs.getString("name"));
                user.setAge(rs.getString("age"));
                user.setPassword(rs.getString("pwd"));
                return user;
            }
        }, userId);
}
```
测试：
```java
public class TestJdbc {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserDao dao=ac.getBean("userDao",UserDao.class);
        User user=new User();
        user=dao.selectUser(6);
        System.out.println(user.getName());
        // JANE
    }
}
```
### 查询所有用户
实现selectAll()方法：
```java
private static final String SQL_SELECT_All_USER = "select * from userinfo";   
public List<User> selectAll() {
    return jdbcTemplate.query(
        SQL_SELECT_All_USER, 
        new ParameterizedRowMapper<User>() {
            public User mapRow(ResultSet rs, int rowNum) 
                throws SQLException {
                User user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setName(rs.getString("name"));
                user.setAge(rs.getString("age"));
                user.setPassword(rs.getString("pwd"));
                return user;
          }
    });
}
```
测试：
```java
public class TestJdbc {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserDao dao=ac.getBean("userDao",UserDao.class);
        List<User> list=dao.selectAll();
        for(User u:list){
            System.out.println(u.getName());
        }
    }
}
```
输出：
```xml
JANE
MIKE
```
### 修改用户
实现updateUser()方法：
```java
private static final String SQL_UPDATE_USER = 
    "update userinfo set age=:age where userid=:userid";
public void updateUser(User user) {
    Map<String, Object> params=new HashMap<String, Object>();
    params.put("userid", user.getUserId());
    params.put("age", user.getAge());
    jdbcTemplate.update(SQL_UPDATE_USER, params);
}
```
测试：
```java
public class TestJdbc {
    public static void main(String[] args) {
        ApplicationContext ac
            = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserDao dao=ac.getBean("userDao",UserDao.class);
        User user=new User();
        user.setUserId(6);
        user.setAge("100");
        dao.updateUser(user);
    }
}
```
查询数据库，可发现值已被修改：
```sql
SQL> select * from lzp.userinfo;
 
USERI NAME       AGE PWD
----- ---------- --- ----------
6     JANE       100 123456
7     MIKE       28  123456
```
## Spring JDBC DAO支持类
除了向DAO中注入`simpleJdbcTemplate`外，我们还可以通过继承Spring提供的`SimpleJdbcDaoSupport`类：
```java
public class UserDaoImpl extends SimpleJdbcDaoSupport implements UserDao {
    //...   
} 
```
获取`simpleJdbcTemplate`对象可通过静态方法：`getSimpleJdbcTemplate()`。

> [《Spring In Action》](https://book.douban.com/subject/5283241/)读书笔记