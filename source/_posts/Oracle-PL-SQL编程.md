---
title: Oracle PL/SQL编程
date: 2017-11-02 15:25:07
tags: [DataBase,Oracle]
---
PL/SQL(Procedural Language/SQL)是一种过程化语言，在PL/SQL 中可以通过IF 语句或LOOP 语句实现控制程序的执行流程，甚至可以定义变量，以便在语句之间传递数据信息，这样PL/SQL 语言就能够实现操控程序处理的细节过程。

PL/SQL 程序都是以块（BLOCK）为基本单位，整个PL/SQL 块分3 部分：声明部分（用DECLARE开头）、执行部分（以BEGIN 开头）和异常处理部分（以EXCEPTION 开头）：
<!--more-->
```sql
[DECLARE]
   --声明部分，可选
BEGIN
   --执行部分，必须
[EXCEPTION]
   --异常处理部分，可选
END
```
对于 PL/SQL 块中的语句，需要指出的是：每一条语句都必须以分号结束，每条SQL 语句可以写成多行的形式，同样必须使用分号来结束。另外，一行中也可以有多条SQL 语句，但是它们之间必须以分号分隔。比如：
```sql
SQL> set serveroutput on
SQL> declare
    a int:=100;
    b int:=200;
    c number;
  begin
    c:=(a+b)/(a-b);
    dbms_output.put_line(c);
  exception
    when zero_divide then
    dbms_output.put_line('除数不能为零');
  end;
  /
-3

PL/SQL 过程已成功完成。
```
其中，“set serveroutput on”命令来实现在服务端显示执行结果；“dbms_output.put_line(c);”语句用于输出信息。
## 数据类型
### 基本数据类型
**1.数值类型**

数值类型主要包括NUMBER、PLS_INTEGER 和BINARY_INTEGER 3 种基本类型。其中，NUMBER 类型的变量可以存储整数或浮点数；而BINARY_INTEGER或PLS_INTEGER 类型的变量只存储整数。

NUMBER 类型还可以通过NUMBER(P,S)的形式来格式化数字，其中，参数P表示精度，参数S表示刻度范围。精度是指数值中所有有效数字的个数。比如：
```sql
money number(9,2);
```
**2.字符类型**

字符类型主要包括 VARCHAR2、CHAR、LONG、NCHAR 和NVARCHAR2 等。这些类型的变量用来存储字符串或字符数据。

 - VARCHAR2 类型：用于存储可变长度的字符串，其语法格式为：
 ```sql
 VARCHAR2(maxlength)
 ```
 参数 maxlength表示可以存储字符串的最大长度，maxlength的最大值可以是32767 字节。

 - CHAR 类型：CHAR 类型表示指定长度的字符串，其语法格式如下：
 ```sql
 CHAR(maxlength)
 ```
 参数 maxlength 是指可存储字符串的最大长度，以字节为单位，最大为32767字节，CHAR 类型的默认最大长度为1字节。

 - LONG 类型：LONG 类型表示一个可变的字符串，最大长度是32767 字节。

 - NCHAR 和NVARCHAR2类型：这两种数据类型的长度要根据各国字符集来确定，只能具体情况具体分析。

**3.日期类型**

日期类型只有一种——DATE 类型，用来存储日期和时间信息，DATE类型的存储空间是7个字节，分别使用一个字节存储世纪、年、月、天、小时、分钟和秒。

**4.布尔类型**

布尔类型也只有一种——BOOLEAN类型，其变量值可以是TRUE、FALSE 或NULL 中的一种。

### 特殊数据类型
**1.%TYPE 类型**

使用%TYPE关键字可以声明一个与指定列名称相同的数据类型，比如声明一个与 emp 表中job 列的数据类型完全相同的变量var_job：
```sql
declare var_job emp.job%type;
```
如果emp.job 列的数据类型为VARCHAR2(10)，那么变量var_job 的数据类型也是
VARCHAR2(10)。

比如，使用%type 类型的变量输出emp 表中编号为7369 的员工名称和职务信息：
```sql
SQL> set serveroutput on
SQL> declare
   var_ename scott.emp.ename%type;
   var_job scott.emp.job%type;
  begin
   select ename,job
   into var_ename,var_job
   from scott.emp where empno=7369;
   dbms_output.put_line(var_ename||'的职务是'||var_job);
  end;
  /
SMITH的职务是CLERK

PL/SQL 过程已成功完成。
```

{% note danger %}
由于into子句中的变量只能存储一个单独的值，所以要求select 子句只能返回一行数据。若SELECT子句返回多行数据，则代码运行后会返回错误信息。
{% endnote %}

**2.RECORD 类型**

RECORD 类型也称作“记录类型”，存储由多个列值组成的一行数据。语法结构如下：
```sql
type record_type is record
(
var_member1 data_type [not null] [:=default_value],
…
var_membern data_type [not null] [:=default_value])
```
比如，声明一个记录类型emp_type，然后使用该类型的变量存储emp表中的一条记录信息，并输出这条记录信息：
```sql
SQL> set serveroutput on
SQL> declare
   type emp_type is record
   (
     var_ename varchar2(20),
     var_job varchar2(20),
     var_sal number
   );
   empinfo emp_type;
  begin
   select ename,job,sal
   into empinfo from scott.emp
   where empno=7369;
   dbms_output.put_line('雇员'||empinfo.var_ename||'的职务是'||empinfo.var_job||'，工资是'||empinfo.var_sal);
  end;
  /
雇员SMITH的职务是CLERK，工资是800

PL/SQL 过程已成功完成。
```
**3.%ROWTYPE 类型**

%ROWTYPE 类型的变量结合了%TYPE 类型和RECORD 类型变量的优点，它可以根据数据表中行的结构定义一种特殊的数据类型，用来存储从数据表中检索到的一行数据，语法如下：
```sql
rowVar_name table_name%rowtype;
```
使用%ROWTYPE改造上个RECORD类型的例子：
```sql
SQL> set serveroutput on
SQL> declare
   row_emp scott.emp%rowtype;
  begin
   select * into row_emp
   from scott.emp where empno=7369;
   dbms_output.put_line('雇员'||row_emp.ename||'的职务是'||row_emp.job||'，工资是'||row_emp.sal);
  end;
  /
雇员SMITH的职务是CLERK，工资是800

PL/SQL 过程已成功完成。
```
## 变量与常量
### 定义变量
定义变量的格式如下所示：
```sql
<变量名> <数据类型> [(长度):=<初始值>];
```
比如：
定义一个用于存储国家名称的可变字符串变量 var_countryname，该变量的最大长度
是50，并且该变量的初始值为“中国”：
```sql
var_countryname varchar2(50):='中国';
```
### 定义常量
定义常量的格式如下所示：
```sql
<常量名> constant <数据类型>:=<常量值>;
```
定义一个常量con_day，用来存储一年的天数：
```sql
con_day constant integer:=365;
```
## 流程控制
### if…then语句
其语法如下：
```sql
if < condition_expression> then
   plsql_sentence
end if;
```
如果 if 后面的条件表达式存在“并且”、“或者”、“非”等逻辑运算，则可以使用“and”、“or”、“not”等逻辑运算符。另外，如果要判断if后面的条件表达式的值为空值，则需要在条件表达式中使用“is”和“null”关键字。
### if…then…else语句
其语法如下：
```sql
if <condition_expression> then
   plsql_sentence1;
else
   plsql_sentence2;
end if;
```
### if...then...elsif语句
其语法如下：
```sql
if < condition_expression1 > then
   plsql_sentence_1;
elsif < condition_expression2 > then
   plsql_sentence_2;
   ...
else
   plsql_sentence_n;
end if;
```
### case语句
其语法如下：
```sql
case < selector>
   when <expression_1> then 
      plsql_sentence_1;
   when <expression_2> then 
      plsql_sentence_2;
   ...
   when <expression_n> then 
      plsql_sentence_n;
   [else plsql_sentence;]
end case;
```
### loop语句
loop 语句会先执行一次循环体，然后再判断“exit when”关键字后面的条件表达式的值是true 还是false，如果是true，则程序会退出循环体，否则程序将再次执行循环体，这样就使得程序至少能够执行一次循环体，语法如下：
```sql
loop
   plsql_sentence;
   exit when end_condition_ exp;
end loop;
```
比如计算1到100自然数的和：
```sql
SQL> set serveroutput on
SQL> declare
    sum_i int:=0;
    i int:=0;
  begin
   loop
    i:=i+1;
    sum_i:=sum_i+i;
   exit when i>=100;
   end loop;
   dbms_output.put_line('自然数1到100的和为：'||sum_i);
  end;
  /
自然数1到100的和为：5050

PL/SQL 过程已成功完成。
```
### while语句
语法如下：
```sql
while condition_expression loop
   plsql_sentence;
end loop;
```
使用 while 语句求得前100 个自然数的和：
```sql
SQL> set serveroutput on
SQL> declare
     sum_i int:=0;
     i int:=0;
  begin
   while i<=99 loop
     i:=i+1;
     sum_i:=sum_i+i;
   end loop;
   dbms_output.put_line('自然数1到100的和为：'||sum_i);
  end;
  /
自然数1到100的和为：5050

PL/SQL 过程已成功完成。
```
### for语句
语法如下：
```sql
for variable_ counter_name in [reverse] lower_limit..upper_limit loop
   plsql_sentence;
end loop;
```
- `variable_ counter_name`：表示一个变量，通常为整数类型，用来作为计数器。默认情况下计数器的值会循环递增，当在循环中使用`reverse`关键字时，计数器的值会随循环递减。

- `lower_limit`：计数器的下限值，当计数器的值小于下限值时，程序终止for循环。

- `upper_limit`：计数器的上限值，当计数器的值大于上限值时，程序终止for循环。

比如，使用 for 语句求得前100 个自然数中奇数之和，
```sql
SQL> set serveroutput on
SQL> declare
    i int:=0;
    sum_i int:=0;
  begin
    for i in reverse 1..100 loop
      if mod(i,2)!=0 then
        sum_i:=sum_i+i;
      end if;
    end loop;
    dbms_output.put_line('自然数1到100的奇数和为：'||sum_i);
  end;
  /
自然数1到100的奇数和为：2500

PL/SQL 过程已成功完成。
```
在上面的for 语句中，由于使用了关键字“reverse”，表示计数器i 的值为递减状态，即i 的初始值为100，随着每次递减1，最后一次for 循环时i 的值变为1。如果在for 语句中不使用关键字“reverse”，则表示计数器i 的值为递增状态，即i 的初始值为1。
## 游标
游标分为显式游标和隐式游标。
### 显式游标
显式游标是由用户声明和操作的一种游标，通常用于操作查询结果集，使用它处理数据的步骤包括：声明游标、打开游标、读取游标和关闭游标4个步骤。

**1.声明游标**

声明游标主要包括游标名称和为游标提供结果集的 SELECT 语句。语法如下：
```sql
cursor cur_name[(input_parameter1[,input_parameter2]…)]
   [return ret_type]
is select_ sentence;
```
- `cur_name`：表示所声明的游标名称。

- `ret_type`：表示执行游标操作后的返回值类型，这是一个可选项。

- `select_ sentence`：游标所使用的SELECT 语句，它为游标的反复读取提供了结果集。

- `input_parameter1`：作为游标的“输入参数”，可以有多个，这是一个可选项。

比如声明一个游标，用来读取emp 表中职务为销售员（SALESMAN）的雇员信息：
```sql
SQL> declare
   cursor cur_emp(var_job in varchar2:='SALESMAN')
   is select empno,ename,sal
      from emp
      where job=var_job;
```
{% note danger %}
输入参数var_job类型为varchar2，但不可以指定长度，如：varchar2(10)，否则程序报错。
{% endnote %}

**2.打开游标**

打开游标的语法格式如下：
```sql
open cur_name[(para_value1[,para_value2]…)];
```
比如：
```sql
open cur_emp('MANAGER');
```
上面这条语句表示打开游标 cur_emp，然后给游标的“输入参数”赋值为“MANAGER”。当然这里可以省略“('MANAGER')”，这样表示“输入参数”的值仍然使用其初始值（即SALESMAN）。

**3.读取游标**

当打开一个游标之后，就可以读取游标中的数据了其语法格式如下：
```sql
fetch cur_name into {variable};
```
- `cur_name`：要读取的游标名称。

- `variable`：%RECORD类型或者%ROWTYPE类型变量。

**4.关闭游标**

游标使用完毕后需要关闭，以释放系统资源，比如 SELECT 语句返回的结果集等。它的语法格式如下：
```sql
close cur_name;
```
### 游标的属性
无论是显式游标还是隐式游标，都具有%found、%notfound、%isopen 和%rowcount4个属性，通过这4个属性可以获知SQL语句的执行结果以及该游标的状态信息：

1. %found：布尔型属性，如果SQL 语句至少影响到一行数据，则该属性为true，否则为fasle。

2. %notfound：布尔型属性，与%found 属性的功能相反。

3. %rowcount：数字型属性，返回受SQL 语句影响的行数。

4. %isopen：布尔型属性，当游标已经打开时返回true，游标关闭时则为false。

下面举个使用显式游标的例子：
```sql
SQL> set serveroutput on
SQL> declare
   cursor cur_emp(var_job in varchar2:='SALESMAN')
   is
    select * from scott.emp where job=var_job;
   row_emp scott.emp%rowtype;
  begin
   open cur_emp;
   fetch cur_emp into row_emp;   //先让指针指向结果集中的第一行，并将值保存到row_emp中
   while cur_emp%found loop
     dbms_output.put_line('雇员'||row_emp.ename||'的编号是'||row_emp.empno||'，工资是：'||row_emp.sal);
     fetch cur_emp into row_emp;  //让指针指向结果集中的下一行，并将值保存到row_emp中
   end loop;
   close cur_emp;
  end;
  /
雇员ALLEN的编号是7499，工资是：1600
雇员WARD的编号是7521，工资是：1250
雇员MARTIN的编号是7654，工资是：1250
雇员TURNER的编号是7844，工资是：1500

PL/SQL 过程已成功完成。
```
### 隐式游标
在执行一个 SQL 语句时，Oracle 会自动创建一个隐式游标。这个游标是内存中处理该语句的工作区域。隐式游标主要是处理数据操纵语句（如UPDATE、DELETE 语句）的执行结果，当然特殊情况下，也可以处理SELECT 语句的查询结果。由于隐式游标也有属性，当使用隐式游标的属性时，需要在属性前面加上隐式游标的默认名称——sql。

在实际的 PL/SQL 编程中，经常使用隐式游标来判断更新数据行或删除数据行的情况。

比如把scott.emp表中销售员（即SALESMAN）的工资上调20%，然后使用隐式游标sql的%rowcount属性输出上调工资的员工数量：
```sql
SQL> set serveroutput on
SQL> begin
    update scott.emp
    set sal=sal*1.2 where job='SALESMAN';
   if sql%notfound then
    dbms_output.put_line('没有雇员需要上调工资');
   else
    dbms_output.put_line('有'||sql%rowcount||'个雇员工资上调20%');
   end if;
  end;
  /
有4个雇员工资上调20%

PL/SQL 过程已成功完成。
```
### 通过for语句循环游标
在使用隐式游标或显式游标处理具有多行数据的结果集时，用户可以配合for语句来完成。在使用for语句遍历游标中的数据时，可以把它的计时器看做一个自动的RECORD类型的变量。

比如使用for遍历一个隐式游标：
```sql
SQL> set serveroutput on
SQL> begin
   for emp_record in (select * from scott.emp where job='SALESMAN') loop
     dbms_output.put_line('雇员编号：'||emp_record.empno||'，雇员姓名：'||emp_record.ename||'，工资为：'||emp_record);
   end loop;
  end;
  /
雇员编号：7499，雇员姓名：ALLEN，工资为：1920
雇员编号：7521，雇员姓名：WARD，工资为：1500
雇员编号：7654，雇员姓名：MARTIN，工资为：1500
雇员编号：7844，雇员姓名：TURNER，工资为：1800

PL/SQL 过程已成功完成。
```
## 异常
在编写PL/SQL程序时，避免不了会发生一些异常。Oracle 系统异常分为预定义异常和自定义异常。
### 预定义异常
Oracle系统常见的预定义异常及其说明如下表所示：
<table>
	<tr>
		<th>系统预定义异常</th>
		<th>说明</th>
	</tr>
	<tr>
		<td>ZERO_DIVIDE</td>
		<td>除数为零时引发的异常</td>
	</tr>
	<tr>
		<td>ACCESS_INTO_NULL</td>
		<td>企图为某个未初始化对象的属性赋值</td>
	</tr>
	<tr>
		<td>COLLECTION_IS_NULL</td>
		<td>企图使用未初始化的集合元素</td>
	</tr>
	<tr>
		<td>CURSOR_ALREADY_OPEN</td>
		<td>企图再次打开一个已经打开过的游标，但在重新打开之前，游标未关闭</td>
	</tr>
	<tr>
		<td>INVALID_CURSOR</td>
		<td>执行一个非法的游标操作，例如，关闭一个未打开的游标</td>
	</tr>
	<tr>
		<td>INVALID_NUMBER</td>
		<td>企图将一个字符串转换成一个无效的数字而失败</td>
	</tr>
	<tr>
		<td>LOGIN_DENIED</td>
		<td>企图使用无效的用户名或密码连接数据库</td>
	</tr>
	<tr>
		<td>NO_DATA_FOUND</td>
		<td>SELECT INTO 语句没有返回数据</td>
	</tr>
	<tr>
		<td>ROWTYPE_MISMATCH</td>
		<td>主游标变量与PL/SQL 游标变量的返回类型不兼容</td>
	</tr>
	<tr>
		<td>SELF_IS_NULL</td>
		<td>使用对象类型时，使用空对象调用其方法</td>
	</tr>
	<tr>
		<td>SUBSCRIPT_BEYOND_COUNT</td>
		<td>元素下标超过嵌套表或VARRAY 的最大值</td>
	</tr>
	<tr>
		<td>SUBSCRIPT_OUTSIDE_LIMIT</td>
		<td>企图使用非法索引号引用嵌套表或VARRAY 中的元素</td>
	</tr>
	<tr>
		<td>SYS_INVALID_ROWID</td>
		<td>字符串向ROWID 转换时的错误，因为该字符串不是一个有效的ROWID 值</td>
	</tr>
	<tr>
		<td>TIMEOUT_ON_RESOURCE</td>
		<td>Oracle 在等待资源时超时</td>
	</tr>
	<tr>
		<td>TOO_MANY_ROWS</td>
		<td>执行SELECT INTO 语句时，结果集超过一行引发的异常</td>
	</tr>
</table>

比如：
```sql
SQL> set serveroutput on
SQL> declare
   var_empno number;
   var_ename varchar2(50);
  begin
   select empno,ename into var_empno,var_ename
   from scott.emp where deptno=10;
   if sql%found then
    dbms_output.put_line('雇员编号：'||var_empno);
   end if;
  exception
   when too_many_rows then
    dbms_output.put_line('返回记录超过一行');
   when no_data_found then
    dbms_output.put_line('无数据');
  end;
  /
返回记录超过一行

PL/SQL 过程已成功完成。
```
### 自定义异常
Oracle的自定义异常就可以分为错误编号异常和业务逻辑异常两种。

**1.错误编号异常**

错误编号异常是指在Oracle系统发生错误时，系统会显示错误编号和相关描述信息的异常，比如：
```sql
SQL> insert into scott.dept values(10,'开发一部','福州');
insert into scott.dept values(10,'开发一部','福州')
*
第 1 行出现错误:
ORA-00001: 违反唯一约束条件 (SCOTT.PK_DEPT)
```
对于这种异常，首先在PL/SQL块的声明部分（DECLARE 部分）使用`EXCEPTION`类型定义一个异常变量名，然后使用语句`PRAGMA EXCEPTION_INIT`为“错误编号”关联这个异常变量名，接下来就可以像对待系统预定义异常一样处理了。比如：
```sql
SQL> set serveroutput on
SQL> declare
   primary_iterant exception;
   pragma exception_init(primary_iterant,-00001);
 begin
   insert into scott.dept values(10,'开发一部','福州');
 exception
   when primary_iterant then
     dbms_output.put_line('主键重复！');
 end;
 /
主键重复！

PL/SQL 过程已成功完成。
```
**2.业务异常**

程序开发人员可以根据具体的业务逻辑规则自定义一个异常。业务逻辑异常是Oracle系统本身无法知道的，这样就需要有一个引发异常的机制，引发业务逻辑异常通常使用`RAISE` 语句来实现。

比如，自定义一个异常变量，在向dept表中插入数据时，若判断loc字段的值为null，则使用raise语句引发异常：
```sql
SQL> set serveroutput on
SQL> declare
    null_exception exception;
    dept_row scott.dept%rowtype;
  begin
    dept_row.deptno:=66;
    dept_row.dname:='开发二部';
    insert into scott.dept
    values(dept_row.deptno,dept_row.dname,dept_row.loc);
    if dept_row.loc is null then
      raise null_exception;
    end if;
  exception
    when null_exception then
       dbms_output.put_line('loc字段不能为空！');
    rollback;
  end;
  /
loc字段不能为空！

PL/SQL 过程已成功完成。
```