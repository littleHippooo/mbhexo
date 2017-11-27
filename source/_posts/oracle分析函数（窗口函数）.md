---
title: Oracle分析函数（窗口函数）
date: 2017-11-10 14:40:47
tags: [DataBase,Oracle,Oracle 11g]
---
Oracle 中的分析函数基于对数据行的分组来计算相关值，类似于聚合函数。其和聚合函数主要的区别在于：分析函数对于每个分组返回多行数据，而聚合函数每个分组只能对应一行数据。

分析函数由三个部分组成：分区子句、排序子句和开窗子句，基本语法如下：
```sql
function(arg1,arg2,...argN)
over([partition-by-clause] [order-by-clause] [windowing-clause])
```
<!--more-->
开窗子句windowing-clause 指定了分析函数进行运算的数据子集。开窗子句的具体语法如下：
```sql
[rows | range] between <start expr> and <end expr>

<start expr> is [unbounded preceding | current row | n preceding | n following]
<end expr> is [unbounded following | current row | n preceding | n following]
```
- `unbounded preceding`表示以分组数据的第一行最为上边界；

- `unbounded following`表示以分组数据的最后一行最为下边界；

- `current row`表示当前数据行；

- `n preceding`表示当前数据行的前n 行；

- `n following`表示当前数据行的后n 行。

为了演示分析函数，首先在SH用户下创建一张sales_fact表：
```sql
SQL> create table sales_fact as
  select country_name country,country_subRegion region,prod_name product,
  calendar_year year,calendar_week_number week,
  sum(amount_sold) sale,
  sum(amount_sold*( case
   when mod(rownum,10)=0 then 1.4
   when mod(rownum,5)=0 then 0.6
   when mod(rownum,2)=0 then 0.9
   when mod(rownum,2)=1 then 1.2
   else 1 end)) receipts
  from sales,times,customers,countries,products
  where sales.time_id=times.time_id and
  sales.prod_id = products.prod_id and
  sales.cust_id = customers.cust_id and
  customers.country_id = countries.country_id
  group by
  country_name,country_subRegion,prod_name,calendar_year,calendar_week_number;

表已创建。
```
## 分析模式下的聚合函数
前面所说聚合函数每个分组只能对应一行数据是在传统的非分析模式下的结果。分析模式下的聚合函数则没有此限制。

比如下面的SQL语句计算了sale列按照产品，国家，地区和年份为一组，从每年年初开始到该年份每一周的动态求和值。（为了节约篇幅，下面结果只取前10周结果集）。
```sql
SQL>  select year,week,sale,
  sum(sale) over(
   partition by product,country,region,year
   order by week
   rows between unbounded preceding and current row
  ) running_sum_sale
  from sales_fact
  where country in ('Australia') and product = 'Xtend Memory' and week <= 10
  order by year,week;

      YEAR       WEEK       SALE RUNNING_SUM_SALE
---------- ---------- ---------- ----------------
      1998          1      58.15            58.15
      1998          2      29.39            87.54
      1998          3      29.49           117.03
      1998          4      29.49           146.52
      1998          5       29.8           176.32
      1998          6      58.78            235.1
      1998          9      58.78           293.88
      1998         10     117.76           411.64
      1999          1      53.52            53.52
      1999          3       94.6           148.12
      1999          4       40.5           188.62
      1999          5      80.01           268.63
      1999          6       40.5           309.13
      1999          8     103.11           412.24
      1999          9      53.34           465.58
      1999         10         72           537.58
      2000          1       46.7             46.7
      2000          3      93.41           140.11
      2000          4      46.54           186.65
      2000          5       46.7           233.35
      2000          7       70.8           304.15
      2000          8      46.54           350.69
      2001          1      92.26            92.26
      2001          2     118.38           210.64
      2001          3      47.24           257.88
      2001          4      256.7           514.58
      2001          5      93.44           608.02
      2001          6      22.44           630.46
      2001          7      69.96           700.42
      2001          8      46.06           746.48
      2001          9      92.67           839.15
      2001         10      69.05            908.2

已选择32行。
```
聚合函数`sum(sale)`声明要求和的列，`partition by product,country,region,year`分区子句声明了分组的列，`order by week`排序子句声明了分组的数据行按照week列来进行排序，`rows between unbounded preceding and current row`开窗子句声明了计算的窗口范围为分组的第一行到当前行。

下面例子的窗口范围为整个分组：
```sql
SQL> select year,week,sale,
  max(sale) over(
   partition by product,country,region,year
   order by week
   rows between unbounded preceding and unbounded following
  ) max_sal_per_year
  from sales_fact
  where country in ('Australia') and product = 'Xtend Memory' and week <= 10
  order by year,week;

      YEAR       WEEK       SALE MAX_SAL_PER_YEAR
---------- ---------- ---------- ----------------
      1998          1      58.15           117.76
      1998          2      29.39           117.76
      1998          3      29.49           117.76
      1998          4      29.49           117.76
      1998          5       29.8           117.76
      1998          6      58.78           117.76
      1998          9      58.78           117.76
      1998         10     117.76           117.76
      1999          1      53.52           103.11
      1999          3       94.6           103.11
      1999          4       40.5           103.11
      1999          5      80.01           103.11
      1999          6       40.5           103.11
      1999          8     103.11           103.11
      1999          9      53.34           103.11
      1999         10         72           103.11
      2000          1       46.7            93.41
      2000          3      93.41            93.41
      2000          4      46.54            93.41
      2000          5       46.7            93.41
      2000          7       70.8            93.41
      2000          8      46.54            93.41
      2001          1      92.26            256.7
      2001          2     118.38            256.7
      2001          3      47.24            256.7
      2001          4      256.7            256.7
      2001          5      93.44            256.7
      2001          6      22.44            256.7
      2001          7      69.96            256.7
      2001          8      46.06            256.7
      2001          9      92.67            256.7
      2001         10      69.05            256.7

已选择32行。
```
下面例子的窗口范围为当前周的前两周和后两周，也就是五周。在分组的边界处，窗口会自动缩小：
```sql
SQL> select year,week,sale,
  max(sale) over(
   partition by product,country,region,year
   order by week
   rows between 2 preceding and 2 following
  ) max_sal_per_year
  from sales_fact
  where country in ('Australia') and product = 'Xtend Memory' and week <= 10
  order by year,week;

      YEAR       WEEK       SALE MAX_SAL_PER_YEAR
---------- ---------- ---------- ----------------
      1998          1      58.15            58.15
      1998          2      29.39            58.15
      1998          3      29.49            58.15
      1998          4      29.49            58.78
      1998          5       29.8            58.78
      1998          6      58.78           117.76
      1998          9      58.78           117.76
      1998         10     117.76           117.76
      1999          1      53.52             94.6
      1999          3       94.6             94.6
      1999          4       40.5             94.6
      1999          5      80.01           103.11
      1999          6       40.5           103.11
      1999          8     103.11           103.11
      1999          9      53.34           103.11
      1999         10         72           103.11
      2000          1       46.7            93.41
      2000          3      93.41            93.41
      2000          4      46.54            93.41
      2000          5       46.7            93.41
      2000          7       70.8             70.8
      2000          8      46.54             70.8
      2001          1      92.26           118.38
      2001          2     118.38            256.7
      2001          3      47.24            256.7
      2001          4      256.7            256.7
      2001          5      93.44            256.7
      2001          6      22.44            256.7
      2001          7      69.96            93.44
      2001          8      46.06            92.67
      2001          9      92.67            92.67
      2001         10      69.05            92.67

已选择32行。
```
{% note danger %}
默认的窗口子句是`rows between unbounded preceding and current row`。
{% endnote %}

## lag和lead
lag和lead函数能够实现跨行引用。lag能够访问结果集中前面行内容，lead能够访问结果集中后面行内容。

{% note danger %}
lag和lead函数不支持开窗子句，仅支持`partition by`和`order by`子句。
{% endnote %}

### lag
lag函数的语法如下：
```sql
lag(expression, offset, default) over(partition-clause order-by-clause)
```
`expression`表示返回的列，`offset`表示相隔的行数（不能为负数），default表示默认值。

比如，从前一行中返回一个值：
```sql
SQL>  select year,week,sale,
   lag(sale) over(
   partition by product,country,region,year
   order by week
   ) prior_wk_sales
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week;

      YEAR       WEEK       SALE PRIOR_WK_SALES
---------- ---------- ---------- --------------
      1998          1      58.15
      1998          2      29.39          58.15
      1998          3      29.49          29.39
      1998          4      29.49          29.49
      1998          5       29.8          29.49
      1998          6      58.78           29.8
      1998          9      58.78          58.78
      1998         10     117.76          58.78
      1999          1      53.52
      1999          3       94.6          53.52
      1999          4       40.5           94.6
      1999          5      80.01           40.5
      1999          6       40.5          80.01
      1999          8     103.11           40.5
      1999          9      53.34         103.11
      1999         10         72          53.34
      2000          1       46.7
      2000          3      93.41           46.7
      2000          4      46.54          93.41
      2000          5       46.7          46.54
      2000          7       70.8           46.7
      2000          8      46.54           70.8
      2001          1      92.26
      2001          2     118.38          92.26
      2001          3      47.24         118.38
      2001          4      256.7          47.24
      2001          5      93.44          256.7
      2001          6      22.44          93.44
      2001          7      69.96          22.44
      2001          8      46.06          69.96
      2001          9      92.67          46.06
      2001         10      69.05          92.67

已选择32行。
```
可见lag函数在分区的上边界返回空值，默认行数为1。

指定lag函数的默认值，并指定行数为3：
```sql
SQL>  select year,week,sale,
   lag(sale,3,sale) over(
   partition by product,country,region,year
   order by week
   ) prior_wk_sales
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week;

      YEAR       WEEK       SALE PRIOR_WK_SALES
---------- ---------- ---------- --------------
      1998          1      58.15          58.15
      1998          2      29.39          29.39
      1998          3      29.49          29.49
      1998          4      29.49          58.15
      1998          5       29.8          29.39
      1998          6      58.78          29.49
      1998          9      58.78          29.49
      1998         10     117.76           29.8
      1999          1      53.52          53.52
      1999          3       94.6           94.6
      1999          4       40.5           40.5
      1999          5      80.01          53.52
      1999          6       40.5           94.6
      1999          8     103.11           40.5
      1999          9      53.34          80.01
      1999         10         72           40.5
      2000          1       46.7           46.7
      2000          3      93.41          93.41
      2000          4      46.54          46.54
      2000          5       46.7           46.7
      2000          7       70.8          93.41
      2000          8      46.54          46.54
      2001          1      92.26          92.26
      2001          2     118.38         118.38
      2001          3      47.24          47.24
      2001          4      256.7          92.26
      2001          5      93.44         118.38
      2001          6      22.44          47.24
      2001          7      69.96          256.7
      2001          8      46.06          93.44
      2001          9      92.67          22.44
      2001         10      69.05          69.96

已选择32行。
```
### lead
lead和lag类似。不再赘述。

## first_value和last_value
first_value和last_value函数通常与order by语句配合来筛选出分区中的最大值和最小值。它们都支持开窗子句。

### first_value
first_value返回窗口中的第一个值。ignore nulls表示忽略空值，如果第一个是空值返回第二个：
```sql
SQL>  select year,week,sale,
   first_value(sale ignore nulls) over(
   partition by product,country,region,year
   order by sale desc
   rows between unbounded preceding and unbounded following
   ) max_sale
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week;

      YEAR       WEEK       SALE   MAX_SALE
---------- ---------- ---------- ----------
      1998          1      58.15     117.76
      1998          2      29.39     117.76
      1998          3      29.49     117.76
      1998          4      29.49     117.76
      1998          5       29.8     117.76
      1998          6      58.78     117.76
      1998          9      58.78     117.76
      1998         10     117.76     117.76
      1999          1      53.52     103.11
      1999          3       94.6     103.11
      1999          4       40.5     103.11
      1999          5      80.01     103.11
      1999          6       40.5     103.11
      1999          8     103.11     103.11
      1999          9      53.34     103.11
      1999         10         72     103.11
      2000          1       46.7      93.41
      2000          3      93.41      93.41
      2000          4      46.54      93.41
      2000          5       46.7      93.41
      2000          7       70.8      93.41
      2000          8      46.54      93.41
      2001          1      92.26      256.7
      2001          2     118.38      256.7
      2001          3      47.24      256.7
      2001          4      256.7      256.7
      2001          5      93.44      256.7
      2001          6      22.44      256.7
      2001          7      69.96      256.7
      2001          8      46.06      256.7
      2001          9      92.67      256.7
      2001         10      69.05      256.7

已选择32行。
```
### last_value
last_value返回窗口中的最后一个值。respect nulls表示识别空值，如果最后一个是空值也将其返回。
```sql
SQL>  select year,week,sale,
   last_value(sale respect nulls) over(
   partition by product,country,region,year
   order by sale desc
   rows between unbounded preceding and unbounded following
   ) min_sale
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week;

      YEAR       WEEK       SALE   MIN_SALE
---------- ---------- ---------- ----------
      1998          1      58.15      29.39
      1998          2      29.39      29.39
      1998          3      29.49      29.39
      1998          4      29.49      29.39
      1998          5       29.8      29.39
      1998          6      58.78      29.39
      1998          9      58.78      29.39
      1998         10     117.76      29.39
      1999          1      53.52       40.5
      1999          3       94.6       40.5
      1999          4       40.5       40.5
      1999          5      80.01       40.5
      1999          6       40.5       40.5
      1999          8     103.11       40.5
      1999          9      53.34       40.5
      1999         10         72       40.5
      2000          1       46.7      46.54
      2000          3      93.41      46.54
      2000          4      46.54      46.54
      2000          5       46.7      46.54
      2000          7       70.8      46.54
      2000          8      46.54      46.54
      2001          1      92.26      22.44
      2001          2     118.38      22.44
      2001          3      47.24      22.44
      2001          4      256.7      22.44
      2001          5      93.44      22.44
      2001          6      22.44      22.44
      2001          7      69.96      22.44
      2001          8      46.06      22.44
      2001          9      92.67      22.44
      2001         10      69.05      22.44

已选择32行。
```
## nth_value
nth_value函数用于返回任意行的数据，语法如下：
```sql
nth_value(measure, n) [from first | from last] [respect nulls | ignore nulls]
over(partition-clause order-by-clause windowing-clause)
```
比如`first_value(sale)`等价于`nth_value(sale,1)`；`first_value(sale ignore nulls)`等价于`nth_value(sale,1) from first ignore nulls`。

比如求得分区内第二大的sale值大小：
```sql
SQL>  select year,week,sale,
   nth_value(sale,2) ignore nulls over(
   partition by product,country,region,year
   order by sale desc
   rows between unbounded preceding and unbounded following
   ) second_max_sale
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week;

      YEAR       WEEK       SALE SECOND_MAX_SALE
---------- ---------- ---------- ---------------
      1998          1      58.15           58.78
      1998          2      29.39           58.78
      1998          3      29.49           58.78
      1998          4      29.49           58.78
      1998          5       29.8           58.78
      1998          6      58.78           58.78
      1998          9      58.78           58.78
      1998         10     117.76           58.78
      1999          1      53.52            94.6
      1999          3       94.6            94.6
      1999          4       40.5            94.6
      1999          5      80.01            94.6
      1999          6       40.5            94.6
      1999          8     103.11            94.6
      1999          9      53.34            94.6
      1999         10         72            94.6
      2000          1       46.7            70.8
      2000          3      93.41            70.8
      2000          4      46.54            70.8
      2000          5       46.7            70.8
      2000          7       70.8            70.8
      2000          8      46.54            70.8
      2001          1      92.26          118.38
      2001          2     118.38          118.38
      2001          3      47.24          118.38
      2001          4      256.7          118.38
      2001          5      93.44          118.38
      2001          6      22.44          118.38
      2001          7      69.96          118.38
      2001          8      46.06          118.38
      2001          9      92.67          118.38
      2001         10      69.05          118.38

已选择32行。
```
## rank
rank函数以数值的形式返回一个数据行在排序后的结果集中的位置。在排名并列的情况下，具有相同值的行将具有相同的排名，并且接下来的排名会被跳过。

rank函数不支持开窗子句，作用于整个分区：
```sql
SQL>  select * from (
   select year,week,sale,
   rank() over(
   partition by product,country,region,year
   order by sale desc
   ) sales_rank
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week
   ) order by year,sales_rank;

      YEAR       WEEK       SALE SALES_RANK
---------- ---------- ---------- ----------
      1998         10     117.76          1
      1998          6      58.78          2
      1998          9      58.78          2
      1998          1      58.15          4
      1998          5       29.8          5
      1998          4      29.49          6
      1998          3      29.49          6
      1998          2      29.39          8
      1999          8     103.11          1
      1999          3       94.6          2
      1999          5      80.01          3
      1999         10         72          4
      1999          1      53.52          5
      1999          9      53.34          6
      1999          4       40.5          7
      1999          6       40.5          7
      2000          3      93.41          1
      2000          7       70.8          2
      2000          1       46.7          3
      2000          5       46.7          3
      2000          4      46.54          5
      2000          8      46.54          5
      2001          4      256.7          1
      2001          2     118.38          2
      2001          5      93.44          3
      2001          9      92.67          4
      2001          1      92.26          5
      2001          7      69.96          6
      2001         10      69.05          7
      2001          3      47.24          8
      2001          8      46.06          9
      2001          6      22.44         10

已选择32行。
```
## dense_rank
dense_rank函数是rank函数的变体，区别在于dense_rank函数的排名值是连续的：
```sql
SQL>  select * from (
   select year,week,sale,
   dense_rank() over(
   partition by product,country,region,year
   order by sale desc
   ) sales_dense_rank
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week
   ) order by year,sales_dense_rank;

      YEAR       WEEK       SALE SALES_DENSE_RANK
---------- ---------- ---------- ----------------
      1998         10     117.76                1
      1998          6      58.78                2
      1998          9      58.78                2
      1998          1      58.15                3
      1998          5       29.8                4
      1998          4      29.49                5
      1998          3      29.49                5
      1998          2      29.39                6
      1999          8     103.11                1
      1999          3       94.6                2
      1999          5      80.01                3
      1999         10         72                4
      1999          1      53.52                5
      1999          9      53.34                6
      1999          4       40.5                7
      1999          6       40.5                7
      2000          3      93.41                1
      2000          7       70.8                2
      2000          1       46.7                3
      2000          5       46.7                3
      2000          4      46.54                4
      2000          8      46.54                4
      2001          4      256.7                1
      2001          2     118.38                2
      2001          5      93.44                3
      2001          9      92.67                4
      2001          1      92.26                5
      2001          7      69.96                6
      2001         10      69.05                7
      2001          3      47.24                8
      2001          8      46.06                9
      2001          6      22.44               10

已选择32行。
```
## row_number
row_number函数为结果集中的每一行分配一个递增行编号，支持开窗子句。如果存在值相同的数据行，谁先谁后具有不确定性。
```sql
SQL>  select year,week,sale,
   row_number() over(
   partition by product,country,region,year
   order by sale
   ) sales_rn
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,sale;

      YEAR       WEEK       SALE   SALES_RN
---------- ---------- ---------- ----------
      1998          2      29.39          1
      1998          3      29.49          2
      1998          4      29.49          3
      1998          5       29.8          4
      1998          1      58.15          5
      1998          9      58.78          6
      1998          6      58.78          7
      1998         10     117.76          8
      1999          4       40.5          1
      1999          6       40.5          2
      1999          9      53.34          3
      1999          1      53.52          4
      1999         10         72          5
      1999          5      80.01          6
      1999          3       94.6          7
      1999          8     103.11          8
      2000          4      46.54          1
      2000          8      46.54          2
      2000          5       46.7          3
      2000          1       46.7          4
      2000          7       70.8          5
      2000          3      93.41          6
      2001          6      22.44          1
      2001          8      46.06          2
      2001          3      47.24          3
      2001         10      69.05          4
      2001          7      69.96          5
      2001          1      92.26          6
      2001          9      92.67          7
      2001          5      93.44          8
      2001          2     118.38          9
      2001          4      256.7         10

已选择32行。
```
## ratio_to_report
ratio_to_report函数用于计算当前行的值占分区总和的值的百分比，该函数没有排序和开窗子句。

比如计算当前周的销售额在该年以及所有销售额中的百分比：
```sql
SQL>  select year,week,sale,
   trunc(100*ratio_to_report(sale) over(partition by product,country,region,year),2) || '%' p1,
   trunc(100*ratio_to_report(sale) over(partition by product,country,region),2) || '%' p2
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week <= 10
   order by product,country,year,week;

      YEAR       WEEK       SALE P1              P2                
---------- ---------- ---------- --------------- -----------------
      1998          1      58.15 14.12%          2.63%
      1998          2      29.39 7.13%           1.33%
      1998          3      29.49 7.16%           1.33%
      1998          4      29.49 7.16%           1.33%
      1998          5       29.8 7.23%           1.34%
      1998          6      58.78 14.27%          2.66%
      1998          9      58.78 14.27%          2.66%
      1998         10     117.76 28.6%           5.33%
      1999          1      53.52 9.95%           2.42%
      1999          3       94.6 17.59%          4.28%
      1999          4       40.5 7.53%           1.83%
      1999          5      80.01 14.88%          3.62%
      1999          6       40.5 7.53%           1.83%
      1999          8     103.11 19.18%          4.66%
      1999          9      53.34 9.92%           2.41%
      1999         10         72 13.39%          3.26%
      2000          1       46.7 13.31%          2.11%
      2000          3      93.41 26.63%          4.23%
      2000          4      46.54 13.27%          2.1%
      2000          5       46.7 13.31%          2.11%
      2000          7       70.8 20.18%          3.2%
      2000          8      46.54 13.27%          2.1%
      2001          1      92.26 10.15%          4.17%
      2001          2     118.38 13.03%          5.36%
      2001          3      47.24 5.2%            2.13%
      2001          4      256.7 28.26%          11.62%
      2001          5      93.44 10.28%          4.23%
      2001          6      22.44 2.47%           1.01%
      2001          7      69.96 7.7%            3.16%
      2001          8      46.06 5.07%           2.08%
      2001          9      92.67 10.2%           4.19%
      2001         10      69.05 7.6%            3.12%

已选择32行。
```
## ntile
ntile函数对一个分区中的有序结果集进行划分，分为若干个组，如果不能够等分，则每个组中相差的数据行不能超过一行，并为每个小组分配唯一的组编号。该函数不支持开窗子句。

比如将2001年的销售额数据行分为十个小组：
```sql
SQL>  select year,week,sale,
   ntile(10) over(
   partition by product,country,region,year
   order by sale
   ) group#
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and year=2001;

      YEAR       WEEK       SALE     GROUP#
---------- ---------- ---------- ----------
      2001         18      22.37          1
      2001         23      22.38          1
      2001          6      22.44          1
      2001         52      23.14          1
      2001         50      23.14          1
      2001         44      23.29          2
      2001         40      45.18          2
      2001         49      45.26          2
      2001          8      46.06          2
      2001          3      47.24          2
      2001         41      67.19          3
      2001         34       68.9          3
      2001         32       68.9          3
      2001         10      69.05          3
      2001          7      69.96          3
      2001         11      71.57          4
      2001         36      91.12          4
      2001         15      91.98          4
      2001         31      92.21          4
      2001          1      92.26          4
      2001          9      92.67          5
      2001         37      93.16          5
      2001          5      93.44          5
      2001         46      93.58          5
      2001         27      94.48          5
      2001         51     114.82          6
      2001         33     115.52          6
      2001         39     115.57          6
      2001         13     116.81          6
      2001         12     116.81          7
      2001         29     116.85          7
      2001         20     118.03          7
      2001          2     118.38          7
      2001         24     136.92          8
      2001         42     136.98          8
      2001         38        139          8
      2001         25     139.28          8
      2001         43     139.58          9
      2001         22     141.78          9
      2001         14     162.91          9
      2001         30     162.91          9
      2001         48     182.96         10
      2001         21      233.7         10
      2001          4      256.7         10
      2001         16     278.44         10

已选择45行。
```
## stddev
stddev函数用于计算某些数据行在分区中的标准差：
```sql
SQL>  select year,week,sale,
   stddev(sale) over(
   partition by product,country,region,year
   order by sale
   rows between unbounded preceding and unbounded following
   ) stddev
   from sales_fact
   where country in ('Australia') and product = 'Xtend Memory' and week<10
   order by product,country,year,week;

      YEAR       WEEK       SALE     STDDEV
---------- ---------- ---------- ----------
      1998          1      58.15  15.517783
      1998          2      29.39  15.517783
      1998          3      29.49  15.517783
      1998          4      29.49  15.517783
      1998          5       29.8  15.517783
      1998          6      58.78  15.517783
      1998          9      58.78  15.517783
      1999          1      53.52 25.8395281
      1999          3       94.6 25.8395281
      1999          4       40.5 25.8395281
      1999          5      80.01 25.8395281
      1999          6       40.5 25.8395281
      1999          8     103.11 25.8395281
      1999          9      53.34 25.8395281
      2000          1       46.7  19.670004
      2000          3      93.41  19.670004
      2000          4      46.54  19.670004
      2000          5       46.7  19.670004
      2000          7       70.8  19.670004
      2000          8      46.54  19.670004
      2001          1      92.26  68.235866
      2001          2     118.38  68.235866
      2001          3      47.24  68.235866
      2001          4      256.7  68.235866
      2001          5      93.44  68.235866
      2001          6      22.44  68.235866
      2001          7      69.96  68.235866
      2001          8      46.06  68.235866
      2001          9      92.67  68.235866

已选择29行。
```
## listagg
listagg函数将分区中多个数据行中的某列的值以某个符号拼接成一行，语法如下：
```sql
listagg(string,separator) within group(order-by-clause) over(partition-by-clause)
```
`within group(order-by-clause)`子句声明排序顺序。

比如将sales_fact数据表中的country转化为以逗号分隔的一行值：
```sql
SQL> col country_string for a50
SQL> select listagg(country,',')
  within group(order by country desc) country_string
  from(
    select distinct country from sales_fact
  );

COUNTRY_STRING
--------------------------------------------------
United States of America,United Kingdom,Turkey,Spa
in,Singapore,Saudi Arabia,Poland,New Zealand,Japan
,Italy,Germany,France,Denmark,China,Canada,Brazil,
Australia,Argentina
```