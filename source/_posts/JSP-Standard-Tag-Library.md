---
title: JSP Standard Tag Library
date: 2016-11-07 09:19:15
tags: servlet&jsp 
---
JSTL（JSP Standard Tag Library）下载地址：[https://jstl.java.net/](https://jstl.java.net/)。

JSTL包含：

1.JSTL API

2.JSTL Implementation

JSP页面中使用JSTL，使用taglib指令引入：
```xml
<%@ taglib rui="uri" prefix="prefix"%>
```
<!--more-->
## 通用动作指令
引入：
```xml
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```
### out标签   
标记`<c:out>`具有以下属性：
<table>
        <tr>
            <td>
                属性
            </td>
            <td>
                描述
            </td>
        </tr>
        <tr>
            <td>
                value*+ &nbsp;
            </td>
            <td>
                要运算的表达式
            </td>
        </tr>
        <tr>
            <td>
                default
            </td>
            <td>
                默认值
            </td>
        </tr>
        <tr>
            <td>
                escapeXml
            </td>
            <td>
                True，如果标签转义特殊XML字符
            </td>
        </tr>
</table>

`*`表示属性是必需的，`+`号表示可以为表达式。

默认情况下，`excapeXml`属性为true，意味着会将<，>，'，"和&转换为&lt;，&gt;，&#039;和&amp;。
### set标签   
`<c:set>`标记具有以下属性：

<table>
        <tr>
            <th>
                属性
                <br>
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                
                    value+
                
            </td>
            <td>
                
                    要创建的字符串，或要引用的限域对象，或新的属性值
                
            </td>
        </tr>
        <tr>
            <td>
                
                    target+
                
            </td>
            <td>
                
                    其属性应该被修改的限域对象目标
                
            </td>
        </tr>
        <tr>
            <td>
                
                    property+
                
            </td>
            <td>
                
                    要修改的属性名称
                
            </td>
        </tr>
        <tr>
            <td>
                
                    var
                
            </td>
            <td>
                
                    限域变量
                
            </td>
        </tr>
        <tr>
            <td>
                
                    scope
                
            </td>
            <td>
                
                    范围，默认为page
                
            </td>
        </tr>
</table>

如，创建一个page范围的foo变量，并赋值：
```xml
<c:set var="foo" value="The wisest fool"/>
```
创建一个限域变量job，值为request范围的对象position，限域变量的范围为page：
```xml
<c:set var="job" value="${requestScope.position}" socpe="page"/>
```
设置address对象的city属性为fuzhou：
```xml
<c:set target="${address}" property="city" value="fuzhzou"/>
```
也可以这样写：
```xml
<c:set target="${address}" property="city">
    fuzhou
</c:set>
```
### remove标签     
`<c:remove>`标签具有以下属性：

<table>
        <tr>
            <th>
                属性
            </th>
            <th>
                描述
            </th>
            <th>
                默认值
            </th>
        </tr>
        <tr>
            <td>
                var
            </td>
            <td>
                要删除的变量名
            </td>
            <td>
                None
            </td>
        </tr>
        <tr>
            <td>
                scope
            </td>
            <td>
                删除变量的作用域
            </td>
            <td>
                所有作用域
            </td>
        </tr>
</table>

如删除作用域为page的job限域变量：
```xml
<c:remove var="job" scope="page"/>
```
## 条件式动作指令
引入：
```xml
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```
### if标签  
`<c:if>`标签具有以下属性：
<table>
        <tr>
            <th>
                属性
            </th>
            <th>
                描述
            </th>
            <th>
                默认
            </th>
        </tr>
        <tr>
            <td>
                test*+
            </td>
            <td>
                条件计算
            </td>
            <td>
                None
            </td>
        </tr>
        <tr>
            <td>
                var
            </td>
            <td>
                变量名称来存储条件的结果，Boolean类型
            </td>
            <td>
                None
            </td>
        </tr>
        <tr>
            <td>
                scope
            </td>
            <td>
                var变量的作用域
            </td>
            <td>
                page
            </td>
        </tr>
</table>

如：
```xml
<c:set var="salary" scope="session" value="${2000*2}"/>
<c:if test="${salary > 2000}">
    My salary is: <c:out value="${salary}"/>
</c:if>
```
模拟if...else：
```xml
<c:if test="${param.user=='mrbird' && password=='mrbird'}">
    mrbird logged in successfully.
</c:if>
<c:if test="${!(param.user=='mrbird' && password=='mrbird')}">
    userName or password is wrong
</c:if>
```
### choose,when和otherwise
该标签类似于Java中的switch和case关键字类似，使用方法如下：
```xml
<c:choose>
    <c:when test="${param.user=="mrbird"}">
        hi,mrbird.
    </c:when>
    <c:when test="${param.user=="jint"}">
        hi,jint.
    </c:when>
    <c:otherwise>
        hi,someone else.
    </c:otherwise>
</c:choose>   
```
## iterator动作指令
### forEach标签   
`<c:forEach>`标记具有以下属性：
<table>
        <tr>
            <th>
                属性
            </th>
            <th>
                描述
            </th>
            <th>
                默认
            </th>
        </tr>
        <tr>
            <td>
                items+
            </td>
            <td>
                要迭代的对象集合
            </td>
            <td>
                None
            </td>
        </tr>
        <tr>
            <td>
                begin+
            </td>
            <td>
                开始索引
            </td>
            <td>
                0
            </td>
        </tr>
        <tr>
            <td>
                end+
            </td>
            <td>
                结束索引
            </td>
            <td>
                Last element
            </td>
        </tr>
        <tr>
            <td>
                step+
            </td>
            <td>
                迭代步长
            </td>
            <td>
                1
            </td>
        </tr>
        <tr>
            <td>
                var
            </td>
            <td>
                当前迭代内容的限域变量名
            </td>
            <td>
                None
            </td>
        </tr>
        <tr>
            <td>
                varStatus
            </td>
            <td>
                保存迭代状态的限域变量名
            </td>
            <td>
                None
            </td>
        </tr>
</table>

其中，`varStatus`包含一些属性：

1.current当前这次迭代的（集合中的）项

2.index当前这次迭代从 0 开始的迭代索引

3.count当前这次迭代从 1 开始的迭代计数

4.first用来表明当前这轮迭代是否为第一次迭代的标志

5.last用来表明当前这轮迭代是否为最后一次迭代的标志

如循环输出books集合，并控制单双行表格样式：
```xml
<table>
    <tr style="background:#ababff">
        <td>ISBN</td>
        <td>Title</td>
    </tr>    
    <c:forEach item="${requestScope.books}" var="book" vatStatus="status">
        <c:if test="${status.count%2 == 0}">
            <tr style="background:#eeeeff">
        </c:if>
        <c:if test="${status.count%2 != 0}">
            <tr style="background:#dedeff">
        </c:if>
            <td>${book.isbn}</td>
            <td>${book.title}</td>
        </tr>    
    </c:forEach>
</table>    
```

简单的`forEach`标签示例：
```xml
<c:forEach var="x" begin="1" end="5">
    <c:out value="${x}"/>,
</c:forEach>
```
页面输出1，2，3，4，5。
### forTokens标签    
`forTokens`标签使用的比较少，常用的例子：
```xml
<c:forTokens items="Zara,nuha,roshy" delims="," var="name">
    <c:out value="${name}"/>
</c:forTokens>
```
这将产生以下输出结果：
```xml
Zara
nuha
roshy
```
## 格式化动作指令  
引入：
```xml
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
```
### formatNumber标签
`<fmt:formatNumber>`标签用于格式化数字，百分比和货币。`<fmt:formatNumber>`标签有如下属性：  
<table>
        <tr>
            <th>
                属性
            </th>
            <th>
                描述
            </th>
            <th>
                默认值
            </th>
        </tr>
        <tr>
            <td>
                value*+
            </td>
            <td>
                要显示的数字
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                type+
            </td>
            <td>
                NUMBER，CURRENCY，或 PERCENT类型
            </td>
            <td>
                Number
            </td>
        </tr>
        <tr>
            <td>
                pattern+
            </td>
            <td>
                指定一个自定义的格式化模式用于输出
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                currencyCode+
            </td>
            <td>
                货币码（当type="currency"时）
            </td>
            <td>
                取决于默认区域
            </td>
        </tr>
        <tr>
            <td>
                currencySymbol+
            </td>
            <td>
                货币符号 (当 type="currency"时)
            </td>
            <td>
                取决于默认区域
            </td>
        </tr>
        <tr>
            <td>
                groupingUsed+
            </td>
            <td>
                是否对数字分组 (TRUE 或 FALSE)
            </td>
            <td>
                true
            </td>
        </tr>
        <tr>
            <td>
                maxIntegerDigits+
            </td>
            <td>
                整型数最大的位数
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                minIntegerDigits+
            </td>
            <td>
                整型数最小的位数
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                maxFractionDigits+
            </td>
            <td>
                小数点后最大的位数
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                minFractionDigits+
            </td>
            <td>
                小数点后最小的位数
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                var
            </td>
            <td>
                存储格式化数字的变量
            </td>
            <td>
                Print to page
            </td>
        </tr>
        <tr>
            <td>
                scope
            </td>
            <td>
                var属性的作用域
            </td>
            <td>
                page
            </td>
        </tr>
</table> 

`pattern`属性包含的字符：
<table>
        <tr>
            <th>
                符号
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                0
            </td>
            <td>
                代表一位数字
            </td>
        </tr>
        <tr>
            <td>
                E
            </td>
            <td>
                使用指数格式
            </td>
        </tr>
        <tr>
            <td>
                #
            </td>
            <td>
                代表一位数字，若没有则显示0
            </td>
        </tr>
        <tr>
            <td>
                .
            </td>
            <td>
                小数点
            </td>
        </tr>
        <tr>
            <td>
                ,
            </td>
            <td>
                数字分组分隔符
            </td>
        </tr>
        <tr>
            <td>
                ;
            </td>
            <td>
                分隔格式
            </td>
        </tr>
        <tr>
            <td>
                -
            </td>
            <td>
                使用默认负数前缀
            </td>
        </tr>
        <tr>
            <td>
                %
            </td>
            <td>
                百分数
            </td>
        </tr>
        <tr>
            <td>
                ?
            </td>
            <td>
                千分数
            </td>
        </tr>
        <tr>
            <td>
                ¤
            </td>
            <td>
                货币符号，使用实际的货币符号代替
            </td>
        </tr>
        <tr>
            <td>
                X
            </td>
            <td>
                指定可以作为前缀或后缀的字符
            </td>
        </tr>
        <tr>
            <td>
                '
            </td>
            <td>
                在前缀或后缀中引用特殊字符
            </td>
        </tr>
</table>

例子：
```xml
<c:set var="balance" value="120000.2309" />
格式化数字 (1): <fmt:formatNumber value="${balance}" 
                    type="currency"/>
格式化数字 (2): <fmt:formatNumber type="number" 
                    maxIntegerDigits="3" value="${balance}" />
格式化数字 (3): <fmt:formatNumber type="number" 
                    maxFractionDigits="3" value="${balance}" />
格式化数字 (4): <fmt:formatNumber type="number" 
                    groupingUsed="false" value="${balance}" />
格式化数字 (5): <fmt:formatNumber type="percent" 
                    maxIntegerDigits="3" value="${balance}" />
格式化数字 (6): <fmt:formatNumber type="percent" 
                    minFractionDigits="10" value="${balance}" />
格式化数字 (7): <fmt:formatNumber type="percent" 
                    maxIntegerDigits="3" value="${balance}" />
格式化数字 (8): <fmt:formatNumber type="number" 
                    pattern="###.###E0" value="${balance}" />
美元 :
    <fmt:setLocale value="en_US"/>
    <fmt:formatNumber value="${balance}" type="currency"/>
```
结果：
```xml
数字格式化:
格式化数字 (1): ￥120,000.23
格式化数字 (2): 000.231
格式化数字 (3): 120,000.231
格式化数字 (4): 120000.231
格式化数字 (5): 023%
格式化数字 (6): 12,000,023.0900000000%
格式化数字 (7): 023%
格式化数字 (8): 120E3
美元 : $120,000.23
```
### formatDate标签
`<fmt:formatDate>`标签用于使用不同的方式格式化日期。   

`<fmt:formatDate>`标签有如下属性：
<table>
        <tr>
            <th>
                属性
            </th>
            <th>
                描述
            </th>
            <th>
                是否必要
            </th>
            <th>
                默认值
            </th>
        </tr>
        <tr>
            <td>
                value
            </td>
            <td>
                要显示的日期
            </td>
            <td>
                是
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                type
            </td>
            <td>
                DATE, TIME, 或 BOTH
            </td>
            <td>
                否
            </td>
            <td>
                date
            </td>
        </tr>
        <tr>
            <td>
                dateStyle
            </td>
            <td>
                FULL, LONG, MEDIUM, SHORT, 或 DEFAULT
            </td>
            <td>
                否
            </td>
            <td>
                default
            </td>
        </tr>
        <tr>
            <td>
                timeStyle
            </td>
            <td>
                FULL, LONG, MEDIUM, SHORT, 或 DEFAULT
            </td>
            <td>
                否
            </td>
            <td>
                default
            </td>
        </tr>
        <tr>
            <td>
                pattern
            </td>
            <td>
                自定义格式模式
            </td>
            <td>
                否
            </td>
            <td>
                无
            </td>
        </tr>
        <tr>
            <td>
                timeZone
            </td>
            <td>
                显示日期的时区
            </td>
            <td>
                否
            </td>
            <td>
                默认时区
            </td>
        </tr>
        <tr>
            <td>
                var
            </td>
            <td>
                存储格式化日期的变量名
            </td>
            <td>
                否
            </td>
            <td>
                显示在页面
            </td>
        </tr>
        <tr>
            <td>
                scope
            </td>
            <td>
                存储格式化日志变量的范围
            </td>
            <td>
                否
            </td>
            <td>
                页面
            </td>
        </tr>
</table>

`<fmt:formatDate>` 标签格式模式：
<table>
        <tr>
            <th>
                代码
            </th>
            <th>
                描述
            </th>
            <th>
                实例
            </th>
        </tr>
        <tr>
            <td>
                
                    G
                
            </td>
            <td>
                
                    时代标志
                
            </td>
            <td>
                
                    AD
                
            </td>
        </tr>
        <tr>
            <td>
                
                    y
                
            </td>
            <td>
                
                    不包含纪元的年份。如果不包含纪元的年份小于 10，
                
                
                    则显示不具有前导零的年份。
                
            </td>
            <td>
                
                    2002
                
            </td>
        </tr>
        <tr>
            <td>
                
                    M
                
            </td>
            <td>
                
                    月份数字。一位数的月份没有前导零。
                
            </td>
            <td>
                
                    April &amp; 04
                
            </td>
        </tr>
        <tr>
            <td>
                
                    d
                
            </td>
            <td>
                
                    月中的某一天。一位数的日期没有前导零。
                
            </td>
            <td>
                
                    20
                
            </td>
        </tr>
        <tr>
            <td>
                
                    h
                
            </td>
            <td>
                
                    12 小时制的小时。一位数的小时数没有前导零。
                
            </td>
            <td>
                
                    12
                
            </td>
        </tr>
        <tr>
            <td>
                
                    H
                
            </td>
            <td>
                
                    24 小时制的小时。一位数的小时数没有前导零。
                
            </td>
            <td>
                
                    0
                
            </td>
        </tr>
        <tr>
            <td>
                
                    m
                
            </td>
            <td>
                
                    分钟。一位数的分钟数没有前导零。
                
            </td>
            <td>
                
                    45
                
            </td>
        </tr>
        <tr>
            <td>
                
                    s
                
            </td>
            <td>
                
                    秒。一位数的秒数没有前导零。
                
            </td>
            <td>
                
                    52
                
            </td>
        </tr>
        <tr>
            <td>
                
                    S
                
            </td>
            <td>
                
                    毫秒
                
            </td>
            <td>
                
                    970
                
            </td>
        </tr>
        <tr>
            <td>
                
                    E
                
            </td>
            <td>
                
                    周几
                
            </td>
            <td>
                
                    Tuesday
                
            </td>
        </tr>
        <tr>
            <td>
                
                    D
                
            </td>
            <td>
                
                    一年中的第几天
                
            </td>
            <td>
                
                    180
                
            </td>
        </tr>
        <tr>
            <td>
                
                    F
                
            </td>
            <td>
                
                    一个月中的第几个周几
                
            </td>
            <td>
                
                    2 (一个月中的第二个星期三)
                
            </td>
        </tr>
        <tr>
            <td>
                
                    w
                
            </td>
            <td>
                
                    一年中的第几周r
                
            </td>
            <td>
                
                    27
                
            </td>
        </tr>
        <tr>
            <td>
                
                    W
                
            </td>
            <td>
                
                    一个月中的第几周
                
            </td>
            <td>
                
                    2
                
            </td>
        </tr>
        <tr>
            <td>
                
                    a
                
            </td>
            <td>
                
                    a.m./p.m. 指示符
                
            </td>
            <td>
                
                    PM
                
            </td>
        </tr>
        <tr>
            <td>
                
                    k
                
            </td>
            <td>
                
                    小时(12 小时制的小时)
                
            </td>
            <td>
                
                    24
                
            </td>
        </tr>
        <tr>
            <td>
                
                    K
                
            </td>
            <td>
                
                    小时(24 小时制的小时)
                
            </td>
            <td>
                
                    0
                
            </td>
        </tr>
        <tr>
            <td>
                
                    z
                
            </td>
            <td>
                
                    时区
                
            </td>
            <td>
                
                    中部标准时间
                
            </td>
        </tr>
        <tr>
            <td>
                
                    '
                
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                
                    转义文本
                
            </td>
        </tr>
        <tr>
            <td>
                
                    ''
                
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                
                    单引号
                
            </td>
        </tr>
</table>

例子：
```xml
<c:set var="now" value="<%=new java.util.Date()%>" />
<p>日期格式化 (1): <fmt:formatDate type="time" value="${now}" /></p>
<p>日期格式化 (2): <fmt:formatDate type="date" value="${now}" /></p>
<p>日期格式化 (3): <fmt:formatDate type="both" value="${now}" /></p>
<p>日期格式化 (4): <fmt:formatDate type="both" dateStyle="short" 
                    timeStyle="short" value="${now}" /></p>
<p>日期格式化 (5): <fmt:formatDate type="both" dateStyle="medium" 
                    timeStyle="medium" value="${now}" /></p>
<p>日期格式化 (6): <fmt:formatDate type="both" dateStyle="long"
                    timeStyle="long" value="${now}" /></p>
<p>日期格式化 (7): <fmt:formatDate pattern="yyyy-MM-dd" value="${now}" /></p>
```
结果：
```xml
日期格式化:
日期格式化 (1): 11:19:43
日期格式化 (2): 2016-6-26
日期格式化 (3): 2016-6-26 11:19:43
日期格式化 (4): 16-6-26 上午11:19
日期格式化 (5): 2016-6-26 11:19:43
日期格式化 (6): 2016年6月26日 上午11时19分43秒
日期格式化 (7): 2016-06-26
```
剩下的fmt标签较少使用，懒得记录。
## 函数
引入：
```xml
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
```
### contains函数    
`fn:contains()`函数的语法如下：
```xml
<c:if test="${fn:contains(<原始字符串>, <要查找的子字符串>)}">
    ...
</c:if>﻿​
```
如，下面的EL表达式都返回true：
```xml
<c:set var="myString" value="Hello World"/>
${fn:contains(myString,"Hello")}
${fn:contains("Stella Cadente","Cadente")}
```
### containsIgnoreCase函数
和`contains`类似，不区分大小写。
### endsWith函数
判断以什么为结尾。
### startsWith函数
### escapeXml函数
如：
```xml
${fn:escapeXml("Use <br> to change lines")}  
```
显示为：
```xml
Use <br> to change lines
```
### indexOf函数
`fn:indexOf()`函数返回一个字符串中指定子串的位置。

`fn:indexOf()`函数的语法如下：
```xml
${fn:indexOf(<原始字符串>,<子字符串>)}
```
例子：
```xml
<c:set var="string1" value="This is first String."/>
<p>Index: ${fn:indexOf(string1, "first")}</p>
```
结果：
```xml
Index: 8
```
### join函数    
`fn:join()`函数将一个数组中的所有元素使用指定的分隔符来连接成一个字符串。
### split函数
`fn:split()`函数将一个字符串用指定的分隔符分裂为一个子串数组。

join和split例子：
```xml
<c:set var="string1" value="www runoob com"/>
<c:set var="string2" value="${fn:split(string1, ' ')}" />
<c:set var="string3" value="${fn:join(string2, '-')}" />
<p>string3 字符串 : ${string3}</p>
```
结果为：
```xml
字符串为 : www-runoob-com
```
### length函数
### replace函数
`fn:replace()`函数将字符串中所有指定的子串用另外的字符串替换。

`fn:replace()`函数的语法如下：
```xml
${fn:replace(<原始字符串>, <被替换的字符串>, <要替换的字符串>)}      
```
例子：
```xml
<c:set var="string1" value="I am from USA"/>
<c:set var="string2" value="${fn:replace(string1, 'USA', 'China')}" />
<p>替换后的字符串 : ${string2}</p>
```
结果：
```xml
替换后的字符串 : I am from China
```
### substring函数
`fn:substring()`函数返回字符串中指定开始和结束索引的子串。

`fn:substring()`函数的语法如下：
```xml
${fn:substring(<string>, <beginIndex>, <endIndex>)}
```
例子：
```xml
<c:set var="string1" value="This is first String."/>
<c:set var="string2" value="${fn:substring(string1, 5, 15)}" />
<p>生成的子字符串为 : ${string2}</p>
```
结果：
```xml
生成的子字符串为 : is first S
```
### substringBefore函数
`fn:substringBefore()`函数返回一个字符串中指定子串前面的部分。

如：
```xml
<c:set var="string1" value="This is first String."/>
<c:set var="string2" value="${fn:substringBefore(string1, 'first')}" />
<p>生成的子字符串 : ${string2}</p>    
```
结果：
```xml
生成的子字符串 : This is
```
### substringAfter函数
### toLowerCase函数
### toUpperCase函数
### trim函数
## sql标签
略。

> [《Servlet和JSP学习指南》](https://book.douban.com/subject/22994746/)学习笔记