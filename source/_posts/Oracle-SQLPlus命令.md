---
title: Oracle SQLPlus命令
date: 2017-11-01 20:23:48
tags: [Oracle,DataBase]
---
SQLPlus是一个被DBA和开发人员广泛使用的功能强大的Oracle工具，可以在各个平台上拥有操作的一致性。SQLPlus可以执行输入的SQL语句和SQL文件，通过SQLPlus可以和数据库进行对话。以下例子基于Oracle 11g。
## set命令设置运行环境
在Oracle 11g中，可以使用set命令来设置SQLPlus的运行环境。set命令语法如下：
<!--more-->
```sql
set variable value
```
`variable`为变量名，`value`为变量值。下面介绍几个常用的set变量。

### pagesize变量
pagesize变量用来设置从顶部标题到页结束行（包含页首的空行）之间的行数。pagesize的默认值为14：
```sql
SQL> show pagesize
pagesize 14
```
使用`set pagesize`命令修改一页的行数为18：
```sql
SQL> set pagesize 18;
SQL> select user_id,username,account_status from dba_users;

   USER_ID USERNAME                       ACCOUNT_STATUS
---------- ------------------------------ --------------------------------
        74 MGMT_VIEW                      OPEN
         0 SYS                            OPEN
         5 SYSTEM                         OPEN
        30 DBSNMP                         OPEN
        72 SYSMAN                         OPEN
        84 SCOTT                          OPEN
         9 OUTLN                          EXPIRED & LOCKED
        75 FLOWS_FILES                    EXPIRED & LOCKED
        57 MDSYS                          EXPIRED & LOCKED
        53 ORDSYS                         EXPIRED & LOCKED
        42 EXFSYS                         EXPIRED & LOCKED
        32 WMSYS                          EXPIRED & LOCKED
        31 APPQOSSYS                      EXPIRED & LOCKED
        78 APEX_030200                    EXPIRED & LOCKED
        83 OWBSYS_AUDIT                   EXPIRED & LOCKED
```
可手动数一下是不是18行(lll￢ω￢)。
### newpage变量
该变量用于设置一页中空行的数量，默认值为1，可以使用`set newpage`命令改变该值：
```sql
SQL> show newpage
newpage 1
SQL> set newpage 5
SQL> select user_id,username,account_status from dba_users;





   USER_ID USERNAME                       ACCOUNT_STATUS
---------- ------------------------------ --------------------------------
        74 MGMT_VIEW                      OPEN
         0 SYS                            OPEN
         5 SYSTEM                         OPEN
        30 DBSNMP                         OPEN
        72 SYSMAN                         OPEN
        84 SCOTT                          OPEN
         9 OUTLN                          EXPIRED & LOCKED
        75 FLOWS_FILES                    EXPIRED & LOCKED
        57 MDSYS                          EXPIRED & LOCKED
        53 ORDSYS                         EXPIRED & LOCKED
        42 EXFSYS                         EXPIRED & LOCKED
```
### linesize变量
该变量用于设置SQLPlus环境中一行所显示的最多字符总数，默认值为80，当pagesize过小时，数据就会出现折行显示的情况。可以使用`set linesize`命令来调整linesize的值：
```sql
SQL> show linesize
linesize 80
SQL> set linesize 120
```
### pause变量
用于设置输出结果翻页时，是否暂停，基本语法如下：
```sql
set pause value
```
value可取的值有：

- `off`，默认值，返回结果一次性输出完毕，中间翻页不会暂停；

- `on`，表示输出结果的每一页都暂停，用户按ENTER继续；

- `text`，在设置为on之后，继续设置text的值，用于暂停时显示；

比如：
```sql
SQL> set pause on
SQL> set pause '按<enter>键继续'
SQL> select user_id,username,account_status from dba_users;
按<enter>键继续

   USER_ID USERNAME                       ACCOUNT_STATUS
---------- ------------------------------ --------------------------------
        74 MGMT_VIEW                      OPEN
         0 SYS                            OPEN
         5 SYSTEM                         OPEN
        30 DBSNMP                         OPEN
        72 SYSMAN                         OPEN
        84 SCOTT                          OPEN
         9 OUTLN                          EXPIRED & LOCKED
        75 FLOWS_FILES                    EXPIRED & LOCKED
        57 MDSYS                          EXPIRED & LOCKED
        53 ORDSYS                         EXPIRED & LOCKED
        42 EXFSYS                         EXPIRED & LOCKED
        32 WMSYS                          EXPIRED & LOCKED
        31 APPQOSSYS                      EXPIRED & LOCKED
        78 APEX_030200                    EXPIRED & LOCKED
        83 OWBSYS_AUDIT                   EXPIRED & LOCKED
按<enter>键继续
```
### numformat变量
该变量值用于设置显示数值的默认格式，基本语法如下：
```sql
set numformat format
```
format为数值掩码，常用值及其说明如下：

<table>
	<tr>
		<th>掩码</th>
		<th>说明</th>
		<th>举例</th>
	</tr>
	<tr>
		<td>9</td>
		<td>查询结果中数字替换格式的掩码</td>
		<td>999</td>
	</tr>
	<tr>
		<td>0</td>
		<td>格式中的掩码屏蔽掉查询结果中的数字</td>
		<td>999.00</td>
	</tr>
	<tr>
		<td>$</td>
		<td>在查询结果中的数字前添加美元前缀</td>
		<td>$999</td>
	</tr>
	<tr>
		<td>S</td>
		<td>为数字显示符号类型，通常用于显示查询结果中的正负数字</td>
		<td>S999</td>
	</tr>
	<tr>
		<td>,</td>
		<td>在字符`,`位置上放置都逗号/td>
		<td>999,99</td>
	</tr>
</table>

查看scott.emp表中的SAL字段值，然后使用"$999,999,999.00"格式显示:
```sql
SQL> select ename,job,sal from scott.emp;

ENAME      JOB              SAL
---------- --------- ----------
SMITH      CLERK            800
ALLEN      SALESMAN        1600
WARD       SALESMAN        1250
JONES      MANAGER         2975
MARTIN     SALESMAN        1250
BLAKE      MANAGER         2850
CLARK      MANAGER         2450
SCOTT      ANALYST         3000
KING       PRESIDENT       5000
TURNER     SALESMAN        1500
ADAMS      CLERK           1100
SQL> set numformat $999,999,999.00
SQL> select ename,job,sal from scott.emp;

ENAME      JOB                    SAL
---------- --------- ----------------
SMITH      CLERK              $800.00
ALLEN      SALESMAN         $1,600.00
WARD       SALESMAN         $1,250.00
JONES      MANAGER          $2,975.00
MARTIN     SALESMAN         $1,250.00
BLAKE      MANAGER          $2,850.00
CLARK      MANAGER          $2,450.00
SCOTT      ANALYST          $3,000.00
KING       PRESIDENT        $5,000.00
TURNER     SALESMAN         $1,500.00
ADAMS      CLERK            $1,100.00
```
### timing变量
该变量用于显示执行SQL语句所花的时间，默认值为off：
```sql
SQL> set timing on
SQL> select ename,job,sal from scott.emp;

ENAME      JOB                    SAL
---------- --------- ----------------
SMITH      CLERK              $800.00
ALLEN      SALESMAN         $1,600.00
WARD       SALESMAN         $1,250.00
JONES      MANAGER          $2,975.00
MARTIN     SALESMAN         $1,250.00
BLAKE      MANAGER          $2,850.00
CLARK      MANAGER          $2,450.00
SCOTT      ANALYST          $3,000.00
KING       PRESIDENT        $5,000.00
TURNER     SALESMAN         $1,500.00
ADAMS      CLERK            $1,100.00

ENAME      JOB                    SAL
---------- --------- ----------------
JAMES      CLERK              $950.00
FORD       ANALYST          $3,000.00
MILLER     CLERK            $1,300.00

已选择14行。

已用时间:  00: 00: 00.04
```
set命令还有很多变量可用，可使用`help set`命令来查看。
## 常用SQLPlus命令
### help命令
help命令用来帮助用户查询指定命令详细介绍，类似于Linux的man，其的语法如下：
```sql
help|? [topic]
```
`?`表示一个命令的部分字符，用于模糊查询；topic参数表示要查询的命令的完整名称。如果直接输入help，则显示的是命令本身的详细信息：
```sql
SQL> help

 HELP
 ----

 Accesses this command line help system. Enter HELP INDEX or ? INDEX
 for a list of topics.

 You can view SQL*Plus resources at
     http://www.oracle.com/technology/tech/sql_plus/
 and the Oracle Database Library at
     http://www.oracle.com/technology/documentation/

 HELP|? [topic]


SQL> help set

 SET
 ---

 Sets a system variable to alter the SQL*Plus environment settings
 for your current session. For example, to:
     -   set the display width for data
     -   customize HTML formatting
     -   enable or disable printing of column headings
     -   set the number of lines per page

 SET system_variable value

 where system_variable and value represent one of the following clauses:

   APPI[NFO]{OFF|ON|text}                   NEWP[AGE] {1|n|NONE}
   ARRAY[SIZE] {15|n}                       NULL text
   AUTO[COMMIT] {OFF|ON|IMM[EDIATE]|n}      NUMF[ORMAT] format
   AUTOP[RINT] {OFF|ON}                     NUM[WIDTH] {10|n}
   AUTORECOVERY {OFF|ON}                    PAGES[IZE] {14|n}
   AUTOT[RACE] {OFF|ON|TRACE[ONLY]}         PAU[SE] {OFF|ON|text}
     [EXP[LAIN]] [STAT[ISTICS]]             RECSEP {WR[APPED]|EA[CH]|OFF}
   BLO[CKTERMINATOR] {.|c|ON|OFF}           RECSEPCHAR {_|c}
   CMDS[EP] {;|c|OFF|ON}                    SERVEROUT[PUT] {ON|OFF}
   COLSEP {_|text}                            [SIZE {n | UNLIMITED}]
   CON[CAT] {.|c|ON|OFF}                      [FOR[MAT]  {WRA[PPED] |
   COPYC[OMMIT] {0|n}                          WOR[D_WRAPPED] |
   COPYTYPECHECK {ON|OFF}                      TRU[NCATED]}]
   DEF[INE] {&|c|ON|OFF}                    SHIFT[INOUT] {VIS[IBLE] |
   DESCRIBE [DEPTH {1|n|ALL}]                 INV[ISIBLE]}
     [LINENUM {OFF|ON}] [INDENT {OFF|ON}]   SHOW[MODE] {OFF|ON}
   ECHO {OFF|ON}                            SQLBL[ANKLINES] {OFF|ON}
   EDITF[ILE] file_name[.ext]               SQLC[ASE] {MIX[ED] |
   EMB[EDDED] {OFF|ON}                        LO[WER] | UP[PER]}
   ERRORL[OGGING] {ON|OFF}                  SQLCO[NTINUE] {> | text}
     [TABLE [schema.]tablename]             SQLN[UMBER] {ON|OFF}
     [TRUNCATE] [IDENTIFIER identifier]     SQLPLUSCOMPAT[IBILITY] {x.y[.z]}
   ESC[APE] {\|c|OFF|ON}                    SQLPRE[FIX] {#|c}
   ESCCHAR {@|?|%|$|OFF}                    SQLP[ROMPT] {SQL>|text}
   EXITC[OMMIT] {ON|OFF}                    SQLT[ERMINATOR] {;|c|ON|OFF}
   FEED[BACK] {6|n|ON|OFF}                  SUF[FIX] {SQL|text}
   FLAGGER {OFF|ENTRY|INTERMED[IATE]|FULL}  TAB {ON|OFF}
   FLU[SH] {ON|OFF}                         TERM[OUT] {ON|OFF}
   HEA[DING] {ON|OFF}                       TI[ME] {OFF|ON}
   HEADS[EP] {||c|ON|OFF}                   TIMI[NG] {OFF|ON}
   INSTANCE [instance_path|LOCAL]           TRIM[OUT] {ON|OFF}
   LIN[ESIZE] {80|n}                        TRIMS[POOL] {OFF|ON}
   LOBOF[FSET] {1|n}                        UND[ERLINE] {-|c|ON|OFF}
   LOGSOURCE [pathname]                     VER[IFY] {ON|OFF}
   LONG {80|n}                              WRA[P] {ON|OFF}
   LONGC[HUNKSIZE] {80|n}                   XQUERY {BASEURI text|
   MARK[UP] HTML [OFF|ON]                     ORDERING{UNORDERED|
     [HEAD text] [BODY text] [TABLE text]              ORDERED|DEFAULT}|
     [ENTMAP {ON|OFF}]                        NODE{BYVALUE|BYREFERENCE|
     [SPOOL {OFF|ON}]                              DEFAULT}|
     [PRE[FORMAT] {OFF|ON}]                   CONTEXT text}

```
也可以使用`help index`命令查看SQLPlus命令清单：
```sql
SQL> help index

Enter Help [topic] for help.

 @             COPY         PAUSE                    SHUTDOWN
 @@            DEFINE       PRINT                    SPOOL
 /             DEL          PROMPT                   SQLPLUS
 ACCEPT        DESCRIBE     QUIT                     START
 APPEND        DISCONNECT   RECOVER                  STARTUP
 ARCHIVE LOG   EDIT         REMARK                   STORE
 ATTRIBUTE     EXECUTE      REPFOOTER                TIMING
 BREAK         EXIT         REPHEADER                TTITLE
 BTITLE        GET          RESERVED WORDS (SQL)     UNDEFINE
 CHANGE        HELP         RESERVED WORDS (PL/SQL)  VARIABLE
 CLEAR         HOST         RUN                      WHENEVER OSERROR
 COLUMN        INPUT        SAVE                     WHENEVER SQLERROR
 COMPUTE       LIST         SET                      XQUERY
 CONNECT       PASSWORD     SHOW

```
### describe命令
该命令用于查询指定数据表的组成结构，语法如下：
```sql
desc[ribe] object_name
```
describe可缩写为desc。

比如查询scott.emp表中SALESMAN的编号，姓名和工资，过程中，使用`#desc scott.emp`命令查询scott.emp表中工资字段的名称：
```sql
SQL> select empno,ename,
  2  #desc scott.emp
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 EMPNO                                     NOT NULL NUMBER(4)
 ENAME                                              VARCHAR2(10)
 JOB                                                VARCHAR2(9)
 MGR                                                NUMBER(4)
 HIREDATE                                           DATE
 SAL                                                NUMBER(7,2)
 COMM                                               NUMBER(7,2)
 DEPTNO                                             NUMBER(2)

  2  sal from scott.emp where job = 'SALESMAN';

     EMPNO ENAME             SAL
---------- ---------- ----------
      7499 ALLEN            1600
      7521 WARD             1250
      7654 MARTIN           1250
      7844 TURNER           1500

```
### spool命令
该命令可以将查询结果输出到指定文件中，spool的语法格式如下：
```sql
 spo[ol] [file_name[.ext] [CRE[ATE] | REP[LACE] | APP[END]] | OFF | OUT]
 ```
- `cre[ate]`，表示创建一个新的文件，默认值；

- `rep[lace]`，表示覆盖已存在的文件；

- `app[end]`，表示追加到一个已存在的文件中；

- `off|out`，表示关闭spool输出。

比如：
```sql
SQL> spool d:\emp.txt
SQL> select empno,ename,job,sal from scott.emp;

     EMPNO ENAME      JOB              SAL
---------- ---------- --------- ----------
      7369 SMITH      CLERK            800
      7499 ALLEN      SALESMAN        1600
      7521 WARD       SALESMAN        1250
      7566 JONES      MANAGER         2975
      7654 MARTIN     SALESMAN        1250
      7698 BLAKE      MANAGER         2850
      7782 CLARK      MANAGER         2450
      7788 SCOTT      ANALYST         3000
      7839 KING       PRESIDENT       5000
      7844 TURNER     SALESMAN        1500
      7876 ADAMS      CLERK           1100

     EMPNO ENAME      JOB              SAL
---------- ---------- --------- ----------
      7900 JAMES      CLERK            950
      7902 FORD       ANALYST         3000
      7934 MILLER     CLERK           1300

已选择14行。

SQL> spool off
```
到D盘打开emp.txt如下：

![mrbird_photo_20171105144257.png](img/mrbird_photo_20171105144257.png)

### define命令
该命令用来定义一个变量并赋值，基本语法如下：
```sql
 def[ine] [variable] | [variable = text]
```
比如：
```sql
SQL> define vjob='SALESMAN'
SQL> define vjob
DEFINE VJOB            = "SALESMAN" (CHAR)
```
### show命令
show命令用来显示SQLPlus系统变量的值，语法如下：
```sql
 sho[w] option
```
option表示要显示的系统选项，常用的值有：all，parameters [parameter_name]，sga，spool和user等。
```sql
SQL> show parameters db_block_size

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_block_size                        integer     8192
SQL> show sga

Total System Global Area 3373858816 bytes
Fixed Size                  2180424 bytes
Variable Size            1862273720 bytes
Database Buffers         1493172224 bytes
Redo Buffers               16232448 bytes
SQL> show user
USER 为 "SYSTEM"
```
### save命令
该命令将SQL缓冲区的最近一条SQL或PL/SQL块保存到指定的文件中，语法如下：
```sql
 sav[e] [FILE] file_name[.ext] [CRE[ATE] | REP[LACE] | APP[END]]
```
比如：
```sql
SQL> select * from scott.dept;

    DEPTNO DNAME          LOC
---------- -------------- -------------
        10 ACCOUNTING     NEW YORK
        20 RESEARCH       DALLAS
        30 SALES          CHICAGO
        40 OPERATIONS     BOSTON

SQL> save d:\dept.sql
已创建 file d:\dept.sql
```
如果不指定文件扩展名，默认为.sql。

### get命令
该命令将一个SQL脚本文件的内容放进SQL的缓冲区，语法格式如下：
```sql
 get [FILE] file_name[.ext] [LIST | NOLIST]
```
其中list表示加载到缓冲区的时候显示文件的内容，nolist则表示不显示。

比如加载d:\dept.sql到SQL缓冲区，并运行命令`/`执行该语句：
```sql
SQL> get d:\dept.sql list
  1* select * from scott.dept
SQL> /

    DEPTNO DNAME          LOC
---------- -------------- -------------
        10 ACCOUNTING     NEW YORK
        20 RESEARCH       DALLAS
        30 SALES          CHICAGO
        40 OPERATIONS     BOSTON
```

### start和@
两个命令都是用于执行一个sql脚本文件，比如：
```sql
SQL> start d:\dept.sql

    DEPTNO DNAME          LOC
---------- -------------- -------------
        10 ACCOUNTING     NEW YORK
        20 RESEARCH       DALLAS
        30 SALES          CHICAGO
        40 OPERATIONS     BOSTON

SQL> @ d:\dept.sql

    DEPTNO DNAME          LOC
---------- -------------- -------------
        10 ACCOUNTING     NEW YORK
        20 RESEARCH       DALLAS
        30 SALES          CHICAGO
        40 OPERATIONS     BOSTON
```

## 格式化查询结果

### column
该命令可以实现格式化查询结果，设置列宽，设置列标题等。语法如下：
```sql
col[umn] [column_name|alias|option]
```
`column_name`用于指定要设置的列的名称，`alias`用于指定列的别名，`option`用于指定列的显示格式，其值和说明如下表所示：


<table>
	<tr>
		<th>option选项的值</th>
		<th>说明</th>
	</tr>
	<tr>
		<td>clear</td>
		<td>清除指定列所设置的格式，恢复默认值</td>
	</tr>
	<tr>
		<td>format</td>
		<td>格式化指定列</td>
	</tr>
	<tr>
		<td>heading</td>
		<td>指定列标题</td>
	</tr>
	<tr>
		<td>justify</td>
		<td>调整列标题的对齐方式，默认情况下：数值类型的右对齐，其他类型的左对齐</td>
	</tr>
	<tr>
		<td>null</td>
		<td>替换null值</td>
	</tr>
	<tr>
		<td>print/noprint</td>
		<td>显示列标题或隐藏列标题，默认为print</td>
	</tr>
	<tr>
		<td>on/off</td>
		<td>控制定义的显示属性状态，off表示定义的所有显示属性都不起作用</td>
	</tr>
	<tr>
		<td>wrapped</td>
		<td>当字符串的长度超过显示宽度时，将字符串的超出部分折叠到下一行显示</td>
	</tr>
	<tr>
		<td>word_wrapped</td>
		<td>表示从一个完整的字符处折叠</td>
	</tr>
	<tr>
		<td>truncated</td>
		<td>表示截取字符串尾部</td>
	</tr>
</table>

**format**选项

使用format选项格式化scott.emp表中的sal列，格式为$999,999.00：
```sql
SQL> column sal format $999,999.00
SQL> select empno,ename,sal from scott.emp;

     EMPNO ENAME               SAL
---------- ---------- ------------
      7369 SMITH           $800.00
      7499 ALLEN         $1,600.00
      7521 WARD          $1,250.00
      7566 JONES         $2,975.00
      7654 MARTIN        $1,250.00
      7698 BLAKE         $2,850.00
      7782 CLARK         $2,450.00
      7788 SCOTT         $3,000.00
      7839 KING          $5,000.00
      7844 TURNER        $1,500.00
      7876 ADAMS         $1,100.00

     EMPNO ENAME               SAL
---------- ---------- ------------
      7900 JAMES           $950.00
      7902 FORD          $3,000.00
      7934 MILLER        $1,300.00

已选择14行。
```
**heading**选项

使用heading选项将scott.emp表的empno，ename和sal三个列名转换为中文：
```sql
SQL> column empno heading 员工编号
SQL> column ename heading 员工姓名
SQL> column sal heading 工资
SQL> select empno,ename,sal from scott.emp;

  员工编号 员工姓名           工资
---------- ---------- ------------
      7369 SMITH           $800.00
      7499 ALLEN         $1,600.00
      7521 WARD          $1,250.00
      7566 JONES         $2,975.00
      7654 MARTIN        $1,250.00
      7698 BLAKE         $2,850.00
      7782 CLARK         $2,450.00
      7788 SCOTT         $3,000.00
      7839 KING          $5,000.00
      7844 TURNER        $1,500.00
      7876 ADAMS         $1,100.00

  员工编号 员工姓名           工资
---------- ---------- ------------
      7900 JAMES           $950.00
      7902 FORD          $3,000.00
      7934 MILLER        $1,300.00

已选择14行。
```
**null**选项

使用null选项将scott.emp表中comm列值为null显示成“空值”：
```sql
SQL> column comm null '空值'
SQL> select empno,ename,comm from scott.emp where comm is null;

  员工编号 员工姓名         COMM
---------- ---------- ----------
      7369 SMITH      空值
      7566 JONES      空值
      7698 BLAKE      空值
      7782 CLARK      空值
      7788 SCOTT      空值
      7839 KING       空值
      7876 ADAMS      空值
      7900 JAMES      空值
      7902 FORD       空值
      7934 MILLER     空值

已选择10行。
```
**wrapped/word_wrapped**选项

使用**wrapped**选项实现按照指定长度折行：
```sql
SQL> create table test(
  2  col1 varchar2(100)
  3  );

表已创建。

SQL> insert into test(col1) values ('HOW ARE YOU?');

已创建 1 行。

SQL> select col1 from test;

COL1
--------------------------------------------------------------------------------
HOW ARE YOU?

SQL> column col1 format a5
SQL> column col1 wrapped
SQL> select col1 from test;

COL1
-----
HOW A
RE YO
U?

```
使用**word_wrapped**选项按照完整字符串折行
```sql
SQL> column col1 word_wrapped
SQL> select col1 from test;

COL1
-----
HOW
ARE
YOU?
```
### ttitle和btitle命令
这两个命令分别用来设置打印时每页的页首和页脚标题，其中ttitle语法如下（btitle语法类似）：
```sql
 tti[tle] [printspec [text|variable] ...] | [OFF|ON]
```
`printspec`作为头标题的修饰性选项，其值和说明如下表所示：

<table>
	<tr>
		<th>printspec选项的值</th>
		<th>说明</th>
	</tr>
	<tr>
		<td>col</td>
		<td>指定当前行的第几列打印头标题</td>
	</tr>
	<tr>
		<td>skip</td>
		<td>跳到从下一行开始的第几行，默认为1</td>
	</tr>
	<tr>
		<td>left</td>
		<td>在当前行中左对齐打印数据</td>
	</tr>
	<tr>
		<td>center</td>
		<td>在当前行中间打印数据</td>
	</tr>
	<tr>
		<td>right</td>
		<td>在当前行中右对齐打印数据</td>
	</tr>
	<tr>
		<td>bold</td>
		<td>以黑体打印数据</td>
	</tr>
</table>


比如：打印输出scott.salgrade数据表中的记录，并设置标题：
```SQL
SQL> set pagesize 8
SQL> ttitle left '销售情况排行表'
SQL> btitle left '打印日期2017年11月5日 打印人 MrBird'
SQL> select * from scott.salgrade;

销售情况排行表
     GRADE      LOSAL      HISAL
---------- ---------- ----------
         1        700       1200
         2       1201       1400
         3       1401       2000
打印日期2017年11月5日 打印人 MrBird

销售情况排行表
     GRADE      LOSAL      HISAL
---------- ---------- ----------
         4       2001       3000
         5       3001       9999

打印日期2017年11月5日 打印人 MrBird
```
