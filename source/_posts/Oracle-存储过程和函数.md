---
title: Oracle存储过程与函数
date: 2017-11-03 09:14:00
tags: [DataBase,Oracle 11g,Oracle]
---
## 存储过程
存储过程是一种命名的PL/SQL程序块，它既可以没有参数，也可以有若干个输入、输出参数，甚至可以有多个既作输入又作输出的参数，但它通常没有返回值。存储过程被保存在数据库中，它不可以被SQL 语句直接执行或调用，只能通过EXECUT 命令执行或在PL/SQL 程序块内部被调用。由于存储过程是已经编译好的代码，所以其被调用或引用时，执行效率非常高。
<!--more-->
###  创建存储过程
创建存储过程的语法如下：
```sql
create [or replace] procedure pro_name [(parameter1[,parameter2]…)] is|as
begin
   plsql_sentences;
[exception]
   [dowith _ sentences;]
end [pro_name];
```
- `pro_name`：存储过程的名称，如果数据库中已经存在了此名称，则可以指定“or replace”关键字，这样新的存储过程将覆盖掉原来的存储过程。

- `parameter1`：存储过程的参数，若是输入参数，则需要在其后指定“in”关键字；若是输出参数，则需要在其后面指定“out”关键字。在in或out关键字的后面是参数的数据类型，但不能指定该类型的长度。

创建一个存储过程，该存储过程实现向dept表中插入一条记录：
```sql
SQL> create or replace procedure save_dept is
  begin
    insert into dept values(50,'开发一部','福州');
    commit;
    dbms_output.put_line('插入数据成功！');
  end;
  /

过程已创建。
```
创建过程中如果出现错误，可以使用`show err`指令查看。

若要执行这个存储过程，则需要在SQL*Plus 环境中使用EXECUTE命令来执行该存储过程，或者在PL/SQL 程序块中调用该存储过程。
```sql
SQL> set serveroutput on
SQL> execute save_dept
插入数据成功！

PL/SQL 过程已成功完成。
```
或者在 PL/SQL 块中调用存储过程：
```sql
SQL> delete from dept where deptno=50;

已删除 1 行。

SQL> set serveroutput on
SQL> begin
    save_dept;
  end;
  /
插入数据成功！

PL/SQL 过程已成功完成。
```
### 存储过程的参数
存储过程可以接受多个参数，参数模式包括IN、OUT 和IN OUT 3 种：

**1.IN模式参数**

这是一种输入类型的参数，参数值由调用方传入，并且只能被存储过程读取，是默认的参数模式。

比如创建一个存储过程，并定义 3 个in 模式的变量，然后将这3 个变量的值插入到dept表中：
```sql
SQL> create or replace procedure save_dept(
    deptno in number,
    dname in varchar2,
    loc in varchar2) is
  begin
    insert into dept values(deptno,dname,loc);
    commit;
  end;
  /

过程已创建。
```
调用该存储过程时传参有以下几种方式：

1. 指定名称传递：
```sql
pro_name(parameter1=>value1[,parameter2=>value2]…)
```
 使用这种方式调用上面定义的存储过程：
 ```sql
SQL> begin
    save_dept(dname=>'开发二部',loc=>'福州',deptno=>60);
  end;
  /

PL/SQL 过程已成功完成。
 ```
 使用“指定名称”的方式传递参数值与参数的定义顺序无关，但与参数个数有关。

2. 按位置传递：

 采用这种方式时，用户提供的参数值顺序必须与存储过程中定义的参数顺序相同：
 ```sql
SQL> begin
    save_dept(70,'市场部','福州');
  end;
  /

PL/SQL 过程已成功完成。
 ```

3. 混合方式传递：

 混合方式就是将前两种方式结合到一起：
 ```sql
 PL/SQL 过程已成功完成。

SQL> begin
    save_dept(80,loc=>'福州',dname=>'财务管理部');
  end;
  /

PL/SQL 过程已成功完成。
 ```
有时候参数过多，用户不容易记住参数的顺序和类型，用户可以通过desc命令来查看存储过程中参数的定义信息：
```sql
SQL> desc save_dept
PROCEDURE save_dept
参数名称                       类型                    输入/输出默认值?
------------------------------ ----------------------- ------ --------
 DEPTNO                         NUMBER                  IN
 DNAME                          VARCHAR2                IN
 LOC                            VARCHAR2                IN
```
**2.OUT 模式参数**

这是一种输出类型的参数，表示这个参数在存储过程中已经被赋值，并且这个参数值可以传递到当前存储过程以外的环境中：
```sql
SQL> create or replace procedure select_dept(
   var_deptno in number,
   var_dname out dept.dname%type,
   var_loc out dept.loc%type) is
 begin
   select dname,loc into var_dname,var_loc
   from dept where deptno = var_deptno;
 end;
 /

过程已创建。
```
上述存储过程定义了两个out 参数，由于存储过程要通过out 参数返回值，所以当调用或执行这个存储过程时，都需要定义变量来保存这两个out参数值。

使用EXECUTE命令来执行该存储过程：
```sql
SQL> variable var_dname varchar2(50);
SQL> variable var_loc varchar2(50);
SQL> execute select_dept(50,:var_dname,:var_loc);

PL/SQL 过程已成功完成。
SQL> print var_dname var_loc;

VAR_DNAME
--------------------------------------------------------------------------------
开发一部


VAR_LOC
--------------------------------------------------------------------------------
福州

SQL> select :var_dname,:var_loc from dual;

:VAR_DNAME
--------------------------------------------------------------------------------
:VAR_LOC
--------------------------------------------------------------------------------
开发一部
福州
```
在PL/SQL 程序块中调用该存储过程：
```sql
SQL> set serveroutput on
SQL> declare
   var_dname dept.dname%type;
   var_loc dept.loc%type;
 begin
   save_dept(50,var_dname,var_loc);
   dbms_output.put_line(var_dname||'位于'||var_loc);
 end;
 /
开发一部位于福州

PL/SQL 过程已成功完成。
```
**3.IN OUT模式参数**

在调用存储过程时，IN OUT模式参数可以从外界向该类型的参数传入值；在执行完存储过程之后，可以将该参数的返回值传给外界：
```sql
SQL> create or replace procedure square(
   num in out number) is
 begin
   num:=power(num,2);
 end;
 /

过程已创建。
```
上面的存储过程中定义了一个in out模式的参数num，其既是输入参数也是输出参数，下面用PL/SQL程序块调用该存储过程：
```sql
SQL> declare
    var_number number;
    var_temp number;
  begin
    var_temp:=3;
    var_number:=var_temp;
    square(var_number);
    dbms_output.put_line(var_temp||'的平方为：'||var_number);
  end;
  /
3的平方为：9

PL/SQL 过程已成功完成。
```
从上面的例子中可以看出，变量var_number 在调用存储过程之前是3，而存储过程执行完毕之后，该变量的值变为其平方根9。

**IN 参数的默认值**

前面的 IN 参数的值都是在调用存储过程时传入的，实际上，Oracle 支持在声明IN 参数的同时给其初始化默认值，这样在存储过程调用时，如果没有向IN参数传入值，则存储过程可以使用默认值进行操作：
```sql
SQL> create or replace procedure save_dept(
    var_deptno in number,
    var_dname in varchar2 default '产品创新中心',
    var_loc in varchar2 default '福州') is
  begin
    insert into dept values(var_deptno,var_dname,var_loc);
  end;
  /

过程已创建。
```
var_dname和var_loc定义了默认值，下面调用该存储过程：
```sql
SQL> execute save_dept(90,var_dname=>'人事行政部');

PL/SQL 过程已成功完成。

SQL> select * from dept where deptno = 90;

    DEPTNO DNAME          LOC
---------- -------------- -------------
        90 人事行政部     福州
```
这里var_loc采用了默认值“福州”。
### 删除存储过程
删除存储过程的语法很简单：
```sql
drop procedure procedure_name;
```
比如删除save_dept这个存储过程：
```sql
SQL> drop procedure save_dept;

过程已删除。
```
## 函数
函数一般用于计算和返回一个值，可以将经常需要使用的计算或功能写成一个函数。
### 创建函数
函数的创建语法与存储过程比较类似，它也是一种存储在数据库中的命名程序块，函数可以接受零或多个输入参数，并且函数必须有返回值，语法如下：
```sql
create [or replace] function fun_name[(parameter1[,parameter2]…) return data_type is
   [inner_variable]
begin
   plsql_ sentence;
[exception]
   [dowith _ sentences;]
end [fun_name];
```
由于函数有返回值，所以在函数主体部分（即begin 部分）必须使用return 语句返回函数值，并且要求返回值的类型要与函数声明时的返回值类型（即data_type）相同。

定义一个函数，用于计算emp 表中指定某个部门的平均工资：
```sql
SQL> create or replace function avg_sal(var_deptno number) return number is
    var_result number;
  begin
    select avg(sal) into var_result from emp
    where deptno = var_deptno;
    return var_result;
  exception
    when no_data_found then
     dbms_output.put_line('没有该部门');
    return 0;
  end;
  /

函数已创建。
```
### 调用函数
由于函数有返回值，所以在调用函数时，必须使用一个变量来保存函数的返回值：
```sql
SQL> set serveroutput on
SQL> declare
   var_result number;
 begin
   var_result:=avg_sal(10);
   dbms_output.put_line('编号为10的部门平均工资为：'||var_result);
 end;
 /
编号为10的部门平均工资为：2916.666666666666666666666666666666666667

PL/SQL 过程已成功完成。
```
### 删除函数
删除avg_sal函数：
```sql
SQL> drop function avg_sal;

函数已删除。
```
