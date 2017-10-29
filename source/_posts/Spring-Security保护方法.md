---
title: Spring Security保护方法
date: 2017-02-13 18:25:28
tags: [Spring,Spring Security]
---
Spring Security提供了三种不同的安全注解：

1.Spring Security自带的@Secured注解；

2.JSR-250的@RolesAllowed注解；

3.表达式驱动的注解，包括@PreAuthorize、@PostAuthorize、@PreFilter和 @PostFilter。
<!--more-->
## @Secured
在Spring-Security.xml中启用@Secured注解：
```xml
<global-method-security secured-annotations="enabled"/>
```
例如只有拥有权限“ROLE_ADMIN”的用户才能访问下面这个方法：
```java
@Secured("ROLE_ADMIN")
public void test(){
    ...
}
```
权限不足时，方法抛出Access Denied异常。

@Secured注解会使用一个String数组作为参数。每个String值是一个权限，调用这个方法至少需要具备其中的一个权限。如：
```java
@Secured({"ROLE_ADMIN","ROLE_USER"})
public void test(){
    ...
}
```
## @RolesAllowed
@RolesAllowed注解和@Secured注解在各个方面基本上都是一致的。启用@RolesAllowed注解：
```xml
<global-method-security jsr250-annotations="enabled"/>
```
栗子：
```java
@RolesAllowed("ROLE_ADMIN")
public void test(){
    ...
}   
```
## SpEL注解
启用该注解：
```xml
<global-method-security pre-post-annotations="enabled"/>   
```
### @PreAuthorize
该注解用于方法前验证权限，比如限制非VIP用户提交blog的note字段字数不得超过1000字：
```java
@PreAuthorize("hasRole('ROLE_ADMIN') and #form.note.length() <= 1000 or hasRole('ROLE_VIP')")
public void writeBlog(Form form){
    ...
}
```
表达式中的#form部分直接引用了方法中的同名参数。这使得Spring Security能够检查传入方法的参数，并将这些参数用于认证决策的制定。
### @PostAuthorize    
方法后调用权限验证，比如校验方法返回值：
```java
@PreAuthorize("hasRole(ROLE_USER)")
@PostAuthorize("returnObject.user.userName == principal.username")
public User getUserById(long id){
    ...		
}
```
Spring Security在SpEL中提供了名为returnObject 的变量。在这里方法返回一个User对象，所以这个表达式可以直接访问user对象中的userName属性。