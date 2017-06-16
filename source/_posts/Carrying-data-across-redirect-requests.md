---
title: Carrying data across redirect requests
date: 2017-02-04 19:11:13
tags: [Spring]
---
重定向请求传递数据主要有URL和flash两种方式：
## URL
```java
@RequestMapping(value="/redirect",method=RequestMethod.GET)
public String redirect(Model model){
    model.addAttribute("name", "KangKang");
    model.addAttribute("id", 1l);
    return "redirect:/index/redirect/{name}";
} 
```
重定向 URL路径将会是“/index/redirect/KangKang?id=1l”。
<!--more-->

重定向方法：
```java
@RequestMapping(value="/redirect/{name}")
public String getValue(@PathVariable String name,Long id){
    // do something
}
```
通过断点，可看到name的值为KangKang，id为1l。
## flash
URL只能传递String等简单类型值，而flash则可传递Java对象等复杂的值。

Spring提供了通过`RedirectAttributes`设置flash属性的方法，这是Spring 3.1引入的Model 的一个子接口。`RedirectAttributes`提供了Model的所有功能。
```java
@RequestMapping(value="/redirect",method=RequestMethod.GET)
public String redirect(RedirectAttributes model){
    User user = new User();
    user.setId(2l);
    user.setName("Jane");
    model.addFlashAttribute(user);
    return "redirect:/index/redirect/flash";
}  
```
重定向方法：
```java
@RequestMapping(value="/redirect/flash")
public String getValue(Model model){
    return "testRedirect";
}
```
testRedirect.jsp页面可以直接用EL访问User对象。

如果要在方法中获取User对象的属性，可以使用@ModelAttribute("user")标签。

