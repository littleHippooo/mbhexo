---
title: Oracle Merge语句
date: 2017-11-15 14:59:23
tags: [DataBase,Oracle,Oracle 11g]
---
Merge语句是Oracle 9i新增的语法，用来合并Update和Insert语句。通过Merge语句，根据一张表或子查询的连接条件对另外一张表进行查询，连接条件匹配上的进行Update，无法匹配的执行Insert。这个语法仅需要一次全表扫描就完成了全部工作，执行效率要高于Insert+Update。

merge语句语法如下：
```sql
merge into table_name t
using (subquery) s on (s.column = t.column)
when matched then update ...
when not matched then insert ...
```
<!--more-->
`on`关键字声明了关联条件，当有记录匹配时执行Update语句，没有匹配时，执行Insert语句。
## 示例
创建一张student表：
```sql
create table student(
 sno varchar2(3) not null, -- 学生编号
 sname varchar(9) not null, -- 学生姓名
 ssex char(2) not null -- 性别
);

表已创建。
```
插入一条学生标号为001的数据：
```sql
SQL> merge into student s
  using (select '001' sno,'KangKang' sname,'M' ssex from dual) t
  on (s.sno = t.sno)
  when matched then
   update set s.sname = t.sname,s.ssex = t.ssex
  when not matched then
   insert (s.sno,s.sname,s.ssex) values(t.sno,t.sname,t.ssex);

1 行已合并。

SQL> select * from student;

SNO SNAME     SS
--- --------- --
001 KangKang  M
```
再次插入一条学生编号为001的数据，不过sname和ssex不一样：
```sql
SQL> merge into student s
  using (select '001' sno,'Maria' sname,'F' ssex from dual) t
  on (s.sno = t.sno)
  when matched then
   update set s.sname = t.sname,s.ssex = t.ssex
  when not matched then
   insert (s.sno,s.sname,s.ssex) values(t.sno,t.sname,t.ssex);

1 行已合并。

SQL> select * from student;

SNO SNAME     SS
--- --------- --
001 Maria     F
```