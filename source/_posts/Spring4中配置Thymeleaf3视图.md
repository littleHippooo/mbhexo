---
title: Spring4中配置Thymeleaf3视图
date: 2017-08-06 11:30:14
tags: [Thymeleaf,Spring]
---
引入必要的依赖文件：
```xml
<!-- https://mvnrepository.com/artifact/org.thymeleaf/thymeleaf-spring4 -->
<dependency>
   <groupId>org.thymeleaf</groupId>
   <artifactId>thymeleaf-spring4</artifactId>
   <version>2.1.5.RELEASE</version>
</dependency>
```
<!--more-->
配置Thymeleaf试图解析器：
```xml
<!-- Thymeleaf视图解析器 -->
<bean id="viewResolver" 
   class="org.thymeleaf.spring4.view.ThymeleafViewResolver" 
   p:templateEngine-ref="templateEngine" 
   p:characterEncoding="UTF-8" />
<!-- 模板引擎 -->
<bean id="templateEngine" 
   class="org.thymeleaf.spring4.SpringTemplateEngine" 
   p:templateResolver-ref="templateResolver" />
<!-- 模板解析器 -->	
<bean id="templateResolver" 
   class="org.thymeleaf.templateresolver.ServletContextTemplateResolver" 
   p:prefix="/WEB-INF/templates/" 
   p:suffix=".html" 
   p:templateMode="HTML5" 
   p:cacheable="false" 
   p:characterEncoding="UTF-8"/>
```
