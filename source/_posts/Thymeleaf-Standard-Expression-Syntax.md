---
title: Thymeleaf 标准表达式语法
date: 2017-09-06 18:54:39
tags: Thymeleaf
---
记录几个比较容易忘记的Thymeleaf标准表达式语法，例子基于Spring MVC。
## 变量表达式${ }
在控制器中往页面传递几个变量：
```java
@Controller
public class IndexController {
    
    @RequestMapping(value="/index",method=RequestMethod.GET)
    public String index(HttpSession session, Model model){
        User user = new User();
        user.setName("KangKang");
        user.setAge(25);
        user.setHabbit(new String[]{"football","basketball","swim"});
        session.setAttribute("user", user);
        model.addAttribute(user);
        return "index";
    }
}
```
<!--more-->
在页面中使用变量表达式`${}`来获取它们：
```html
<p th:utext="${user.name}"></p>
<p th:utext="${session.user.getName()}"></p>
<p th:utext="${session.user.upcaseName()}"></p>
<p th:utext="${user.habbit[0]}"></p>
```
可以看到变量表达式不但可以获取变量的属性值，甚至还可以访问变量的方法（getName()和upcaseName()）。session代表HttpSession对象。

## 选择表达式\*{ }
选择表达式的使用方法如下所示：
```html
<div th:object="${session.user}">
   <p>name: <span th:text="*{name}"></span></p>
   <p>age: <span th:text="*{age}"></span></p>
   <p>habbit: <span th:text="*{habbit[0]}"></span></p>
</div>
```
`*{}`代指`th:object`所指定的对象，即`${session.user}`。

## URL链接表达式@{ }
URL链接表达式会给URL自动添加上下文的名字。比如：
```html
<a th:href="@{/main}">main</a>
```
解析后的href值为`http://localhost:8080/thymeleaf/main`。

当需要在URL中传递参数时，比如这样`http://localhost:8080/thymeleaf/main?name=KangKang`，可以如下操作：
```html
<a th:href="@{/main(name=${session.user.name})}">main</a>
```
传递多个参数：
```html
<a th:href="@{/main(name=${session.user.name},age=${session.user.age})}">main</a>
```
路径变量的写法：
```html
<a th:href="@{/main/{name}(name=${session.user.name})}">main</a>
```
后端接受路径变量：
```java
@RequestMapping(value="main/{name}")
public String main(@PathVariable String name){
   System.out.println("pathValue: "+name);
   return "main";
}
```
## 字面量
### 文本常量
文本常量指的是单引号之间的字符串，比如：
```html
<p th:text="'Welcome KangKang'"></p>
```
### 数字常量
```html
<p>The year is <span th:text="2017">1492</span>.</p>
<p>In two years, it will be <span th:text="2017 + 2">1494</span>.</p>
```
### Boolean类型的常量
Boolean类型的常量就是true和false。例如：
```html
<div th:if="${user.isAdmin()} == false"> ... 
```
### Null常量
```html
<div th:if="${variable.something} == null"> ... 
```

## 字面量替换
除了使用`'...' + ${}`来连接字面量和变量外，还可以使用`|...|`来代替，比如：
```html
<p th:utext="|hello,${session.user.name},your age is ${session.user.age}|"></p>
```
等价于：
```html
<p th:utext="'hello,'+${session.user.name}+',your age is '+${session.user.age}"></p>
```

{%note danger%}在`| ... |`字面替换中只允许有变量表达式`${...}`{%endnote%}

## 条件表达式
条件表达式实际上就是三目运算符。比如：
```html
<tr th:class="${row.even}? 'even' : 'odd'">
  ...
</tr>
```
条件表达式也可以使用括号嵌套：
```html
<tr th:class="${row.even}? (${row.first}? 'first' : 'even') : 'odd'">
  ...
</tr> 
```
else表达式也可以省略，在这种情况下，如果条件为false，则返回空值：
```html
<tr th:class="${row.even}? 'even'">
  ...
</tr> 
```
## 默认表达式
默认表达式是一种特殊类型的条件值，不带then部分。比如：
```html
<p th:utext="${session.user.sex} ?: 'sex is unknown'"></p>
```
表示，当`${session.user.sex}`为`null`时，值为sex is unknown，否则为表达式的值。这就好像为表达式指定了一个默认值一样。其等价于：
```
<p th:utext="${session.user.sex != null} ? ${session.user.sex}: 'sex is unknown'"></p>
```

> 更详细的内容可参考官方文档：[http://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#standard-expression-syntax](http://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#standard-expression-syntax)