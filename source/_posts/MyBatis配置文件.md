---
title: MyBatis配置文件
date: 2017-01-05 07:50:03
tags: MyBatis
---
MyBatis配置文件mybatis-config.xml包含：

■ properties：用于配置属性信息。

■ settings：用于配置MyBatis的运行时方式。

■ typeAliases：配置类型别名，可以在xml中用别名取代全限定名。

■ typeHandlers：配置类型处理器。
<!--more-->

■ plugins：配置拦截器，用于拦截sql语句的执行。

■ environments：配置数据源信息、连接池、事务属性等。

■ mappers：配置SQL映射文件。

{% note danger %}注意：这些配置必须按照上述的顺序进行配置！{% endnote %}