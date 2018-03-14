---
title: Bootstrap Table学习指南
date: 2018-01-06 09:43:13
tags: Bootstrap
---
Bootstrap Table是一款基于Bootstrap的jQuery表格插件，通过简单的设置，就可以拥有强大的单选、多选、排序、分页，以及编辑、导出、过滤、扩展等等的功能。作者地址：[https://github.com/wenzhixin/bootstrap-table](https://github.com/wenzhixin/bootstrap-table)。这里简单介绍下使用方法以及对其进行二次封装，方便日常开发使用。
<!--more-->
## 准备工作
因为基于Bootstrap，所以先引入Bootstrap依赖：
```html
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
<script src="http://code.jquery.com/jquery-2.0.0.min.js"></script>
<script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
```
然后引入Bootstrap Table依赖：
```html
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.9.0/bootstrap-table.min.css">
<!-- Latest compiled and minified JavaScript -->
<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.9.0/bootstrap-table.min.js"></script>
<!-- Latest compiled and minified Locales -->
<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.9.0/locale/bootstrap-table-zh-CN.min.js"></script>
```
## 数据准备
本例中使用到的数据表SQL如下：
```sql
-- ----------------------------
-- Table structure for T_ROLE
-- ----------------------------
DROP TABLE "MRBIRD"."T_ROLE";
CREATE TABLE "MRBIRD"."T_ROLE" (
"ROLE_ID" NUMBER NOT NULL ,
"ROLE_NAME" VARCHAR2(100 BYTE) NOT NULL ,
"REMARK" VARCHAR2(100 BYTE) NULL ,
"CREATE_TIME" DATE NOT NULL ,
"MODIFY_TIME" DATE NULL 
);

-- ----------------------------
-- Records of T_ROLE
-- ----------------------------
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('23', '用户管理员', '负责用户的增删改操作', TO_DATE('2018-01-09 15:32:41', 'YYYY-MM-DD HH24:MI:SS'), null);
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('1', '管理员', '管理员', TO_DATE('2017-12-27 16:23:11', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2018-02-24 16:01:45', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('2', '测试账号', '测试账号', TO_DATE('2017-12-27 16:25:09', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2018-01-23 09:11:11', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('3', '注册账户', '注册账户，只可查看，不可操作', TO_DATE('2017-12-29 16:00:15', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2018-02-24 17:33:45', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('24', '系统监控员', '可查看系统监控信息，但不可操作', TO_DATE('2018-01-09 15:52:01', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2018-03-07 19:05:33', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('25', '用户查看', '查看用户，无相应操作权限', TO_DATE('2018-01-09 15:56:30', 'YYYY-MM-DD HH24:MI:SS'), null);
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('63', '影院工作者', '可查看影视信息', TO_DATE('2018-02-06 08:48:28', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2018-03-07 19:05:26', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('64', '天气预报员', '可查看天气预报信息', TO_DATE('2018-02-27 08:47:04', 'YYYY-MM-DD HH24:MI:SS'), null);
INSERT INTO "MRBIRD"."T_ROLE" VALUES ('65', '文章审核', '文章类', TO_DATE('2018-02-27 08:48:01', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2018-03-13 11:20:34', 'YYYY-MM-DD HH24:MI:SS'));
```
后端框架为Spring Boot + MyBatis（通用mapper和pagehelper插件），获取数据的具体细节这里不再描述，可参考文末的源码。
## 使用
编写一个简单的页面：
```html
<form class="form">
    <div class="row">
        <div class="col">
            <div class="input-group">
                <span class="input-group-addon">角色：</span>
                <div class="form-group">
                    <input type="text" name="roleName" class="form-control">
                </div>
            </div>
        </div>
        <div class="col"></div>
        <div class="col">
            <button type="button" class="btn btn-success" onclick="refresh()">重置</button>
            <button type="button" class="btn btn-primary" onclick="search()">搜索</button>
        </div>
    </div>
</form>
<table id="roleTable" data-mobile-responsive="true" class="mb-bootstrap-table text-nowrap"></table>
```
Bootstrap Table插件的使用：
```javascript
$('#roleTable').bootstrapTable({
    method: 'get', // 服务器数据的请求方式 get or post
    url: ctx + "bootstrap-table/list", // 服务器数据的加载地址
    striped: true, //是否显示行间隔色
    cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
    pagination: true, //是否显示分页（*）
    sortable: false, //是否启用排序
    sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
    pageNumber: 1, //初始化加载第一页，默认第一页
    pageSize: 5, //每页的记录行数（*）
    pageList: [5, 25, 50, 100], //可供选择的每页的行数（*）
    strictSearch: true,
    minimumCountColumns: 2, //最少允许的列数
    clickToSelect: true, //是否启用点击选中行
    uniqueId: "ID", //每一行的唯一标识，一般为主键列
    cardView: false,
    detailView: false, //是否显示详细视图
    smartDisplay: false,
    queryParams: function(params) {
        return {
            pageSize: params.limit,
            pageNum: params.offset / params.limit + 1,
            roleName: $(".form").find("input[name='roleName']").val().trim(),
        };
    },
    columns: [{
        checkbox: true
    },{
        field: 'roleId',
        title: '角色ID'
    },{
        field: 'roleName',
        title: '角色'
    }, {
        field: 'remark',
        title: '描述'
    }, {
        field: 'createTime',
        title: '创建时间'
    }, {
        field: 'modifyTime',
        title: '修改时间'
    }]
});
// 搜索方法
function search() {
    $('#roleTable').bootstrapTable('refresh');
}
// 重置方法
function refresh() {
    $(".form")[0].reset();
    search();
}
```
后端返回的JSON数据如下所示：
```json
{
    "total": 9,
    "rows": [{
        "roleId": 1,
        "roleName": "管理员",
        "remark": "管理员",
        "createTime": 1514362991000,
        "modifyTime": 1519459305000
    }, {
        "roleId": 2,
        "roleName": "测试账号",
        "remark": "测试账号",
        "createTime": 1514363109000,
        "modifyTime": 1516669871000
    }, {
        "roleId": 3,
        "roleName": "注册账户",
        "remark": "注册账户，只可查看，不可操作",
        "createTime": 1514534415000,
        "modifyTime": 1519464825000
    }, {
        "roleId": 23,
        "roleName": "用户管理员",
        "remark": "负责用户的增删改操作",
        "createTime": 1515483161000,
        "modifyTime": null
    }, {
        "roleId": 24,
        "roleName": "系统监控员",
        "remark": "可查看系统监控信息，但不可操作",
        "createTime": 1515484321000,
        "modifyTime": 1520420733000
    }, {
        "roleId": 25,
        "roleName": "用户查看",
        "remark": "查看用户，无相应操作权限",
        "createTime": 1515484590000,
        "modifyTime": null
    }, {
        "roleId": 63,
        "roleName": "影院工作者",
        "remark": "可查看影视信息",
        "createTime": 1517878108000,
        "modifyTime": 1520420726000
    }, {
        "roleId": 64,
        "roleName": "天气预报员",
        "remark": "可查看天气预报信息",
        "createTime": 1519692424000,
        "modifyTime": null
    }, {
        "roleId": 65,
        "roleName": "文章审核",
        "remark": "文章类",
        "createTime": 1519692481000,
        "modifyTime": 1520911234000
    }]
}
```
页面显示效果如下：
![QQ截图20180314172620.png](img/QQ截图20180314172620.png)

## 二次封装
实际使用中除了几个常用的参数比如url，queryParams，columns等等之外，剩下的参数一般默认就好，所以接下来对其进行二次封装，使得开发中更为方便。
```javascript
var $Mrbird = (function() {
    var bootstrapTable_default = {
        method: 'get',
        striped: true,
        cache: false,
        pagination: true,
        sortable: false,
        sidePagination: "server",
        pageNumber: 1,
        pageSize: 5,
        pageList: [5, 10, 25, 50, 100],
        strictSearch: true,
        showColumns: false,
        minimumCountColumns: 2,
        clickToSelect: true,
        uniqueId: "ID",
        cardView: false,
        detailView: false,
        smartDisplay: false,
        queryParams: function(params) {
            return {
                pageSize: params.limit,
                pageNum: params.offset / params.limit + 1,
            };
        }
    }
    function _initTable(id, settings) {
        var params = $.extend({}, bootstrapTable_default, settings);
        if (typeof params.url == 'undefined') {
            throw '初始化表格失败，请配置url参数！';
        }
        if (typeof params.columns == 'undefined') {
            throw '初始化表格失败，请配置columns参数！';
        }
        $('#' + id).bootstrapTable(params);
    }
    return {
        initTable: function(id, settings) {
            _initTable(id, settings);
        },
        refreshTable: function(id) {
            $('#' + id).bootstrapTable('refresh');
        }
    }
})($);
```
这样，在使用Bootstap Table插件的时候只需要像下面这样书写即可：
```javascript
$(function() {
    var settings = {
        url: ctx + "bootstrap-table/list",
        queryParams: function(params) {
            return {
                pageSize: params.limit,
                pageNum: params.offset / params.limit + 1,
                roleName: $(".form").find("input[name='roleName']").val().trim(),
            };
        },
        columns: [{
                checkbox: true
            },
            {
                field: 'roleId',
                title: '角色ID'
            }, {
                field: 'roleName',
                title: '角色'
            }, {
                field: 'remark',
                title: '描述'
            }, {
                field: 'createTime',
                title: '创建时间'
            }, {
                field: 'modifyTime',
                title: '修改时间'
            }
        ]
    }
    $Mrbird.initTable('roleTable', settings);
});
```
## 附录
Bootstap Table除了上面介绍的内容外，其还包含了许多别的特性，可参考官方文档：[http://bootstrap-table.wenzhixin.net.cn/zh-cn/documentation/](http://bootstrap-table.wenzhixin.net.cn/zh-cn/documentation/)。

