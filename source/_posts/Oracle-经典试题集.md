---
title: Oracle 经典试题集
date: 2016-03-02 09:18:12
tags: [Oracle,DataBase]
password: 465af3ec97365f9e17081f9ea40590e27472f946
encrypt: true 
enc_pwd: 6742530
---
一份很好的Oracle SQL试题集🙌。
<!--more-->

准备工作：
```sql
create table student(
    sno varchar2(10) primary key,
    sname varchar2(20),
    sage number(2),
    ssex varchar2(5)
);
create table teacher(
    tno varchar2(10) primary key,
    tname varchar2(20)
);
create table course(
    cno varchar2(10),
    cname varchar2(20),
    tno varchar2(20),
    constraint pk_course primary key (cno,tno)
);
create table sc(
    sno varchar2(10),
    cno varchar2(10),
    score number(4,2),
    constraint pk_sc primary key (sno,cno)
);

/*******初始化学生表的数据******/
insert into student values ('s001','张三',23,'男');
insert into student values ('s002','李四',23,'男');
insert into student values ('s003','吴鹏',25,'男');
insert into student values ('s004','琴沁',20,'女');
insert into student values ('s005','王丽',20,'女');
insert into student values ('s006','李波',21,'男');
insert into student values ('s007','刘玉',21,'男');
insert into student values ('s008','萧蓉',21,'女');
insert into student values ('s009','陈萧晓',23,'女');
insert into student values ('s010','陈美',22,'女');
commit;

/******************初始化教师表***********************/
insert into teacher values ('t001', '刘阳');
insert into teacher values ('t002', '谌燕');
insert into teacher values ('t003', '胡明星');
commit;

/***************初始化课程表****************************/
insert into course values ('c001','J2SE','t002');
insert into course values ('c002','Java Web','t002');
insert into course values ('c003','SSH','t001');
insert into course values ('c004','Oracle','t001');
insert into course values ('c005','SQL SERVER 2005','t003');
insert into course values ('c006','C#','t003');
insert into course values ('c007','JavaScript','t002');
insert into course values ('c008','DIV+CSS','t001');
insert into course values ('c009','PHP','t003');
insert into course values ('c010','EJB3.0','t002');
commit;

/***************初始化成绩表***********************/
insert into sc values ('s001','c001',78.9);
insert into sc values ('s002','c001',80.9);
insert into sc values ('s003','c001',81.9);
insert into sc values ('s004','c001',60.9);
insert into sc values ('s001','c002',82.9);
insert into sc values ('s002','c002',72.9);
insert into sc values ('s003','c002',81.9);
insert into sc values ('s001','c003','59');
commit;
```
1、查询“c001”课程比“c002”课程成绩高的所有学生的成绩信息；
```sql
SQL> select a.* from
  2  (select * from sc a where a.cno = 'c001') a,
  3  (select * from sc b where b.cno = 'c002') b
  4  where a.sno=b.sno and a.score > b.score;

SNO        CNO             SCORE
---------- ---------- ----------
s002       c001             80.9

```
或者：
```sql
SQL> select * from sc a
  2  where a.cno = 'c001'
  3  and  exists (select * from sc b where b.cno='c002' and a.score > b.score and a.sno = b.sno);

SNO        CNO             SCORE
---------- ---------- ----------
s002       c001             80.9
```

2、查询平均成绩大于60分的同学的学号和平均成绩；
```sql
SQL> select sno,avg(score) from sc group by sno having avg(score) > 60;

SNO        AVG(SCORE)
---------- ----------
s003             81.9
s004             60.9
s001             73.6
s002             76.9
```

3、查询所有同学的学号、姓名、选课数、总成绩；
```sql
SQL> SELECT a.sno, a.sNAME,sum(score),count(b.cno)
  2  FROM student a, sc b
  3  WHERE a.sno = b.sno(+)
  4  group by a.sno,sname;

SNO        SNAME                SUM(SCORE) COUNT(B.CNO)
---------- -------------------- ---------- ------------
s009       陈萧晓                                     0
s005       王丽                                       0
s001       张三                      220.8            3
s008       萧蓉                                       0
s003       吴鹏                      163.8            2
s004       琴沁                       60.9            1
s007       刘玉                                       0
s006       李波                                       0
s010       陈美                                       0
s002       李四                      153.8            2
```

4、查询姓“刘”的老师的个数：
```sql
SQL> select count(1) from TEACHER where TNAME LIKE '刘%';

  COUNT(1)
----------
         1
```
