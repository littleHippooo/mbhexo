---
title: MyBatis通用Mapper和PageHelper
date: 2017-12-28 19:12:25
tags: MyBatis
---
如果项目中使用到了MyBatis框架，那么使用通用Mapper和PageHelper分页插件将极大的简化我们的操作。通用Mapper可以简化对单表的CRUD操作，PageHelper分页插件可以帮我们自动拼接分页SQL，并且可以使用MyBatis Geneator来自动生成实体类，Mapper接口和Mapper xml代码，非常的方便。插件地址及作者链接[https://gitee.com/free](https://gitee.com/free)。
<!--more-->
## 引入依赖
这里使用Spring Boot来构建，可参考[Spring-Boot中使用Mybatis.html](Spring-Boot中使用Mybatis.html)搭建一个Spring boot + MyBatis的框架，然后在pom中引入：
```xml
<!-- mybatis -->
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>1.3.1</version>
</dependency>
<!-- 通用mapper -->
<dependency>
    <groupId>tk.mybatis</groupId>
    <artifactId>mapper-spring-boot-starter</artifactId>
    <version>1.1.5</version>
</dependency>
<!-- pagehelper 分页插件 -->
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper-spring-boot-starter</artifactId>
    <version>1.2.3</version>
</dependency>
```
接着在pom中配置MyBatis Geneator：
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.mybatis.generator</groupId>
            <artifactId>mybatis-generator-maven-plugin</artifactId>
            <version>1.3.5</version>
            <dependencies>
                <dependency>
                    <!-- 数据库连接驱动 -->
                    <groupId>com.oracle</groupId>
                    <artifactId>ojdbc6</artifactId>
                    <version>6.0</version>
                </dependency>
                <dependency>
                    <groupId>tk.mybatis</groupId>
                    <artifactId>mapper</artifactId>
                    <version>3.4.0</version>
                </dependency>
            </dependencies>
            <executions>
                <execution>
                    <id>Generate MyBatis Artifacts</id>
                    <phase>package</phase>
                    <goals>
                        <goal>generate</goal>
                    </goals>
                </execution>
            </executions>
            <configuration>
                <!--允许移动生成的文件 -->
                <verbose>true</verbose>
                <!-- 是否覆盖 -->
                <overwrite>true</overwrite>
                <!-- 自动生成的配置 -->
                <configurationFile>src/main/resources/mybatis-generator.xml</configurationFile>
            </configuration>
        </plugin>
    </plugins>
</build>
```
`src/main/resources/mybatis-generator.xml`为生成器的配置，下文会介绍到。
## 配置插件
在Spring Boot配置文件application.yml中配置MyBatis：
```yml
mybatis:
  # type-aliases扫描路径
  type-aliases-package: com.springboot.bean
  # mapper xml实现扫描路径
  mapper-locations: classpath:mapper/*.xml
  property:
    order: BEFORE
```
接下来开始配置插件。
### 配置通用Mapper
在Spring Boot配置文件application.yml中配置通用Mapper：
```yml
#mappers 多个接口时逗号隔开
mapper:
  mappers: com.springboot.config.MyMapper
  not-empty: false
  identity: oracle
```
关于参数的说明，参考[https://gitee.com/free/Mapper/blob/master/wiki/mapper3/2.Integration.md](https://gitee.com/free/Mapper/blob/master/wiki/mapper3/2.Integration.md)中的**可配参数介绍**。

除此之外，我们需要定义一个MyMapper接口：
```java
import tk.mybatis.mapper.common.Mapper;
import tk.mybatis.mapper.common.MySqlMapper;

public interface MyMapper<T> extends Mapper<T>, MySqlMapper<T> {
	
}
```
值得注意的是，该接口不能被扫描到，应该和自己定义的Mapper分开。自己定义的Mapper都需要继承这个接口。
### 配置PageHelper
在Spring Boot配置文件application.yml中配置通用配置PageHelper：
```yml
#pagehelper
pagehelper: 
  helperDialect: oracle
  reasonable: true
  supportMethodsArguments: true
  params: count=countSql
```
参数相关说明参考[https://github.com/pagehelper/Mybatis-PageHelper/blob/master/wikis/zh/HowToUse.md](https://github.com/pagehelper/Mybatis-PageHelper/blob/master/wikis/zh/HowToUse.md)中的**分页插件参数介绍**。
### 配置Geneator*
在路径src/main/resources/下新建mybatis-generator.xml：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
    PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
    "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
<generatorConfiguration>
    <context id="oracle" targetRuntime="MyBatis3Simple" defaultModelType="flat">

        <plugin type="tk.mybatis.mapper.generator.MapperPlugin">
            <!-- 该配置会使生产的Mapper自动继承MyMapper -->
            <property name="mappers" value="com.springboot.config.MyMapper" />
            <!-- caseSensitive默认false，当数据库表名区分大小写时，可以将该属性设置为true -->
            <property name="caseSensitive" value="false"/>
        </plugin>

        <!-- 阻止生成自动注释 -->
        <commentGenerator>
            <property name="javaFileEncoding" value="UTF-8"/>
            <property name="suppressDate" value="true"/>
            <property name="suppressAllComments" value="true"/>
        </commentGenerator>

        <!-- 数据库链接地址账号密码 -->
        <jdbcConnection 
            driverClass="oracle.jdbc.driver.OracleDriver"
            connectionURL="jdbc:oracle:thin:@localhost:1521:ORCL"
            userId="scott"
            password="6742530">
        </jdbcConnection>

        <javaTypeResolver>
            <property name="forceBigDecimals" value="false"/>
        </javaTypeResolver>

        <!-- 生成Model类存放位置 -->
        <javaModelGenerator targetPackage="com.springboot.bean" targetProject="src/main/java">
            <property name="enableSubPackages" value="true"/>
            <property name="trimStrings" value="true"/>
        </javaModelGenerator>

        <!-- 生成映射文件存放位置 -->
        <sqlMapGenerator targetPackage="mapper" targetProject="src/main/resources">
            <property name="enableSubPackages" value="true"/>
        </sqlMapGenerator>

        <!-- 生成Dao类存放位置 -->
        <!-- 客户端代码，生成易于使用的针对Model对象和XML配置文件的代码
            type="ANNOTATEDMAPPER",生成Java Model 和基于注解的Mapper对象
            type="XMLMAPPER",生成SQLMap XML文件和独立的Mapper接口 -->
        <javaClientGenerator type="XMLMAPPER" targetPackage="com.springboot.mapper" targetProject="src/main/java">
            <property name="enableSubPackages" value="true"/>
        </javaClientGenerator>

        <!-- 配置需要生成的表 -->
        <table tableName="T_USER" domainObjectName="User" enableCountByExample="false" enableUpdateByExample="false" enableDeleteByExample="false" enableSelectByExample="false" selectByExampleQueryId="false">
            <generatedKey column="id" sqlStatement="oralce" identity="true"/>
        </table>
    </context>
</generatorConfiguration>
```
更详细的说明可参考链接：[http://blog.csdn.net/isea533/article/details/42102297](http://blog.csdn.net/isea533/article/details/42102297)。

## 代码生成
配置好MyBatis Geneator后，在eclipse中运行命令`mybatis-generator:generate`：

![QQ截图20171227095243.png](img/QQ截图20171227095243.png)

以下为自动成成的代码：

User：
```java
@Table(name = "T_USER")
public class User {
    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "USERNAME")
    private String username;
    
    @Column(name = "PASSWD")
    private String passwd;
    
    @Column(name = "CREATE_TIME")
    private Date createTime;
    
    @Column(name = "STATUS")
    private String status;

    ...
}    
```
因为这里数据库试用的是Oracle，其没有主键自动自增的功能，这里先将`@GeneratedValue(strategy = GenerationType.IDENTITY)`去掉，主键的生成下面会介绍到。生成的主键是BigDecimal类型的，我们将其改为Long类型。

UserMapper：
```java
import com.springboot.bean.User;
import com.springboot.config.MyMapper;

public interface UserMapper extends MyMapper<User> {
}
```
UserMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.springboot.mapper.UserMapper">
    <resultMap id="BaseResultMap" type="com.springboot.bean.User">
        <!--
        WARNING - @mbg.generated
        -->
        <id column="ID" jdbcType="DECIMAL" property="id" />
        <result column="USERNAME" jdbcType="VARCHAR" property="username" />
        <result column="PASSWD" jdbcType="VARCHAR" property="passwd" />
        <result column="CREATE_TIME" jdbcType="TIMESTAMP" property="createTime" />
        <result column="STATUS" jdbcType="CHAR" property="status" />
    </resultMap>
</mapper>
```
极其方便的说！

## Mapper
要让Spring Boot扫描到Mapper接口，需要在Spring Boot入口类中加入`@MapperScan("com.springboot.mapper")`注解。

为了获取到Oracle 中序列的值，我们定义一个SeqenceMapper接口：
```java
public interface SeqenceMapper {
    @Select("select ${seqName}.nextval from dual")
    Long getSequence(@Param("seqName") String seqName);
}
```
因为这里仅介绍Mapper自带的CRUD方法，所以UserMapper接口中无需定义任何方法。
## 通用Service
我们可以定义一个通用的Service，在其中定义一些通用的方法：

IService：
```java
@Service
public interface IService<T> {

    Long getSequence(@Param("seqName") String seqName);
    
    List<T> selectAll();
    
    T selectByKey(Object key);
    
    int save(T entity);
    
    int delete(Object key);
    
    int updateAll(T entity);
    
    int updateNotNull(T entity);
    
    List<T> selectByExample(Object example);
}
```
其实现类BaseService：
```java
public abstract class BaseService<T> implements IService<T> {

    @Autowired
    protected Mapper<T> mapper;
    @Autowired
    protected SeqenceMapper seqenceMapper;
    
    public Mapper<T> getMapper() {
        return mapper;
    }
    @Override
    public Long getSequence(@Param("seqName") String seqName){
        return seqenceMapper.getSequence(seqName);
    }
    
    @Override
    public List<T> selectAll() {
        //说明：查询所有数据
        return mapper.selectAll();
    }
    
    @Override
    public T selectByKey(Object key) {
        //说明：根据主键字段进行查询，方法参数必须包含完整的主键属性，查询条件使用等号
        return mapper.selectByPrimaryKey(key);
    }
    
    @Override
    public int save(T entity) {
        //说明：保存一个实体，null的属性也会保存，不会使用数据库默认值
        return mapper.insert(entity);
    }
    
    @Override
    public int delete(Object key) {
        //说明：根据主键字段进行删除，方法参数必须包含完整的主键属性
        return mapper.deleteByPrimaryKey(key);
    }
    
    @Override
    public int updateAll(T entity) {
        //说明：根据主键更新实体全部字段，null值会被更新
        return mapper.updateByPrimaryKey(entity);
    }
    
    @Override
    public int updateNotNull(T entity) {
        //根据主键更新属性不为null的值
        return mapper.updateByPrimaryKeySelective(entity);
    }
    
    @Override
    public List<T> selectByExample(Object example) {
        //说明：根据Example条件进行查询
        //重点：这个查询支持通过Example类指定查询列，通过selectProperties方法指定查询列
        return mapper.selectByExample(example);
    }
}
```
接下来让UserService接口继承IService接口：
```java
public interface UserService extends IService<User>{
	
}
```
其实现类UserServiceImpl：
```java
@Repository("userService")
public class UserServiceImpl extends BaseService<User> implements UserService{
	
}
```
这样即可在UserService中使用BaseService中的通用方法了。
## 测试
测试插入：
```java
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = Application.class)
public class ApplicationTest {
    @Autowired
    private UserService userService;
    
    @Test
    public void test() throws Exception {
        User user = new User();
        user.setId(userService.getSequence("seq_user"));
        user.setUsername("scott");
        user.setPasswd("ac089b11709f9b9e9980e7c497268dfa");
        user.setCreateTime(new Date());
        user.setStatus("0");
        this.userService.save(user);
    }
}
```
运行代码，查看数据库：

![QQ截图20171227102024.png](img/QQ截图20171227102024.png)

测试查询：
```java
Example example = new Example(User.class);
example.createCriteria().andCondition("username like '%i%'");
example.setOrderByClause("id desc");
List<User> userList = this.userService.selectByExample(example);
for (User u : userList) {
    System.out.println(u.getUsername());
}

List<User> all = this.userService.selectAll();
for (User u : all) {
    System.out.println(u.getUsername());
}

User user = new User();
user.setId(1l);
user = this.userService.selectByKey(user);
System.out.println(user.getUsername());
```
测试删除：
```java
User user = new User();
user.setId(4l);
this.userService.delete(user);
```
分页测试，从第二页开始，每页2条数据：
```java
PageHelper.startPage(2, 2);
List<User> list = userService.selectAll();
PageInfo<User> pageInfo = new PageInfo<User>(list);
List<User> result = pageInfo.getList();
for (User u : result) {
    System.out.println(u.getUsername());
}
```
查看日志打印出的SQL：
```
2017-12-28 10:25:14.033 DEBUG 11116 --- [main] c.s.mapper.UserMapper.selectAll          : ==>  Preparing: SELECT * FROM ( SELECT TMP_PAGE.*, ROWNUM ROW_ID FROM (
                                                                                                          SELECT ID,USERNAME,PASSWD,CREATE_TIME,STATUS FROM T_USER ) TMP_PAGE WHERE ROWNUM <= ? ) WHERE ROW_ID > ? 
2017-12-28 10:25:14.068 DEBUG 11116 --- [main] c.s.mapper.UserMapper.selectAll          : ==> Parameters: 4(Integer), 2(Integer)
2017-12-28 10:25:14.073 DEBUG 11116 --- [main] c.s.mapper.UserMapper.selectAll          : <==      Total: 2
```
插件已经帮我自动拼接好了。

其他注意事项参考官方说明。源码链接：[https://drive.google.com/open?id=1ePz1ihSGSFwNtE_-FWHEG-F5qOJ3dLQi](https://drive.google.com/open?id=1ePz1ihSGSFwNtE_-FWHEG-F5qOJ3dLQi)