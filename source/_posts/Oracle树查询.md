---
title: Oracle树查询
date: 2016-03-28 19:32:28
tags: [Oracle,DataBase]
---
oracle树查询的最重要的就是select…start with…connect by…prior语法了。依托于该语法，我们可以将一个表形结构的以树的顺序列出来。在下面列述了oracle中树型查询的常用查询方式以及经常使用的与树查询相关的oracle特性函数等，在这里只涉及到一张表中的树查询方式而不涉及多表中的关联等。

1.准备测试表和测试数据：
<!--more-->
```sql
--菜单目录结构表
create table tb_menu(
   id     number(10) not null, --主键id
   title  varchar2(50), --标题
   parent number(10) --parent id
)
 
--父菜单
insert into tb_menu(id, title, parent) values(1, '父菜单1',0);
insert into tb_menu(id, title, parent) values(2, '父菜单2',0);
insert into tb_menu(id, title, parent) values(3, '父菜单3',0);
insert into tb_menu(id, title, parent) values(4, '父菜单4',0);
insert into tb_menu(id, title, parent) values(5, '父菜单5',0);
--一级菜单
insert into tb_menu(id, title, parent) values(6, '一级菜单6',1);
insert into tb_menu(id, title, parent) values(7, '一级菜单7',1);
insert into tb_menu(id, title, parent) values(8, '一级菜单8',1);
insert into tb_menu(id, title, parent) values(9, '一级菜单9',2);
insert into tb_menu(id, title, parent) values(10, '一级菜单10',2);
insert into tb_menu(id, title, parent) values(11, '一级菜单11',2);
insert into tb_menu(id, title, parent) values(12, '一级菜单12',3);
insert into tb_menu(id, title, parent) values(13, '一级菜单13',3);
insert into tb_menu(id, title, parent) values(14, '一级菜单14',3);
insert into tb_menu(id, title, parent) values(15, '一级菜单15',4);
insert into tb_menu(id, title, parent) values(16, '一级菜单16',4);
insert into tb_menu(id, title, parent) values(17, '一级菜单17',4);
insert into tb_menu(id, title, parent) values(18, '一级菜单18',5);
insert into tb_menu(id, title, parent) values(19, '一级菜单19',5);
insert into tb_menu(id, title, parent) values(20, '一级菜单20',5);
--二级菜单
insert into tb_menu(id, title, parent) values(21, '二级菜单21',6);
insert into tb_menu(id, title, parent) values(22, '二级菜单22',6);
insert into tb_menu(id, title, parent) values(23, '二级菜单23',7);
insert into tb_menu(id, title, parent) values(24, '二级菜单24',7);
insert into tb_menu(id, title, parent) values(25, '二级菜单25',8);
insert into tb_menu(id, title, parent) values(26, '二级菜单26',9);
insert into tb_menu(id, title, parent) values(27, '二级菜单27',10);
insert into tb_menu(id, title, parent) values(28, '二级菜单28',11);
insert into tb_menu(id, title, parent) values(29, '二级菜单29',12);
insert into tb_menu(id, title, parent) values(30, '二级菜单30',13);
insert into tb_menu(id, title, parent) values(31, '二级菜单31',14);
insert into tb_menu(id, title, parent) values(32, '二级菜单32',15);
insert into tb_menu(id, title, parent) values(33, '二级菜单33',16);
insert into tb_menu(id, title, parent) values(34, '二级菜单34',17);
insert into tb_menu(id, title, parent) values(35, '二级菜单35',18);
insert into tb_menu(id, title, parent) values(36, '二级菜单36',19);
insert into tb_menu(id, title, parent) values(37, '二级菜单37',20);
--三级菜单
insert into tb_menu(id, title, parent) values(38, '三级菜单38',21);
insert into tb_menu(id, title, parent) values(39, '三级菜单39',22);
insert into tb_menu(id, title, parent) values(40, '三级菜单40',23);
insert into tb_menu(id, title, parent) values(41, '三级菜单41',24);
insert into tb_menu(id, title, parent) values(42, '三级菜单42',25);
insert into tb_menu(id, title, parent) values(43, '三级菜单43',26);
insert into tb_menu(id, title, parent) values(44, '三级菜单44',27);
insert into tb_menu(id, title, parent) values(45, '三级菜单45',28);
insert into tb_menu(id, title, parent) values(46, '三级菜单46',28);
insert into tb_menu(id, title, parent) values(47, '三级菜单47',29);
insert into tb_menu(id, title, parent) values(48, '三级菜单48',30);
insert into tb_menu(id, title, parent) values(49, '三级菜单49',31);
insert into tb_menu(id, title, parent) values(50, '三级菜单50',31);
commit;
```
parent字段存储的是上级id，如果是顶级父节点，该parent为0。        

2.树操作

我们从最基本的操作，逐步列出树查询中常见的操作，所有查询出来的节点以家族中的辈份作比方。
### 查找树中的所有顶级父节点

假设这个树是个目录结构，那么第一个操作总是找出所有的顶级节点，再根据该节点找到其下属节点。
```sql
SQL> select * from tb_menu m where m.parent=0;
 
        ID TITLE                                                  PARENT
---------- -------------------------------------------------- ----------
         1 父菜单1                                                     0
         2 父菜单2                                                     0
         3 父菜单3                                                     0
         4 父菜单4                                                     0
         5 父菜单5                                                     0     
```
### 查找一个节点的直属子节点

如果查找的是直属子类节点，也是不用用到树型查询的。
```sql
SQL> select * from tb_menu m where m.parent=1;
 
        ID TITLE                                                  PARENT
---------- -------------------------------------------------- ----------
         6 一级菜单6                                                   1
         7 一级菜单7                                                   1
         8 一级菜单8                                                   1    
```
### 查找一个节点所有直属子节点
```sql
SQL> select * from tb_menu m start with m.id=1 connect by m.parent=prior m.id;
 
        ID TITLE                                                  PARENT
---------- -------------------------------------------------- ----------
         1 父菜单1                                                     0
         6 一级菜单6                                                   1
        21 二级菜单21                                                  6
        38 三级菜单38                                                 21
        22 二级菜单22                                                  6
        39 三级菜单39                                                 22
         7 一级菜单7                                                   1
        23 二级菜单23                                                  7
        40 三级菜单40                                                 23
        24 二级菜单24                                                  7
        41 三级菜单41                                                 24
         8 一级菜单8                                                   1
        25 二级菜单25                                                  8
        42 三级菜单42                                                 25
 
已选择14行。    
```
这个查找的是id为1的节点下的所有直属子类节点，包括子辈的和孙子辈的所有直属节点。

### 查找一个节点的直属父节点

如果查找的是节点的直属父节点，也是不用用到树型查询的。
```sql
SQL>
SELECT
    c. ID,
    c.title,
    P . ID parent_id,
    P .title parent_title
FROM
    tb_menu c,
    tb_menu P
WHERE
    c. PARENT = P . ID
AND c. ID = 6;
 
        ID TITLE                           PARENT_ID PARENT_TITLE
---------- --------------------- ---------- ---------------------------
        6 一级菜单6                         1        父菜单1
```
### 查找一个节点所有直属父节点
```sql
SQL> select * from tb_menu m start with m.id=38 connect by prior m.parent=m.id;
 
        ID TITLE                                                  PARENT
---------- -------------------------------------------------- ----------
        38 三级菜单38                                                 21
        21 二级菜单21                                                  6
         6 一级菜单6                                                   1
         1 父菜单1                                                     0     
```
这里查找的就是id为1的所有直属父节点，打个比方就是找到一个人的父亲、祖父等。但是值得注意的是这个查询出来的结果的顺序是先列出子类节点再列出父类节点，姑且认为是个倒序吧。

上面列出两个树型查询方式，第3条语句和第5条语句，这两条语句之间的区别在于prior关键字的位置不同，所以决定了查询的方式不同。 当parent = prior id时，数据库会根据当前的id迭代出parent与该id相同的记录，所以查询的结果是迭代出了所有的子类记录；而prior parent = id时，数据库会跟据当前的parent来迭代出与当前的parent相同的id的记录，所以查询出来的结果就是所有的父类结果。

以下是一系列针对树结构的更深层次的查询，这里的查询不一定是最优的查询方式，或许只是其中的一种实现而已。
### 查询一个节点的兄弟节点
```sql
--m.parent=m2.parent-->同一个父亲
SQL> 
SELECT
    *   
FROM
    tb_menu M
WHERE
    EXISTS (
        SELECT
            *
        FROM
            tb_menu m2
        WHERE
            M . PARENT = m2. PARENT
        AND m2. ID = 6
    );   
    
        ID TITLE                                                  PARENT
---------- -------------------------------------------------- ----------
         8 一级菜单8                                                   1
         7 一级菜单7                                                   1
         6 一级菜单6                                                   1
```
### 查询与一个节点同级的节点

如果在表中设置了级别的字段，那么在做这类查询时会很轻松，同一级别的就是与那个节点同级的，在这里列出不使用该字段时的实现：
```sql
SQL> 
WITH tmp AS (
    SELECT
        A .*, LEVEL leaf
    FROM
        tb_menu A START WITH A . PARENT = 0 CONNECT BY A . PARENT = PRIOR A . ID
) SELECT
    *
FROM
    tmp
WHERE
    leaf = (
        SELECT
            leaf
        FROM
            tmp
        WHERE
            ID = 50
    ); 
    
        ID TITLE                                        PARENT       LEAF
---------- ----------------------------------------- ---------- ----------
        38 三级菜单38                                     21          4
        39 三级菜单39                                     22          4
        40 三级菜单40                                     23          4
        41 三级菜单41                                     24          4
        42 三级菜单42                                     25          4
        43 三级菜单43                                     26          4
        44 三级菜单44                                     27          4
        45 三级菜单45                                     28          4
        46 三级菜单46                                     28          4
        47 三级菜单47                                     29          4
        48 三级菜单48                                     30          4
        49 三级菜单49                                     31          4
        50 三级菜单50                                     31          4
 
已选择13行。
```
这里使用两个技巧，一个是使用了level来标识每个节点在表中的级别，还有就是使用with语法模拟出了一张带有级别的临时表。

### 查询一个节点父节点的兄弟节点
```sql
SQL> 
WITH tmp AS (
    SELECT
        tb_menu.*, LEVEL lev
    FROM
        tb_menu START WITH PARENT = 0 CONNECT BY PARENT = PRIOR ID
) SELECT
    b.*
FROM
    tmp b,
    (
        SELECT
            *
        FROM
            tmp
        WHERE
            ID = 21
        AND lev = 2
    ) A
WHERE
    b.lev = 1
UNION ALL
    SELECT
        *
    FROM
        tmp
    WHERE
        PARENT = (
            SELECT DISTINCT
                x. ID
            FROM
                tmp x,
                --祖父
                tmp y,
                --父亲
                (
                    SELECT
                        *
                    FROM
                        tmp
                    WHERE
                        ID = 21
                    AND lev > 2
                ) z --儿子
            WHERE
                y. ID = z. PARENT
            AND x. ID = y. PARENT
        );
 
 
        ID TITLE                                      PARENT        LEV
---------- ---------------------------------------- ---------- ----------
         6 一级菜单6                                    1          2
         7 一级菜单7                                    1          2
         8 一级菜单8                                    1          2
```
这里查询分成以下几步。

首先，将第7个一样，将全表都使用临时表加上级别；

其次，根据级别来判断有几种类型，以上文中举的例子来说，有三种情况：

（1）当前节点为顶级节点，即查询出来的lev值为1，那么它没有上级节点，不予考虑。

（2）当前节点为2级节点，查询出来的lev值为2，那么就只要保证lev级别为1的就是其上级节点的兄弟节点。

（3）其它情况就是3以及以上级别，那么就要选查询出来其上级的上级节点（祖父），再来判断祖父的下级节点都是属于该节点的上级节点的兄弟节点。

最后，就是使用union将查询出来的结果进行结合起来，形成结果集。

### 查询一个节点父节点的同级节点

这个其实跟第7种情况是相同的。
```sql
SQL> 
WITH tmp AS (
    SELECT
        A .*, LEVEL leaf
    FROM
    tb_menu A START WITH A . PARENT = 0 CONNECT BY A . PARENT = PRIOR A . ID
) SELECT
    *
FROM
    tmp
WHERE
    leaf = (SELECT leaf FROM tmp WHERE ID = 6) - 1;  
    
        ID TITLE                                         PARENT       LEAF
---------- ------------------------------------------- ---------- ----------
         1 父菜单1                                          0          1
         2 父菜单2                                          0          1
         3 父菜单3                                          0          1
         4 父菜单4                                          0          1
         5 父菜单5                                          0          1
```
基本上，常见的查询在里面了，不常见的也有部分了。其中，查询的内容都是节点的基本信息，都是数据表中的基本字段，但是在树查询中还有些特殊需求，是对查询数据进行了处理的，常见的包括列出树路径等。

补充一个概念，对于数据库来说，根节点并不一定是在数据库中设计的顶级节点，对于数据库来说，根节点就是start with开始的地方。

下面列出的是一些与树相关的特殊需求。

### 名称要列出名称全部路径

这里常见的有两种情况，一种是从顶级列出，直到当前节点的名称（或者其它属性）；一种是从当前节点列出，直到顶级节点的名称（或其它属性）。举地址为例：国内的习惯是从省开始、到市、到县、到居委会的，而国外的习惯正好相反。
从顶部开始：
```sql
SQL> 
SELECT
    SYS_CONNECT_BY_PATH (title, '/')
FROM
    tb_menu
WHERE
    ID = 50 START WITH PARENT = 0 CONNECT BY PARENT = PRIOR ID;
    
SYS_CONNECT_BY_PATH(TITLE,'/')
----------------------------------------------------
/父菜单3/一级菜单14/二级菜单31/三级菜单50
```
从当前节点开始：
```sql
SQL> 
SELECT
    SYS_CONNECT_BY_PATH (title, '/')
FROM
    tb_menu START WITH ID = 50 CONNECT BY PRIOR PARENT = ID;
    
SYS_CONNECT_BY_PATH(TITLE,'/')
------------------------------------------------------    
/三级菜单50
/三级菜单50/二级菜单31
/三级菜单50/二级菜单31/一级菜单14
/三级菜单50/二级菜单31/一级菜单14/父菜单3
```
在这里我又不得不放个牢骚了。oracle只提供了一个sys_connect_by_path函数，却忘了字符串的连接的顺序。在上面的例子中，第一个sql是从根节点开始遍历，而第二个sql是直接找到当前节点，从效率上来说已经是千差万别，更关键的是第一个sql只能选择一个节点，而第二个sql却是遍历出了一颗树来。再次ps一下。

sys_connect_by_path函数就是从start with开始的地方开始遍历，并记下其遍历到的节点，start with开始的地方被视为根节点，将遍历到的路径根据函数中的分隔符，组成一个新的字符串，这个功能还是很强大的。

### 列出当前节点的根节点。

在前面说过，根节点就是start with开始的地方。
```sql
SQL> 
SELECT
    CONNECT_BY_ROOT title,
    tb_menu.*
FROM
    tb_menu START WITH ID = 50 CONNECT BY PRIOR PARENT = ID;
 
CONNECT_BY_ROOTTITLE        ID TITLE                       PARENT
----------------------------------------------------------------
三级菜单50                  50 三级菜单50                     31
三级菜单50                  31 二级菜单31                     14
三级菜单50                  14 一级菜单14                     3
三级菜单50                  3 父菜单3                         0
```
connect_by_root函数用来列的前面，记录的是当前节点的根节点的内容。

### 列出当前节点是否为叶子

这个比较常见，尤其在动态目录中，在查出的内容是否还有下级节点时，这个函数是很适用的。
```sql
SELECT
    CONNECT_BY_ISLEAF,
    tb_menu.*
FROM
    tb_menu START WITH PARENT = 0 CONNECT BY PARENT = PRIOR ID;
 
CONNECT_BY_ISLEAF         ID TITLE                                     PARENT
----------------- ---------- --------------------------------------- ----------
                0          1 父菜单1                                     0
                0          6 一级菜单6                                   1
                0         21 二级菜单21                                  6
                1         38 三级菜单38                                  21
                0         22 二级菜单22                                  6
                1         39 三级菜单39                                  22
                0          7 一级菜单7                                   1
                0         23 二级菜单23                                  7
                1         40 三级菜单40                                  23
                0         24 二级菜单24                                  7
                1         41 三级菜单41                                  24
                0          8 一级菜单8                                   1
                0         25 二级菜单25                                  8
                1         42 三级菜单42                                  25
                0          2 父菜单2                                     0
                0          9 一级菜单9                                   2
                0         26 二级菜单26                                  9
                1         43 三级菜单43                                  6
                0         10 一级菜单10                                  2
                0         27 二级菜单27                                  10
                1         44 三级菜单44                                  27
                0         11 一级菜单11                                  2
                0         28 二级菜单28                                  11
                1         45 三级菜单45                                  28
                1         46 三级菜单46                                  28
                0          3 父菜单3                                     0
                0         12 一级菜单12                                  3
                0         29 二级菜单29                                  12
                1         47 三级菜单47                                  29
                0         13 一级菜单13                                  3
                0         30 二级菜单30                                  13
                1         48 三级菜单48                                  30
                0         14 一级菜单14                                  3
                0         31 二级菜单31                                  14
                1         49 三级菜单49                                  31
                1         50 三级菜单50                                  31
                0          4 父菜单4                                     0
                0         15 一级菜单15                                  4
                1         32 二级菜单32                                  15
                0         16 一级菜单16                                  4
                1         33 二级菜单33                                  16
                0         17 一级菜单17                                  4
                1         34 二级菜单34                                  17
                0          5 父菜单5                                     0
                0         18 一级菜单18                                  5
                1         35 二级菜单35                                  18
                0         19 一级菜单19                                  5
                1         36 二级菜单36                                  19
                0         20 一级菜单20                                  5
                1         37 二级菜单37                                  20
 
已选择50行。	
```