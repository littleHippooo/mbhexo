---
title: Spring+Thymeleaf3国际化
date: 2017-08-07 11:41:38
tags: [Thymeleaf,Spring]
---
Spring+Thymeleaf3国际化配置国际化过程很简单，只需要在src/main/resources路径下定义不同语言环境的配置文件就好了，配置文件需以message开头，加上语言缩写后缀。

比如定义一个英文配置：src/main/resources/message_en.properties；中文环境：src/main/resources/message_zh_CN.properties；默认配置（就是都没匹配上的时候采用）：src/main/resources/message.properties。

定义一个简单的HTML页面用于测试：
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>home</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
    <p data-th-utext="#{home.welcome}">home</p>
</body>
</html> 
```
<!--more-->
其中message_en.properties配置如下：
```xml
home.welcome=This is <b>home</b> page.
```
中文环境配置message_zh_CN.properties：
```xml
home.welcome=\u4F60\u597D\uFF0C\u8FD9\u662F<b>\u4E3B\u9875</b>
```
启动项目，访问该页面：

![QQ截图20170911150628.png](img/QQ截图20170911150628.png)

将浏览器的语言环境设置为英文：

![QQ截图20170911150820.png](img/QQ截图20170911150820.png)

刷新页面如下：

![QQ截图20170911150956.png](img/QQ截图20170911150956.png)

有些版本可能需要手动配置MessageConfiguration：
```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;

@Configuration
public class I18nConfiguration {
    @Bean
    public ResourceBundleMessageSource messageSource(){
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setUseCodeAsDefaultMessage(true);
        messageSource.setFallbackToSystemLocale(false);
        messageSource.setBasenames("message");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setCacheSeconds(2);
        return messageSource;
    }
} 
```
我们还可以在properties文件中使用占位符：
```xml
home.welcome=hello,{0}
```
页面：
```html
<p data-th-utext="#{home.welcome(${user.name})}">home</p>
```