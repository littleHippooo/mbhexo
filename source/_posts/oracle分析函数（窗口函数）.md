---
title: Oracle分析函数（窗口函数）
date: 2017-11-10 14:40:47
tags: [DataBase,Oracle,Oracle 11g]
---
Oracle 中的分析函数基于对数据行的分组来计算相关值，类似于聚合函数。其和聚合函数主要的区别在于：分析函数对于每个分组返回多行数据，而聚合函数每个分组只能对于一行数据。

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

> to be continued...