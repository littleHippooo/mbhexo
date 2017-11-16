---
title: Oracle触发器
date: 2017-11-04 15:14:32
tags: [DataBase,Oracle 11g,Oracle]
---
触发器可以看做一种“特殊”的存储过程，由“触发事件”触发。所谓的“触发事件”指能够引起触发器运行的操作，包括：

1.执行DML 语句（使用INSERT、UPDATE、DELETE 语句对表或视图执行数据处理操作）；

2.执行DDL语句（使用CREATE、ALTER、DROP语句在数据库中创建、修改、删除模式对象）；

3.引发数据库系统事件（如系统启动或退出、产生异常错误等）；

4.引发用户事件（如登录或退出数据库操作）。
<!--more-->
触发器的语法如下：
```sql
create [or replace] trigger tri_name
   [before | after | instead of] tri_event
   on table_name | view_name | user_name | db_name
      [for each row] [when tri_condition]
begin
   plsql_sentences;
end tri_name;
```
- `before | after | instead of`：表示“触发时机”的关键字。`before` 表示在执行DML 等操作之前触发；`after` 表示在DML等操作之后发生；`instead of` 表示触发器为
替代触发器。

- `on`：表示操作的数据表、视图、用户模式和数据库等，对它们执行某种数据操作（比如对表执行INSERT、ALTER、DROP 等操作），将引起触发器的运行。

- `for each row`：指定触发器为行级触发器，当DML语句对每一行数据进行操作时都会引起该触发器的运行。如果未指定该条件，则表示创建语句级触发器，这时无论数据操作影响多少行，触发器都只会执行一次。

- `tri_condition`：表示触发条件表达式。

根据触发器的触发事件和触发器的执行情况，将Oracle 所支持的触发器分为以下4 种类型：
## 语句级触发器
语句级触发器，就是针对一条DML 语句而引起的触发器执行。在语句级触发器中，不使用`for each row` 子句，也就是说无论数据操作影响多少行，触发器都只会执行一次。

比如设计一个触发器，用于记录对soctt.dept表的增删改查操作：

1.创建dept_log 数据表，用于记录操作类型和时间：
```sql
SQL> create table dept_log(
    operate_tag varchar2(10),
    operate_time date
  );

表已创建。
```
2.创建一个关于dept 表的语句级触发器，将用户对dept 表的操作信息保存到dept_log 表中：
```sql
SQL> create or replace trigger tir_dept
    before insert or update or delete
    on dept
  declare
    var_tag varchar2(10);
  begin
    if inserting then
      var_tag:='insert';
    elsif updating then
      var_tag:='update';
    elsif deleting then
      var_tag:='delete';
    end if;
    insert into dept_log values(var_tag,sysdate);
  end;
  /

触发器已创建
```
用户甚至还可以在其中判断特定列是否被更新。例如，要判断用户是否对dept 表中dname 列进行了修改，可以使用下面的语句：
```sql
if updating(dname) then //若修改了dept 表中的dname 列
   do something about update dname
end if;
```
3.执行DML 语句来触发tri_dept：
```sql
SQL> delete from dept where deptno = 90;

已删除 1 行。
SQL> insert into dept values(90,'清算风控部门','福州');

已创建 1 行。
SQL> update dept set loc='厦门' where deptno = 90;

已更新 1 行。
```
4.到dept_log 表中查看日志信息：
```sql
SQL> select * from dept_log;

OPERATE_TA OPERATE_TIME
---------- --------------
delete     13-11月-17
insert     13-11月-17
update     13-11月-17
```
## 行级触发器
行级触发器会针对DML 操作所影响的每一行数据都执行一次触发器。创建这种触发器时，必须在语法中使用`for each row`。使用行级触发器的一个典型应用就是给数据表生成主键值。

举个例子：

1.创建一个用于存储商品种类的数据表，其中包括商品序号列和商品名称列，其中商品序号为主键：
```sql
SQL> create table goods(
     id int not null primary key,
     good_name varchar2(50)
   );

表已创建。
```
2.为主键创建一个序列：
```sql
SQL> create sequence seq_goods_id;

序列已创建。
```
3.创建一个触发器，用于自动为goods 表的id 列赋值：
```sql
SQL> create or replace trigger tri_save_good
    before insert
    on goods
    for each row
  begin
    select seq_goods_id.nextval into :new.id from dual;
  end;
  /

触发器已创建
```
这里使用了`:new.id`关键字——列标识符，这个列标识符用来指向新行的id 列，给它赋值。

列标识符可以分为**原值标识符**和**新值标识符**：

- **原值标识符**用于标识当前行某个列的原始值，记作`:old.column_name`（如，`:old.id`），通常在update 语句和delete 语句中使用；

- **新值标识符**用于标识当前行某个列的新值，记作`:new.column_name`（如，`:new.id`），通常在insert 语句和update 语句中使用。

4.向 goods 表中插入两条记录，其中一条记录不指定id 列的值，由序列seq_goods_id 来产生；另一条记录指定id 的值：
```sql
SQL> insert into goods(good_name) values('apple');

已创建 1 行。
SQL> insert into goods(id,good_name) values(100,'banana');

已创建 1 行。
```
5.查看goods表结果：
```sql
SQL> select * from goods;

        ID GOOD_NAME
---------- ----------------------
         1 apple
         2 banana
```
可见手动指定的id值（100）无法覆盖触发器中指定的`seq_goods_id.nextval`值。
## 替换触发器
替换触发器——instead of 触发器是定义在视图view上的。Oracle中一般不让直接对视图进行DML操作，但我们可以使用替换触发器来实现。

1.创建一个包含dept表和emp表信息的视图：
```sql
SQL> create view view_emp_dept
  as select empno,ename,dept.deptno,dname,job,hiredate
     from emp,dept
     where emp.deptno = dept.deptno;

视图已创建。
```
直接往视图里插入数据：
```sql
SQL> insert into view_emp_dept values(7966,'Jane',70,'市场部','经理',sysdate);

insert into view_emp_dept values(
*
第 1 行出现错误:
ORA-01776: 无法通过联接视图修改多个基表
```
2.直接往视图里插入数据报错，此时编写一个关于view_emp_dept 视图在insert 事件中的触发器：
```sql
SQL> create or replace trigger tri_insert_view_emp_dept
    instead of insert
    on view_emp_dept
  declare
    row_dept dept%rowtype;
  begin
    select * into row_dept from dept where deptno=:new.deptno;
    if sql%notfound then
      insert into dept(deptno,dname) values(:new.deptno,:new.dname);
    end if;
    insert into emp(empno,ename,deptno,job,hiredate)
    values(:new.empno,:new.ename,:new.deptno,:new.job,:new.hiredate);
  end;
  /

触发器已创建
```
在上面触发器的主体代码中，如果新插入行的部门编号（deptno）不在dept 表中，则首先向dept表中插入关于新部门编号的数据行，然后再向emp 表中插入记录行，这是因为emp 表的外键值（emp.deptno）是dept 表的主键值（dept.deptno）。

3.再次执行`insert into view_emp_dept values(7966,'Jane',70,'市场部','经理',sysdate);`：
```sql
SQL> insert into view_emp_dept values(7966,'Jane',70,'市场部','经理',sysdate);

已创建 1 行。
SQL> select * from view_emp_dept where empno=7966;

     EMPNO ENAME          DEPTNO DNAME          JOB       HIREDATE
---------- ---------- ---------- -------------- --------- --------------
      7966 Jane               70 市场部         经理      13-11月-17
```
## 用户事件触发器
用户事件触发器是因进行 DDL 操作或用户登录、退出等操作而引起运行的一种触发器，引起该类型触发器运行的常见用户事件包括：CREATE、ALTER、DROP、ANALYZE、COMMENT、GRANT、REVOKE、RENAME、TRUNCATE、SUSPEND、LOGON 和LOGOFF 等。

1.创建一个日志信息表，用于保存DDL 操作的信息:
```sql
SQL> create table ddl_oper_log(
    db_obj_name varchar2(20),   //数据对象名称
    db_obj_type varchar2(20),   //数据对象类型
    oper_action varchar2(20),   //操作行为
    oper_user varchar2(20),     //操作用户
    oper_time date              //操作时间
  );

表已创建。
```
2.创建一个用户触发器，用于将当前模式下的DDL 操作信息保存到上面所创建的ddl_oper_log日志信息表中：
```sql
SQL> create or replace trigger tri_ddl_oper
    before create or alter or drop
    on scott.schema
  begin
    insert into ddl_oper_log values(
      ora_dict_obj_name,
      ora_dict_obj_type,
      ora_sysevent,
      ora_login_user,
      sysdate);
  end;
  /

触发器已创建
```
- `ora_dict_obj_name`：获取DDL 操作所对应的数据库对象。

- `ora_dict_obj_type`：获取DDL 操作所对应的数据库对象的类型。

- `ora_sysevent`：获取触发器的系统事件名。

- `ora_login_user`：获取登录用户名。

3.执行一些DDL 操作：
```sql
SQL> create table tb_test(id number);

表已创建。
SQL> create view v_test as select * from tb_test;

视图已创建。
SQL> drop view v_test;

视图已删除。
SQL> drop table tb_test;

表已删除。
```
4.查看ddl_oper_log日志表：
```sql
SQL> select * from ddl_oper_log;

DB_OBJ_NAME          DB_OBJ_TYPE          OPER_ACTION          OPER_USER            OPER_TIME
-------------------- -------------------- -------------------- -------------------- -------------
TB_TEST              TABLE                CREATE               SCOTT                13-11月-17
V_TEST               VIEW                 CREATE               SCOTT                13-11月-17
V_TEST               VIEW                 DROP                 SCOTT                13-11月-17
TB_TEST              TABLE                DROP                 SCOTT                13-11月-17
```

