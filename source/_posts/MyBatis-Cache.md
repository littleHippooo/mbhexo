---
title: MyBatis Cache
date: 2017-01-07 10:31:26
tags: MyBatis
---
MyBatis对缓存提供了支持，默认情况下只开启了一级缓存，要开启二级缓存需要进行配置。为了验证这个过程，我们创建log4j.properties：
```xml
log4j.rootLogger=DEBUG , stdout  
log4j.logger.mrbird.leanote=DEBUG   
log4j.appender.stdout=org.apache.log4j.ConsoleAppender   
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout 
```
<!--more-->
在mybatis-config.xml文件中配置它：
```xml
<settings>
    ...
    <setting name="logImpl" value="LOG4J"/>
</settings>
```
## 一级缓存
一级缓存是针对于一个SqlSession而言的，在参数和SQL完全一样的情况下，同一个SqlSession对象调用同一个Mapper方法，只会执行一次SQL，而不同的SqlSession都是相互隔离的，所以即使使用相同的Mapper，相同的方法，也会再次发送SQL进行查询。

举个栗子：
```java
SqlSession sqlSession1 = null;
SqlSession sqlSession2 = null;
final Logger logger = Logger.getLogger(MyBatisMain.class);
try {
    sqlSession1 = SqlSessionFactoryUtil.openSqlSession();
    RoleMapper roleMapper1 = sqlSession1.getMapper(RoleMapper.class);
    Role role1 = roleMapper1.getRoleById(1L);
    logger.debug("使用同一个sqlSession再次执行");
    Role role2 = roleMapper1.getRoleById(1L);
    //使用二级缓存的时候，SqlSession调用了commit方法后才会生效
    sqlSession1.commit();
    logger.debug("使用不同sqlSession再次执行");
    sqlSession2 = SqlSessionFactoryUtil.openSqlSession();
    RoleMapper roleMapper2 = sqlSession2.getMapper(RoleMapper.class);
    Role role3 = roleMapper2.getRoleById(1L);
    //使用二级缓存的时候，SqlSession调用了commit方法后才会生效
    sqlSession2.commit();
} catch (Exception e) {
    e.printStackTrace();
    sqlSession1.rollback();
sqlSession2.rollback();
}finally{
    if(sqlSession1 != null){
        sqlSession1.close();
    }
    if(sqlSession2 != null){
        sqlSession2.close();
    }
}
```
查看控制台输出日志：
```xml
Logging initialized using 'class org.apache.ibatis.logging.slf4j.Slf4jImpl' adapter.
Logging initialized using 'class org.apache.ibatis.logging.log4j.Log4jImpl' adapter.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
Opening JDBC Connection
Created connection 1995619265.
Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@76f2bbc1]
==>  Preparing: select * from t_role where id = ? 
==> Parameters: 1(Long)
<==      Total: 1
使用同一个sqlSession再次执行
使用不同sqlSession再次执行
Opening JDBC Connection
Created connection 2044366277.
Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@79da8dc5]
==>  Preparing: select * from t_role where id = ? 
==> Parameters: 1(Long)
<==      Total: 1
Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@76f2bbc1]
Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@76f2bbc1]
Returned connection 1995619265 to pool.
Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@79da8dc5]
Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@79da8dc5]
Returned connection 2044366277 to pool.
```
可见一级缓存是针对于SqlSession层面的。
## 二级缓存
二级缓存是针对于SqlSessionFactory层面的，也就是说只要是同一个SqlSessionFactory创建的SqlSession，它们间都将共享缓存。开启二级缓存需要POJO都实现Serializable接口，并在你的 SQL 映射文件中添加一行:    
```xml
<cache/>
```
字面上看就是这样。这个简单语句的效果如下:
1.映射语句文件中的所有 select 语句将会被缓存。

2.映射语句文件中的所有 insert,update 和 delete 语句会刷新缓存。

3.缓存会使用 Least Recently Used(LRU,最近最少使用的)算法来收回。

4.根据时间表(比如 no Flush Interval,没有刷新间隔), 缓存不会以任何时间顺序 来刷新。

5.缓存会存储列表集合或对象(无论查询方法返回什么)的 1024 个引用。

6.缓存会被视为是 read/write(可读/可写)的缓存,意味着对象检索不是共享的,而 且可以安全地被调用者修改,而不干扰其他调用者或线程所做的潜在修改。

开启二级缓存后，再次执行上面的方法，查看控制台输出日志：
```xml
Logging initialized using 'class org.apache.ibatis.logging.slf4j.Slf4jImpl' adapter.
Logging initialized using 'class org.apache.ibatis.logging.log4j.Log4jImpl' adapter.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
Cache Hit Ratio [mrbird.leanote.mapper.RoleMapper]: 0.0
Opening JDBC Connection
Created connection 330382173.
Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@13b13b5d]
==>  Preparing: select * from t_role where id = ? 
==> Parameters: 1(Long)
<==      Total: 1
使用同一个sqlSession再次执行
Cache Hit Ratio [mrbird.leanote.mapper.RoleMapper]: 0.0
使用不同sqlSession再次执行
Cache Hit Ratio [mrbird.leanote.mapper.RoleMapper]: 0.3333333333333333
Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@13b13b5d]
Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@13b13b5d]
Returned connection 330382173 to pool.
```
可见，从头到尾只发送了一次SQL进行查询。

<cache>属性都可以通过缓存元素的属性来修改。比如：
```xml
<cache eviction="FIFO" flushInterval="60000" size="512" readOnly="true"/>
```
这个更高级的配置创建了一个 FIFO 缓存,并每隔 60 秒刷新,存数结果对象或列表的 512 个引用,而且返回的对象被认为是只读的,因此在不同线程中的调用者之间修改它们会 导致冲突。

可用的收回策略有:
1.`LRU` – 最近最少使用的:移除最长时间不被使用的对象。

2.`FIFO` – 先进先出:按对象进入缓存的顺序来移除它们。

3.`SOFT` – 软引用:移除基于垃圾回收器状态和软引用规则的对象。

4.`WEAK` – 弱引用:更积极地移除基于垃圾收集器状态和弱引用规则的对象。

默认的是 LRU。

`flushInterval`(刷新间隔)可以被设置为任意的正整数,而且它们代表一个合理的毫秒 形式的时间段。默认情况是不设置,也就是没有刷新间隔,缓存仅仅调用语句时刷新。

`size`(引用数目)可以被设置为任意正整数,要记住你缓存的对象数目和你运行环境的 可用内存资源数目。默认值是 1024。

`readOnly`(只读)属性可以被设置为 true 或 false。只读的缓存会给所有调用者返回缓 存对象的相同实例。因此这些对象不能被修改。这提供了很重要的性能优势。可读写的缓存 会返回缓存对象的拷贝(通过序列化) 。这会慢一些,但是安全,因此默认是 false。

>  [《深入浅出MyBatis技术原理与实战》](https://book.douban.com/subject/26858114/)读书笔记  