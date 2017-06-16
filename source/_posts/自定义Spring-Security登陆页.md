---
title: 自定义Spring Security登陆页
date: 2017-02-07 18:45:02
tags: [Spring,Spring Security]
---
虽然Spring Security框架给我们赠送了个登陆页面，但这个页面过于简单，Spring Security允许我们自定义登陆页。
## 准备工作
第一步在maven中加入Spring Security相关依赖（Spring MVC已搭建好）。
```xml
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-web</artifactId>
    <version>3.2.0.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-config</artifactId>
    <version>3.2.0.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-taglibs</artifactId>
    <version>3.2.0.RELEASE</version>
</dependency>    
```
<!--more-->
为了在项目中使用 Spring Security 控制权限，首先要在web.xml 中配置过滤器，这样我们就可以控制对这个项目的每个请求了。
```xml
<filter>
    <filter-name>springSecurityFilterChain</filter-name>
    <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
</filter>
<filter-mapping>
    <filter-name>springSecurityFilterChain</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>	
```
applicationContext.xml的配置如下：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context" 
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:p="http://www.springframework.org/schema/p" 
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.3.xsd
        http://www.springframework.org/schema/mvc
        http://www.springframework.org/schema/mvc/spring-mvc-4.3.xsd">
    <!-- 开启组件扫描 -->
    <context:component-scan base-package="spring"/>
    <!-- 启用Spring mvc -->
    <mvc:annotation-driven/>
    <!-- 配置viewResolver -->
    <bean id="viewResolver"
        class="org.springframework.web.servlet.view.InternalResourceViewResolver" 
        p:prefix="/WEB-INF/views/" 
        p:suffix=".jsp" 
        p:viewClass="org.springframework.web.servlet.view.JstlView">
    </bean>
    <mvc:resources location="/css/" mapping="/css/**"/>
    <!-- 引入spring-security.xml -->
    <import resource="spring-security.xml"/>
</beans>
```
在applicationContext.xml中，使用`<import/>`标签引入了spring-security.xml配置。spring-security.xml先简单配置如下：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<b:beans xmlns:b="http://www.springframework.org/schema/beans"
    xmlns="http://www.springframework.org/schema/security"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
        http://www.springframework.org/schema/security 
        http://www.springframework.org/schema/security/spring-security-3.2.xsd">
    <!-- 设置免验证路径 -->
    <http pattern="/**/*.css" security="none"/>
    <http pattern="/**/*.jpg" security="none"/>  
    <http pattern="/**/*.jpeg" security="none"/> 
    <http pattern="/checkCode" security="none"/> 
    <http auto-config="true">
        <intercept-url pattern="/login" access="IS_AUTHENTICATED_ANONYMOUSLY" />
        <intercept-url pattern="/admin" access="ROLE_ADMIN"/>
        <intercept-url pattern="/**" access="ROLE_USER"/>
        <form-login login-page="/login"/>
        <custom-filter ref="loginfilter" before="FORM_LOGIN_FILTER" /> 
    </http>
    <b:bean id="loginfilter" 
        class="spring.security.web.MrbirdUsernamePasswordAuthenticationFilter">
        <b:property name="filterProcessesUrl" value="/j_spring_security_check"/> 
        <!-- 登入页面form mothed 必须是post --> 
        <b:property name="postOnly" value="true"/>
        <b:property name="authenticationManager" ref="authenticationManager" />
        <b:property name="continueChainBeforeSuccessfulAuthentication" value="false"/>
    </b:bean>
    <user-service id="user_service">
        <user name="admin" password="123456" authorities="ROLE_USER,ROLE_ADMIN"/>
        <user name="user" password="123456" authorities="ROLE_USER"/>
    </user-service>
    <authentication-manager alias="authenticationManager">
        <authentication-provider user-service-ref="user_service"/>
    </authentication-manager>
</b:beans>
```
上述配置中主要干了几件事：

1.声明在xml 中使用Spring Security 提供的命名空间xmlns="http://www.springframework.org/schema/security"。

2.设置一些免验证资源或者路径。

3.利用`intercept-url`来判断用户需要具有何种权限才能访问对应的url资源，可以在pattern中指定一个特定的url资源，`access`指明需要的权限。比如url "/admin" 必须拥有ROLE_ADMIN的用户才能访问。在实际使用中，Spring Security采用的是一种就近原则，就是说当用户访 问的url 资源满足多个intercepter-url 时，系统将使用第一个符合条件的 intercept-url 进行权限控制。

4.`access="IS_AUTHENTICATED_ANONYMOUSLY"`指定匿名用户也可以访问。

5.`<form-login/>`标签的login-page="/login"属性表示登陆页面的请求，由控制器去处理。

6.`<custom-filter/>`标签引用了一个名为loginfilter的过滤器，用于登陆的时候进行验证。

7.接下来定义了id为loginfilter的bean，其`filterProcessesUrl`设定了登陆页表单提交时的请求；`authenticationManager`属性指向authenticationManager。该bean对应的类下文再做介绍。

8.`user-service`中定义了两个用户，admin 和user，`password`属性定义其密码，`authorities`属性为其分配权限。

9.`<authentication-manager/>`标签注册了一个认证管理器，并通过 `<authentication-provider/>`标签的`user-service-ref`属性将之前定义的用户装配起来。

除此之外，还可以使用SpEL表达式进行url的拦截。
## 启用SpEL
启用SpEL：
```xml
<http auto-config="true" use-expressions="true">
    ...
</http>
```
Spring Security支持的所有SpEL表达式如下：
<table>
        <tr>
            <td>
                安全表达式
            </td>
            <td>
                计算结果
            </td>
        </tr>
        <tr>
            <td>
                authentication
            </td>
            <td>
                用户的认证对象
            </td>
        </tr>
        <tr>
            <td>
                denyAll
            </td>
            <td>
                结果始终为false
            </td>
        </tr>
        <tr>
            <td>
                hasAnyRole(list of&nbsp;roles)
            </td>
            <td>
                如果用户被授予了列表中任意的指定角色，结果为true
            </td>
        </tr>
        <tr>
            <td>
                hasRole(role)
            </td>
            <td>
                如果用户被授予了指定的角色，结果为true
            </td>
        </tr>
        <tr>
            <td>
                hasIpAddress(IP Address)
            </td>
            <td>
                如果请求来自指定IP的话，结果为true
            </td>
        </tr>
        <tr>
            <td>
                isAnonymous()
            </td>
            <td>
                如果当前用户为匿名用户，结果为true
            </td>
        </tr>
        <tr>
            <td>
                isAuthenticated()
            </td>
            <td>
                如果当前用户进行了认证的话，结果为true
            </td>
        </tr>
        <tr>
            <td>
                isFullyAuthenticated()
            </td>
            <td>
                    如果当前用户进行了完整认证的话（不是通过Remember-me功能进行的认
                    证），结果为true
            </td>
        </tr>
        <tr>
            <td>
                isRememberMe()
            </td>
            <td>
                如果当前用户是通过Remember-me自动认证的，结果为true
            </td>
        </tr>
        <tr>
            <td>
                permitAll
            </td>
            <td>
                结果始终为true
            </td>
        </tr>
        <tr>
            <td>
                principal
            </td>
            <td>
                用户的principal对象
            </td>
        </tr>
</table>
使用SpEL改写<intercept-url/>的access属性：
```xml
<http auto-config="true" access-denied-page="/deny" use-expressions="true">
    <intercept-url pattern="/login" access="permitAll" />
    <intercept-url pattern="/admin" access="hasRole('ROLE_ADMIN')"/>
    <intercept-url pattern="/**" access="hasRole('ROLE_USER')"/>
    ...
</http>
```
接下来自己编写个登陆页。
## 自定义登陆页
login.jsp如下：
```html
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <title>login page</title>
    <link href="<c:url value='/css/bootstrap.min.css'/>" 
        rel="stylesheet" type="text/css">
    <link href="<c:url value='/css/bootstrap-theme.min.css'/>" 
        rel="stylesheet" type="text/css">
    <link href="<c:url value='/css/templatemo_style.css'/>" 
        rel="stylesheet" type="text/css">	
</head>
<body class="templatemo-bg-gray">
<div class="container">
    <div class="col-md-12">
        <h1 class="margin-bottom-15">Login Page</h1>
        <form action="<s:url value='/j_spring_security_check'/>"
            class="form-horizontal templatemo-container 
        templatemo-login-form-1 margin-bottom-30" role="form" method="post">				
            <div class="form-group">
                <div class="col-xs-12">		            
                    <div class="control-wrapper">
                        <span class="form-text">username</span>
                        <input type="text" class="form-control" name="j_username"/>
                    </div>		            	            
                </div>              
            </div>
            <div class="form-group">
                <div class="col-md-12">
                    <div class="control-wrapper">
                        <span class="form-text">password</span>
                        <input type="password" class="form-control" name="j_password">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-12">
                    <div class="control-wrapper">
                        <span class="form-text">validateCode</span>
                        <input type="password" class="form-control" name="validateCode">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-12">
                    <div class="control-wrapper">
                        <input type="submit" value="Log in" class="btn btn-info"> 
                        <input type="reset" value="Reset" class="btn btn-info">
                        <img id="checkCodeImg" title="验证码不区分大小写" src="checkCode"
                            onclick="changeValidateCode()" style="cursor: pointer;">
                        <a href="javascript:;" onclick="changeValidateCode()">看不清？</a>
                        <span class="form-error">
                            ${sessionScope['SPRING_SECURITY_LAST_EXCEPTION'].message}
                        </span>
                        <span class="form-error">
                            ${SPRING_SECURITY_403_EXCEPTION.message}
                        </span>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
<script type="text/javascript">
    function changeValidateCode(){
        document.getElementById("checkCodeImg").src = "checkCode"+ "?nocache=" + new Date().getTime();
    }
  </script>
</html>
```
与Spring Security相关的就几个：

1.`/j_spring_security_check`，提交登陆信息的URL地址。

2.`j_username`，输入登陆名的参数名称。

3.`j_password`，输入密码的参数名称。

4.`${sessionScope['SPRING_SECURITY_LAST_EXCEPTION'].message}`和`${SPRING_SECURITY_403_EXCEPTION.message}`用于输出登陆失败的异常信息。

login.jsp页面尾部添加了验证码验证。验证码对应的controller如下：
```java
@Controller
public class CodeController {
    @RequestMapping(value="/checkCode")
    public void createCheckCode(HttpServletRequest request, HttpServletResponse response)
        throws IOException{
        //设置不缓存图片  
        response.setHeader("Pragma", "No-cache");  
        response.setHeader("Cache-Control", "No-cache");  
        response.setDateHeader("Expires", 0);  
        //指定生成的响应类型及格式-图片jpg  
        response.setContentType("image/jpeg"); 
        //指定生成验证码的宽度和高度  
        int width=66,height=30;    
        //创建BufferedImage对象,其作用相当于一图片
        BufferedImage image=new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);
        //创建Graphics对象,其作用相当于画笔
        Graphics g=image.getGraphics();    
        //创建Grapchics2D对象  
        Graphics2D g2d=(Graphics2D)g;       
        Random random=new Random(); 
        //定义字体样式  
        Font mfont=new Font("楷体",Font.BOLD,20); 
        g.setColor(getRandColor(200,250));  
        //绘制背景  
        g.fillRect(0, 0, width, height);    
        //设置字体  
        g.setFont(mfont);                   
        g.setColor(getRandColor(180,200));  
        //绘制20条颜色和位置全部为随机产生的线条,该线条为2f  
        for(int i=0;i<20;i++){  
            int x=random.nextInt(width-1);  
            int y=random.nextInt(height-1);  
            int x1=random.nextInt(6)+1;  
            int y1=random.nextInt(12)+1;  
            //定制线条样式  
            BasicStroke bs=new BasicStroke(2f,BasicStroke.CAP_BUTT,
                BasicStroke.JOIN_BEVEL); 
            Line2D line=new Line2D.Double(x,y,x+x1,y+y1);  
            g2d.setStroke(bs); 
            //绘制直线  
            g2d.draw(line);     
        }  
        String sRand="";  
        String ctmp="";
        String[] rBase={"1","2","3","4","5","6","7","8","9",
                        "a","b","c","d","e","f","g",
                        "h","i","j","k",    "m","n",
                        "o","p","q",    "r","s","t",
                        "u","v","w",    "x","y","z",
                        "A","B","C","D","E","F","G",
                        "H",    "J","K","L","M","N",
                        "O","P","Q",    "R","S","T",
                        "U","V","W",    "X","Y","Z"};
        //制定输出的验证码为四位  
        for(int i=0;i<4;i++){  
            int index = random.nextInt(rBase.length-1); 
            ctmp = rBase[index];  
            sRand+=ctmp;  
            Color color=new Color(20+random.nextInt(110),20+random.nextInt(110),
                random.nextInt(110));  
            g.setColor(color);  
            /*将文字旋转制定角度*/  
            Graphics2D g2d_word=(Graphics2D)g;  
            AffineTransform trans=new AffineTransform();  
            //trans.rotate((45)*3.14/180,15*i+8,7);  
            /*缩放文字*/  
            float scaleSize=random.nextFloat()+0.8f;  
            if(scaleSize>1f) scaleSize=1f;  
            trans.scale(scaleSize, scaleSize);  
            g2d_word.setTransform(trans);  
            g.drawString(ctmp, 12*i+12, 22);  
        }  
        HttpSession session=request.getSession(true);  
        session.setAttribute("validateCode", sRand); 
        //释放g所占用的系统资源
        g.dispose(); 
        //输出图片
        ImageIO.write(image,"JPEG",response.getOutputStream()); 
    }
    /*该方法主要作用是获得随机生成的颜色*/   
    public Color getRandColor(int s,int e){  
        Random random=new Random ();  
        if(s>255) s=255;  
        if(e>255) e=255;  
        int r,g,b;  
        r=s+random.nextInt(e-s);    
        g=s+random.nextInt(e-s);  
        b=s+random.nextInt(e-s);   
        return new Color(r,g,b);  
    } 
}
```
接下来编写index.jsp，成功登陆后跳转到该页面：
```html
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <title>index page</title>
    <link href="<c:url value='/css/templatemo_style.css'/>" rel="stylesheet" 
        type="text/css">	
</head>
<body class="templatemo-bg-gray">
    <div class="index-div">
        <span class="index-text">hello:<sec:authentication property="name"/></span><br/> 
        <hr>
        <a href="<s:url value='/admin'/>">admin.jsp</a>  
        <a href="j_spring_security_logout">logout</a>
    </div>
</body>
</html>
```
编写admin.jsp用于测试权限控制：
```html
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <title>admin page</title>
    <link href="<c:url value='/css/templatemo_style.css'/>" rel="stylesheet" 
        type="text/css">	
</head>
<body class="templatemo-bg-gray">
    <div class="index-div">
        <span class="index-text">welcome admin!</span><br/> 
    </div>
</body>
</html>
```
页面跳转controller：
```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
 
@Controller
public class LoginController {
    @RequestMapping(value="/login")
    public String login(){
        return "login";
    }
    @RequestMapping(value="/admin")
    public String admin(){
        return "admin";
    }
    @RequestMapping(value="/index")
    public String index(){
        return "index";
    }
}
```
## 处理登陆    
在spring-security.xml文件中定义的loginfilter过滤器对应的类如下：
```java
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
 
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication
    .UsernamePasswordAuthenticationFilter;
import org.springframework.util.StringUtils;
 
public class MrbirdUsernamePasswordAuthenticationFilter 
    extends UsernamePasswordAuthenticationFilter{
    private boolean postOnly = true;
    public static final String VALIDATE_CODE = "validateCode";
    public Authentication attemptAuthentication(HttpServletRequest request,
        HttpServletResponse response) throws AuthenticationException {
        if (postOnly && !request.getMethod().equals("POST")) {
            throw new AuthenticationServiceException(
                "Authentication method not supported: " + request.getMethod());
        }
        //获取输入的用户名和密码 
        String username = obtainUsername(request);
        String password = obtainPassword(request);
        //校验
        if (username == null || StringUtils.isEmpty(username.trim())) {
            //校验不通过时抛出相应的异常
            throw new AuthenticationServiceException(
                messages.getMessage("Auth.usernameIsNull"));
        }
        if (password == null || StringUtils.isEmpty(password.trim())) {
            throw new AuthenticationServiceException(
                messages.getMessage("Auth.passwordIsNull"));
        }
        //校验验证码
        checkValidateCode(request);
        
        username = username.trim();
        UsernamePasswordAuthenticationToken authRequest
            = new UsernamePasswordAuthenticationToken(username, password);
        
        setDetails(request, authRequest);
        //不做用户的验证工作，因为在org.springframework.security.web.access
        //.intercept.FilterSecurityInterceptor中会做验证。不需要重复验证。
        return this.getAuthenticationManager().authenticate(authRequest);
    }
    protected void checkValidateCode(HttpServletRequest request) {   
        HttpSession session = request.getSession();  
        String sessionValidateCode = obtainSessionValidateCode(session);   
        //让上一次的验证码失效  
        session.setAttribute(VALIDATE_CODE, null);  
        String validateCodeParameter = obtainValidateCodeParameter(request);    
        if (StringUtils.isEmpty(validateCodeParameter)
            || !sessionValidateCode.equalsIgnoreCase(validateCodeParameter)) {    
            throw new AuthenticationServiceException("验证码错误！");    
        }    
    }  
      
    private String obtainValidateCodeParameter(HttpServletRequest request) {  
        Object obj = request.getParameter(VALIDATE_CODE);  
        return null == obj ? "" : obj.toString().toLowerCase();  
    }  
    
    protected String obtainSessionValidateCode(HttpSession session) {  
        Object obj = session.getAttribute(VALIDATE_CODE);  
        return null == obj ? "" : obj.toString().toLowerCase();  
    }  
	
}
```
`MrbirdUsernamePasswordAuthenticationFilter`继承自`UsernamePasswordAuthenticationFilter`，主要工作是获取用户在登陆界面输入的用户名和密码，并判断是否为空，以及判断验证码的正确性。

`UsernamePasswordAuthenticationToken` 中有2个参数`Object principal`（主要的身份认证信息），`Object credentials`（用于证明principal是正确的信息，比如密码）在一个带有username和password的权限认证请求中，principal就会被赋值username，credentials就会被赋值password。

我们还可以在Spring Security.xml中的loginfilter bean配置登陆成功与失败的过滤器：
```xml
<b:bean id="loginfilter" 
    class="spring.security.web.MrbirdUsernamePasswordAuthenticationFilter">
    ...
    <!-- 验证成功后的处理-->  
    <b:property name="authenticationSuccessHandler" ref="authenticationSuccessHandler"/> 
    <!-- 验证失败后的处理-->  
    <b:property name="authenticationFailureHandler" ref="authenticationFailureHandler"/> 
    ...
</b:bean>
<!-- 登入信息验证失败后，退回到登入页面 -->
<b:bean id="authenticationFailureHandler"  
    class="org.springframework.security.web.authentication
                .SimpleUrlAuthenticationFailureHandler">  
    <b:property name="defaultFailureUrl" value="/login?error=true"/>  
</b:bean> 
<!-- 登入信息验证成功后，登入系统主页 -->
<b:bean id="authenticationSuccessHandler"
    class="spring.security.web.MrbirdLoginSuccessHandler">         
    <b:property name="defaultTargetUrl" value="/index"/>
</b:bean>  
```
其中，`MrbirdLoginSuccessHandler`用于处理登陆成功后的操作，比如生成日志等：
```java
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication
        .SavedRequestAwareAuthenticationSuccessHandler;
 
public class MrbirdLoginSuccessHandler 
    extends SavedRequestAwareAuthenticationSuccessHandler {
        public void onAuthenticationSuccess(HttpServletRequest request, 
            HttpServletResponse response,Authentication authentication) 
            throws ServletException, IOException{
        System.out.println("登陆成功！");
        //获取登陆人信息
        User user = (User) authentication.getPrincipal();
        System.out.println(user.getUsername()+user.getAuthorities());
        //跳转到主页面
        super.onAuthenticationSuccess(request, response, authentication);
    }
}
```
## 处理登出
同样，我们可以添加登出过滤器，在Spring Security.xml中的<http auto-config="true">中配置登出过滤器：
```xml
<http auto-config="true">
    ...
    <logout invalidate-session="true"  logout-url="/j_spring_security_logout"
        success-handler-ref="logoutSuccessHandler"/> 
</http>
 <!-- 登出成功，处理类 -->
<b:bean id="logoutSuccessHandler"   
    class="spring.security.web.MrbirdLogoutSuccessHandler">         
    <b:property name="defaultTargetUrl" value="/login"/>
</b:bean> 
```
`logoutSuccessHandler`对应的类`MrbirdLogoutSuccessHandler`：
```java
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication
    .AbstractAuthenticationTargetUrlRequestHandler;
import org.springframework.security.web.authentication.logout
    .LogoutSuccessHandler;
 
public class MrbirdLogoutSuccessHandler 
    extends AbstractAuthenticationTargetUrlRequestHandler 
    implements LogoutSuccessHandler{
    public void onLogoutSuccess(HttpServletRequest request,
        HttpServletResponse response, Authentication authentication)
        throws IOException, ServletException {
        System.out.println("登出成功！");
        User user = (User) authentication.getPrincipal();
        System.out.println(user.getUsername()+user.getAuthorities());
        //跳转到登陆页
        super.handle(request, response, authentication);
    }
}
```
## 异常信息本地化
Spring Security自带的异常信息显示是纯英文的，但Spring Security支持异常信息本地化，这些信息包括认证失败、访问被拒绝等。  

在Spring Security.xml中配置：
```xml
<b:bean id="loginfilter" 
    class="spring.security.web.MrbirdUsernamePasswordAuthenticationFilter">
    ...
    <b:property name="messageSource" ref="messageSource"/> 
</b:bean>
<!-- 定义登录页面异常信息的本地化 -->  
<b:bean id="messageSource"  
    class="org.springframework.context.support.ReloadableResourceBundleMessageSource">  
    <b:property name="basename" value="classpath:messages_zh_CN"/> 
</b:bean>
```
其中，messages_zh_CN.properties配置如下：
```xml
AbstractUserDetailsAuthenticationProvider.badCredentials=\u8D26\u53F7\u6216\u5BC6\u7801\u9519\u8BEF
Auth.usernameIsNull=\u8D26\u53F7\u4E0D\u80FD\u4E3A\u7A7A
Auth.passwordIsNull=\u5BC6\u7801\u4E0D\u80FD\u4E3A\u7A7A
```
`AbstractUserDetailsAuthenticationProvider.badCredentials`定义了账户或密码不匹配时候的异常信息，`Auth.usernameIsNull`和A`uth.passwordIsNull`则是`MrbirdUsernamePasswordAuthenticationFilter`中抛出的异常。
## 自定义限制页面
当页面因为用户权限不足而受限的时候，显示的是403 Access is Denied页面，我们可以自定义这个受限页面。

修改配置spring security.xml文件的<http/>元素，添加自定义访问拒绝页面的地址：
```xml
<http auto-config="true" access-denied-page="/deny" >
    ...
</http>   
```
在LoginController中添加：
```java
...
@RequestMapping(value="/deny")
public String deny(){
    return "deny";
}
```
## deny.jsp
```html
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <title>deny page</title>
    <link href="<c:url value='/css/templatemo_style.css'/>" rel="stylesheet" type="text/css">	
</head>
<body class="templatemo-bg-gray">
    <div class="index-div">
        <span class="index-text-deny" style='color:#C7425C;font-size:28px;'>
            sorry,Insufficient authority +_+
        </span><br/>
    </div>
</body>
</html>
```
## 测试
最终，工程的目录结构为：

![30421015-file_1488435913481_11db7.png](https://www.tuchuang001.com/images/2017/06/13/30421015-file_1488435913481_11db7.png)

spring security.xml最终配置如下：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<b:beans xmlns:b="http://www.springframework.org/schema/beans"
    xmlns="http://www.springframework.org/schema/security"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
        http://www.springframework.org/schema/security 
        http://www.springframework.org/schema/security/spring-security-3.2.xsd">
    <!-- 设置免验证路径 -->
    <http pattern="/**/*.css" security="none"/>
    <http pattern="/**/*.jpg" security="none"/>  
    <http pattern="/**/*.jpeg" security="none"/> 
    <http pattern="/checkCode" security="none"/> 
    <http auto-config="true" access-denied-page="/deny" use-expressions="true">
        <intercept-url pattern="/login" access="permitAll" />
        <intercept-url pattern="/admin" access="hasRole('ROLE_ADMIN')"/>
        <intercept-url pattern="/**" access="hasRole('ROLE_USER')"/>
        <form-login login-page="/login"/>
        <custom-filter ref="loginfilter" before="FORM_LOGIN_FILTER"  /> 
        <logout invalidate-session="true"  logout-url="/j_spring_security_logout" 
            success-handler-ref="logoutSuccessHandler"/> 
    </http>
    <b:bean id="loginfilter" 
	    class="spring.security.web.MrbirdUsernamePasswordAuthenticationFilter">
        <b:property name="filterProcessesUrl" value="/j_spring_security_check"/> 
        <!-- 登入页面form mothed 必须是post --> 
        <b:property name="postOnly" value="true"/>
        <!-- 权限管理器 -->
        <b:property name="authenticationManager" ref="authenticationManager" /> 
        <b:property name="continueChainBeforeSuccessfulAuthentication" value="false"/>
        <!-- 验证成功后的处理-->  
        <b:property name="authenticationSuccessHandler" ref="authenticationSuccessHandler"/> 
        <!-- 验证失败后的处理-->  
        <b:property name="authenticationFailureHandler" ref="authenticationFailureHandler"/> 
        <b:property name="messageSource" ref="messageSource"/> 
    </b:bean>
    <!-- 定义登录页面异常信息的本地化 -->  
    <b:bean id="messageSource"  
        class="org.springframework.context.support.ReloadableResourceBundleMessageSource">  
        <b:property name="basename" value="classpath:messages_zh_CN"/> 
    </b:bean>
    <!-- 登入信息验证失败后，退回到登入页面 -->
    <b:bean id="authenticationFailureHandler"  
        class="org.springframework.security.web.authentication
            .SimpleUrlAuthenticationFailureHandler">  
        <b:property name="defaultFailureUrl" value="/login?error=true"/>  
    </b:bean> 
    <!-- 登入信息验证成功后，登入系统主页 -->
    <b:bean id="authenticationSuccessHandler"
	    class="spring.security.web.MrbirdLoginSuccessHandler">         
        <b:property name="defaultTargetUrl" value="/index"/>
    </b:bean>  
     <!-- 登出成功，处理类 -->
    <b:bean id="logoutSuccessHandler"    
        class="spring.security.web.MrbirdLogoutSuccessHandler">         
        <b:property name="defaultTargetUrl" value="/login"/>
    </b:bean> 
    <user-service id="user_service">
        <user name="admin" password="123456" authorities="ROLE_USER,ROLE_ADMIN"/>
        <user name="user" password="123456" authorities="ROLE_USER"/>
    </user-service>
    <authentication-manager alias="authenticationManager">
        <authentication-provider user-service-ref="user_service"/>
    </authentication-manager>
</b:beans>
```
启动工程，访问：http://localhost:8080/spring-security/login 

![47298958-file_1487996693373_ac23.png](https://www.tuchuang001.com/images/2017/06/13/47298958-file_1487996693373_ac23.png)

当登录失败时，页面如下：

![41595291-file_1487996714125_5670.png](https://www.tuchuang001.com/images/2017/06/13/41595291-file_1487996714125_5670.png)

admin成功登录后：

![74906915-file_1487996735917_4f76.png](https://www.tuchuang001.com/images/2017/06/13/74906915-file_1487996735917_4f76.png)

控制台输出：
```xml
登陆成功！
admin[ROLE_ADMIN, ROLE_USER]
```
点击admin.jsp：

![49887609-file_1487996760103_2fc7.png](https://www.tuchuang001.com/images/2017/06/13/49887609-file_1487996760103_2fc7.png)

点击logout回到登陆页面，使用user登录：

![87434140-file_1487996785624_ce45.png](https://www.tuchuang001.com/images/2017/06/13/87434140-file_1487996785624_ce45.png)

点击admin.jsp：

![98435752-file_1487996804588_a6ef.png](https://www.tuchuang001.com/images/2017/06/13/98435752-file_1487996804588_a6ef.png)

访问受限。

> [source code](http://pan.baidu.com/s/1qY3185Y)