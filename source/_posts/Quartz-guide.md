---
title: Quartz guide
date: 2017-08-01 15:23:05
tags: [Quartz,Java]
---
Quartz是一款开源的任务调度框架，对任务调度过程进行了高度的抽象，包含**调度器**（Scheduler），**任务**（Job）和**触发器**（Trigger）。Quartz在org.quartz.*中通过接口和类对这三个概念进行了描述（这里使用的Quartz版本为1.8.6）：

**Job**：一个简单的接口，只包含一个`void execute(JobExecutionContext context)`抽象方法。实际开发中，通过实现该接口来定义需要执行的任务。`JobExecutionContext`提供了调度上下文信息。
```java
public interface Job {
    void execute(JobExecutionContext context) 
    	throws JobExecutionException;
}
```
<!--more-->
**JobDetail**：包含多个构造函数，最常用的为`JobDetail(String name, String group, Class jobClass)`jobClass为实现了Job接口的类，name为任务在Scheduler中的名称，group为任务在Scheduler中的组名。组名默认为`Scheduler.DEFAULT_GROUP`。

**Trigger**：一个类，用于描述触发Job执行的时间规则。包含：

1. SimpleTrigger: 一次或者固定时间间隔周期的触发规则。

2. CronTrigger：通过cron表达式描述出更为复杂的触发规则。

**Calendar**：Quartz提供的日历类。一个Trigger可以和多个Calendar关联，以此来排除一些特殊的日期。

**Scheduler**：代表一个Quartz的独立运行容器，Trigger和JobDetail被注册到Scheduler中，二者在Scheduler中拥有各自的名称（name）和组名（group）。Trigger和JobDetail的名称和组名的组合必须唯一，但是Trigger的名称和组名的组合可以和JobDetail的相同，因为它们类型不同。一个Job可以绑定多个Trigger，反之不然。

Job还有一个子接口：StatefulJob，其是一个没有方法的标签接口，代表有状态的任务。

1. 无状态任务：拥有JobDataMap复制，所以可以并发运行；

2. 有状态任务：共享一份JobDataMap，每次对JobDataMap的修改会被保存下来。所以前次的StatefulJob会阻塞下一次的StatefulJob。

## SimpleTrigger
SimpleTrigger包含多个重载的构造器，可根据实际需求来选择。这里使用SimpleTrigger来演示触发一个JobDetail。

首先定义一个简单的Job实现类，代表我们需要进行调度的任务：
```java
import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class SimpleJob implements Job{
    
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        System.out.println("TriggerName: "+context.getTrigger().getName()+
            " Triggered time is: "+new SimpleDateFormat("HH:mm:ss").format((new Date())));
    }
}
```
下面通过SimpleTrigger对SimpleJob进行调度：
```java
import java.util.Date;

import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SimpleTrigger;
import org.quartz.impl.StdSchedulerFactory;

public class SimpleTriggerRunner {
    public static void main(String[] args) {
        try {

            JobDetail jobDetail = new JobDetail("job1","job_group1",SimpleJob.class);

            SimpleTrigger simpleTrigger = new SimpleTrigger("trigger1","trigger_group1");
            simpleTrigger.setStartTime(new Date());
            simpleTrigger.setRepeatInterval(2000);
            simpleTrigger.setRepeatCount(10);

            Scheduler scheduler = new StdSchedulerFactory().getScheduler();

            scheduler.scheduleJob(jobDetail, simpleTrigger);
            scheduler.start();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```
上面代码中做的事情主要有：

1. 通过JobDetail封装SimpleJob，同时指定其名称为`job1`，组名为`job_group1`；

2. 创建一个SimpleTrigger，并指定其名称为`trigger1`，组名为`trigger_group1`，触发启动时间为马上触发，时间间隔为2000毫秒，重复10次；

3. 接着创建了一个Scheduler实例，并且将JobDetail和Trigger实例注册到Scheduler中。

运行代码，观察输出：
```
TriggerName: trigger1 Triggered time is: 16:27:07
TriggerName: trigger1 Triggered time is: 16:27:09
TriggerName: trigger1 Triggered time is: 16:27:11
TriggerName: trigger1 Triggered time is: 16:27:13
TriggerName: trigger1 Triggered time is: 16:27:15
TriggerName: trigger1 Triggered time is: 16:27:17
TriggerName: trigger1 Triggered time is: 16:27:19
TriggerName: trigger1 Triggered time is: 16:27:21
TriggerName: trigger1 Triggered time is: 16:27:23
TriggerName: trigger1 Triggered time is: 16:27:25
TriggerName: trigger1 Triggered time is: 16:27:27
```
## CronTrigger
CronTrigger的调度规则基于Cron表达式。Cron表达式由6个或7个由空格分隔的时间字段：
<table style="margin-top:-20px;"> 
    <tr> 
        <th>位置</th> 
        <th>时间域名</th> 
        <th>允许值</th> 
        <th>允许的特殊字符</th> 
    </tr> 
    <tr> 
        <td>1</td> 
        <td>秒</td> 
        <td>0-59</td> 
        <td>, - \* /</td> 
    </tr> 
    <tr> 
        <td>2</td> 
        <td>分钟</td> 
        <td>0-59</td> 
        <td>, - \* /</td> 
    </tr> 
    <tr> 
        <td>3</td> 
        <td>小时</td> 
        <td>0-23</td> 
        <td>, - \* /</td> 
    </tr> 
    <tr> 
        <td>4</td> 
        <td>日期</td> 
        <td>1-31</td> 
        <td>, - \* ? / L W C </td> 
    </tr> 
    <tr> 
        <td>5</td> 
        <td>月份</td> 
        <td>1-12</td> 
        <td>, - \* /</td> 
    </tr> 
    <tr> 
        <td>6</td> 
        <td>星期</td> 
        <td>1-7</td> 
        <td>, - \* ? / L C #</td> 
    </tr> 
    <tr> 
        <td>7</td> 
        <td>年(可选)</td> 
        <td>空值1970-2099</td> 
        <td>, - \* /</td> 
    </tr>  
</table>

其中特殊字符的含义如下：

- 星号（\*）：可用在所有字段中，表示对应时间域的每一个时刻。例如，\*在分钟字段时，表示“每分钟”；

- 问号（?）：该字符只在日期和星期字段中使用，它通常指定为“无意义的值”，相当于点位符；

- 减号（-）：表达一个范围，如在小时字段中使用“10-12”，则表示从10到12点，即10,11,12；

- 逗号（,）：表示一个列表值，如在星期字段中使用“MON,WED,FRI”，则表示星期一，星期三和星期五；

- 斜杠（/）：x/y表达一个等步长序列，x为起始值，y为增量步长值。如在分钟字段中使用0/15，则表示为0,15,30和45秒，而5/15在分钟字段中表示5,20,35,50，你也可以使用*/y，它等同于0/y；

- L：该字符只在日期和星期字段中使用，代表“Last”的意思，但它在两个字段中意思不同。L在日期字段中，表示这个月份的最后一天，如一月的31号，非闰年二月的28号；如果L用在星期中，则表示一个星期的最后一天（也就是星期六，国外星期第一天为周天）。但是，如果L出现在星期字段里，而且在前面有一个数值X，则表示“这个月的最后一个星期X-1”，例如，6L表示该月的最后一个星期五，5L表示该月的最后一个星期四，以此类推。

- W：该字符只能出现在日期字段里，是对前导日期的修饰，表示离该日期最近的工作日。例如15W表示离该月15号最近的工作日，如果该月15号是星期六，则匹配14号星期五；如果15日是星期日，则匹配16号星期一；如果15号是星期二，那结果就是15号星期二。但必须注意关联的匹配日期不能够跨月，如你指定1W，如果1号是星期六，结果匹配的是3号星期一，而非上个月最后的那天；

- LW组合：在日期字段可以组合使用LW，它的意思是当月的最后一个工作日；

- 井号（#）：该字符只能在星期字段中使用，表示当月某个工作日。如6#3表示当月的第三个星期五（6表示星期五，#3表示当前的第三个），而4#5表示当月的第五个星期三，假设当月没有第五个星期三，忽略不触发；

- C：该字符只在日期和星期字段中使用，代表“Calendar”的意思。它的意思是计划所关联的日期，如果日期没有被关联，则相当于日历中所有日期。例如5C在日期字段中就相当于日历5日以后的第一天。1C在星期字段中相当于星期日后的第一天。

Cron表达式对特殊字符的大小写不敏感，对代表星期的缩写英文大小写也不敏感。

下面给出一些完整的Cron表示式的实例：

<table>
    <tr >
      <th >
        表示式
      </th>
      <th>
        说明
      </th>
    </tr>
    <tr >
      <td>
        "0 0 12 \* \* ? "
      </td>
      <td>
        每天12点运行
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 ? \* \*"
      </td>
      <td>
        每天10:15运行
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 \* \* ?"
      </td>
      <td>
        每天10:15运行
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 \* \* ? \*"
      </td>
      <td>
        每天10:15运行
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 \* \* ? 2008"
      </td>
      <td>
        在2008年的每天10：15运行
      </td>
    </tr>
    <tr >
      <td>
        "0 \* 14 \* \* ?"
      </td>
      <td>
        每天14点到15点之间每分钟运行一次，开始于14:00，结束于14:59。
      </td>
    </tr>
    <tr >
      <td>
        "0 0/5 14 \* \* ?"
      </td>
      <td>
        每天14点到15点每5分钟运行一次，开始于14:00，结束于14:55。
      </td>
    </tr>
    <tr >
      <td>
        "0 0/5 14,18 \* \* ?"
      </td>
      <td>
        每天14点到15点每5分钟运行一次，此外每天18点到19点每5钟也运行一次。
      </td>
    </tr>
    <tr >
      <td>
        "0 0-5 14 \* \* ?"
      </td>
      <td>
        每天14:00点到14:05，每分钟运行一次。
      </td>
    </tr>
    <tr >
      <td>
        "0 10,44 14 ? 3 WED"
      </td>
      <td>
        3月每周三的14:10分到14:44，每分钟运行一次。
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 ? \* MON-FRI"
      </td>
      <td>
        每周一，二，三，四，五的10:15分运行。
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 15 \* ?"
      </td>
      <td>
        每月15日10:15分运行。
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 L \* ?"
      </td>
      <td>
        每月最后一天10:15分运行。
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 ? \* 6L"
      </td>
      <td>
        每月最后一个星期五10:15分运行。
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 ? \* 6L 2014-2016"
      </td>
      <td>
        在2014,2015,2016年每个月的最后一个星期五的10:15分运行。
      </td>
    </tr>
    <tr >
      <td>
        "0 15 10 ? \* 6#3"
      </td>
      <td>
        每月第三个星期五的10:15分运行。
      </td>
    </tr>
</table>

附：[在线Cron表达式生成器](http://www.pdtools.net/tools/becron.jsp)

**CronTrigger实例**

使用CronTrigger对simpleJob进行调度，使用Cron表达式制定调度规则，让其每5秒运行一次：
```java
import org.quartz.CronExpression;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;

public class CronTriggerRunner {
    public static void main(String[] args) {
        try {
            JobDetail jobDetail = new JobDetail("job2","job_group2",SimpleJob.class);
            
            CronTrigger cronTrigger = new CronTrigger("trigger2","trigger_group2");
            CronExpression ce = new CronExpression("0/5 * * * * ?");
            cronTrigger.setCronExpression(ce);
            
            Scheduler scheduler = new StdSchedulerFactory().getScheduler();
            
            scheduler.scheduleJob(jobDetail, cronTrigger);
            scheduler.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```
运行，观察输出：
```xml
TriggerName: trigger2 Triggered time is: 09:38:00
TriggerName: trigger2 Triggered time is: 09:38:05
TriggerName: trigger2 Triggered time is: 09:38:10
TriggerName: trigger2 Triggered time is: 09:38:15
TriggerName: trigger2 Triggered time is: 09:38:20
TriggerName: trigger2 Triggered time is: 09:38:25
TriggerName: trigger2 Triggered time is: 09:38:30
TriggerName: trigger2 Triggered time is: 09:38:35
TriggerName: trigger2 Triggered time is: 09:38:40
TriggerName: trigger2 Triggered time is: 09:38:45
TriggerName: trigger2 Triggered time is: 09:38:50
TriggerName: trigger2 Triggered time is: 09:38:55
TriggerName: trigger2 Triggered time is: 09:39:00
TriggerName: trigger2 Triggered time is: 09:39:05
...
```
Calendar略。