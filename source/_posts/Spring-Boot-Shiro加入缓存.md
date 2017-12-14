---
title: Spring Boot Shiro加入缓存
date: 2017-11-25 10:34:43
tags: [Spring,Spring Boot,Shiro,Ehcache]
---
在Shiro中加入缓存可以使权限相关操作尽可能快，避免频繁访问数据库获取权限信息，因为对于一个用户来说，其权限在短时间内基本是不会变化的。Shiro提供了Cache的抽象，其并没有直接提供相应的实现，因为这已经超出了一个安全框架的范围。在Shiro中可以集成常用的缓存实现，这里介绍基于Ehcache缓存的实现。

在[《Spring-Boot-shiro权限控制》](/Spring-Boot-Shiro权限控制.html)中，当用户访问"获取用户信息"、"新增用户"和"删除用户"的时候，后台输出了三次打印信息，如下所示：
<!--more-->
```
用户mrbird获取权限-----ShiroRealm.doGetAuthorizationInfo
用户mrbird获取权限-----ShiroRealm.doGetAuthorizationInfo
用户mrbird获取权限-----ShiroRealm.doGetAuthorizationInfo
```
说明在这三次访问中，Shiro都会从数据库中获取用户的权限信息，通过Druid数据源SQL监控后台也可以证实这一点：

![QQ截图20171214105048.png](img/QQ截图20171214105048.png)

这对数据库来说是没必要的消耗。接下来使用缓存来解决这个问题。
## Ehcache依赖
加入Ehcache相关依赖：
```xml
<!-- shiro ehcache -->
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-ehcache</artifactId>
    <version>1.3.2</version>
</dependency>
<!-- ehchache -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
<dependency>
    <groupId>net.sf.ehcache</groupId>
    <artifactId>ehcache</artifactId>
</dependency>
```
## Ehcache配置
在src/main/resource/config路径下新增一个Ehcache配置——shiro-ehcache.xml：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="http://ehcache.org/ehcache.xsd"
    updateCheck="false">
    <diskStore path="java.io.tmpdir/Tmp_EhCache" />
    <defaultCache
        maxElementsInMemory="10000"
        eternal="false"
        timeToIdleSeconds="120"
        timeToLiveSeconds="120"
        overflowToDisk="false"
        diskPersistent="false"
        diskExpiryThreadIntervalSeconds="120" />
    
    <!-- 登录记录缓存锁定1小时 -->
    <cache 
        name="passwordRetryCache"
        maxEntriesLocalHeap="2000"
        eternal="false"
        timeToIdleSeconds="3600"
        timeToLiveSeconds="0"
        overflowToDisk="false"
        statistics="true" />
</ehcache>
```
关于Ehcahe的一些说明：

- name：缓存名称。

- maxElementsInMemory：缓存最大数目

- maxElementsOnDisk：硬盘最大缓存个数。

- eternal：对象是否永久有效，一但设置了，timeout将不起作用。 

- overflowToDisk：是否保存到磁盘。

- timeToIdleSeconds:设置对象在失效前的允许闲置时间（单位：秒）。仅当`eternal=false`对象不是永久有效时使用，可选属性，默认值是0，也就是可闲置时间无穷大。

- timeToLiveSeconds：设置对象在失效前允许存活时间（单位：秒）。最大时间介于创建时间和失效时间之间。仅当`eternal=false`对象不是永久有效时使用，默认是0，也就是对象存活时间无穷大。

- diskPersistent：是否缓存虚拟机重启期数据，默认值为false。

- diskSpoolBufferSizeMB：这个参数设置DiskStore（磁盘缓存）的缓存区大小。默认是30MB。每个Cache都应该有自己的一个缓冲区。 

- diskExpiryThreadIntervalSeconds：磁盘失效线程运行时间间隔，默认是120秒。

- memoryStoreEvictionPolicy：当达到maxElementsInMemory限制时，Ehcache将会根据指定的策略去清理内存。默认策略是LRU（最近最少使用）。你可以设置为FIFO（先进先出）或是LFU（较少使用）。 

- clearOnFlush：内存数量最大时是否清除。
 
- memoryStoreEvictionPolicy：Ehcache的三种清空策略：**FIFO**，first in first out，这个是大家最熟的，先进先出。**LFU**， Less Frequently Used，就是上面例子中使用的策略，直白一点就是讲一直以来最少被使用的。如上面所讲，缓存的元素有一个hit属性，hit值最小的将会被清出缓存。**LRU**，Least Recently Used，最近最少使用的，缓存的元素有一个时间戳，当缓存容量满了，而又需要腾出地方来缓存新的元素的时候，那么现有缓存元素中时间戳离当前时间最远的元素将被清出缓存。

## ShiroConfig配置Ehcache
接着在ShiroConfig中注入Ehcache缓存：
```java
@Bean
public EhCacheManager getEhCacheManager() {
    EhCacheManager em = new EhCacheManager();
    em.setCacheManagerConfigFile("classpath:config/shiro-ehcache.xml");
    return em;
}
```
将缓存对象注入到SecurityManager中：
```java
@Bean  
public SecurityManager securityManager(){  
    DefaultWebSecurityManager securityManager =  new DefaultWebSecurityManager();
    securityManager.setRealm(shiroRealm());
    securityManager.setRememberMeManager(rememberMeManager());
    securityManager.setCacheManager(getEhCacheManager());
    return securityManager;  
}  
```
配置完毕启动项目，分别访问访问"获取用户信息"、"新增用户"和"删除用户"，可发现后台只打印一次获取权限信息：
```
用户mrbird获取权限-----ShiroRealm.doGetAuthorizationInfo
```
查看Druid数据源SQL监控：

![QQ截图20171214110718.png](img/QQ截图20171214110718.png)

SQL只执行了一次，说明缓存成功。

源码连接：[https://drive.google.com/open?id=1QpFwxvqEDgOytCCI1rpYpQU03mkFeBjw](https://drive.google.com/open?id=1QpFwxvqEDgOytCCI1rpYpQU03mkFeBjw)

