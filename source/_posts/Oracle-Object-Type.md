---
title: Oracle对象类型
date: 2017-11-06 14:39:28
tags: [DataBase,Oracle,Oracle 11g]
---
在Oracle数据库中，我们可以创建自定义的对象类型（Object Type）。数据库的对象类型和Java中的类相似，可以包含属性和方法（函数和存储过程）。对象类型包括对象类型规范（Object Type Specification）和对象类型主体（Object Type Body）。对象类型规范用于定义对象的属性和不包含实现的方法。对象类型主体用于实现对象类型规范中定义的方法。

<!--more-->
{% note danger %}
如果对象类型规范中没有定义方法，则可以不用定义对象类型主体。
{% endnote %}

## 创建简单的对象类型
简单的对象类型就是不包含方法的对象类型，语法如下：
```sql
create [or replace] type type_name as object (
   column_name data_type
   [,column_name data_type, ... ]
);
```
比如创建一个地址对象类型：
```sql
SQL> create or replace type address as object (
     province varchar2(10),
     city varchar2(10)
  ) not final;
  /

类型已创建。
```
`not final`关键字说明该对象类型可以被继承，接下来定义一个子类型addressDetail 继承自address 类型：
```sql
SQL> create or replace type addressdetail under address (
     street varchar2(20)
  );
  /

类型已创建。

SQL> desc addressdetail;
 addressdetail 扩展 SCOTT.ADDRESS
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 PROVINCE                                           VARCHAR2(10)
 CITY                                               VARCHAR2(10)
 STREET                                             VARCHAR2(20)
```
可见addressdetail 继承了address 的province 和city 属性。
## 创建带有方法的对象类型
可以在定义对象类型规范的时候包含函数或者存储过程，语法如下：
```sql
create [or replace] type type_name as object (
   column_name data_type,
   ...,
   [ map|order ]member function method_name(args_list) return return_type,
   [ map|order ]member procedure pro_name(aggs_list),
   ...
)
```
其中map 或order 关键字表示对结果进行排序。

比如创建一个学生信息对象类型student：
```sql
SQL> create or replace type student as object (
    name varchar2(20),
    sex char(2),
    birthday date,
    member function get_age return number
  );
  /

类型已创建。
```
函数`get_age()`用于返回学生年龄。

接下来创建student 对象主体：
```sql
SQL> create or replace type body student as
    member function get_age return number as
      var_age number;
    begin
      select floor(months_between(sysdate,birthday)/12) into var_age from dual;
      return var_age;
    end;
  end;
  /

类型主体已创建。
```
## 对象类型的应用
创建对象类型后，可以在数据库中使用对象类型。一般来说根据使用情况的不同，可以分为以下四种类型：列对象、对象表、可变数组与嵌套表。
### 列对象
列对象指的是数据表中的单个列的类型为对象类型。

创建员工信息表，其中address属性类型为上述定义的addressdetail类型：
```sql
SQL> create table empinfo (
     eName varchar2(20),
     eSex char(2),
     eAge int,
     eAddress addressdetail
  );

表已创建。
```
查看empinfo表的结构：
```sql
SQL> set desc depth 2
SQL> desc empinfo
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 ENAME                                              VARCHAR2(20)
 ESEX                                               CHAR(2)
 EAGE                                               NUMBER(38)
 EADDRESS                                           ADDRESSDETAIL
 ADDRESSDETAIL 扩展 SCOTT.ADDRESS
   PROVINCE                                         VARCHAR2(10)
   CITY                                             VARCHAR2(10)
   STREET                                           VARCHAR2(20)

```
在往包含列对象的数据表插入数据的时候，只能使用对象类型的构造方法：
```sql
SQL> insert into empinfo values('KangKang','M',25,addressdetail('福建','福州','鼓楼区'));

已创建 1 行。
```
查询student表信息的时候，如果以对象类型中的某个属性为查询条件时，必须使用表的别名的形式，比如：
```sql
SQL> select * from empinfo where eAddress.city='福州';
select * from empinfo where eAddress.city='福州'
                            *
第 1 行出现错误:
ORA-00904: "EADDRESS"."CITY": 标识符无效

SQL> select * from empinfo e where e.eAddress.city='福州';

ENAME                ES       EAGE EADDRESS(PROVINCE, CITY, STREET)
-------------------- -- ---------- ----------------------------------------
KangKang             M          25 ADDRESSDETAIL('福建', '福州', '鼓楼区')
```
更新包含两种方式：整体更新和只更列对象的某一列。

1.更新整体：
```sql
 SQL> update empinfo e set e.eAddress = addressdetail('福建','福州','台江区');

已更新 1 行。
```

2.更新列对象的某一列：
```sql
SQL> update empinfo e set e.eAddress.city='厦门' where e.eName='KangKang';

已更新 1 行。
```

### 对象表
如果需要使用对象类型来定义整个表，那么可以将这个表创建为对象表，对象表中的每一组数据都是一个对象。语法如下：
```sql
create table table_name of type_name;
```
创建一个上述定义的student 对象表：
```sql
SQL> create table studentinfo of student;

表已创建。

SQL> desc studentinfo
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 NAME                                               VARCHAR2(20)
 SEX                                                CHAR(2)
 BIRTHDAY                                           DATE
```
向对象表插入数据有两种方式：当普通表插入和使用构造方法插入：

1.当普通表插入：
```sql
SQL> insert into studentinfo values('KangKang','M',to_date('19920314','yyyyMMdd'));

已创建 1 行。
```

2.使用构造方法插入：
```sql
SQL> insert into studentinfo values(student('Jane','F',to_date('19930905','yyyyMMdd')));

已创建 1 行。
```

查询数据和查询普通表没有区别。因为student对象包含了`get_age()`函数，这里演示该函数的使用：
```sql
SQL> select s.name,s.birthday,s.get_age() age from studentinfo s;

NAME                 BIRTHDAY              AGE
-------------------- -------------- ----------
KangKang             14-3月 -92             25
Jane                 05-9月 -93             24
```
### 对象标识符和对象引用
对象表中的每个对象都具有一个唯一的对象标识符（Object Identifier，OID），可以存储在名为ref 的列中：
```sql
SQL> col ref for a60
SQL> set linesize 120
SQL> select s.name,ref(s) ref from studentinfo s;

NAME                 REF
-------------------- ------------------------------------------------------------
KangKang             00002802093C3B2A8DC8BD4ED991B4D78B90B44F1A293F80C3178D48158B
                     B3E126560AE7120100023F0000

Jane                 0000280209E237A8A6E6A844AE87A66B0F284E7231293F80C3178D48158B
                     B3E126560AE7120100023F0001
```
那个一大串的字符便是OID。

对象的引用使用ref 关键字来完成，引用的值实际上为对象表中的OID。比如创建一个成绩表，其中stu 属性为studentinfo 对象表中对象的引用：
```sql
SQL> create table stuScore (
     stu ref student,
     score number
  );

表已创建。
```
往该表插入信息：
```sql
SQL> insert into stuScore select ref(s),98 from studentinfo s where s.name='KangKang';

已创建 1 行。
SQL> insert into stuScore select ref(s),100 from studentinfo s where s.name='Jane';

已创建 1 行。
```
`ref(s)`可以获取对当前对象表中对象的OID。

查询：
```sql
SQL> col stu for a60
SQL> select stu,score from stuScore;

STU                                                               SCORE
------------------------------------------------------------ ----------
00002202083C3B2A8DC8BD4ED991B4D78B90B44F1A293F80C3178D48158B         98
B3E126560AE712

0000220208E237A8A6E6A844AE87A66B0F284E7231293F80C3178D48158B        100
B3E126560AE712
```
这里虽然关联了学生信息表studentinfo，但是默认查询出来stu 的值为OID，如果需要查看详细的学生信息，可以使用`deref()`函数：
```sql
SQL> select deref(stu) stu,score from stuScore;

STU(NAME, SEX, BIRTHDAY)                                          SCORE
------------------------------------------------------------ ----------
STUDENT('KangKang', 'M ', '14-3月 -92')                              98
STUDENT('Jane', 'F ', '05-9月 -93')                                 100
```
使用下面的方法也可以查询出关联信息：
```sql
SQL> select s.stu.name,s.stu.birthday,s.stu.get_age(),s.score from stuScore s;

STU.NAME             STU.BIRTHDAY   S.STU.GET_AGE()      SCORE
-------------------- -------------- --------------- ----------
KangKang             14-3月 -92                  25         98
Jane                 05-9月 -93                  24        100
```
### 可变数组
Oralce中的可变数组就是一个可以存储多个值的有最大长度的数组，数组的成员可以是任意类型。

创建一个长度为10的可变数组，存放数据类型是scoreType
```sql
SQL> create or replace type scoreType as object (
     subName varchar2(10),
     score int
  );
  /

类型已创建。
SQL> create or replace type arrScoreType as varray(10) of scoreType;
   /

类型已创建。
```
创建一个学生信息表：
```sql
SQL> create table stuInfo (
     stuId int primary key,
     score arrScoreType
  );

表已创建。
```
使用可变数组的构造函数往stuInfo 表插入数据：
```sql
SQL> insert into stuInfo values(1, 
    arrScoreType(scoreType('sql', 50), scoreType('C#', 80), scoreType('java', 90)));

已创建 1 行。

SQL> insert into stuInfo values(2, 
    arrScoreType(scoreType('sql', 60), scoreType('C#', 85), scoreType('java', 95), scoreType('html', 60)));

已创建 1 行。
```
直接查询stuInfo 表数据：
```sql
SQL> col score for a100
SQL> select stuid, score from stuInfo;

     STUID SCORE(SUBNAME, SCORE)
---------- ----------------------------------------------------------------------------------------------------
         1 ARRSCORETYPE(SCORETYPE('sql', 50), SCORETYPE('C#', 80), SCORETYPE('java', 90))
         2 ARRSCORETYPE(SCORETYPE('sql', 60), SCORETYPE('C#', 85), SCORETYPE('java', 95), SCORETYPE('html', 60))
```
查询结果是集合。如何才能查询出可变数组里的数据呢？思路是：用table函数把集合转化为表，然后再从这个表查询数据：
```sql
SQL> select s.stuid,t.* from stuinfo s,table(select score from stuinfo where stuid = s.stuid) t;

     STUID SUBNAME         SCORE
---------- ---------- ----------
         1 sql                50
         1 C#                 80
         1 java               90
         2 sql                60
         2 C#                 85
         2 java               95
         2 html               60

已选择7行。
```
{% note danger %}
table函数里面只能是一个可变数组或嵌套表。
{% endnote %}
更新值。更新stuinfo只能整个可变数组一起更新，不能只更新数组的某个元素：
```sql
update stuInfo set score = arrScoreType(scoreType('sql', 50), scoreType('C#', 80)) where stuId = 1;

已更新 1 行。
```
### 嵌套表
创建一个嵌套表类型，类型为scoreType：
```sql
SQL> create or replace type nestTableType is table of scoreType;
  /

类型已创建。
```
接着创建包含嵌套表的学生信息表：
```sql
SQL> create table stuInfo (
     stuid int,
     score nestTableType
  ) nested table score store as nestTable;

表已创建。
```
`nested table score store as nestTable`意思是：stuInfo这个表中的score这一列是嵌套表类型，嵌套表实际是存在nestTable这个表中。

插入值的方式和可变数组一样：
```sql
SQL> insert into stuInfo values(3, nestTableType(scoreType('sql', 70), scoreType('java', 93)));

已创建 1 行。
```
查询方式也和可变数组一样：
```sql
SQL> select s.stuid,t.* from stuinfo s,table(select score from stuinfo where stuid = s.stuid) t;

     STUID SUBNAME         SCORE
---------- ---------- ----------
         3 sql                70
         3 java               93
```
嵌套表更新和可变数组不一样，嵌套表更新可以只更新部分数据：
```sql
SQL> update table(select score from stuinfo where stuid = 3) t set t.score = 80 where t.subname = 'sql';

已更新 1 行。
```
可变数组和嵌套表的异同：

相同点：

1. 都是对象类型；

2. 都可以作为表中某列的数据类型（record和快表是不能作为列的数据类型的）。

不同点：

1. 可变数组本身就存放在原表中，而嵌套表存放在另外的表中；

2. 可变数组有大小限制，而嵌套表没有；

3. 可变数组更新时必须更新整个可变数组，而嵌套表更新时可以只更新嵌套表中的部分记录。

> 参考自[https://my.oschina.net/u/2273582/blog/493931](https://my.oschina.net/u/2273582/blog/493931)