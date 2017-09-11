---
title: Nexus搭建私服
date: 2016-10-29 10:15:54
tags: maven
---
## 安装Nexus  
下载Nexus：[http://pan.baidu.com/s/1miTmJB6 ](http://pan.baidu.com/s/1miTmJB6 )，密码：2jh7

解压后找到bin/jsw目录下选择对于的操作系统文件夹：  

![19865483-file_1487995065115_181e8.png](img/19865483-file_1487995065115_181e8.png)

<!--more--> 
如windows-x86-64，双击start-nexus.bat即可启动nexus，启动后浏览器访问loaclhost:8081/nexus/：

![79775439-file_1487995089844_127eb.png](img/79775439-file_1487995089844_127eb.png)

点击右上角Log In登录，管理员账号密码 admin，admin123。
## Nexus仓库和仓库组
### Nexus内置仓库
点击左侧的Repositories可看到： 

![92574541-file_1487995113580_1670c.png](img/92574541-file_1487995113580_1670c.png)

类型分为：group（仓库组），proxy（代理），hosted（宿主），virtual（虚拟）：

`Central`：代理Maven**中央仓库**，策略为Release，因此只会下载和缓存中央仓库中的发行版本构件

`Releases`：策略为Release的**宿主类型仓库**，用来部署组织内部的发行版本构件

`Snapshots`：策略为Snapshots的**宿主类型仓库**，用来部署组织内部的快照版本构件

`Apache Snapshots`：策略为Snapshots的**代理仓库**，用来代理Apache Maven仓库的快照版本构件

`3rd party`：策略为Release的**宿主类型仓库**，用来部署无法从公共仓库获得的第三方发行版构件

`Public Repositories`：该**仓库组**为上述所有策略为Release的仓库聚合并通过一致的地址提供服务

`Public Snapshot Repositories`：该**仓库组**为上述所有策略为Snapshots的仓库聚合并通过一致的地址提供服务

上述的几种仓库类型关系如下图所示：  

![22119072-file_1487995134996_3555.png](img/22119072-file_1487995134996_3555.png)

maven可以直接从宿主仓库和代理仓库下载构件，代理仓库会间接地从远程仓库下载并缓存构件。为了方便，maven可以从仓库组下载构件，仓库组没有实际的内容，它会转向其包含的宿主仓库或者代理仓库获得实际的构件。
### 创建Nexus宿主仓库
点击Repositories界面的Add按钮，选择Hosted Repository：    

![55892256-file_1487995155963_8fa.png](img/55892256-file_1487995155963_8fa.png)

`Repository ID`：仓库id，该值会被作为仓库路径的最后一项内容

`Repository Name`：仓库名称

`Provider`：仓库的格式，一般选默认的Maven2

`Repository Policy`：配置仓库构件为快照类型还是发行类型

`Default Local Storage Location`：仓库默认地址，自动根据id生成

`Override Local Storage Location`：自定义仓库地址

`Deployment Policy`：部署策略，有Disable Redeploy（同一构件只能部署一次），Allow Redeploy（允许重新部署），Readonly（禁止部署）

`Allow File Browsing`：为true时以树形结构浏览仓库存储文件内容

`Include in Search`：是否对该仓库进行索引并提供搜索

`Publish URL`：是否通过URL提供服务，为false的时候，访问该仓库地址会得到HTTP 404 Not Found错误

`Not Found Cache TTL`：如果某文件不存在，在这1440分钟内再次访问这个文件，直接返回不存在信息

> 未完待续，懒得写 