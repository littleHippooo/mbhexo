---
title: Oracle程序包
date: 2017-11-04 15:54:58
tags: [DataBase,Oracle 11g,Oracle]
---
程序包由PL/SQL 程序元素（如变量、类型）和匿名PL/SQL 块（如游标）、命名PL/SQL 块（如存储过程和函数）组成。一个完整的程序包包含程序包规范和程序包主体，程序包规范用于规定在程序包中可以使用哪些变量、类型、游标和子程序（只包含名称没有具体实现）；程序包的主体包含了在规范中声明的游标、过程和函数的实现代码。这个过程类似于在Java中定义一个包含抽象方法的接口，然后创建一个该接口的实现类。
<!--more-->
## 程序包的规范
程序包的语法如下：
```sql
create [or replace ] package pack_name is
   [declare_variable];
   [declare_type];
   [declare_cursor];
   [declare_function];
   [declare_ procedure];
end [pack_name];
```
比如创建一个程序包规范，并声明一个获取指定部门平均工资函数和一个提高指定部门指定百分比工资的存储过程：
```sql
SQL> create or replace package pack_test is
     function avg_sal(var_deptno number) return number;
     procedure rise_sal(var_job varchar2,percent number);
  end;
  /

程序包已创建。
```
{% note danger %}
在“规范”中声明的函数和存储过程只有头部的声明，而没有函数体和存储过程主体。
{% endnote %}

## 程序包主体
程序包的语法如下：
```sql
create [or replace] package body pack_name is
   [inner_variable]
   [cursor_body]
   [function_title]
   {begin
      fun_plsql;
   [exception]
      [dowith _ sentences;]
   end [fun_name]}
   [procedure_title]
   {begin
      pro_plsql;
   [exception]
      [dowith _ sentences;]
   end [pro_name]}
   …
end [pack_name];
```
创建pack_test的主体：
```sql
SQL> create or replace package body pack_test is
    function avg_sal(var_deptno number) return number is  //函数实现
      num_avg_sal number;
    begin
      select avg(sal) into num_avg_sal
      from emp where deptno = var_deptno;
      return num_avg_sal;
    exception
      when no_data_found then
        dbms_output.put_line('没有该部门');
      return 0;
    end;
    procedure rise_sal(var_job varchar2,percent number) is  //存储过程实现
    begin
      update emp set sal=sal*(1+percent) where job = var_job;
    end;
  end;
  /

程序包体已创建。
```
在PL/SQL代码块中调用程序包的avg_sal函数和rise_sal存储过程：
```sql
SQL> set serveroutput on
SQL> declare
   num_avg_sal number;
  begin
   num_avg_sal:=pack_test.avg_sal(10);
   dbms_output.put_line('10号部门的平均工资为：'||num_avg_sal);
   pack_test.rise_sal('SALESMAN',0.2);
  end;
  /
10号部门的平均工资为：2916.666666666666666666666666666666666667

PL/SQL 过程已成功完成。
```