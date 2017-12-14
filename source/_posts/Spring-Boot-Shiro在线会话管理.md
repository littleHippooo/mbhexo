---
title: Spring Boot Shiro在线会话管理
date: 2017-11-28 18:29:59
tags: [Spring,Spring Boot,Shiro]
---
在Shiro中我们可以通过`org.apache.shiro.session.mgt.eis.SessionDAO`对象的`getActiveSessions()`方法方便的获取到当前所有有效的Session对象。通过这些Session对象，我们可以实现一些比较有趣的功能，比如查看当前系统的在线人数，查看这些在线用户的一些基本信息，强制让某个用户下线等。

为了达到这几个目标，我们在现有的Spring Boot Shiro项目基础上进行一些改造。
<!--more-->
## 更改ShiroConfig
为了能够在Spring Boot中使用`SessionDao`，我们在ShiroConfig中配置该Bean：
```java
@Bean
public SessionDAO sessionDAO() {
    MemorySessionDAO sessionDAO = new MemorySessionDAO();
    return sessionDAO;
}
```
在Shiro中，`SessionDao`通过`org.apache.shiro.session.mgt.SessionManager`进行管理，所以继续在ShiroConfig中配置`SessionManager`：
```java
@Bean
public SessionManager sessionManager() {
    DefaultWebSessionManager sessionManager = new DefaultWebSessionManager();
    Collection<SessionListener> listeners = new ArrayList<SessionListener>();
    listeners.add(new ShiroSessionListener());
    sessionManager.setSessionListeners(listeners);
    sessionManager.setSessionDAO(sessionDAO());
    return sessionManager;
}
```
其中`ShiroSessionListener`为`org.apache.shiro.session.SessionListener`接口的手动实现，所以接下来定义一个该接口的实现：
```java
public class ShiroSessionListener implements SessionListener{
    private final AtomicInteger sessionCount = new AtomicInteger(0);
    
    @Override
    public void onStart(Session session) {
        sessionCount.incrementAndGet();
    }
    
    @Override
    public void onStop(Session session) {
        sessionCount.decrementAndGet();
    }
    
    @Override
    public void onExpiration(Session session) {
        sessionCount.decrementAndGet();
    }
}
```
其维护着一个原子类型的Integer对象，用于统计在线Session的数量。

定义完SessionManager后，还需将其注入到SecurityManager中：
```java
@Bean  
public SecurityManager securityManager(){  
    DefaultWebSecurityManager securityManager =  new DefaultWebSecurityManager();
    securityManager.setRealm(shiroRealm());
    securityManager.setRememberMeManager(rememberMeManager());
    securityManager.setCacheManager(getEhCacheManager());
    securityManager.setSessionManager(sessionManager());
    return securityManager;  
}
```
## UserOnline
配置完ShiroConfig后，我们可以创建一个UserOnline实体类，用于描述每个在线用户的基本信息：
```java
public class UserOnline implements Serializable{
	
    private static final long serialVersionUID = 3828664348416633856L;
    // session id
    private String id;
    // 用户id
    private String userId;
    // 用户名称
    private String username;
    // 用户主机地址
    private String host;
    // 用户登录时系统IP
    private String systemHost;
    // 状态
    private String status;
    // session创建时间
    private Date startTimestamp;
    // session最后访问时间
    private Date lastAccessTime;
    // 超时时间
    private Long timeout;
    // get set略
}    
```
## Service
创建一个Service接口，包含查看所有在线用户和根据SessionId踢出用户抽象方法：
```java
public interface SessionService {
    List<UserOnline> list();
    boolean forceLogout(String sessionId);
}
```
其具体实现：
```java
@Service("sessionService")
public class SessionServiceImpl implements SessionService {
    @Autowired
    private SessionDAO sessionDAO;

    @Override
    public List<UserOnline> list() {
        List<UserOnline> list = new ArrayList<>();
        Collection<Session> sessions = sessionDAO.getActiveSessions();
        for (Session session : sessions) {
            UserOnline userOnline = new UserOnline();
            User user = new User();
            SimplePrincipalCollection principalCollection = new SimplePrincipalCollection();
            if (session.getAttribute(DefaultSubjectContext.PRINCIPALS_SESSION_KEY) == null) {
                continue;
            } else {
                principalCollection = (SimplePrincipalCollection) session
                	.getAttribute(DefaultSubjectContext.PRINCIPALS_SESSION_KEY);
                user = (User) principalCollection.getPrimaryPrincipal();
                userOnline.setUsername(user.getUserName());
                userOnline.setUserId(user.getId().toString());
            }
            userOnline.setId((String) session.getId());
            userOnline.setHost(session.getHost());
            userOnline.setStartTimestamp(session.getStartTimestamp());
            userOnline.setLastAccessTime(session.getLastAccessTime());
            Long timeout = session.getTimeout();
            if (timeout == 0l) {
                userOnline.setStatus("离线");
            } else {
                userOnline.setStatus("在线");
            }
            userOnline.setTimeout(timeout);
            list.add(userOnline);
        }
        return list;
    }

    @Override
    public boolean forceLogout(String sessionId) {
        Session session = sessionDAO.readSession(sessionId);
        session.setTimeout(0);
        return true;
    }
}
```
通过SessionDao的`getActiveSessions()`方法，我们可以获取所有有效的Session，通过该Session，我们还可以获取到当前用户的Principal信息。

值得说明的是，当某个用户被踢出后（Session Time置为0），该Session并不会立刻从ActiveSessions中剔除，所以我们可以通过其timeout信息来判断该用户在线与否。

## Controller
定义一个SessionContoller，用于处理Session的相关操作：
```java
@Controller
@RequestMapping("/online")
public class SessionController {
    @Autowired
    SessionService sessionService;
    
    @RequestMapping("index")
    public String online() {
        return "online";
    }

    @ResponseBody
    @RequestMapping("list")
    public List<UserOnline> list() {
        return sessionService.list();
    }

    @ResponseBody
    @RequestMapping("forceLogout")
    public ResponseBo forceLogout(String id) {
        try {
            sessionService.forceLogout(id);
            return ResponseBo.ok();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseBo.error("踢出用户失败");
        }
    }
}
```
## 页面
我们编写一个online.html页面，用于展示所有在线用户的信息：
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>在线用户管理</title>
    <script th:src="@{/js/jquery-1.11.1.min.js}"></script>
    <script th:src="@{/js/dateFormat.js}"></script>
</head>
<body>
    <h3>在线用户数：<span id="onlineCount"></span></h3>
    <table>
        <tr>
            <th>序号</th>
            <th>用户名称</th>
            <th>登录时间</th>
            <th>最后访问时间</th>
            <th>主机</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
    </table>
    <a th:href="@{/index}">返回</a>
</body>
<script th:inline="javascript">
    var ctx = [[@{/}]];
    $.get(ctx + "online/list", {}, function(r){
        var length = r.length;
        $("#onlineCount").text(length);
        var html = "";
        for(var i = 0; i < length; i++){
            html += "<tr>"
                + "<td>" + (i+1) + "</td>"
                + "<td>" + r[i].username + "</td>"
                + "<td>" + new Date(r[i].startTimestamp).Format("yyyy-MM-dd hh:mm:ss") + "</td>"
                + "<td>" + new Date(r[i].lastAccessTime).Format("yyyy-MM-dd hh:mm:ss") + "</td>"
                + "<td>" + r[i].host + "</td>"
                + "<td>" + r[i].status + "</td>"
                + "<td><a href='#' onclick='offline(\"" + r[i].id + "\",\"" + r[i].status +"\")'>下线</a></td>"
                + "</tr>";
        }
        $("table").append(html);
    },"json");
	
    function offline(id,status){
        if(status == "离线"){
            alert("该用户已是离线状态！！");
            return;
        }
        $.get(ctx + "online/forceLogout", {"id": id}, function(r){
            if (r.code == 0) {
                alert('该用户已强制下线！');
                location.href = ctx + 'online/index';
            } else {
                alert(r.msg);
            }
        },"json");
    }
</script>
</html>
```
在index.html中加入该页面的入口：
```html
...
<body>
    <p>你好！[[${user.userName}]]</p>
    <p shiro:hasRole="admin">你的角色为超级管理员</p>
    <p shiro:hasRole="test">你的角色为测试账户</p>
    <div>
        <a shiro:hasPermission="user:user" th:href="@{/user/list}">获取用户信息</a>
        <a shiro:hasPermission="user:add" th:href="@{/user/add}">新增用户</a>
        <a shiro:hasPermission="user:delete" th:href="@{/user/delete}">删除用户</a>
    </div>
    <a shiro:hasRole="admin" th:href="@{/online/index}">在线用户管理</a>
    <a th:href="@{/logout}">注销</a>
</body>
...
```
## 测试
启动项目，在Opera浏览器中使用mrbird账户访问：

![QQ截图20171214191456.png](img/QQ截图20171214191456.png)

在FireFox浏览器中使用tester账户访问：

![QQ截图20171214191543.png](img/QQ截图20171214191543.png)

然后在mrbird主界面点击“在线用户管理”：

![QQ截图20171214191641.png](img/QQ截图20171214191641.png)

显示的信息符合我们的预期，点击tester的下线按钮，强制将其踢出：

![QQ截图20171214191917.png](img/QQ截图20171214191917.png)

回到tester用户的主界面，点击“查看用户信息”，会发现页面已经被重定向到login页面，因为其Session已经失效！

再次刷新mrird的online页面，显示如下：

![QQ截图20171214192219.png](img/QQ截图20171214192219.png)

源码链接：[https://drive.google.com/open?id=1AkCqvpVfGtdqpDktziCZrxSjPG854Arn](https://drive.google.com/open?id=1AkCqvpVfGtdqpDktziCZrxSjPG854Arn)