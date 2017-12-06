---
title: Spring Boot JdbcTemplate配置Druid多数据源
date: 2017-08-17 19:59:03
tags: [Spring,Spring Boot,Druid]
---
JdbcTemplate配置Druid多数据源的核心在于创建JdbcTemplate时候为其分配不同的数据源，然后在需要访问不同数据库的时候使用对应的JdbcTemplate即可。这里介绍在Spring Boot中基于Oracle和Mysql配置Druid多数据源。
## 引入依赖
先根据[https://mrbird.cc/%E5%BC%80%E5%90%AFSpring-Boot.html](https://mrbird.cc/%E5%BC%80%E5%90%AFSpring-Boot.html)开启一个最简单的Spring Boot应用，然后引入如下依赖：
<!--more-->
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>

<!-- oracle驱动 -->
<dependency>
    <groupId>com.oracle</groupId>
    <artifactId>ojdbc6</artifactId>
    <version>6.0</version>
</dependency>

<!-- mysql驱动 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>

<!-- druid数据源驱动 -->
<dependency>
   <groupId>com.alibaba</groupId>
   <artifactId>druid-spring-boot-starter</artifactId>
   <version>1.1.6</version>
</dependency>
```
## 多数据源配置
接着在Spring Boot配置文件application.yml中配置多数据源：
```yml
server:
  context-path: /web

spring:
  datasource:
    druid:
      # 数据库访问配置, 使用druid数据源
      # 数据源1 mysql
      mysql:
        type: com.alibaba.druid.pool.DruidDataSource
        driver-class-name: com.mysql.jdbc.Driver
        url: jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=UTF-8&rewriteBatchedStatements=true&autoReconnect=true&failOverReadOnly=false&zeroDateTimeBehavior=convertToNull
        username: root
        password: 123456
      # 数据源2 oracle
      oracle: 
        type: com.alibaba.druid.pool.DruidDataSource
        driver-class-name: oracle.jdbc.driver.OracleDriver
        url: jdbc:oracle:thin:@localhost:1521:ORCL
        username: scott
        password: 123456
        
      # 连接池配置
      initial-size: 5
      min-idle: 5
      max-active: 20
      # 连接等待超时时间
      max-wait: 30000
      # 配置检测可以关闭的空闲连接间隔时间
      time-between-eviction-runs-millis: 60000
      # 配置连接在池中的最小生存时间
      min-evictable-idle-time-millis: 300000
      validation-query: select '1' from dual
      test-while-idle: true
      test-on-borrow: false
      test-on-return: false
      # 打开PSCache，并且指定每个连接上PSCache的大小
      pool-prepared-statements: true
      max-open-prepared-statements: 20
      max-pool-prepared-statement-per-connection-size: 20
      # 配置监控统计拦截的filters, 去掉后监控界面sql无法统计, 'wall'用于防火墙
      filters: stat,wall
      # Spring监控AOP切入点，如x.y.z.service.*,配置多个英文逗号分隔
      aop-patterns: com.springboot.servie.*
      
    
      # WebStatFilter配置
      web-stat-filter:
        enabled: true
        # 添加过滤规则
        url-pattern: /*
        # 忽略过滤的格式
        exclusions: '*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*'
      
      # StatViewServlet配置 
      stat-view-servlet:
        enabled: true
        # 访问路径为/druid时，跳转到StatViewServlet
        url-pattern: /druid/*
        # 是否能够重置数据
        reset-enable: false
        # 需要账号密码才能访问控制台
        login-username: druid
        login-password: druid123
        # IP白名单
        # allow: 127.0.0.1
        #　IP黑名单（共同存在时，deny优先于allow）
        # deny: 192.168.1.218
      
      # 配置StatFilter
      filter: 
        stat: 
          log-slow-sql: true 
```
然后创建一个多数据源配置类，根据application.yml分别配置一个Mysql和Oracle的数据源，并且将这两个数据源注入到两个不同的JdbcTemplate中：
```java
@Configuration
public class DataSourceConfig {
    @Primary
    @Bean(name = "mysqldatasource")
    @ConfigurationProperties("spring.datasource.druid.mysql")
    public DataSource dataSourceOne(){
        return DruidDataSourceBuilder.create().build();
    }
    
    @Bean(name = "oracledatasource")
    @ConfigurationProperties("spring.datasource.druid.oracle")
    public DataSource dataSourceTwo(){
        return DruidDataSourceBuilder.create().build();
    }
    
    @Bean(name = "mysqlJdbcTemplate")
    public JdbcTemplate primaryJdbcTemplate(
            @Qualifier("mysqldatasource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
    
    @Bean(name = "oracleJdbcTemplate")
    public JdbcTemplate secondaryJdbcTemplate(
            @Qualifier("oracledatasource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}
```
上述代码根据application.yml创建了mysqldatasource和oracledatasource数据源，其中mysqldatasource用`@Primary`标注为主数据源，接着根据这两个数据源创建了mysqlJdbcTemplate和oracleJdbcTemplate。

`@Primary`标志这个Bean如果在多个同类Bean候选时，该Bean优先被考虑。多数据源配置的时候，必须要有一个主数据源，用`@Primary`标志该Bean。

数据源创建完毕，接下来开始进行测试代码编写。
## 测试
首先往Mysql和Oracle中创建测试表，并插入一些测试数据：

Mysql：
```sql
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `sno` varchar(3) NOT NULL,
  `sname` varchar(9) NOT NULL,
  `ssex` char(2) NOT NULL,
  `database` varchar(10) DEFAULT NULL
) DEFAULT CHARSET=utf8;

INSERT INTO `student` VALUES ('001', '康康', 'M', 'mysql');
INSERT INTO `student` VALUES ('002', '麦克', 'M', 'mysql');
```
Oracle：
```sql
DROP TABLE "SCOTT"."STUDENT";
CREATE TABLE "SCOTT"."STUDENT" (
  "SNO" VARCHAR2(3 BYTE) NOT NULL ,
  "SNAME" VARCHAR2(9 BYTE) NOT NULL ,
  "SSEX" CHAR(2 BYTE) NOT NULL ,
  "database" VARCHAR2(10 BYTE) NULL 
);

INSERT INTO "SCOTT"."STUDENT" VALUES ('001', 'KangKang', 'M ', 'oracle');
INSERT INTO "SCOTT"."STUDENT" VALUES ('002', 'Mike', 'M ', 'oracle');
INSERT INTO "SCOTT"."STUDENT" VALUES ('003', 'Jane', 'F ', 'oracle');
INSERT INTO "SCOTT"."STUDENT" VALUES ('004', 'Maria', 'F ', 'oracle');
```
接着创建两个Dao及其实现类，分别用于从Mysql和Oracle中获取数据：

MysqlStudentDao接口：
```java
public interface MysqlStudentDao {
    List<Map<String, Object>> getAllStudents();
}
```
MysqlStudentDao实现；
```java
@Repository
public class MysqlStudentDaoImp implements MysqlStudentDao{
    @Autowired
    @Qualifier("mysqlJdbcTemplate")
    private JdbcTemplate jdbcTemplate;
    
    @Override
    public List<Map<String, Object>> getAllStudents() {
        return this.jdbcTemplate.queryForList("select * from student");
    }
}
```
可看到，在MysqlStudentDaoImp中注入的是mysqlJdbcTemplate。

OracleStudentDao接口：
```java
public interface OracleStudentDao {
    List<Map<String, Object>> getAllStudents();
}
```
OracleStudentDao实现：
```java
@Repository
public class OracleStudentDaoImp implements OracleStudentDao{
    @Autowired
    @Qualifier("oracleJdbcTemplate")
    private JdbcTemplate jdbcTemplate;
    
    @Override
    public List<Map<String, Object>> getAllStudents() {
        return this.jdbcTemplate.queryForList("select * from student");
    }
}
```
在OracleStudentDaoImp中注入的是oracleJdbcTemplate。

随后编写Service层：

StudentService接口：
```java
public interface StudentService {
    List<Map<String, Object>> getAllStudentsFromOralce();
    List<Map<String, Object>> getAllStudentsFromMysql();
}

```
StudentService实现：
```java
@Service("studentService")
public class StudentServiceImp implements StudentService{
    @Autowired
    private OracleStudentDao oracleStudentDao;
    @Autowired
    private MysqlStudentDao mysqlStudentDao;
    
    @Override
    public List<Map<String, Object>> getAllStudentsFromOralce() {
        return this.oracleStudentDao.getAllStudents();
    }
    
    @Override
    public List<Map<String, Object>> getAllStudentsFromMysql() {
        return this.mysqlStudentDao.getAllStudents();
    }
}
```
最后编写一个Controller：
```java
@RestController
public class StudentController {
    @Autowired
    private StudentService studentService;
    
    @RequestMapping("querystudentsfromoracle")
    public List<Map<String, Object>> queryStudentsFromOracle(){
        return this.studentService.getAllStudentsFromOralce();
    }
    
    @RequestMapping("querystudentsfrommysql")
    public List<Map<String, Object>> queryStudentsFromMysql(){
        return this.studentService.getAllStudentsFromMysql();
    }
}
```
最终项目目录如下图所示：

![QQ截图20171206092910.png](img/QQ截图20171206092910.png)

启动项目，访问：[http://localhost:8080/web/querystudentsfrommysql](http://localhost:8080/web/querystudentsfrommysql)：

![QQ截图20171206093020.png](img/QQ截图20171206093020.png)

[http://localhost:8080/web/querystudentsfromoracle](http://localhost:8080/web/querystudentsfromoracle)：

![QQ截图20171206093117.png](img/QQ截图20171206093117.png)

> [source code](https://drive.google.com/open?id=1-CVx2gJ1t6wHkfVseZnwxBmlOgVSs_87)