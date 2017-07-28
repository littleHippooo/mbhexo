---
title: Oracle basis
date: 2016-03-01 10:44:10
tags: Oracle
password: 465af3ec97365f9e17081f9ea40590e27472f946
---
## Oracle数据类型
**NUMBER**

NUMBER表示数字类型，经常被定义成NUMBER（P，S）形式，其中：P表示数字的总位数；S表示小数点后面的位数。

如：`Sal  NUMBER(6,2)`：表示Sal列中的数据，整数位最大为4位，小数位最大位数是2位，也就是最大取值：9999.99。P不写为*号的时候代表默认38。
<!--more-->

**CHAR**

CHAR表示固定长度的字符类型，经常被定义成CHAR（N）形式， N表示占用的字节数，N的最大取值是2000。

例如在表Emp中的Ename列的定义如下：`Ename  CHAR(20)`：表示Ename列中最多可存储20个字节的字符串，并且占用的空间是固定的20个字节。

**VARCHAR2**

VARCHAR2表示变长的字符类型，定义格式是VARCHAR2（N）， N表示最多可占用的字节数，最大长度是4000字节。

例如在表Emp中的JOB列的定义如下： `JOB VARCHAR2(100)`：表示JOB列中最多可存储长度为100个字节的字符串。根据其中保存的数据长度，占用的空间是变化的，最大占用空间为100个字节。

**CHAR和VARCHAR2的区别**

1. CHAR和VARCHAR2类型

 CHAR和VARCHAR2类型都是用来表示字符串数据类型，用来在表中存放字符串信息， 比如姓名、职业、地址等。
 
 CHAR存放定长字符，如果数据存不满定长长度，则补齐空格；

 VARCHAR2存放变长字符，实际数据有多少长度则占用多少。
 
 如保存字符串'HELLOWORLD'，共10个英文字母：

   CHAR(100)： 10个字母，补齐90个空格，实际占用100个字节。

   VARCHAR2(100) ：10个字母，实际占用10个字节。
    
 CHAR类型浪费空间换取查询时间的缩短，VARCHAR2节省空间查询时间较CHAR类型要长。字符串按照自然顺序排序。	

2. CHAR和VARCHAR2的存储编码

 字符串在数据库中存储的默认单位是字节，也可显式指定为字符。如：
 
 `CHAR(10)`，等价于 `CHAR(10 BYTE)`。
 
 如果指定单位为字符：`CHAR(10 CHAR)`，20个字节。
 
 `VARCHAR2(10)`， 等价于`VARCHAR2（10 BYTE）`。
 
 指定单位为字符：`VARCHAR2(10 CHAR)`，20个字节。

3. CHAR和VARCHAR2的最大长度

 CHAR类型的最大取值为2000字节，也就是定义为`CHAR（2000）`。其中最多保存2000个英文字符，1000个汉字（GBK）。
 
 VARCHAR2最大取值为4000字节，也就是`VARCHAR2（4000）`，最多保存4000个英文字符，2000个汉字（GBK）。
 
 CHAR如果不指定长度，默认为1个字节， VARCHAR2必须指定长度。

**DATE**

DATE用于定义日期时间的数据，长度是7个字节，默认格式是：DD-MON-RR， 例如：“11-APR-71”。如果是中文环境，是“11-4月-71”这种形式。

例如在表Emp中的Hiredate列的定义如下：`Hiredate DATE`：表示Hiredate列中存放的是日期数据。

**LONG和CLOB类型**

LONG类型可以认为是VARCHAR2的加长版，用来存储变长字符串，最多达2GB的字符串数据，但是LONG类型有诸多限制，所以不建议使用：

- 每个表只能有一个LONG类型列；
 
- 不能作为主键；
 
- 不能建立索引；
 
- 不能出现在查询条件中等

CLOB用来存储定长或变长字符串，最多达4GB的字符串数据，ORACLE建议开发中使用CLOB替代LONG类型。

## SQL分类
SQL（Structured Query Language）是结构化查询语言的缩写。可分为：

**数据定义语言（DDL  Data Definition Language）：**用于建立，修改和删除数据库对象。包含：

- CREATE：创建表或其他对象的结构。

- ALTER: 修改表或其他对象的结构。

- DROP：删除表或其他对象的结构。

- TRUNCATE：删除表数据，保留表结构。

CREATE语句创建表格：
```sql
SQL> create table employee (
  2  id NUMBER(10) not null,
  3  name VARCHAR2(20),
  4  gender CHAR(1),
  5  birth DATE,
  6  salary NUMBER(6,2),
  7  job VARCHAR2(30),
  8  deptno NUMBER(2)
  9  );

表已创建。

SQL> desc employee;
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 ID                                        NOT NULL NUMBER(10)
 NAME                                               VARCHAR2(20)
 GENDER                                             CHAR(1)
 BIRTH                                              DATE
 SALARY                                             NUMBER(6,2)
 JOB                                                VARCHAR2(30)
 DEPTNO                                             NUMBER(2)
 ```
修改表名：
```sql
SQL> RENAME employee TO employee1;

表已重命名。
```
增加列：

在建表之后，要给表增加列可以使用`ALTER TABLE`的`ADD`子句实现。如在employee1表最后面增加一列：
```sql
SQL> ALTER TABLE employee1 ADD(hiredate DATE DEFAULT SYSDATE);

表已更改。

SQL> desc employee1
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 ID                                        NOT NULL NUMBER(10)
 NAME                                               VARCHAR2(20)
 GENDER                                             CHAR(1)
 BIRTH                                              DATE
 SALARY                                             NUMBER(6,2)
 JOB                                                VARCHAR2(30)
 DEPTNO                                             NUMBER(2)
 HIREDATE                                           DATE
 ```
删除列：

删除employee1表中的hiredate列：
```sql
SQL> ALTER TABLE employee1 DROP(hiredate);

表已更改。
```
删除所有表数据，保留结构：
```sql
SQL> truncate TABLE employee1;

表被截断。
```
`TRUNCATE TABLE`在功能上与不带`WHERE`子句的`DELETE`语句相同：二者均删除表中的全部行。但`TRUNCATE TABLE`比`DELETE`速度快，且使用的系统和事务日志资源少。`DELETE`语句每次删除一行，并在事务日志中为所删除的每行记录一项。

修改列：

建表之后，可以改变表中列的数据类型、长度和默认值，注意这种修改仅对以后插入的数据有效，另外如果表中已经有数据的情况下，把长度由大改小，有可能不成功，比如原来的类型是`VARCHAR2(100)`，其中已经存放了100个字节长度的数据，如果要改为`VARCHAR2(80)`，则不会修改成功。

修改表employee1的列job，并增加默认值的设置：
```sql
SQL> ALTER TABLE employee1 MODIFY(job VARCHAR2(40) DEFAULT 'manager');

表已更改。
```
删除表：
```sql
SQL> drop table employee1;

表已删除。

SQL> desc employee1;
ERROR:
ORA-04043: 对象 employee1 不存在
```
**数据操纵语言（DML  Data Manipulation Language）：**用于改变数据表中的数据，和事务相关，执行完后需要通过事务控制语句提交后才真正的将改变应用到数据库中。

包括：

- INSERT：将数据插入到数据表中。

- UPDATE：更新数据表中已存在的数据。

- DELETE：删除数据表中的数据。

**事务控制语言（TCL  Transaction Control Language）：**用来维护数据一致性的语句。

包括：

- COMMIT：提交，确认已经进行的数据改变。 

- ROLLBACK：回滚，取消已经进行的数据改变。

- SAVEPOINT：保存点，使当前的事务可以回退到指定的保存点，便于取消部分改变。

**数据查询语言（DQL  Data Query Language）：**用来查询需要的数据。SELECT语句。

**数据控制语言（DCL  Data Control Language）：**用于执行权限的授予与回收工作。

包括：

- GRANT：授予，用于给用户或角色授予权限。

- REVOKE：用于收回用户或角色的权限。

- CREATE USER：创建用户。

## SQL基础查询
**FROM子句**

SELECT用于指定要查询的列，FROM指定要从哪个表中查询。如果要查询所有列，可以在SELECT后面使用*号，如果只查询特定的列，可以直接在SELECT后面指定列名，列名之间用逗号隔开。

**列的别名**

当我们查询的内容不是一个单纯的列，可能是一个函数，或者表达式，那么在结果集中该字段对应的字段名就是这个函数或者表达式。这样不够清晰，为此我们可以单独指定别名，这样在结果集中该字段的名字就是这个别名。若想显示自己想要的内容，使用双引号。其中"AS"可以省略。
```sql
SQL> SELECT ename,sal*12 as "年薪",job from emp;

ENAME            年薪 JOB
---------- ---------- ---------
SMITH            9600 CLERK
ALLEN           19200 SALESMAN
WARD            15000 SALESMAN
JONES           35700 MANAGER
MARTIN          15000 SALESMAN
BLAKE           34200 MANAGER
CLARK           29400 MANAGER
SCOTT           36000 ANALYST
KING            60000 PRESIDENT
TURNER          18000 SALESMAN
ADAMS           13200 CLERK
```
**AND,OR**

与和或。AND优先级高于OR，可以用括号提高优先级。
```sql
SQL> select ename,sal,job from emp where sal > 1000 or job = 'CLERK';

ENAME             SAL JOB
---------- ---------- ---------
SMITH             800 CLERK
ALLEN            1600 SALESMAN
WARD             1250 SALESMAN
JONES            2975 MANAGER
MARTIN           1250 SALESMAN
BLAKE            2850 MANAGER
CLARK            2450 MANAGER
SCOTT            3000 ANALYST
KING             5000 PRESIDENT
TURNER           1500 SALESMAN
ADAMS            1100 CLERK
JAMES             950 CLERK
FORD             3000 ANALYST
MILLER           1300 CLERK
```
**LIKE**

用于模糊查询，支持两个通配符，%：表示0到多个字符，_表示一个字符。
```sql
SQL> select ename,sal,job from emp where ename like '_L%';

ENAME             SAL JOB
---------- ---------- ---------
ALLEN            1600 SALESMAN
BLAKE            2850 MANAGER
CLARK            2450 MANAGER
```
**IN,NOT IN**

在WHERE子句中可以用比较操作符`IN(list)`来取出符合列表范围中的数据。其中的参数list表示值列表，当列或表达式匹配于列表中的任何一个值时，条件为TRUE，该条记录则被显示出来。IN也可以理解为一个范围比较操作符，只不过这个范围是一个指定的值列表，`NOT IN(list)`取出不符合此列表中的数据记录。
```sql
SQL> select ename,sal,job from emp where job in('CLERK','SALESMAN');

ENAME             SAL JOB
---------- ---------- ---------
SMITH             800 CLERK
ALLEN            1600 SALESMAN
WARD             1250 SALESMAN
MARTIN           1250 SALESMAN
TURNER           1500 SALESMAN
ADAMS            1100 CLERK
JAMES             950 CLERK
MILLER           1300 CLERK
```
**BETWEEN AND**
```sql
SQL> select ename,sal,job from emp where sal between 1500 and 3000;

ENAME             SAL JOB
---------- ---------- ---------
ALLEN            1600 SALESMAN
JONES            2975 MANAGER
BLAKE            2850 MANAGER
CLARK            2450 MANAGER
SCOTT            3000 ANALYST
TURNER           1500 SALESMAN
FORD             3000 ANALYST
```
**ANY,ALL**

当我们需要判断内容>，>=，<，<=一个列表中的多个值时，需要结合ANY或ALL来使用。ANY(LIST)：大于列表中其中之一即可，即大于最小的；ALL(LIST)：大于列表中所有，即大于最大的。

列表中的内容通常不是固定值，而是一个查询结果集，所以常在子查询中，与IN道理一样。如查询谁的薪水比FORD高？如果有多个同名，比任何一个叫FORD的人高就行：
```sql
SQL> select ename from emp where sal > any(select sal from emp where ename = 'FORD');

ENAME
----------
KING
```
**查询条件中使用表达式和函数**

当查询需要对选出的字段进行进一步计算，可以在数字列上使用算术表达式(+、-、*、/)。表达式符合四则运算的默认优先级，如果要改变优先级可以使用括号。算术运算主要是针对数字类型的数据，对日期类型的数据可以做加减操作，表示在一个日期值上加或减一个天数。

{% note danger %}查询条件中不能使用聚合函数！{% endnote %}

查询条件中使用算数表达式，查询年薪大于5w元的员工记录：
```sql
SQL> select ename,sal,job from emp where sal*12 > 50000;

ENAME             SAL JOB
---------- ---------- ---------
KING             5000 PRESIDENT
```
**ORDER BY**

使用ORDER BY字句：用于对结果即按照指定的字段的值升序或者降序进行排序。ASC：升序，默认也是ASC；DESC：降序。

查看工资排名：
```sql
SQL> select ename,sal,job from emp order by sal;

ENAME             SAL JOB
---------- ---------- ---------
SMITH             800 CLERK
JAMES             950 CLERK
ADAMS            1100 CLERK
WARD             1250 SALESMAN
MARTIN           1250 SALESMAN
MILLER           1300 CLERK
TURNER           1500 SALESMAN
ALLEN            1600 SALESMAN
CLARK            2450 MANAGER
BLAKE            2850 MANAGER
JONES            2975 MANAGER
SCOTT            3000 ANALYST
FORD             3000 ANALYST
KING             5000 PRESIDENT
```
若排序的字段中有NULL值，NULL被视为最大值。当多个字段进行排序时， 每个字段可以分别指定升降序，并且排序顺序按照第一个字段优先排序，只有第一个字段值相同时才按照第二个字段排序，以此类推。
```sql
SQL> select ename,sal,job,deptno from emp
  2  order by deptno desc,sal desc;

ENAME             SAL JOB           DEPTNO
---------- ---------- --------- ----------
BLAKE            2850 MANAGER           30
ALLEN            1600 SALESMAN          30
TURNER           1500 SALESMAN          30
WARD             1250 SALESMAN          30
MARTIN           1250 SALESMAN          30
JAMES             950 CLERK             30
FORD             3000 ANALYST           20
SCOTT            3000 ANALYST           20
JONES            2975 MANAGER           20
ADAMS            1100 CLERK             20
SMITH             800 CLERK             20
KING             5000 PRESIDENT         10
CLARK            2450 MANAGER           10
MILLER           1300 CLERK             10
```
**聚合函数（分组函数，组函数）**

查询时需要做一些数据统计，比如：查询职员表中各部门职员的平均薪水，各部门的员工人数。当需要统计的数据并不能在职员表里直观列出，而是需要根据现有的数据计算得到结果，这种功能可以使用聚合函数来实现，即：将表的全部数据划分为几组数据，每组数据统计出一个结果。

因为是多行数据参与运算返回一行结果，也称作分组函数、多行函数、集合函数。用到的关键字：

- GOURP BY 按什么分组。

- HAVING 进一步限制分组结果。

聚合函数是忽略NULL值的。

1、MAX和MIN

用来取得列或表达式的最大、最小值，可以用来统计任何数据类型，包括数字、字符和日期。计算最早和最晚的入职时间，参数是日期：
```sql
SQL> select max(hiredate),min(hiredate) from emp;

MAX(HIREDATE)  MIN(HIREDATE)
-------------- --------------
23-5月 -87     17-12月-80
```
2、AVG和SUM

AVG和SUM函数用来统计列或表达式的平均值和和值，这两个函数只能操作数字类型，并忽略NULL值。统计所有员工的总工资和平均工资：
```sql
SQL> select avg(sal) avg_sal,sum(sal) sum_sal from emp;

   AVG_SAL    SUM_SAL
---------- ----------
2073.21429      29025
```
3、COUNT

COUNT函数用来计算表中的记录条数，同样忽略NULL值。例如获取职员表中一共有多少名职员记录：
```sql
SQL> select count(1) from emp;

  COUNT(1)
----------
        14
```
**分组**

**1、GROUP BY子句**

其是为聚合函数服务的，可以在统计数据时细化分组。他允许将某个字段值一样的记录看成一组，然后进行统计。而不是将整张表所有记录看成一组，那么每组可以出一个统计结果。

查看每个部门的最高工资，最低工资：
```sql
SQL> select deptno "部门", max(sal) "最高工资",min(sal) "最低工资"
  2  from emp group by deptno;

      部门   最高工资   最低工资
---------- ---------- ----------
        30       2850        950
        20       3000        800
        10       5000       1300
```
SQL语法要求：除了聚合函数，其他不在GROUP BY子句中的列名，不能出现在SELECT语句后面。

GROUP BY进行分组的字段应在整张表中有重复数据，否则分组毛有意义GROUP BY子句后面允许指定多个字段，那么是按照这些字段值的组合相同的记录看作一组。

查看每个部门每种职位的平均工资以及工资总和：
```sql
SQL> select deptno,job,avg(sal),sum(sal)
  2  from emp group by deptno,job;

    DEPTNO JOB         AVG(SAL)   SUM(SAL)
---------- --------- ---------- ----------
        20 CLERK            950       1900
        30 SALESMAN        1400       5600
        20 MANAGER         2975       2975
        30 CLERK            950        950
        10 PRESIDENT       5000       5000
        30 MANAGER         2850       2850
        10 CLERK           1300       1300
        10 MANAGER         2450       2450
        20 ANALYST         3000       6000
```
**2、HAVING字句**

HAVING 也是用于添加过滤条件的，它的过滤实际是在统计结果之后进行的，所以HAVING是为统计结果进行过滤使用的，其不能独立出现，必须跟在GROUP BY子句后面。

查看平均工资大于2000的部门：
```sql
SQL> select deptno,avg(sal) from emp
  2  group by deptno having avg(sal) > 2000;

    DEPTNO   AVG(SAL)
---------- ----------
        20       2175
        10 2916.66667
```
HAVING子句解决了WHERE子句后面不能跟聚合函数的问题：
```sql
SQL> select deptno,avg(sal) from emp where avg(sal) > 2000
  2  group by deptno;
select deptno,avg(sal) from emp where avg(sal) > 2000
                                      *
第 1 行出现错误:
ORA-00934: 此处不允许使用分组函数
```
该语句会报错，原因在于我们的过滤条件是平均工资高于2000，而WHERE的过滤时机在于：第一次从表中查询数据时进行过滤，只有满足WHERE条件的记录才会被查询出来。而判断平均工资高于2000，首先平均工资统计是建立在数据查询出来的基础上的，所以这时WHERE已经完成了过滤。改使用HVING 子句就可解决。

**查询语句的执行顺序**

当一条查询语句中包含所有的子句，执行顺序依下列子句次序：

- FROM 子句：执行顺序为从后往前、从右到左。数据量较少的表尽量放在后面。

- WHERE子句：执行顺序为自下而上、从右到左。将能过滤掉最大数量记录的条件写在WHERE 子句的最右。

- GROUP BY：执行顺序从左往右分组，最好在GROUP BY前使用WHERE将不需要的记录在GROUP BY之前过滤掉。

- HAVING 子句：消耗资源。尽量避免使用，HAVING 会在检索出所有记录之后才对结果集进行过滤，需要排序等操作。

- SELECT子句：少用\*号，尽量取字段名称。ORACLE 在解析的过程中，通过查询数据字典将*号依次转换成所有的列名，消耗时间。

- ORDER BY子句：执行顺序为从左到右排序，消耗资源。

##  SQL关联查询
**关联查询**

当从多张表查询数据时，我们会建立关联关系然后在张表中进行查询工作，重点就是如何指定这些表中数据的对应关系(关联关系)，N张表查询时至少要有N-1个连接条件。

查询每个员工的名字，工资，以及部门名称和所在地：
```sql
SQL> select e.ename,e.deptno,d.dname,d.loc
  2  from emp e join dept d
  3  on(d.deptno = e.deptno);

ENAME          DEPTNO DNAME          LOC
---------- ---------- -------------- -------------
CLARK              10 ACCOUNTING     NEW YORK
KING               10 ACCOUNTING     NEW YORK
MILLER             10 ACCOUNTING     NEW YORK
JONES              20 RESEARCH       DALLAS
FORD               20 RESEARCH       DALLAS
ADAMS              20 RESEARCH       DALLAS
SMITH              20 RESEARCH       DALLAS
SCOTT              20 RESEARCH       DALLAS
WARD               30 SALES          CHICAGO
TURNER             30 SALES          CHICAGO
ALLEN              30 SALES          CHICAGO
JAMES              30 SALES          CHICAGO
BLAKE              30 SALES          CHICAGO
MARTIN             30 SALES          CHICAGO
```
或者：
```sql
SQL> select e.ename,e.deptno,d.dname,d.loc
  2  from emp e,dept d
  3  where e.deptno = d.deptno;
```
**内连接**

内连接只返回两个关联表中所有满足连接条件的记录。

**外连接**

内连接返回两个表中所有满足连接条件的数据记录，在有些情况下，需要返回那些不满足连接条件的记录，需要使用外连接，即不仅返回满足连接条件的记录，还将返回不满足连接条件的记录。

将员工SOCTT的部门号改为50：
```sql
SQL> update emp set deptno = 50
  2  where ename = 'SCOTT';
```
执行下面语句：
```sql
SQL> select e.ename,d.dname
  2  from emp e join dept d
  3  on(e.deptno = d.deptno);

ENAME      DNAME
---------- --------------
CLARK      ACCOUNTING
KING       ACCOUNTING
MILLER     ACCOUNTING
JONES      RESEARCH
FORD       RESEARCH
ADAMS      RESEARCH
SMITH      RESEARCH
WARD       SALES
TURNER     SALES
ALLEN      SALES
JAMES      SALES
BLAKE      SALES
MARTIN     SALES

已选择13行。
```
会发现SCOTT员工没有被查询出来，原因是其不满足连接条件。

外连接允许我们在关联查询的时候，以一张表作为驱动表(数据要显示全)。该表的数据全部会体现再结果集中，但是来自关联表中的字段由于不满足连接条件没有对应的记录，所以全部取NULL。外连接主要解决的问题就是显示再关联查询中不满足连接条件的记录。

外连接分为：左外连接，右外连接，全外连接。

使用左外连接查询员工信息：
```sql
SQL> select e.ename,d.dname
  2  from emp e left outer join dept d
  3  on(e.deptno = d.deptno);

ENAME      DNAME
---------- --------------
MILLER     ACCOUNTING
KING       ACCOUNTING
CLARK      ACCOUNTING
FORD       RESEARCH
ADAMS      RESEARCH
JONES      RESEARCH
SMITH      RESEARCH
JAMES      SALES
TURNER     SALES
BLAKE      SALES
MARTIN     SALES
WARD       SALES
ALLEN      SALES
SCOTT

已选择14行。
```
可以看出，虽然SCOTT不满足连接条件，但也出现在查询结果中了。

**自连接**

当前表的一条记录对应当前表的多条记录，自连接的设计是为了解决同类型数据间又存在上下级关系的树状结构的保存与关联。

查看员工的名字以及他领导的名字：
```sql
SQL> select e.ename "员工",m.ename "领导"
  2  from emp e,emp m
  3  where e.mgr = m.empno;

员工       领导
---------- ----------
FORD       JONES
SCOTT      JONES
TURNER     BLAKE
ALLEN      BLAKE
WARD       BLAKE
JAMES      BLAKE
MARTIN     BLAKE
MILLER     CLARK
ADAMS      SCOTT
BLAKE      KING
JONES      KING
CLARK      KING
SMITH      FORD
```
若想将没有领导的人也列出来，可以将代码改为：
```sql
SQL> select e.ename "员工",m.ename "领导"
  2  from emp e,emp m
  3  where e.mgr = m.empno(+);

员工       领导
---------- ----------
FORD       JONES
SCOTT      JONES
JAMES      BLAKE
TURNER     BLAKE
MARTIN     BLAKE
WARD       BLAKE
ALLEN      BLAKE
MILLER     CLARK
ADAMS      SCOTT
CLARK      KING
BLAKE      KING
JONES      KING
SMITH      FORD
KING

已选择14行。
```
等同于：
```sql
SQL> select e.ename "员工",m.ename "领导"
  2  from emp e left join emp m
  3  on(e.mgr = m.empno);

员工       领导
---------- ----------
FORD       JONES
SCOTT      JONES
JAMES      BLAKE
TURNER     BLAKE
MARTIN     BLAKE
WARD       BLAKE
ALLEN      BLAKE
MILLER     CLARK
ADAMS      SCOTT
CLARK      KING
BLAKE      KING
JONES      KING
SMITH      FORD
KING

已选择14行。
```

