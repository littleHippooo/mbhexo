---
title: Spring Boot AOP记录用户操作日志
date: 2017-08-25 10:45:07
tags: [Spring,Spring Boot]
---
在Spring框架中，使用AOP配合自定义注解可以方便的实现用户操作的监控。首先搭建一个基本的Spring Boot Web环境[开启Spring Boot](https://mrbird.cc/%E5%BC%80%E5%90%AFSpring-Boot.html)，然后引入必要依赖：
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>

<!-- aop依赖 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>

<!-- oracle驱动 -->
<dependency>
   <groupId>com.oracle</groupId>
   <artifactId>ojdbc6</artifactId>
   <version>6.0</version>
</dependency>

<!-- druid数据源驱动 -->
<dependency>
   <groupId>com.alibaba</groupId>
   <artifactId>druid-spring-boot-starter</artifactId>
   <version>1.1.6</version>
</dependency>
```
<!--more-->
## 自定义注解
定义一个方法级别的`@Log`注解，用于标注需要监控的方法：
```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Log {
    String value() default "";
}
```
## 创建库表和实体
在数据库中创建一张sys_log表，用于保存用户的操作日志，数据库采用oracle 11g：
```sql
CREATE TABLE "SCOTT"."SYS_LOG" (
   "ID" NUMBER(20) NOT NULL ,
   "USERNAME" VARCHAR2(50 BYTE) NULL ,
   "OPERATION" VARCHAR2(50 BYTE) NULL ,
   "TIME" NUMBER(11) NULL ,
   "METHOD" VARCHAR2(200 BYTE) NULL ,
   "PARAMS" VARCHAR2(500 BYTE) NULL ,
   "IP" VARCHAR2(64 BYTE) NULL ,
   "CREATE_TIME" DATE NULL 
);

COMMENT ON COLUMN "SCOTT"."SYS_LOG"."USERNAME" IS '用户名';
COMMENT ON COLUMN "SCOTT"."SYS_LOG"."OPERATION" IS '用户操作';
COMMENT ON COLUMN "SCOTT"."SYS_LOG"."TIME" IS '响应时间';
COMMENT ON COLUMN "SCOTT"."SYS_LOG"."METHOD" IS '请求方法';
COMMENT ON COLUMN "SCOTT"."SYS_LOG"."PARAMS" IS '请求参数';
COMMENT ON COLUMN "SCOTT"."SYS_LOG"."IP" IS 'IP地址';
COMMENT ON COLUMN "SCOTT"."SYS_LOG"."CREATE_TIME" IS '创建时间';

CREATE SEQUENCE seq_sys_log START WITH 1 INCREMENT BY 1;
```
库表对应的实体：
```java
public class SysLog implements Serializable{

    private static final long serialVersionUID = -6309732882044872298L;
    
    private Integer id;
    private String username;
    private String operation;
    private Integer time;
    private String method;
    private String params;
    private String ip;
    private Date createTime;
    // get,set略
}
```
## 保存日志的方法
为了方便，这里直接使用Spring JdbcTemplate来操作数据库。定义一个SysLogDao接口，包含一个保存操作日志的抽象方法：
```java
public interface SysLogDao {
    void saveSysLog(SysLog syslog);
}
```
其实现方法：
```java
@Repository
public class SysLogDaoImp implements SysLogDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Override
    public void saveSysLog(SysLog syslog) {
        StringBuffer sql = new StringBuffer("insert into sys_log ");
        sql.append("(id,username,operation,time,method,params,ip,create_time) ");
        sql.append("values(seq_sys_log.nextval,:username,:operation,:time,:method,");
        sql.append(":params,:ip,:createTime)");
        
        NamedParameterJdbcTemplate npjt = new NamedParameterJdbcTemplate(this.jdbcTemplate.getDataSource());
        npjt.update(sql.toString(), new BeanPropertySqlParameterSource(syslog));
    }
}
```
## 切面和切点
定义一个LogAspect类，使用`@Aspect`标注让其成为一个切面，切点为使用`@Log`注解标注的方法，使用`@Around`环绕通知：
```java
@Aspect
@Component
public class LogAspect {

    @Autowired
    private SysLogDao sysLogDao;
    
    @Pointcut("@annotation(com.springboot.annotation.Log)")
    public void pointcut() { }

    @Around("pointcut()")
    public Object around(ProceedingJoinPoint point) {
        Object result = null;
        long beginTime = System.currentTimeMillis();
        try {
            // 执行方法
            result = point.proceed();
        } catch (Throwable e) {
            e.printStackTrace();
        }
        // 执行时长(毫秒)
        long time = System.currentTimeMillis() - beginTime;
        // 保存日志
        saveLog(point, time);
        return result;
    }

	private void saveLog(ProceedingJoinPoint joinPoint, long time) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        SysLog sysLog = new SysLog();
        Log logAnnotation = method.getAnnotation(Log.class);
        if (logAnnotation != null) {
            // 注解上的描述
            sysLog.setOperation(logAnnotation.value());
        }
        // 请求的方法名
        String className = joinPoint.getTarget().getClass().getName();
        String methodName = signature.getName();
        sysLog.setMethod(className + "." + methodName + "()");
        // 请求的方法参数值
        Object[] args = joinPoint.getArgs();
        // 请求的方法参数名称
        LocalVariableTableParameterNameDiscoverer u = new LocalVariableTableParameterNameDiscoverer();
        String[] paramNames = u.getParameterNames(method);
        if (args != null && paramNames != null) {
            String params = "";
            for (int i = 0; i < args.length; i++) {
                params += "  " + paramNames[i] + ": " + args[i];
            }
            sysLog.setParams(params);
        }
        // 获取request
        HttpServletRequest request = HttpContextUtils.getHttpServletRequest();
        // 设置IP地址
        sysLog.setIp(IPUtils.getIpAddr(request));
        // 模拟一个用户名
        sysLog.setUsername("mrbird");
        sysLog.setTime((int) time);
        sysLog.setCreateTime(new Date());
        // 保存系统日志
        sysLogDao.saveSysLog(sysLog);
    }
}
```
## 测试
TestController：
```java
@RestController
public class TestController {

    @Log("执行方法一")
    @GetMapping("/one")
    public void methodOne(String name) { }
    
    @Log("执行方法二")
    @GetMapping("/two")
    public void methodTwo() throws InterruptedException {
        Thread.sleep(2000);
    }
    
    @Log("执行方法三")
    @GetMapping("/three")
    public void methodThree(String name, String age) { }
}
```
最终项目目录如下图所示：

![QQ截图20171208113619.png](img/QQ截图20171208113619.png)

启动项目，分别访问：

- [http://localhost:8080/web/one?name=KangKang](http://localhost:8080/web/one?name=KangKang)

- [http://localhost:8080/web/two](http://localhost:8080/web/two)

- [http://localhost:8080/web/three?name=Mike&age=25](http://localhost:8080/web/three?name=Mike&age=25)

查询数据库：
```sql
SQL> select * from sys_log order by id;

        ID USERNAME   OPERATION        TIME METHOD                         PARAMS                         IP         CREATE_TIME
---------- ---------- ---------- ---------- ------------------------------ ------------------------------ ---------- --------------
        11 mrbird     执行方法一          6 com.springboot.controller.Test  name: KangKang                127.0.0.1  08-12月-17
                                            Controller.methodOne()

        12 mrbird     执行方法二       2000 com.springboot.controller.Test                                127.0.0.1  08-12月-17
                                            Controller.methodTwo()

        13 mrbird     执行方法三          0 com.springboot.controller.Test  name: Mike age: 25            127.0.0.1  08-12月-17
                                            Controller.methodThree()
```

> [source code](https://drive.google.com/open?id=17I4IJdg7gJfQhn6Hhsar3_xOHsIhcWvl)