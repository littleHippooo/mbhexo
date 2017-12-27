---
title: Spring Boot Shiro权限控制
date: 2017-12-24 08:56:07
tags: [Spring,Spring Boot,Shiro]
---
在[《Spring-Boot-shiro用户认证》](/Spring-Boot-shiro用户认证.html)中，我们通过继承AuthorizingRealm抽象类实现了`doGetAuthenticationInfo()`方法完成了用户认证操作。接下来继续实现`doGetAuthorizationInfo()`方法完成Shiro的权限控制功能。

授权也称为访问控制，是管理资源访问的过程。即根据不同用户的权限判断其是否有访问相应资源的权限。在Shiro中，权限控制有三个核心的元素：权限，角色和用户。
<!--more-->
## 库模型设计
在这里，我们使用RBAC（Role-Based Access Control，基于角色的访问控制）模型设计用户，角色和权限间的关系。简单地说，一个用户拥有若干角色，每一个角色拥有若干权限。这样，就构造成“用户-角色-权限”的授权模型。在这种模型中，用户与角色之间，角色与权限之间，一般者是多对多的关系。如下图所示：

![QQ截图20171214123601.png](img/QQ截图20171214123601.png)

根据这个模型，设计数据库表，并插入一些测试数据：
```sql
-- ----------------------------
-- Table structure for T_PERMISSION
-- ----------------------------
CREATE TABLE "SCOTT"."T_PERMISSION" (
   "ID" NUMBER(10) NOT NULL ,
   "URL" VARCHAR2(256 BYTE) NULL ,
   "NAME" VARCHAR2(64 BYTE) NULL 
);

COMMENT ON COLUMN "SCOTT"."T_PERMISSION"."URL" IS 'url地址';
COMMENT ON COLUMN "SCOTT"."T_PERMISSION"."NAME" IS 'url描述';

-- ----------------------------
-- Records of T_PERMISSION
-- ----------------------------
INSERT INTO "SCOTT"."T_PERMISSION" VALUES ('1', '/user', 'user:user');
INSERT INTO "SCOTT"."T_PERMISSION" VALUES ('2', '/user/add', 'user:add');
INSERT INTO "SCOTT"."T_PERMISSION" VALUES ('3', '/user/delete', 'user:delete');

-- ----------------------------
-- Table structure for T_ROLE
-- ----------------------------
CREATE TABLE "SCOTT"."T_ROLE" (
   "ID" NUMBER NOT NULL ,
   "NAME" VARCHAR2(32 BYTE) NULL ,
   "MEMO" VARCHAR2(32 BYTE) NULL 
);

COMMENT ON COLUMN "SCOTT"."T_ROLE"."NAME" IS '角色名称';
COMMENT ON COLUMN "SCOTT"."T_ROLE"."MEMO" IS '角色描述';

-- ----------------------------
-- Records of T_ROLE
-- ----------------------------
INSERT INTO "SCOTT"."T_ROLE" VALUES ('1', 'admin', '超级管理员');
INSERT INTO "SCOTT"."T_ROLE" VALUES ('2', 'test', '测试账户');

-- ----------------------------
-- Table structure for T_ROLE_PERMISSION
-- ----------------------------
CREATE TABLE "SCOTT"."T_ROLE_PERMISSION" (
   "RID" NUMBER(10) NULL ,
   "PID" NUMBER(10) NULL 
);

COMMENT ON COLUMN "SCOTT"."T_ROLE_PERMISSION"."RID" IS '角色id';
COMMENT ON COLUMN "SCOTT"."T_ROLE_PERMISSION"."PID" IS '权限id';

-- ----------------------------
-- Records of T_ROLE_PERMISSION
-- ----------------------------
INSERT INTO "SCOTT"."T_ROLE_PERMISSION" VALUES ('1', '2');
INSERT INTO "SCOTT"."T_ROLE_PERMISSION" VALUES ('1', '3');
INSERT INTO "SCOTT"."T_ROLE_PERMISSION" VALUES ('2', '1');
INSERT INTO "SCOTT"."T_ROLE_PERMISSION" VALUES ('1', '1');

-- ----------------------------
-- Table structure for T_USER
-- ----------------------------
CREATE TABLE "SCOTT"."T_USER" (
   "ID" NUMBER NOT NULL ,
   "USERNAME" VARCHAR2(20 BYTE) NOT NULL ,
   "PASSWD" VARCHAR2(128 BYTE) NOT NULL ,
   "CREATE_TIME" DATE NULL ,
   "STATUS" CHAR(1 BYTE) NOT NULL 
);

COMMENT ON COLUMN "SCOTT"."T_USER"."USERNAME" IS '用户名';
COMMENT ON COLUMN "SCOTT"."T_USER"."PASSWD" IS '密码';
COMMENT ON COLUMN "SCOTT"."T_USER"."CREATE_TIME" IS '创建时间';
COMMENT ON COLUMN "SCOTT"."T_USER"."STATUS" IS '是否有效 1：有效  0：锁定';

-- ----------------------------
-- Records of T_USER
-- ----------------------------
INSERT INTO "SCOTT"."T_USER" VALUES ('2', 'tester', '243e29429b340192700677d48c09d992', TO_DATE('2017-12-11 17:20:21', 'YYYY-MM-DD HH24:MI:SS'), '1');
INSERT INTO "SCOTT"."T_USER" VALUES ('1', 'mrbird', '42ee25d1e43e9f57119a00d0a39e5250', TO_DATE('2017-12-11 10:52:48', 'YYYY-MM-DD HH24:MI:SS'), '1');

-- ----------------------------
-- Table structure for T_USER_ROLE
-- ----------------------------
CREATE TABLE "SCOTT"."T_USER_ROLE" (
   "USER_ID" NUMBER(10) NULL ,
   "RID" NUMBER(10) NULL 
);

COMMENT ON COLUMN "SCOTT"."T_USER_ROLE"."USER_ID" IS '用户id';
COMMENT ON COLUMN "SCOTT"."T_USER_ROLE"."RID" IS '角色id';

-- ----------------------------
-- Records of T_USER_ROLE
-- ----------------------------
INSERT INTO "SCOTT"."T_USER_ROLE" VALUES ('1', '1');
INSERT INTO "SCOTT"."T_USER_ROLE" VALUES ('2', '2');
```
一些非空约束这里就不贴了，可参考源码中的init.sql。

上面的sql创建了五张表：用户表**T_USER**、角色表**T_ROLE**、用户角色关联表**T_USER_ROLE**、权限表**T_PERMISSION**和权限角色关联表**T_ROLE_PERMISSION**。用户mrbird角色为admin，用户tester角色为test。admin角色拥有用户的所有权限（user:user,user:add,user:delete），而test角色只拥有用户的查看权限（user:user）。密码都是123456，经过Shiro提供的MD5加密。
## Dao层
创建两个实体类，对应用户角色表Role和用户权限表Permission：

Role:
```java
public class Role implements Serializable{

    private static final long serialVersionUID = -227437593919820521L;
    private Integer id;
    private String name;
    private String memo;
    // get set略
}    
```
Permission:
```java
public class Permission implements Serializable{

    private static final long serialVersionUID = 7160557680614732403L;
    private Integer id;
    private String url;
    private String name;
    // get,set略	
}
```
创建两个dao接口，分别用户查询用户的所有角色和用户的所有权限：

UserRoleMapper：
```java
@Mapper
public interface UserRoleMapper {
    List<Role> findByUserName(String userName);
}
```
UserPermissionMapper：
```java
@Mapper
public interface UserPermissionMapper {
    List<Permission> findByUserName(String userName);
}
```
其xml实现：

UserRoleMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.springboot.dao.UserRoleMapper">
    <resultMap type="com.springboot.pojo.Role" id="role">
        <id column="id" property="id" javaType="java.lang.Integer" jdbcType="NUMERIC"/>
        <id column="name" property="name" javaType="java.lang.String" jdbcType="VARCHAR"/>
        <id column="memo" property="memo" javaType="java.lang.String" jdbcType="VARCHAR"/>
    </resultMap>
    <select id="findByUserName" resultMap="role">
        select r.id,r.name,r.memo from t_role r
        left join t_user_role ur on(r.id = ur.rid) 
        left join t_user u on(u.id = ur.user_id)
        where u.username = #{userName}
    </select>
</mapper>
```
UserPermissionMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.springboot.dao.UserPermissionMapper">
    <resultMap type="com.springboot.pojo.Permission" id="permission">
        <id column="id" property="id" javaType="java.lang.Integer" jdbcType="NUMERIC"/>
        <id column="url" property="url" javaType="java.lang.String" jdbcType="VARCHAR"/>
        <id column="name" property="name" javaType="java.lang.String" jdbcType="VARCHAR"/>
    </resultMap>
    <select id="findByUserName" resultMap="permission">
        select p.id,p.url,p.name from t_role r
        left join t_user_role ur on(r.id = ur.rid) 
        left join t_user u on(u.id = ur.user_id)
        left join t_role_permission rp on(rp.rid = r.id) 
        left join t_permission p on(p.id = rp.pid ) 
        where u.username = #{userName}
    </select>
</mapper>
```
数据层准备好后，接下来对Realm进行改造。
## Realm
在Shiro中，用户角色和权限的获取是在Realm的`doGetAuthorizationInfo()`方法中实现的，所以接下来手动实现该方法：
```java
public class ShiroRealm extends AuthorizingRealm {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UserRoleMapper userRoleMapper;
    @Autowired
    private UserPermissionMapper userPermissionMapper;

    /**
     * 获取用户角色和权限
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principal) {
        User user = (User) SecurityUtils.getSubject().getPrincipal();
        String userName = user.getUserName();
        
        System.out.println("用户" + userName + "获取权限-----ShiroRealm.doGetAuthorizationInfo");
        SimpleAuthorizationInfo simpleAuthorizationInfo = new SimpleAuthorizationInfo();
        
        // 获取用户角色集
        List<Role> roleList = userRoleMapper.findByUserName(userName);
        Set<String> roleSet = new HashSet<String>();
        for (Role r : roleList) {
            roleSet.add(r.getName());
        }
        simpleAuthorizationInfo.setRoles(roleSet);
        
        // 获取用户权限集
        List<Permission> permissionList = userPermissionMapper.findByUserName(userName);
        Set<String> permissionSet = new HashSet<String>();
        for (Permission p : permissionList) {
            permissionSet.add(p.getName());
        }
        simpleAuthorizationInfo.setStringPermissions(permissionSet);
        return simpleAuthorizationInfo;
    }

    /**
     * 登录认证
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        // 登录认证已经实现过，这里不再贴代码
    }
}	
```
在上述代码中，我们通过方法`userRoleMapper.findByUserName(userName)`和`userPermissionMapper.findByUserName(userName)`获取了当前登录用户的角色和权限集，然后保存到SimpleAuthorizationInfo对象中，并返回给Shiro，这样Shiro中就存储了当前用户的角色和权限信息了。

除了对Realm进行改造外，我们还需修改ShiroConfig配置。
## ShiroConfig
Shiro为我们提供了一些和权限相关的注解，如下所示：
```java
// 表示当前Subject已经通过login进行了身份验证；即Subject.isAuthenticated()返回true。
@RequiresAuthentication  
 
// 表示当前Subject已经身份验证或者通过记住我登录的。
@RequiresUser  

// 表示当前Subject没有身份验证或通过记住我登录过，即是游客身份。
@RequiresGuest  

// 表示当前Subject需要角色admin和user。  
@RequiresRoles(value={"admin", "user"}, logical= Logical.AND)  

// 表示当前Subject需要权限user:a或user:b。
@RequiresPermissions (value={"user:a", "user:b"}, logical= Logical.OR)  
```
要开启这些注解的使用，需要在ShiroConfig中添加如下配置：
```java
...
@Bean
@DependsOn({"lifecycleBeanPostProcessor"})
public DefaultAdvisorAutoProxyCreator advisorAutoProxyCreator() {
    DefaultAdvisorAutoProxyCreator advisorAutoProxyCreator = new DefaultAdvisorAutoProxyCreator();
    advisorAutoProxyCreator.setProxyTargetClass(true);
    return advisorAutoProxyCreator;
}

@Bean
public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(SecurityManager securityManager) {
    AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor = new AuthorizationAttributeSourceAdvisor();
    authorizationAttributeSourceAdvisor.setSecurityManager(securityManager);
    return authorizationAttributeSourceAdvisor;
}
...
```
## Controller
编写一个UserController，用于处理User类的访问请求，并使用Shiro权限注解控制权限：
```java
@Controller
@RequestMapping("/user")
public class UserController {

    @RequiresPermissions("user:user")
    @RequestMapping("list")
    public String userList(Model model) {
        model.addAttribute("value", "获取用户信息");
        return "user";
    }
    
    @RequiresPermissions("user:add")
    @RequestMapping("add")
    public String userAdd(Model model) {
        model.addAttribute("value", "新增用户");
        return "user";
    }
    
    @RequiresPermissions("user:delete")
    @RequestMapping("delete")
    public String userDelete(Model model) {
        model.addAttribute("value", "删除用户");
        return "user";
    }
}
```
在LoginController中添加一个/403跳转：
```java
@GetMapping("/403")
public String forbid() {
    return "403";
}
```
## 前端页面
对index.html进行改造，添加三个用户操作的链接：
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>首页</title>
</head>
<body>
    <p>你好！[[${user.userName}]]</p>
    <h3>权限测试链接</h3>
    <div>
        <a th:href="@{/user/list}">获取用户信息</a>
        <a th:href="@{/user/add}">新增用户</a>
        <a th:href="@{/user/delete}">删除用户</a>
    </div>
    <a th:href="@{/logout}">注销</a>
</body>
</html>
```
当用户对用户的操作有相应权限的时候，跳转到user.html：
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>[[${value}]]</title>
</head>
<body>
    <p>[[${value}]]</p>
    <a th:href="@{/index}">返回</a>
</body>
</html>
```
403页面：
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>暂无权限</title>
</head>
<body>
    <p>您没有权限访问该资源！！</p>
    <a th:href="@{/index}">返回</a>
</body>
```
## 测试
启动项目，使用mrbird的账户登录后主页如下图所示：

![QQ截图20171214100711.png](img/QQ截图20171214100711.png)

点击"获取用户信息连接"：

![QQ截图20171214100752.png](img/QQ截图20171214100752.png)

因为mrbird角色为admin，对着三个链接都由访问权限，所以这里就不演示了。

接着使用tester用户登录。因为tester用户角色为test，只拥有（user:user）权限，所以当其点击"新增用户"和"删除用户"的时候：

![QQ截图20171214101044.png](img/QQ截图20171214101044.png)

后台抛出<span style="color:red;font-weight: bold;">org.apache.shiro.authz.AuthorizationException: Not authorized to invoke method:...</span>异常！！！

这里有点出乎意料，本以为在ShiroConfig中配置了`shiroFilterFactoryBean.setUnauthorizedUrl("/403");`，没有权限的访问会自动重定向到/403，结果证明并不是这样。后来研究发现，该设置只对filterChain起作用，比如在filterChain中设置了`filterChainDefinitionMap.put("/user/update", "perms[user:update]");`，如果用户没有`user:update`权限，那么当其访问`/user/update`的时候，页面会被重定向到/403。

那么对于上面这个问题，我们可以定义一个全局异常捕获类：
```java
@ControllerAdvice
@Order(value = Ordered.HIGHEST_PRECEDENCE)
public class GlobalExceptionHandler {
    @ExceptionHandler(value = AuthorizationException.class)
    public String handleAuthorizationException() {
        return "403";
    }
}
```
启动项目，再次使用tester的账号点击"新增用户"和"删除用户"链接的时候，页面如下所示：

![QQ截图20171214101815.png](img/QQ截图20171214101815.png)

页面已经成功重定向到/403。

源码链接[https://drive.google.com/open?id=1Ji7ZfB3xXKInTfqPBt1fY21QeDzn6DrQ](https://drive.google.com/open?id=1Ji7ZfB3xXKInTfqPBt1fY21QeDzn6DrQ)