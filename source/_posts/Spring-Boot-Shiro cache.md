---
title: Spring Boot Shiro中使用缓存
date: 2017-12-25 10:34:43
tags: [Spring,Spring Boot,Shiro,Ehcache,Redis]
---
在Shiro中加入缓存可以使权限相关操作尽可能快，避免频繁访问数据库获取权限信息，因为对于一个用户来说，其权限在短时间内基本是不会变化的。Shiro提供了Cache的抽象，其并没有直接提供相应的实现，因为这已经超出了一个安全框架的范围。在Shiro中可以集成常用的缓存实现，这里介绍基于Redis和Ehcache缓存的实现。

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
## Redis
### 引入Redis依赖
网络上已经有关于Shiro集成Redis的实现，我们引入即可：
```xml
<!-- shiro-redis -->
<dependency>
    <groupId>org.crazycake</groupId>
    <artifactId>shiro-redis</artifactId>
    <version>2.4.2.1-RELEASE</version>
</dependency>
```
### 配置Redis
我们在application.yml配置文件中加入Redis配置：
```yml
spring:
  redis:
    host: localhost
    port: 6379
    pool:
      max-active: 8
      max-wait: -1
      max-idle: 8
      min-idle: 0
    timeout: 0
```
接着在ShiroConfig中配置Redis：
```java
public RedisManager redisManager() {
    RedisManager redisManager = new RedisManager();
    return redisManager;
}

public RedisCacheManager cacheManager() {
    RedisCacheManager redisCacheManager = new RedisCacheManager();
    redisCacheManager.setRedisManager(redisManager());
    return redisCacheManager;
}
```
上面代码配置了RedisManager，并将其注入到了RedisCacheManager中，最后在SecurityManager中加入RedisCacheManager：
```java
@Bean  
public SecurityManager securityManager(){  
    DefaultWebSecurityManager securityManager =  new DefaultWebSecurityManager();
    ...
    securityManager.setCacheManager(cacheManager());
    return securityManager;  
}
```
配置完毕启动项目，分别访问访问"获取用户信息"、"新增用户"和"删除用户"，可发现后台只打印一次获取权限信息：
```
用户mrbird获取权限-----ShiroRealm.doGetAuthorizationInfo
```
查看Druid数据源SQL监控：

![QQ截图20171225105337.png](img/QQ截图20171225105337.png)

源码：[https://drive.google.com/open?id=1DAQhLRgvuDDuxlmQ36WxT_Sf1mrhGgbT](https://drive.google.com/open?id=1DAQhLRgvuDDuxlmQ36WxT_Sf1mrhGgbT)
## Ehcache
### Ehcache依赖
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
### Ehcache配置
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
```s
### ShiroConfig配置Ehcache
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

