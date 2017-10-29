---
title: MyBatis typeHandler
date: 2017-01-04 14:52:57
tags: MyBatis
---
MyBatis在设置参数或者从结果集中获取参数的时候，都会用到注册了的typeHandler进行处理。typeHandler的作用为将参数从javaType转为jdbcType，或者从数据库取出结果时把jdbcType转为javaType。
<!--more-->
## 带的typeHandler
<table>
        <tr>
            <td>
                类型处理器
            </td>
            <td>
                Java类型
            </td>
            <td>
                JDBC类型
            </td>
        </tr>
        <tr>
            <td>
                BooleanTypeHandler
            </td>
            <td>
                java.lang.Boolean,boolean
            </td>
            <td>
                数据库兼容的BOOLEAN
            </td>
        </tr>
        <tr>
            <td>
                ByteTypeHandler
            </td>
            <td>
                java.lang.Byte,byte
            </td>
            <td>
                数据库兼容的NUMERIC或BYTE
            </td>
        </tr>
        <tr>
            <td>
                ShortTypeHandler&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                java.lang.Short,short
            </td>
            <td>
                数据库兼容的NUMERIC或SHORT INTEGER
            </td>
        </tr>
        <tr>
            <td>
                IntegerTypeHandler&nbsp;
            </td>
            <td>
                java.lang.Integer,int
            </td>
            <td>
                数据库兼容的NUMERIC或INTEGER
            </td>
        </tr>
        <tr>
            <td>
                LongTypeHandler&nbsp;
            </td>
            <td>
                java.lang.Long,long
            </td>
            <td>
                数据库兼容的NUMERIC或LONG INTEGER
            </td>
        </tr>
        <tr>
            <td>
                FloatTypeHandler&nbsp;
            </td>
            <td>
                java.lang.Float,float
            </td>
            <td>
                数据库兼容的NUMERIC或FLOAT
            </td>
        </tr>
        <tr>
            <td>
                DoubleTypeHandler&nbsp;
            </td>
            <td>
                java.lang.Double,double
            </td>
            <td>
                数据库兼容的NUMERIC或DOUBLE
            </td>
        </tr>
        <tr>
            <td>
                BigDecimalTypeHandler
            </td>
            <td>
                java.math.BigDecimal
            </td>
            <td>
                数据库兼容的NUMERIC或DECIMAL
            </td>
        </tr>
        <tr>
            <td>
                StringTypeHandler&nbsp;
            </td>
            <td>
                java.lang.Stirng
            </td>
            <td>
                CHAR,VARCHAR
            </td>
        </tr>
        <tr>
            <td>
                ClobypeHandler&nbsp;
            </td>
            <td>
                java.lang.String
            </td>
            <td>
                CLOB,LONGVARCHAR
            </td>
        </tr>
        <tr>
            <td>
                NStringTypeHanler
            </td>
            <td>
                java.lang.String
            </td>
            <td>
                NVARCHAR,NCHAR
            </td>
        </tr>
        <tr>
            <td>
                NClobTypeHandler&nbsp;
            </td>
            <td>
                java.lang.String
            </td>
            <td>
                NNCLOB
            </td>
        </tr>
        <tr>
            <td>
                ByteArrayTypeHandler&nbsp;
            </td>
            <td>
                byte[]
            </td>
            <td>
                数据库兼容的字节流类型
            </td>
        </tr>
        <tr>
            <td>
                BlobTypeHandler&nbsp;
            </td>
            <td>
                byte[]
            </td>
            <td>
                BLOB,LONGVARBINARY
            </td>
        </tr>
        <tr>
            <td>
                DateTypeHandler&nbsp;
            </td>
            <td>
                java.util.Date
            </td>
            <td>
                TIMESTAMP
            </td>
        </tr>
        <tr>
            <td>
                DateOnlyTypeHandler&nbsp;
            </td>
            <td>
                java.util.Date
            </td>
            <td>
                DATE
            </td>
        </tr>
        <tr>
            <td>
                TimeOnlyTypeHandler&nbsp;
            </td>
            <td>
                java.util.Date
            </td>
            <td>
                TIME
            </td>
        </tr>
        <tr>
            <td>
                SqlTimestampTypeHandler&nbsp;
            </td>
            <td>
                java.sql.Timestamp
            </td>
            <td>
                TIMESTAMP
            </td>
        </tr>
        <tr>
            <td>
                SqlDateTypeHandler&nbsp;
            </td>
            <td>
                java.sql.Date
            </td>
            <td>
                DATE
            </td>
        </tr>
        <tr>
            <td>
                SqlTimeTypeHandler&nbsp;
            </td>
            <td>
                java.sql.Time
            </td>
            <td>
                TIME
            </td>
        </tr>
        <tr>
            <td>
                ObjectTypeHandler&nbsp;
            </td>
            <td>
                Any
            </td>
            <td>
                OTHER或未指定类型
            </td>
        </tr>
        <tr>
            <td>
                EnumTypeHandler&nbsp;
            </td>
            <td>
                Enumeration Type
            </td>
            <td>
                
                    VARCHAR或任意兼容的字符串类型，存
                
                
                    储枚举的名称
                
            </td>
        </tr>
        <tr>
            <td>
                EnumOrdinalTypeHandler&nbsp;
            </td>
            <td>
                Enumeration Type
            </td>
            <td>
                
                    任何兼容的NUMERIC或DOUBLE类型，
                
                
                    存储枚举的索引
                
            </td>
        </tr>
</table>

为了演示自带的typeHandler，新建一张表：
```sql
CREATE TABLE `t_role` (
    `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
    `role_name` varchar(60) NOT NULL COMMENT '角色名称',
    `note` varchar(1024) DEFAULT NULL COMMENT '备注',
    `is_girl` varchar(20) DEFAULT NULL COMMENT '是否为女孩',
    PRIMARY KEY (`id`)
) 
```
库表对应的实体类Role略。

接口RoleMapper中定义一个createRole()抽象方法：
```java
public int createRole(Role role);
```
映射文件：
```xml
<insert id="createRole" parameterType="role">
    <![CDATA[
        insert into t_role(role_name,note,is_girl) values (#{roleName},#{note},
        #{isGirl})
    ]]>
</insert>
```
测试插入方法：
```java
......
sqlSession = SqlSessionFactoryUtil.openSqlSession();
RoleMapper roleMapper = sqlSession.getMapper(RoleMapper.class);
Role role = new Role();
role.setRoleName("雏田");
role.setNote("日向雏田");
role.setIsGirl(Boolean.TRUE);
roleMapper.createRole(role);
sqlSession.commit();
......
```
查询数据库：
```sql
mysql> select * from t_role;
+----+-----------+----------+---------+
| id | role_name | note     | is_girl |
+----+-----------+----------+---------+
| 1  |  雏田      | 日向雏田 |    1    |
+----+-----------+----------+---------+
1 row in set (0.00 sec)
```
从结果中可以看出，默认的BooleantypeHandler将true转换为了1。

如果想把true转换为Y,false转换为N,我们可以自定义BooleantypeHandler。
## 自定义typeHandler
自定义typeHandler可以通过继承BasetypeHandler或者实现typeHandler接口来实现，现自定义一个BooleanTypeHandler：
```java
package mrbird.leanote.typehandler;
 
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;
 
public class BooleanTypeHandler implements TypeHandler<Boolean>{
 
    @Override
    public Boolean getResult(ResultSet arg0, String arg1) throws SQLException {
        String str = arg0.getString(arg1);
        Boolean flag = Boolean.FALSE;
        if(str.equalsIgnoreCase("Y")){
            flag = Boolean.TRUE;
        }
        return flag;
    }
    
    @Override
    public Boolean getResult(ResultSet arg0, int arg1) throws SQLException {
        String str = arg0.getString(arg1);
        Boolean flag = Boolean.FALSE;
        if(str.equalsIgnoreCase("Y")){
            flag = Boolean.TRUE;
        }
        return flag;
    }
    
    @Override
    public Boolean getResult(CallableStatement arg0, int arg1)
            throws SQLException {
        String str = arg0.getString(arg1);
        Boolean flag = Boolean.FALSE;
        if(str.equalsIgnoreCase("Y")){
            flag = Boolean.TRUE;
        }
        return flag;  
    }
    
    @Override
    public void setParameter(PreparedStatement arg0, int arg1, Boolean arg2,
    		JdbcType arg3) throws SQLException {
        Boolean flag = (Boolean) arg2;    
        String value = flag == true ? "Y" : "N";    
        arg0.setString(arg1, value); 	
    }
}
```
在mybatis-config.xml文件中配置该typeHandler：
```xml
<typeHandlers>
    <typeHandler javaType="Boolean" jdbcType="VARCHAR" 
        handler="mrbird.leanote.typehandler.BooleanTypeHandler" />
</typeHandlers>
```
然后在映射文件中对需要转换的字段标注javaType和jdbcType，或者无需在mybatis-config.xml中注册直接在映射文件中指明typeHandler的路径即可。

指明javaType和jdbcType，与注册中的一致即可找到相对应的typeHandler：
```xml
<insert id="createRole" parameterType="role">
    <![CDATA[
        insert into t_role(role_name,note,is_girl) values (#{roleName},#{note},
        #{isGirl,javaType=Boolean,jdbcType=VARCHAR})
    ]]>
</insert>
```
或指明typeHandler路径：
```xml
<insert id="createRole" parameterType="role">
    <![CDATA[
        insert into t_role(role_name,note,is_girl) values (#{roleName},#{note},
        #{isGirl,typeHandler=mrbird.leanote.typehandler.BooleanTypeHandler})
    ]]>
</insert>
```
测试：
```java
......
sqlSession = SqlSessionFactoryUtil.openSqlSession();
RoleMapper roleMapper = sqlSession.getMapper(RoleMapper.class);
Role role = new Role();
role.setRoleName("鸣人");
role.setNote("旋涡鸣人");
role.setIsGirl(Boolean.FALSE);
roleMapper.createRole(role);
sqlSession.commit();
......
```
查询数据库：
```sql
mysql> select * from t_role;
+----+-----------+----------+---------+
| id | role_name | note     | is_girl |
+----+-----------+----------+---------+
|  1 | 雏田      | 日向雏田  | 1       |
|  2 | 鸣人      | 旋涡鸣人  | N       |
+----+-----------+----------+---------+
2 rows in set (0.00 sec)
```
可发现，false已经转换为N了。 
## 枚举类型typeHandler
MyBatis自带两种枚举类型处理器：

1.org.apache.ibatis.type.EnumOrdinalTypeHandler

2.org.apache.ibatis.type.EnumTypeHandler

EnumOrdinalTypeHandler使用整数下标传递，EnumTypeHandler使用枚举字符串传递。

创建一个枚举类型Sex：
```java
package mrbird.leanote.enums;
 
public enum Sex {
    MALE(1,"男"),FEMALE(2,"女");
    private int id;
    private String name;
    private Sex(int id, String name) {
        this.id = id;
        this.name = name;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
```
### EnumOrdinalTypeHandler
创建一张表来演示EnumOrdinalTypeHandler：
```sql
CREATE TABLE `t_student` (
    `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
    `cnname` varchar(60) NOT NULL COMMENT '学生姓名',
    `sex` tinyint(4) NOT NULL COMMENT '性别',
    `selfcard_no` int(20) NOT NULL COMMENT '学生证号',
    `note` varchar(1024) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`)
)
```
这里sex字段类型为tinyint类型。

Student实体类略。

定义一个interface：
```java
package mrbird.leanote.mapper;
 
import java.util.List;
import mrbird.leanote.pojo.Student;
 
public interface StudentMapper {
    public List<Student> getAllStudent();
    public int createStudent(Student stu);
}
```
对应的映射文件StudentMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentMapper">  
    <resultMap type="student" id="studentList">
        <id column="id" property="id"/>
        <result column="cnname" property="cnName"/>
        <result column="sex" property="sex"
            typeHandler="org.apache.ibatis.type.EnumOrdinalTypeHandler"/>
        <result column="selfcard_no" property="selfCardNo"/>
        <result column="note" property="note"/>
    </resultMap>
    <select id="getAllStudent" resultMap="studentList">
        <![CDATA[select * from t_student]]>
    </select>
    <insert id="createStudent" parameterType="student">
        <![CDATA[
            insert into t_student(cnname,sex,selfcard_no,note) values (
            #{cnName},
            #{sex,typeHandler=org.apache.ibatis.type.EnumOrdinalTypeHandler},
            #{selfCardNo},#{note})
        ]]>
    </insert>
</mapper>
```
测试createStudent方法：
```java
...
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
Student stu = new Student();
stu.setCnName("鸣人");
stu.setSex(Sex.MALE);
stu.setSelfCardNo(1L);
stu.setNote("漩涡鸣人");
studentMapper.createStudent(stu);
sqlSession.commit();
...
```
查询数据库：
```sql
mysql> select * from t_student;
+----+--------+-----+-------------+----------+
| id | cnname | sex | selfcard_no | note     |
+----+--------+-----+-------------+----------+
|  1 | 鸣人   |  0  |          1  | 漩涡鸣人  |
+----+--------+-----+-------------+----------+
1 row in set (0.00 sec)
```
可见EnumOrdinalTypeHandler已经将MALE转换为了MALE的下标了。

测试getAllStudent方法：
```java
...
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
List<Student> students = studentMapper.getAllStudent();
for(Student stu : students){
	System.out.println(stu.getCnName()+"性别："+stu.getSex());
}
...
```
控制台输出：
```xml
鸣人性别：MALE
```
### EnumTypeHandler 
为了演示EnumTypeHandler，我们需要把sex字段类型改为VARCHAR：
```sql
alter table t_student modify column sex VARCHAR(20);
```
修改映射文件中的typeHandler：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentMapper">  
    <resultMap type="student" id="studentList">
        <id column="id" property="id"/>
        <result column="cnname" property="cnName"/>
        <result column="sex" property="sex"
            typeHandler="org.apache.ibatis.type.EnumTypeHandler"/>
        <result column="selfcard_no" property="selfCardNo"/>
        <result column="note" property="note"/>
    </resultMap>
    <select id="getAllStudent" resultMap="studentList">
        <![CDATA[select * from t_student]]>
    </select>
    <insert id="createStudent" parameterType="student">
        <![CDATA[
            insert into t_student(cnname,sex,selfcard_no,note) values (
            #{cnName},
            #{sex,typeHandler=org.apache.ibatis.type.EnumTypeHandler},
            #{selfCardNo},#{note})
        ]]>
    </insert>
</mapper>
```
测试createStudent方法：
```java
...
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
Student stu = new Student();
stu.setCnName("雏田");
stu.setSex(Sex.FEMALE);
stu.setSelfCardNo(2L);
stu.setNote("日向雏田");
studentMapper.createStudent(stu);
sqlSession.commit();
...
```
查询数据库：
```sql
mysql> select * from t_student where selfcard_no = '2';
+----+--------+--------+-------------+----------+
| id | cnname | sex    | selfcard_no | note     |
+----+--------+--------+-------------+----------+
|  2 | 雏田   | FEMALE |           2 | 日向雏田  |
+----+--------+--------+-------------+----------+
1 row in set (0.00 sec)
```
可见EnumTypeHandler保存的是枚举字符串。

> [《深入浅出MyBatis技术原理与实战》](https://book.douban.com/subject/26858114/)读书笔记       