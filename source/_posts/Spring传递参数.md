---
title: Spring传递参数
date: 2017-01-21 19:36:08
tags: Spring
---
总结下平时使用Spring时，服务端接收客户端传递的参数的几种方式。
## 同名变量
在客户端，使用GET请求发送一个变量到服务端，比如传递一个`testParam`变量：
```javascript
var testParam = 'mrbird';
$.ajax({
    url:"${pageContext.request.contextPath}/test?testParam="+testParam,
    method:"get"
});
```
<!--more-->
服务端：
```java
@Controller
@RequestMapping(value="/test")
public class TestContoller {
    @RequestMapping(method=RequestMethod.GET)
    public void test(String testParam){
        
    }
}
```
用testParam同名参数接收，通过断点，得到的值为mrbird。
## @requestParam
和第一种方法类似，只不过使用`@requestParam`注解后，变量可以使用别的名字命名：
```java
@Controller
@RequestMapping(value="/test")
public class TestContoller {
    @RequestMapping(method=RequestMethod.GET)
    public void test(@RequestParam("testParam") String param){
    
    }
}
```
## HttpServletRequest
通过`HttpServletRequest`对象获取：
```java
@Controller
@RequestMapping(value="/test")
public class TestContoller {
    @RequestMapping(method=RequestMethod.GET)
    public void test(HttpServletRequest request){
        String param = request.getParameter("testParam");
    }
}
```
## POJO
使用POJO接收参数适用于参数量较多的时候，比方说表单提交的时候，但这里我们还是用testParam栗子演示。

创建一个用于接收参数的POJO，并定义和传递参数同名的属性：
```java
public class Params {
    private String testParam;
    
    public String getTestParam() {
        return testParam;
    }
    public void setTestParam(String testParam) {
        this.testParam = testParam;
    }
}
```
服务端：
```java
@Controller
@RequestMapping(value="/test")
public class TestContoller {
    @RequestMapping(method=RequestMethod.GET)
    public void test(Params param){
        String testParam = param.getTestParam();
    }
}
```
## 占位符
我们将GET请求的URL改为：
```javascript
url:"${pageContext.request.contextPath}/test/"+testParam,
```
将参数通过URL路径进行标识，而不是通过查询参数。

为了实现这种路径变量，Spring MVC允许我们在`@RequestMapping`路径中添加占位符。占位符的名称要用大括号（“{”和“}”）括起来。路径中的其他部分要与所处理的请求完全匹配， 但是占位符部分可以是任意的值。

修改controller：  
```java
@Controller
@RequestMapping(value="/test")
public class TestContoller {
    @RequestMapping(value="{testParam}",method=RequestMethod.GET)
    public void test(@PathVariable String testParam){
 
    }
}
```
test方法参数名称必须和占位符名称相同。

     