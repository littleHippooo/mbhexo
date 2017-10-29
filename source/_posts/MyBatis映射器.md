---
title: MyBatis映射器
date: 2017-01-05 10:11:41
tags: MyBatis
---
映射器的配置：
<table>
        <tr>
            <td>
                <strong>
                    元素名称
                </strong>
            </td>
            <td>
                <strong>
                    描述
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                select
            </td>
            <td>
                查询语句
            </td>
        </tr>
        <tr>
            <td>
                insert
            </td>
            <td>
                插入语句
            </td>
        </tr>
        <tr>
            <td>
                update
            </td>
            <td>
                更新语句
            </td>
        </tr>
        <tr>
            <td>
                delete
            </td>
            <td>
                删除语句
            </td>
        </tr>
        <tr>
            <td>
                sql
            </td>
            <td>
                允许定义一部分SQL，然后各个地方引用
            </td>
        </tr>
        <tr>
            <td>
                resultMap
            </td>
            <td>
                用于定义结果集
            </td>
        </tr>
        <tr>
            <td>
                cache
            </td>
            <td>
                给定命名控件的缓存配置
            </td>
        </tr>
        <tr>
            <td>
                cache-ref
            </td>
            <td>其它命名控件缓存配置的引用</td>
        </tr>
</table>

<!--more-->
## select
### mapUnderscoreToCamelCase
数据库字段名一般采用下划线命名规则，而java中的字段名用的是驼峰命名规则：
<table>
    <tr>
        <td>
                JavaBean
        </td>
        <td>
                数据库
        </td>
    </tr>
    <tr>
        <td>
            id
        </td>
        <td>
            id
        </td>
    </tr>
    <tr>
        <td>
            roleName
        </td>
        <td>
            role_name
        </td>
    </tr>
    <tr>
        <td>
            note
        </td>
        <td>
            note
        </td>
    </tr>
    <tr>
        <td>
            isGirl&nbsp; &nbsp;
        </td>
        <td>
            is_girl
        </td>
    </tr>
</table>
如果数据库字段命名规范，我们可以在settins中配置mapUnderscoreToCamelCase为true：
```xml
<settings>
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
```
MyBatis就会自动将数据库字段名转换为JavaBean的字段名，比如：
```xml
<select id="getRole" parameterType="long" resultType="role">
	<![CDATA[select * from t_role where id = #{id}]]>
</select>
```
如果不将mapUnderscoreToCamelCase设置为true，则select元素必须指明字段别名：
```xml
<select id="getRole" parameterType="long" resultType="role">
    <![CDATA[select id,role_name as roleName,
        note,is_girl as isGirl from t_role where id = #{id}]]>
</select>
```
否则没有对应上的字段值为null。
### 传递多个参数
1.使用Map传参

定义一个抽象方法：
```java
public List<Role> getRole(Map<String,String> params); 
```
映射文件中配置select：
```xml
<resultMap type="role" id="roleList">
    <id column="id" property="id"/>
    <result column="role_name" property="roleName"/>
    <result column="note" property="note"/>
    <result column="is_girl" property="isGirl" 
        javaType="Boolean" jdbcType="VARCHAR"/>
</resultMap>
<select id="getRole" resultMap="roleList">
    <![CDATA[select * from t_role where role_name like 
        concat('%',#{roleName},'%') and note like 
        concat('%',#{note},'%')
    ]]>
</select>
```
测试：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
RoleMapper mapper = sqlSession.getMapper(RoleMapper.class);
Map<String,String> params = new HashMap<String,String>();
params.put("roleName", "雏田");
params.put("note", "日向");
List<Role> roleList = mapper.getRole(params);
for(Role r : roleList){
    System.out.println(r.getRoleName()+" is a girl:"+r.getIsGirl());
}
...
```
输出：
```xml
雏田 is a girl:true
```
2.使用注解传参

修改抽象方法：
```java
public List<Role> getRole(@Param("roleName")String roleName,
    @Param("note")String note);
```
测试：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
RoleMapper mapper = sqlSession.getMapper(RoleMapper.class);
List<Role> roleList = mapper.getRole("雏田", "日向");
for(Role r : roleList){
    System.out.println(r.getRoleName()+" is a girl:"+r.getIsGirl());
}
...
```
输出：
```xml
雏田 is a girl:true
```
3.使用JavaBean传参

定义一个传递参数JavaBean：
```java
public class RoleParams {
    private String roleName;
    private String note;
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
修改抽象方法：
```java
public List<Role> getRole(RoleParams params);
```
测试：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
RoleMapper mapper = sqlSession.getMapper(RoleMapper.class);
RoleParams params = new RoleParams();
params.setRoleName("鸣人");
params.setNote("旋涡");
List<Role> roleList = mapper.getRole(params);
for(Role r : roleList){
    System.out.println(r.getRoleName()+" is a girl:"+r.getIsGirl());
}
...
```
输出：
```xml
鸣人 is a girl:false
```
## insert
### 主键回填和自定义
开发中有时候需要获取到插入行的主键值，MyBatis的主键回填可以完成这个功能。

定义一个createRole抽象方法：
```java
public int createRole(Role role); 
```
映射：
```xml
<insert id="createRole" parameterType="role" useGeneratedKeys="true"
    keyProperty="id">
    <![CDATA[
        insert into t_role(role_name,note,is_girl) values (#{roleName},#{note},
        #{isGirl,typeHandler=mrbird.leanote.typehandler.BooleanTypeHandler})
    ]]>
</insert>
```
useGeneratedKeys会使MyBatis使用JDBC的getGeneratedKeys方法来获取出由数据库内部生成的主键，keyProperty表示以哪个列为属性的主键。

测试获取主键：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
RoleMapper mapper = sqlSession.getMapper(RoleMapper.class);
Role role = new Role();
role.setRoleName("佐助");
role.setNote("宇智波");
role.setIsGirl(Boolean.FALSE);
mapper.createRole(role);
System.out.println(role.getId()); //7
sqlSession.commit();
...
```
页面输出 7，查询数据库：
```sql
mysql> select * from t_role;
+----+-----------+----------+---------+
| id | role_name | note     | is_girl |
+----+-----------+----------+---------+
|  1 | 雏田      | 日向雏田  | Y       |
|  2 | 鸣人      | 旋涡鸣人  | N       |
|  7 | 佐助      | 宇智波    | N       |
+----+-----------+----------+---------+
3 rows in set (0.00 sec)
```
假如数据库主键没有设置自增，我们的要求是：如果表t_role没有记录，则id设置为1，否则我们取最大id加2。这时候我们可以对映射文件的insert标签稍作修改：
```xml
<insert id="createRole" parameterType="role" useGeneratedKeys="true"
    keyProperty="id">
    <!-- resultType必须和POJO里id的类型一致 -->
    <selectKey keyProperty="id" resultType="long" order="BEFORE">
        <![CDATA[
            select if(max(id) is null,1,max(id)+2) as id from t_role
        ]]>
    </selectKey>
    <![CDATA[
        insert into t_role(id,role_name,note,is_girl) values (#{id},#{roleName},
        #{note},
        #{isGirl,typeHandler=mrbird.leanote.typehandler.BooleanTypeHandler})
    ]]>
</insert>
```
测试：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
RoleMapper mapper = sqlSession.getMapper(RoleMapper.class);
Role role = new Role();
role.setRoleName("小樱");
role.setNote("春野樱");
role.setIsGirl(Boolean.TRUE);
mapper.createRole(role);
System.out.println(role.getId()); //9
sqlSession.commit();
...
```
输出9和我们预期的一致，查询数据库：
```sql
mysql> select * from t_role;
+----+-----------+----------+---------+
| id | role_name | note     | is_girl |
+----+-----------+----------+---------+
|  1 | 雏田      | 日向雏田  | Y       |
|  2 | 鸣人      | 旋涡鸣人  | N       |
|  7 | 佐助      | 宇智波    | N       |
|  9 | 小樱      | 春野樱    | Y       |
+----+-----------+----------+---------+
4 rows in set (0.00 sec)
```
## update & delete
update和delete较为简单，一个简单的更新和删除例子：
```xml
<update id="updateRole" parameterType="role">
    <![CDATA[
        update t_role set role_name = #{roleName},
        note = #{note} where id = #{id}
    ]]>
</update>
<delete id="deleteRole" parameterType="long">
    <![CDATA[
        delete from t_role where id = #{id}
    ]]>
</delete>
```
## 参数
### 参数配置
参数除了可以指定javaType，jdbcType和typeHandler外，还可以对数值类型的参数设置精度：
```xml
#{price,javaType=double,jdbcType=NUMERIC,numericScale=2}
```
### $与井

#{}的值被作为sql的参数，而${}则会被当作sql的一部分。
## sql元素
sql元素的作用是可以定义sql语句的一部分，然后导出引用：
```xml
<sql id="t_role_column">
    <![CDATA[id,role_name as roleName,note,is_girl as isGirl]]>
</sql>
<select id="getRole" resultMap="roleList">
    select <include refid="t_role_column"/>
    from t_role where role_name like 
    concat('%',#{roleName},'%') and note like 
    concat('%',#{note},'%')
</select>
```
上述代码定义了一个id为t_role_column的sql，然后在select元素中使用include元素引用了它，从而达到了重用的功能。

还可以在sql元素中指定标签：
```xml
<sql id="t_role_column">
    <![CDATA[${prefix}.id,${prefix}.role_name as roleName,
    ${prefix}.note,${prefix}.is_girl as isGirl]]>
</sql>
<select id="getRole" resultMap="roleList">
    select 
    <include refid="t_role_column">
        <property name="prefix" value="t"/>
    </include>
    from t_role t where t.role_name like 
    concat('%',#{roleName},'%') and t.note like 
    concat('%',#{note},'%')
</select>
```
这个功能在使用关联查询的时候较为方便。
## 级联

🎉[MyBatis级联](https://mrbird.cc/MyBatis%E7%BA%A7%E8%81%94.html)

## cache

🎉[MyBatis缓存机制](https://mrbird.cc/MyBatis-Cache.html)

>  [《深入浅出MyBatis技术原理与实战》](https://book.douban.com/subject/26858114/)读书笔记       