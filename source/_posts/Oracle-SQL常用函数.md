---
title: Oracle SQL常用函数
date: 2016-09-06 10:35:24
tags: [Oracle,DataBase,Oracle 11g]
---
文中例子涉及到的表数据：
```sql
SQL> select empno,ename,job, hiredate,sal,deptno,comm from lzp.emp;
 
     EMPNO ENAME      JOB       HIREDATE         SAL     DEPTNO       COMM
---------- ---------- --------- -------------- ------- ---------- ----------
      7369 SMITH      CLERK     17-12月-80       800         20        null
      7499 ALLEN      SALESMAN  20-2月 -81      3100         30        300
      7521 WARD       SALESMAN  22-2月 -81      1250         30        500
      7566 JONES      MANAGER   02-4月 -81      2975         20        null
      7654 MARTIN     SALESMAN  28-9月 -81      8000         30        1400
      7698 BLAKE      MANAGER   01-5月 -81      2850         30        null
      7782 CLARK      MANAGER   09-6月 -81      2450         10        null
      7788 SCOTT      ANALYST   19-4月 -87      3000         20        null
      7839 KING       PRESIDENT 17-11月-81      5000         10        null
      7844 TURNER     SALESMAN  08-9月 -81      1500         30         0
      7876 ADAMS      CLERK     23-5月 -87      1100         20        null
      7900 JAMES      CLERK     03-12月-81       950         30        null
      7902 FORD       ANALYST   03-12月-81      3000         20        null
      7934 MILLER     CLERK     23-1月 -82      1300         10        null
 
已选择14行。
```
<!--more-->
## 字符函数
### 字符串截取
```sql
SQL> select substr('mrbird',3,6) from dual;
 
SUBS
----
bird 
```
### 查找子串位置
```sql
SQL> select instr('mrBird','Bird') from dual;
 
INSTR('MRBIRD','BIRD')
----------------------
                     3  
```
### 字符串连接
```sql
/* 1. || */
SQL> select 'mr'||'Bird'as result from dual;
 
RESULT
------
mrBird
/* 2.concat */
SQL> select concat('mr','Bird') as result from dual;
 
RESULT
------
mrBird
```
### 去除空格
```sql
SQL > 
SELECT
    LTRIM ('   mrBird') l,
    RTRIM ('mrBird   ') r,
    TRIM ('  mrBird  ') T
FROM
    dual;
 
L      R      T
------ ------ ------
mrBird mrBird mrBird
```
### 去除前缀和后缀
```sql
SQL > 
SELECT
    TRIM (LEADING 'M' FROM 'MMMMMmrBird') s1,
    TRIM (TRAILING 'D' FROM 'mrBirdDDDD') s2,
    TRIM ('M' FROM 'MMMmrBirdMMMM') s3
FROM
    dual; 
    
S1     S2     S3
------ ------ ------
mrBird mrBird mrBird  
```
### 计算字符串长度
```sql
SQL> select length('mrbird') from dual;
 
LENGTH('MRBIRD')
----------------
               6
```
### initcap（首字母变大写） ,lower（变小写）,upper（变大写）
```sql
SQL> select initcap('mrbird') s1,lower('MRBIRD') s2,upper('mrbird') s3 from dual;
 
S1     S2     S3
------ ------ ------
Mrbird mrbird MRBIRD
```
### 替换
```sql
SQL> select replace('mrXiaoniao','Xiaoniao','Bird') from dual;
 
REPLAC
------
mrBird
```
### decode[实现if ..then 逻辑] 注:第一个是表达式,最后一个是不满足任何一个条件的值
```sql
SQL> 
SELECT
    DECODE (
        deptno,
        10,
        '人力资源部',
        20,
        '软件开发部',
        30,
        '市场部',
        '其他神秘部门'
    ) deptName,
    deptno,
    ename
FROM
    lzp.emp
WHERE
    empno >= 7900;
 
DEPTNAME         DEPTNO ENAME
------------ ---------- ----------
市场部               30 JAMES
软件开发部           20 FORD
人力资源部           10 MILLER
```
### case[实现switch ..case 逻辑]
```sql
SQL> 
SELECT
    CASE
WHEN sal < 2000 THEN
    '被剥削的人'
WHEN sal < 3000 THEN
    '被压榨的人'
WHEN sal < 5000 THEN
    '普通的人'
ELSE
    '努力的人'
END meno,
 sal,
 ename
FROM
    lzp.emp
WHERE
    deptno = 30
ORDER BY
    sal ASC;
    
MENO              SAL ENAME
---------- ---------- ----------
被剥削的人        950 JAMES
被剥削的人       1250 WARD
被剥削的人       1500 TURNER
被压榨的人       2850 BLAKE
普通的人         3100 ALLEN
努力的人         8000 MARTIN
 
已选择6行。
```
### 十进制和ASCII互相转换
```sql
SQL> select ascii('A'),chr(65) from dual;
 
ASCII('A') C
---------- -
        65 A    
```
## 日期函数
TO_DATE格式(以时间: 2007-11-02 13:45:25 为例)
<table>
        <tr>
            <td colspan="4">
                
                    <strong>
                        Year
                    </strong>
                
            </td>
        </tr>
        <tr>
            <td>
                yy &nbsp; &nbsp;
                <br>
            </td>
            <td>
                two digits
            </td>
            <td>
                两位年
            </td>
            <td>
                显示值:07
            </td>
        </tr>
        <tr>
            <td>
                yyy
            </td>
            <td>
                three digits
            </td>
            <td>
                三位年
            </td>
            <td>
                显示值:007
            </td>
        </tr>
        <tr>
            <td>
                yyyy
            </td>
            <td>
                four digits
            </td>
            <td>
                四位年
            </td>
            <td>
                显示值:2007
            </td>
        </tr>
        <tr>
            <td colspan="4">
                
                    <strong>
                        Month
                    </strong>
                
            </td>
        </tr>
        <tr>
            <td>
                mm &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            </td>
            <td>
                number&nbsp;
            </td>
            <td>
                两位月&nbsp;
            </td>
            <td>
                显示值:11
            </td>
        </tr>
        <tr>
            <td>
                mon&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            </td>
            <td>
                abbreviated
            </td>
            <td>
                字符集表示
            </td>
            <td>
                显示值:11月,若是英文版,显示nov&nbsp;
            </td>
        </tr>
        <tr>
            <td>
                month
            </td>
            <td>
                spelled out
            </td>
            <td>
                字符集表示
            </td>
            <td>
                显示值:11月,若是英文版,显示november
            </td>
        </tr>
        <tr>
            <td colspan="4">
                
                    <strong>
                        Day
                    </strong>
                
            </td>
        </tr>
        <tr>
            <td>
                dd &nbsp; &nbsp; &nbsp;&nbsp;
            </td>
            <td>
                number
            </td>
            <td>
                当月第几天
            </td>
            <td>
                显示值:02
            </td>
        </tr>
        <tr>
            <td>
                ddd&nbsp;&nbsp;
            </td>
            <td>
                number
            </td>
            <td>
                当年第几天
            </td>
            <td>
                显示值:306
            </td>
        </tr>
        <tr>
            <td>
                dy &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            </td>
            <td>
                abbreviated &nbsp; &nbsp;
            </td>
            <td>
                当周第几天简写&nbsp;
            </td>
            <td>
                显示值:星期五,若是英文版,显示fri
            </td>
        </tr>
        <tr>
            <td>
                day
            </td>
            <td>
                spelled out
            </td>
            <td>
                当周第几天全写
            </td>
            <td>
                显示值:星期五,若是英文版,显示friday
            </td>
        </tr>
        <tr>
            <td>
                ddspth
            </td>
            <td>
                spelled out
            </td>
            <td>
                当月第几天英文
            </td>
            <td>
                显示值:second
            </td>
        </tr>
        <tr>
            <td colspan="4">
                
                    <strong>
                        Hour
                    </strong>
                
            </td>
        </tr>
        <tr>
            <td>
                hh &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
                &nbsp; &nbsp;&nbsp;
            </td>
            <td>
                two digits
            </td>
            <td>
                12小时进制&nbsp;
            </td>
            <td>
                显示值:01
            </td>
        </tr>
        <tr>
            <td>
                hh24
            </td>
            <td>
                two digits
            </td>
            <td>
                24小时进制
            </td>
            <td>
                显示值:13
            </td>
        </tr>
        <tr>
            <td colspan="4">
                
                    <strong>
                        Minute
                    </strong>
                    &nbsp;
                
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;mi/mm &nbsp; &nbsp;&nbsp;
            </td>
            <td>
                two digits
            </td>
            <td>
                60进制
            </td>
            <td>
                显示值:45
            </td>
        </tr>
        <tr>
            <td colspan="4">
                
                    <strong>
                        Second
                    </strong>
                
            </td>
        </tr>
        <tr>
            <td>
                ss &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            </td>
            <td>
                two digits
            </td>
            <td>
                60进制
            </td>
            <td>
                显示值:25
            </td>
        </tr>
        <tr>
            <td colspan="4">
                
                    <strong>
                        Others
                    </strong>
                
            </td>
        </tr>
        <tr>
            <td>
                Q &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;
            </td>
            <td>
                digit
            </td>
            <td>
                季度
            </td>
            <td>
                显示值:4
            </td>
        </tr>
        <tr>
            <td>
                WW
            </td>
            <td>
                digit
            </td>
            <td>
                当年第几周&nbsp;
            </td>
            <td>
                显示值:44
            </td>
        </tr>
        <tr>
            <td>
                W
            </td>
            <td>
                digit
            </td>
            <td>
                当月第几周
            </td>
            <td>
                显示值:1
            </td>
        </tr>
</table>

24小时格式下时间范围为： 0:00:00 - 23:59:59....     
 
12小时格式下时间范围为： 1:00:00 - 12:59:59 .... 
### 日期字符串相互转换
时间转字符串:

Year：
```sql
SQL>  
SELECT
    TO_CHAR (SYSDATE, 'yy') yy,
    TO_CHAR (SYSDATE, 'yyy') yyy,
    TO_CHAR (SYSDATE, 'yyyy') yyyy
FROM
    dual;
    
YY YYY YYYY
-- --- ----
16 016 2016
```
Month：
```sql
SQL>
SELECT
    TO_CHAR (SYSDATE, 'mm') mm,
    TO_CHAR (SYSDATE, 'mon') mon,
    TO_CHAR (SYSDATE, 'month') month
FROM
    dual;
 
MM MON      MONTH
-- -------- ------
09 9月      9月   
```
Day：
```sql
SQL>
SELECT
    TO_CHAR (SYSDATE, 'dd') dd,
    TO_CHAR (SYSDATE, 'ddd') ddd,
    TO_CHAR (SYSDATE, 'dy') dy,
    TO_CHAR (SYSDATE, 'day') DAY,
    TO_CHAR (SYSDATE, 'ddspth') ddspth
FROM
    dual;
    
DD DDD DY           DAY       DDSPTH
-- --- ------------ --------- --------------
06 250 tue       tuesday      sixth
```
Hour：
```sql
SQL>
SELECT
    TO_CHAR (SYSDATE, 'hh') hh,
    TO_CHAR (SYSDATE, 'hh24') hh24
FROM
    dual;
    
HH HH24
-- --
05 17
```
Minute,Second略

季度，周：
```sql
SQL>
SELECT
    TO_CHAR (SYSDATE, 'Q') Q,
    TO_CHAR (SYSDATE, 'WW') WW,
    TO_CHAR (SYSDATE, 'W') W
FROM
    dual;
    
Q WW W
- -- -
3 36 1
```
字符串转时间：
```sql
SQL> select to_date('2016-09-06','yyyy-MM-dd') time from dual;
 
TIME
--------------
06-9月 -16
```
### next_day
返回下个星期的日期,day为1-7或星期日-星期六,1表示星期日，也可以用英文表示星期。
```sql
SQL> select next_day(sysdate,'monday') time from dual;
 
TIME
--------------
12-9月 -16
```
### 两个日期相差天数
```sql
SQL> select floor(sysdate - to_date('20020405','yyyymmdd')) time from dual;
 
      TIME
----------
      5268 
```
### months_between
```sql
SQL> 
SELECT
    MONTHS_BETWEEN (
        TO_DATE ('2016-09-01', 'yyyy-MM-dd'),
        TO_DATE ('2016-01-01', 'yyyy-MM-dd')
    ) months
FROM
    dual;
    
    MONTHS
----------
         8
```
### round [舍入到最接近的日期]（day:舍入到最接近的星期日）
```sql
SQL> 
SELECT
    SYSDATE S1,
    ROUND (SYSDATE) S2,
    ROUND (SYSDATE, 'year') YEAR,
    ROUND (SYSDATE, 'month') MONTH,
    ROUND (SYSDATE, 'day') DAY
FROM
    dual;
    
S1             S2             YEAR           MONTH          DAY
-------------- -------------- -------------- -------------- --------------
07-9月 -16     07-9月 -16     01-1月 -17     01-9月 -16     04-9月 -16
```
### 计算时间差
注:oracle时间差是以天数为单位,所以换算成年月,日
```sql
SQL>
SELECT
    FLOOR (
        TO_NUMBER (
            SYSDATE - TO_DATE (
                '2007-11-02 15:55:03',
                'yyyy-mm-dd hh24:mi:ss'
            )
        ) / 365
    ) AS spanYears
FROM
    dual;
 
 SPANYEARS
----------
         8
SQL>
SELECT
    CEIL (
        MONTHS_BETWEEN (
            SYSDATE,
            TO_DATE (
                '2007-11-02 15:55:03',
                'yyyy-mm-dd hh24:mi:ss'
            )
        )
    ) AS spanMonths
FROM
    dual;
    
SPANMONTHS
----------
       107
SQL>
SELECT
    FLOOR (
        TO_NUMBER (
            SYSDATE - TO_DATE (
                '2007-11-02 15:55:03',
                'yyyy-mm-dd hh24:mi:ss'
            )
        )
    ) AS spanDays
FROM
    dual;
    
  SPANDAYS
----------
      3231
SQL>
SELECT
    FLOOR (
        TO_NUMBER (
            SYSDATE - TO_DATE (
                '2007-11-02 15:55:03',
                'yyyy-mm-dd hh24:mi:ss'
            )
        ) * 24
    ) AS spanHours
FROM
    dual;
    
 SPANHOURS
----------
     77562
/* 分秒略，以此类推 */
```
### 查找月的最后一天
```sql
SQL> select last_day(sysdate) from dual;
 
LAST_DAY(SYSDA
--------------
30-9月 -16
```
### ADD_MONTHS(date，i)
对给定的日期加上给定的月，查看每个员工入职20周年
```sql
SQL> select ename,add_months(hiredate,12*20) from lzp.emp;
 
ENAME      ADD_MONTHS(HIR
---------- --------------
SMITH      17-12月-00
ALLEN      20-2月 -01
WARD       22-2月 -01
JONES      02-4月 -01
MARTIN     28-9月 -01
BLAKE      01-5月 -01
CLARK      09-6月 -01
SCOTT      19-4月 -07
KING       17-11月-01
TURNER     08-9月 -01
ADAMS      23-5月 -07
JAMES      03-12月-01
FORD       03-12月-01
MILLER     23-1月 -02

已选择14行。
```
### EXTRACT
单独获取指定时间的年或月或日
```sql
SQL> select extract(year from sysdate) from dual;
 
EXTRACT(YEARFROMSYSDATE)
------------------------
                    2016
```
## 数字函数
### 取整函数（ceil 向上取整,floor 向下取整）
```sql
SQL> select ceil(66.6) N1,floor(66.6) N2 from dual;
 
        N1         N2
---------- ----------
        67         66
```
### 取幂(power) 和 求平方根(sqrt)
```sql
SQL>  select power(3,2) N1,sqrt(9) N2 from dual;
 
        N1         N2
---------- ----------
         9          3
```
### 求余
```sql
SQL>  select mod(9,5) from dual;
 
  MOD(9,5)
----------
         4
```
### 返回固定小数位数 （round:四舍五入，trunc:直接截断）
```sql
SQL> select round(66.667,2) N1,trunc(66.667,2) N2 from dual;
 
        N1         N2
---------- ----------
     66.67      66.66
```
### 返回值的符号（正数返回为1,负数为-1）
```sql
SQL> select sign(-32),sign(293) from dual;
 
 SIGN(-32)  SIGN(293)
---------- ----------
        -1          1
```
### LEAST、GREATEST
两个函数都可以有多个参数值，但参数类型必须一致，返回结果是参数列表中最大或最小的值。 在比较之前，在参数列表中第二个以后的参数会被隐含的转换为第一个参数的数据类型，所以如果可以转换，则继续比较，如果不能转换将会报错。
```sql
SQL> select least(1,2,3),greatest(sysdate,'01-10月-16') from dual;
 
LEAST(1,2,3) GREATEST(SYSDA
------------ --------------
           1 01-10月-16
```
## 其他函数
### vsize: 返回表达式所需的字节数
```sql
SQL> select vsize('mrBird123') from dual;
 
VSIZE('MRBIRD123')
------------------
                 9
```
### nvl(ex1,ex2):
ex1值为空则返回ex2,否则返回该值本身ex1（常用） 例：如果雇员没有佣金，将显示0，否则显示佣金 
```sql
SQL> select comm,nvl(comm,0) from lzp.emp;
 
      COMM NVL(COMM,0)
---------- -----------
                     0
       300         300
       500         500
                     0
      1400        1400
                     0
                     0
                     0
                     0
         0           0
                     0
                     0
                     0
                     0
 
已选择14行。
```
### nullif(ex1,ex2): 
```sql
SQL> select nullif(88,88) from dual;
 
NULLIF(88,88)
-------------
 
SQL> select nullif(88,123) from dual;
 
NULLIF(88,123)
--------------
            88
SQL> select nullif('mrBird','mrBird') from dual;
 
NULLIF
------
```
### nvl2(ex1,ex2,ex3) :
如果ex1不为空，显示ex2,否则显示ex3

> 注：部分内容来自[脚本之家](http://www.jb51.net/)