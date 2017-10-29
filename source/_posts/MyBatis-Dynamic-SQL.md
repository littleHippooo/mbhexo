---
title: MyBatis Dynamic SQL
date: 2017-01-08 10:23:29
tags: MyBatis
---
MyBatis 的强大特性之一便是它的动态 SQL。如果你有使用 JDBC 或其他类似框架的经验，你就能体会到根据不同条件拼接 SQL 语句有多么痛苦。拼接的时候要确保不能忘了必要的空格，还要注意省掉列名列表最后的逗号。利用动态 SQL 这一特性可以彻底摆脱这种痛苦。
<!--more-->
## if
动态 SQL 通常要做的事情是有条件地包含 where 子句的一部分。比如：
```xml
<select id="findRoles" resultType="roleList">
    SELECT * FROM t_role 
    WHERE 1 = 1
    <if test="roleNo != null and roleNo != ''">
        AND role_no like concat('%',#{roleNo},'%')
    </if>
    <if test="roleName != null and roleName != ''">
        AND role_name like concat('%',#{roleName},'%')
    </if>
</select>
```
## choose, when, otherwise
有些时候，我们不想用到所有的条件语句，而只想从中择其一二。针对这种情况，MyBatis 提供了 choose 元素，它有点像 Java 中的 switch 语句。

如：
```xml
<select id="findRoles" resultType="roleList">
    SELECT * FROM t_role 
    WHERE 1 = 1
    <choose>
        <when test="roleNo != null and roleNo != ''">
            AND role_no = #{roleNo}
        </when>
        <when test="roleName != null and roleName != ''">
            AND role_name like concat('%',#{roleName},'%')
        </when>
        <otherwise>
            AND note is not null
        </otherwise>
    </choose>
</select>        
```
## trim, where, set
在第一个栗子中，假如不加上1=1的话，比如当第一个条件不成立的时候，SQL就变成了这样：
```sql
SELECT * FROM t_role WHERE AND roleName like concat('%',#{roleName},'%')
```
为了防止这种情况，我们可以使用where元素：
```xml
<select id="findRoles" resultType="roleList">
    SELECT * FROM t_role 
    <where>
        <if test="roleNo != null and roleNo != ''">
            AND role_no like concat('%',#{roleNo},'%')
        </if>
        <if test="roleName != null and roleName != ''">
            AND role_name like concat('%',#{roleName},'%')
        </if> 
    </where>
</select>
```
where 元素知道只有在一个以上的if条件有值的情况下才去插入“WHERE”子句。而且，若最后的内容是“AND”或“OR”开头的，where 元素也知道如何将他们去除。

和 where 元素等价的自定义 trim 元素为：
```xml
<trim prefix="WHERE" prefixOverrides="AND |OR ">
    ... 
</trim>
```
perfix表示语句前缀，prefixOverrides表示要去除的前缀（注意此例中的空格也是必要的）。它带来的结果就是所有在 prefixOverrides 属性中指定的内容将被移除，并且插入 prefix 属性中指定的内容。

类似的用于动态更新语句的解决方案叫做 set。set 元素可以被用于动态包含需要更新的列，而舍去其他的。比如：
```xml
<update id="updateRole" parameterType="role">
    update t_role
    <set>
        <if test="roleName != null and roleName != ''">
            role_name = #{roleName},
        </if>
        <if test="note != null and note != ''">
            note = #{note}
        </if>
        where role_no = #{roleNo}
    </set>
</update>
```
这里，set 元素会动态前置 SET 关键字，同时也会消除无关的逗号。

对应的trim元素的写法为：
```xml
<trim prefix="SET" suffixOverrides=",">
    ...
</trim>
```
suffixOverrides去除后缀。
## forEach
动态 SQL 的另外一个常用的必要操作是需要对一个集合进行遍历，通常是在构建 IN 条件语句的时候。比如：        
```xml
<select id="findUserBySex" resultType="user">
    select * from t_user where sex in
    <forEach item="sex" index="index" collection="sexList" open="(" 
        separator="," close=")">
        #{sex}
    </forEach>
</select>
```
说明：
1.collection配置的sexList是传递进来的参数名称，可以为数组，List，Set或集合。

2.item配置的是循环中当前的元素。

3.index配置的是当前元素的下标。

4.open和close配置的是以什么符号将这些集合元素包裹起来。

5.separator配置的是间隔符。
## bind
bind元素可以从 OGNL 表达式中创建一个变量并将其绑定到上下文。比如：
```xml
<select id="findRole" resultMap="roleList">
    <bind name="pattern" value="'%' + _parameter + '%'"/>
    select * from t_role where role_name like #{pattern}
</select>
```
其中`_paramrter`代表的是传进来的参数，和通配符连接后赋给了pattern。
## Multi-db vendor support
一个配置了“_databaseId”变量的 databaseIdProvider 对于动态代码来说是可用的，这样就可以根据不同的数据库厂商构建特定的语句。比如下面的例子：
```xml
<insert id="insert">
    <selectKey keyProperty="id" resultType="int" order="BEFORE">
        <if test="_databaseId == 'oracle'">
            select seq_users.nextval from dual
        </if>
        <if test="_databaseId == 'db2'">
            select nextval for seq_users from sysibm.sysdummy1"
        </if>
    </selectKey>
    insert into users values (#{id}, #{name})
</insert>
```
> [《深入浅出MyBatis技术原理与实战》](https://book.douban.com/subject/26858114/)读书笔记 