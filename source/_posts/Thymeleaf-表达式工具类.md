---
title: Thymeleaf 表达式工具类
date: 2017-09-10 10:36:30
tags: Thymeleaf
---
Thymeleaf默认提供了丰富的表达式工具类，这里列举一些常用的工具类。

## Objects工具类
```html
/*
 * 当obj不为空时，返回obj，否则返回default默认值
 * 其同样适用于数组、列表或集合
 */
${#objects.nullSafe(obj,default)}
${#objects.arrayNullSafe(objArray,default)}
${#objects.listNullSafe(objList,default)}
${#objects.setNullSafe(objSet,default)} 
```
<!--more-->
## String工具类
```html
/*
 * Null-safe toString()
 */
${#strings.toString(obj)}   // 也可以是 array*、list* 或 set*

/*
 * 检查String是否为空(或null)。在检查之前执行trim()操作也同样适用于数组、列表或集合
 */
${#strings.isEmpty(name)}
${#strings.arrayIsEmpty(nameArr)}
${#strings.listIsEmpty(nameList)}
${#strings.setIsEmpty(nameSet)}

/*
 * 对字符串执行“isEmpty()”检查, 如果为false则返回它, 如果为true则默认为另一个指定的字符串。
 * 也同样适用于数组、列表或集合
 */
${#strings.defaultString(text,default)}
${#strings.arrayDefaultString(textArr,default)}
${#strings.listDefaultString(textList,default)}
${#strings.setDefaultString(textSet,default)}

/*
 * 检查字符串中是否包含片段，比如 ${#strings.containsIgnoreCase(user.name,'kang')}
 * 也同样适用于数组、列表或集合
 */
${#strings.contains(name,'ez')}               // 也可以是 array*、list* 或 set*
${#strings.containsIgnoreCase(name,'ez')}     // 也可以是 array*、list* 或 set*

/*
 * 检查字符串是否以片段开始或结束
 * 也同样适用于数组、列表或集合
 */
${#strings.startsWith(name,'Don')}            // 也可以是 array*、list* 或 set*
${#strings.endsWith(name,endingFragment)}     // 也可以是 array*、list* 或 set*

/*
 * 子串相关操作
 * 也同样适用于数组、列表或集合
 */
${#strings.indexOf(name,frag)}                // 也可以是 array*、list* 或 set*
${#strings.substring(name,3,5)}               // 也可以是 array*、list* 或 set*
${#strings.substringAfter(name,prefix)}       // 也可以是 array*、list* 或 set*
${#strings.substringBefore(name,suffix)}      // 也可以是 array*、list* 或 set*
${#strings.replace(name,'las','ler')}         // 也可以是 array*、list* 或 set*

/*
 * 附加和前置
 * 也同样适用于数组、列表或集合
 */
${#strings.prepend(str,prefix)}               // 也可以是 array*、list* 或 set*
${#strings.append(str,suffix)}                // 也可以是 array*、list* 或 set*

/*
 * 大小写转换
 * 也同样适用于数组、列表或集合
 */
${#strings.toUpperCase(name)}                 // 也可以是 array*、list* 或 set*
${#strings.toLowerCase(name)}                 // 也可以是 array*、list* 或 set*

/*
 * 拆分和拼接
 */
${#strings.arrayJoin(namesArray,',')}
${#strings.listJoin(namesList,',')}
${#strings.setJoin(namesSet,',')}
${#strings.arraySplit(namesStr,',')}          // 返回String []
${#strings.listSplit(namesStr,',')}           // 返回List<String>
${#strings.setSplit(namesStr,',')}            // 返回Set<String>

/*
 * Trim
 * 也同样适用于数组、列表或集合
 */
${#strings.trim(str)}                         // 也可以是 array*、list* 或 set*

/*
 * 计算长度
 * 也同样适用于数组、列表或集合
 */
${#strings.length(str)}                       // 也可以是 array*、list* 或 set*

/*
 * 缩写文本, 使其最大大小为n。如果文本较大, 它将被剪辑并在末尾附加“...”
 * 也同样适用于数组、列表或集合
 */
${#strings.abbreviate(str,10)}                // 也可以是 array*、list* 或 set*

/*
 * 将第一个字符转换为大写(反之亦然)
 */
${#strings.capitalize(str)}                   // 也可以是 array*、list* 或 set*
${#strings.unCapitalize(str)}                 // 也可以是 array*、list* 或 set*

/*
 * 将每个单词的第一个字符转换为大写
 */
${#strings.capitalizeWords(str)}              // 也可以是 array*、list* 或 set*
${#strings.capitalizeWords(str,delimiters)}   // 也可以是 array*、list* 或 set*

/*
 * 转义字符串
 */
${#strings.escapeXml(str)}                    // 也可以是 array*、list* 或 set*
${#strings.escapeJava(str)}                   // 也可以是 array*、list* 或 set*
${#strings.escapeJavaScript(str)}             // 也可以是 array*、list* 或 set*

${#strings.unescapeJava(str)}                 // 也可以是 array*、list* 或 set*
${#strings.unescapeJavaScript(str)}           // 也可以是 array*、list* 或 set*

/*
 * 空安全比较和连接
 */
${#strings.equals(first, second)}
${#strings.equalsIgnoreCase(first, second)}
${#strings.concat(values...)}
${#strings.concatReplaceNulls(nullValue, values...)}

/*
 * 随机数
 */
${#strings.randomAlphanumeric(count)} 

```
## Dates工具类
```html
/*
 * 使用标准区域设置格式格式化日期
 * 也同样适用于数组、列表或集合
 */
${#dates.format(date)}
${#dates.arrayFormat(datesArray)}
${#dates.listFormat(datesList)}
${#dates.setFormat(datesSet)}

/*
 * 使用ISO8601格式格式化日期
  * 也同样适用于数组、列表或集合
 */
${#dates.formatISO(date)}
${#dates.arrayFormatISO(datesArray)}
${#dates.listFormatISO(datesList)}
${#dates.setFormatISO(datesSet)}

/*
 * 使用指定的格式格式化日期，比如 ${#dates.format(date,'yyyy-MM-dd HH:mm:ss')}
 * 也同样适用于数组、列表或集合
 */
${#dates.format(date, 'dd/MMM/yyyy HH:mm')}
${#dates.arrayFormat(datesArray, 'dd/MMM/yyyy HH:mm')}
${#dates.listFormat(datesList, 'dd/MMM/yyyy HH:mm')}
${#dates.setFormat(datesSet, 'dd/MMM/yyyy HH:mm')}

/*
 * 获取日期属性
 * 也同样适用于数组、列表或集合
 */
${#dates.day(date)}                    // 也可以是 arrayDay(...), listDay(...)之类的
${#dates.month(date)}                  // 也可以是 arrayMonth(...), listMonth(...)之类的
${#dates.monthName(date)}              // 也可以是 arrayMonthName(...), listMonthName(...)之类的
${#dates.monthNameShort(date)}         // 也可以是 arrayMonthNameShort(...), listMonthNameShort(...)之类的
${#dates.year(date)}                   // 也可以是 arrayYear(...), listYear(...)之类的
${#dates.dayOfWeek(date)}              // 也可以是 arrayDayOfWeek(...), listDayOfWeek(...)之类的
${#dates.dayOfWeekName(date)}          // 也可以是 arrayDayOfWeekName(...), listDayOfWeekName(...)之类的
${#dates.dayOfWeekNameShort(date)}     // 也可以是 arrayDayOfWeekNameShort(...), listDayOfWeekNameShort(...)之类的
${#dates.hour(date)}                   // 也可以是 arrayHour(...), listHour(...)之类的
${#dates.minute(date)}                 // 也可以是 arrayMinute(...), listMinute(...)之类的
${#dates.second(date)}                 // 也可以是 arraySecond(...), listSecond(...)之类的
${#dates.millisecond(date)}            // 也可以是 arrayMillisecond(...), listMillisecond(...)之类的

/*
 * 根据year,month,day创建日期(java.util.Date)对象，比如 ${#dates.create('2008','08','08')}
 */
${#dates.create(year,month,day)}
${#dates.create(year,month,day,hour,minute)}
${#dates.create(year,month,day,hour,minute,second)}
${#dates.create(year,month,day,hour,minute,second,millisecond)}

/*
 * 创建当前日期和时间创建日期(java.util.Date)对象，比如 ${#dates.format(#dates.createNow(),'yyyy-MM-dd HH:mm:ss')}
 */
${#dates.createNow()}

${#dates.createNowForTimeZone()}

/*
 * 创建当前日期创建一个日期(java.util.Date)对象(时间设置为00:00)
 */
${#dates.createToday()}

${#dates.createTodayForTimeZone()} 
```
## Calendars工具类
```html
/*
 * 使用标准区域设置格式格式化日历
 * 也同样适用于数组、列表或集合
 */
${#calendars.format(cal)}
${#calendars.arrayFormat(calArray)}
${#calendars.listFormat(calList)}
${#calendars.setFormat(calSet)}

/*
 * 使用ISO8601格式格式化日历
 * 也同样适用于数组、列表或集合
 */
${#calendars.formatISO(cal)}
${#calendars.arrayFormatISO(calArray)}
${#calendars.listFormatISO(calList)}
${#calendars.setFormatISO(calSet)}

/*
 * 使用指定的格式格式化日历
 * 也同样适用于数组、列表或集合
 */
${#calendars.format(cal, 'dd/MMM/yyyy HH:mm')}
${#calendars.arrayFormat(calArray, 'dd/MMM/yyyy HH:mm')}
${#calendars.listFormat(calList, 'dd/MMM/yyyy HH:mm')}
${#calendars.setFormat(calSet, 'dd/MMM/yyyy HH:mm')}

/*
 * 获取日历属性
 * 也同样适用于数组、列表或集合
 */
${#calendars.day(date)}                // 也可以是 arrayDay(...), listDay(...)之类的
${#calendars.month(date)}              // 也可以是 arrayMonth(...), listMonth(...)之类的
${#calendars.monthName(date)}          // 也可以是 arrayMonthName(...), listMonthName(...)之类的
${#calendars.monthNameShort(date)}     // 也可以是 arrayMonthNameShort(...), listMonthNameShort(...)之类的
${#calendars.year(date)}               // 也可以是 arrayYear(...), listYear(...)之类的
${#calendars.dayOfWeek(date)}          // 也可以是 arrayDayOfWeek(...), listDayOfWeek(...)之类的
${#calendars.dayOfWeekName(date)}      // 也可以是 arrayDayOfWeekName(...), listDayOfWeekName(...)之类的
${#calendars.dayOfWeekNameShort(date)} // 也可以是 arrayDayOfWeekNameShort(...), listDayOfWeekNameShort(...)之类的
${#calendars.hour(date)}               // 也可以是 arrayHour(...), listHour(...)之类的
${#calendars.minute(date)}             // 也可以是 arrayMinute(...), listMinute(...)之类的
${#calendars.second(date)}             // 也可以是 arraySecond(...), listSecond(...)之类的
${#calendars.millisecond(date)}        // 也可以是 arrayMillisecond(...), listMillisecond(...)之类的

/*
 * 从其组件创建日历(java.util.Calendar)对象
 */
${#calendars.create(year,month,day)}
${#calendars.create(year,month,day,hour,minute)}
${#calendars.create(year,month,day,hour,minute,second)}
${#calendars.create(year,month,day,hour,minute,second,millisecond)}

${#calendars.createForTimeZone(year,month,day,timeZone)}
${#calendars.createForTimeZone(year,month,day,hour,minute,timeZone)}
${#calendars.createForTimeZone(year,month,day,hour,minute,second,timeZone)}
${#calendars.createForTimeZone(year,month,day,hour,minute,second,millisecond,timeZone)}

/*
 * 为当前日期和时间创建一个日历(java.util.Calendar)对象
 */
${#calendars.createNow()}

${#calendars.createNowForTimeZone()}

/*
 * 为当前日期创建日历(java.util.Calendar)对象(时间设置为00:00)
 */
${#calendars.createToday()}

${#calendars.createTodayForTimeZone()} 
```
## Numbers工具类
```html
/*
 * ==========================
 * 格式化整数
 * ==========================
 */

/* 
 * 设置最小整数位数。
 * 也同样适用于数组、列表或集合
 */
${#numbers.formatInteger(num,3)}
${#numbers.arrayFormatInteger(numArray,3)}
${#numbers.listFormatInteger(numList,3)}
${#numbers.setFormatInteger(numSet,3)}


/* 
 * 设置最小整数位数和千位分隔符：
 * 'POINT'、'COMMA'、'WHITESPACE'、'NONE' 或 'DEFAULT'(根据本地化)。
 * 也同样适用于数组、列表或集合
 */
${#numbers.formatInteger(num,3,'POINT')}
${#numbers.arrayFormatInteger(numArray,3,'POINT')}
${#numbers.listFormatInteger(numList,3,'POINT')}
${#numbers.setFormatInteger(numSet,3,'POINT')}


/*
 * ==========================
 * 格式化十进制数
 * ==========================
 */

/*
 * 设置最小整数数字和(精确的)十进制数字。
 * 也同样适用于数组、列表或集合
 */
${#numbers.formatDecimal(num,3,2)}
${#numbers.arrayFormatDecimal(numArray,3,2)}
${#numbers.listFormatDecimal(numList,3,2)}
${#numbers.setFormatDecimal(numSet,3,2)}

/*
 * 设置最小整数数字和(精确的)小数位数, 以及小数分隔符。
 * 也同样适用于数组、列表或集合
 */
${#numbers.formatDecimal(num,3,2,'COMMA')}
${#numbers.arrayFormatDecimal(numArray,3,2,'COMMA')}
${#numbers.listFormatDecimal(numList,3,2,'COMMA')}
${#numbers.setFormatDecimal(numSet,3,2,'COMMA')}

/*
 * 设置最小整数数字和(精确的)十进制数字, 以及千位和十进制分隔符。
 * 也同样适用于数组、列表或集合
 */
${#numbers.formatDecimal(num,3,'POINT',2,'COMMA')}
${#numbers.arrayFormatDecimal(numArray,3,'POINT',2,'COMMA')}
${#numbers.listFormatDecimal(numList,3,'POINT',2,'COMMA')}
${#numbers.setFormatDecimal(numSet,3,'POINT',2,'COMMA')}

/*
 * ==========================
 * 实用方法
 * ==========================
 */

/*
 * 创建一个从x到y的整数序列(数组)
 */
${#numbers.sequence(from,to)}
${#numbers.sequence(from,to,step)} 
```
比如：
```html
<p th:utext="${#numbers.formatInteger(0.1024,3)}"></p>
<p th:utext="${#numbers.formatInteger(1.024,3)}"></p>
<p th:utext="${#numbers.formatInteger(10.24,3)}"></p>
<p th:utext="${#numbers.formatInteger(102.4,3)}"></p>
```
页面输出：

![mrbird_photo_20170927145905.png](img/mrbird_photo_20170927145905.png)

```html
<p th:utext="${#numbers.formatInteger(1.024,2,'POINT')}"></p>
<p th:utext="${#numbers.formatInteger(1024,3,'POINT')}"></p>
<p th:utext="${#numbers.formatInteger(1024,10,'POINT')}"></p>

<p th:utext="${#numbers.formatInteger(1.024,2,'COMMA')}"></p>
<p th:utext="${#numbers.formatInteger(1024,3,'COMMA')}"></p>
<p th:utext="${#numbers.formatInteger(1024,10,'COMMA')}"></p>

<p th:utext="${#numbers.formatInteger(1.024,2,'WHITESPACE')}"></p>
<p th:utext="${#numbers.formatInteger(1024,3,'WHITESPACE')}"></p>
<p th:utext="${#numbers.formatInteger(1024,10,'WHITESPACE')}"></p>
```
页面输出：

![mrbird_photo_20170927150746.png](img/mrbird_photo_20170927150746.png)

POINT指的是`.`，COMMA指的是`,`，WHITESPACE指的是空格。三个数位为一组，使用指定的分隔符分割。比如1.024并不是小数，而是使用了`.`分隔的1024。
## Booleans工具类
```html
/*
 * 评估条件, 类似于 th:if 标签
 * 也同样适用于数组、列表或集合
 */
${#bools.isTrue(obj)}
${#bools.arrayIsTrue(objArray)}
${#bools.listIsTrue(objList)}
${#bools.setIsTrue(objSet)}

/*
 * 用否定来评估条件
 * 也同样适用于数组、列表或集合
 */
${#bools.isFalse(cond)}
${#bools.arrayIsFalse(condArray)}
${#bools.listIsFalse(condList)}
${#bools.setIsFalse(condSet)}

/*
 * 评估条件并执行与操作
 * 接收数组、列表或集合作为参数
 */
${#bools.arrayAnd(condArray)}
${#bools.listAnd(condList)}
${#bools.setAnd(condSet)}

/*
 * 评估条件并执行或操作
 * 接收数组、列表或集合作为参数
 */
${#bools.arrayOr(condArray)}
${#bools.listOr(condList)}
${#bools.setOr(condSet)} 
```
## Arrays工具类
```html
/*
 * 转换为数组, 试图推断数组组件类。注意, 如果结果数组为空, 或者目标对象的元素不是全部相同的类, 则
 * 此方法将返回Object []。
 */
${#arrays.toArray(object)}

/*
 * 转换为指定组件类的数组。
 */
${#arrays.toStringArray(object)}
${#arrays.toIntegerArray(object)}
${#arrays.toLongArray(object)}
${#arrays.toDoubleArray(object)}
${#arrays.toFloatArray(object)}
${#arrays.toBooleanArray(object)}

/*
* 计算数组长度
 */
${#arrays.length(array)}

/*
 * 检查数组是否为空
 */
${#arrays.isEmpty(array)}

/*
 * 检查数组中是否包含元素或元素集合
 */
${#arrays.contains(array, element)}
${#arrays.containsAll(array, elements)} 
```
## Lists工具类
```html
/*
 * 转化为 list
 */
${#lists.toList(object)}

/*
 * 计算大小
 */
${#lists.size(list)}

/*
 */
${#lists.isEmpty(list)}

/*
 * 检查list中是否包含元素或元素集合
 */
${#lists.contains(list, element)}
${#lists.containsAll(list, elements)}

/*
 * 排序给定列表的副本。列表的成员必须
 * 实现comparable, 或者必须定义comparator。
 */
${#lists.sort(list)}
${#lists.sort(list, comparator)} 
```
## Sets工具类
```html
/*
 * 转化为 to set
 */
${#sets.toSet(object)}

/*
 * 计算大小
 */
${#sets.size(set)}

/*
 * 检查set是否为empty
 */
${#sets.isEmpty(set)}

/*
 * 检查set中是否包含元素或元素集合
 */
${#sets.contains(set, element)}
${#sets.containsAll(set, elements)} 
```
## Maps工具类
```html
/*
 * 计算大小
 */
${#maps.size(map)}

/*
 * 检查map是否为空
 */
${#maps.isEmpty(map)}

/*
 * 检查map中是否包含key/s或value/s
 */
${#maps.containsKey(map, key)}
${#maps.containsAllKeys(map, keys)}
${#maps.containsValue(map, value)}
${#maps.containsAllValues(map, value)} 
```
## 注意事项
值得注意的是，在使用工具类对某个表达式进行处理时候，你可能会写成：
```html
${#strings.isEmpty(${session.user.name})}。
```
实际上这种写法是错误的，将抛出异常。正确的写法为：
```html
${#strings.isEmpty(session.user.name)}。
```
