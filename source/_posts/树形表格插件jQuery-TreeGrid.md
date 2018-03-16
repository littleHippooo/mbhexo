---
title: 树形表格插件jQuery TreeGrid
date: 2018-01-10 09:45:38
tags: [Bootstrap,jQuery]
---
借助树形表格插件jQuery TreeGrid，我们可以以表格的形式来展现那些带有层级关系的数据，比如部门上下级，菜单表等。jQuery TreeGrid的官方地址为：[http://maxazan.github.io/jquery-treegrid/](http://maxazan.github.io/jquery-treegrid/)。由于这里的使用环境为bootstrap，原始的jQuery TreeGrid插件显得不是那么的灵活和美观，为了在bootstrap中无缝的使用该插件，这里引用了经过二次封装的jQuery TreeGrid插件jquery.treegrid.extension.js，作者为：[http://www.cnblogs.com/landeanfen/p/6776152.html](http://www.cnblogs.com/landeanfen/p/6776152.html)。
<!--more-->
## 引入依赖
首先先引入bootstrap相关的依赖：
```html
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
<script src="http://code.jquery.com/jquery-2.0.0.min.js"></script>
<script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
```
然后引入jQuery TreeGrid依赖以及jquery.treegrid.extension.js ：
```html
<!-- jquery.treegrid -->
<link rel="stylesheet" data-th-href="@{css/jqTreeGrid/jquery.treegrid.css}">
<script data-th-src="@{js/jqTreeGrid/jquery.treegrid.js}"></script>
<!-- jquery.treegrid.extension -->
<script data-th-src="@{js/jqTreeGrid/jquery.treegrid.extension.js}"></script>
```
因为bootstrap没有自带图标组件，为了下文的使用，这里引入[font-awesome](http://fontawesome.dashgame.com/):
```html
<link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
```
## 数据
使用的数据表：
```sql
-- ----------------------------
-- Table structure for T_DEPT
-- ----------------------------
DROP TABLE "MRBIRD"."T_DEPT";
CREATE TABLE "MRBIRD"."T_DEPT" (
"DEPT_ID" NUMBER NOT NULL ,
"PARENT_ID" NUMBER NOT NULL ,
"DEPT_NAME" VARCHAR2(100 BYTE) NOT NULL ,
"ORDER_NUM" NUMBER NULL ,
"CREATE_TIME" DATE NULL 
);

-- ----------------------------
-- Records of T_DEPT
-- ----------------------------
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('7', '2', '开发一部福州分部', null, TO_DATE('2018-03-15 09:32:15', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('1', '0', '开发部', null, TO_DATE('2018-01-04 15:42:26', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('3', '1', '开发二部', null, TO_DATE('2018-01-04 15:42:29', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('5', '0', '人事部', null, TO_DATE('2018-01-04 15:42:32', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('2', '1', '开发一部', null, TO_DATE('2018-01-04 15:42:34', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('4', '0', '市场部', null, TO_DATE('2018-01-04 15:42:36', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('6', '0', '测试部', null, TO_DATE('2018-01-04 15:42:38', 'YYYY-MM-DD HH24:MI:SS'));
```
后端框架为Spring Boot + MyBatis（通用mapper和pagehelper插件），获取数据的具体细节这里不再描述，可参考文末的源码。
## 使用
编写一个简单的页面：
```html
<form class="form">
    <div class="row">
        <div class="col">
            <div class="input-group">
                <span class="input-group-addon">部门名称：</span>
                <div class="form-group">
                    <input type="text" name="deptName" class="form-control">
                </div>
            </div>
        </div>
        <div class="col">
            <button type="button" class="btn btn-success" onclick="refresh()">重置</button>
            <button type="button" class="btn btn-primary" onclick="search()">搜索</button>
        </div>
    </div>
</form>
<table id="deptTreeTable" data-mobile-responsive="true" class="mb-bootstrap-table text-nowrap"></table>
```
jQuery TreeGrid插件的使用：
```javascript
var ctx = [[@{/}]];

$(function() {
    initDeptTreeTable();
});

function initDeptTreeTable() {
    $('#deptTreeTable').bootstrapTreeTable({
        id: 'deptId', // 选取记录返回的值
        code: 'deptId', // 用于设置父子关系
        parentCode: 'parentId', // 用于设置父子关系
        rootCodeValue: null, //设置根节点code值----可指定根节点，默认为null,"",0,"0"
        data: [], // 构造table的数据集合，如果是ajax请求则不必填写
        type: "GET", // 请求数据的ajax类型
        url: ctx + 'dept/list', // 请求数据的ajax的url
        ajaxParams: {
            deptName: $(".form").find("input[name='deptName']").val().trim()
        }, // 请求数据的ajax的data属性
        expandColumn: 2, // 在哪一列上面显示展开按钮
        expandAll: true, // 是否全部展开
        striped: true, // 是否各行渐变色
        columns: [{
                field: 'selectItem',
                checkbox: true
            },
            {
                title: '编号',
                field: 'deptId',
                width: '50px'
            },
            {
                title: '名称',
                field: 'deptName'
            },
            {
                title: '创建时间',
                field: 'createTime'
            }
        ], // 设置列
        toolbar: null, //顶部工具条
        height: 0,
        expanderExpandedClass: 'fa fa-chevron-down', // 展开的按钮的图标
        expanderCollapsedClass: 'fa fa-chevron-up' // 缩起的按钮的图标
    });
}
// 搜索方法
function search() {
    initDeptTreeTable();
}
// 重置方法
function refresh() {
    $(".form")[0].reset();
    search();
}
```
参数说明如注解所示，其中expanderExpandedClass和expanderCollapsedClass为展开和缩起的图标，这里使用的是文章开始引入的font-awesome。

后端返回的JSON数据如下所示：
```json
[{
    "deptId": 1,
    "parentId": 0,
    "deptName": "开发部",
    "orderNum": null,
    "createTime": 1515051746000
}, {
    "deptId": 2,
    "parentId": 1,
    "deptName": "开发一部",
    "orderNum": null,
    "createTime": 1515051754000
}, {
    "deptId": 3,
    "parentId": 1,
    "deptName": "开发二部",
    "orderNum": null,
    "createTime": 1515051749000
}, {
    "deptId": 4,
    "parentId": 0,
    "deptName": "市场部",
    "orderNum": null,
    "createTime": 1515051756000
}, {
    "deptId": 5,
    "parentId": 0,
    "deptName": "人事部",
    "orderNum": null,
    "createTime": 1515051752000
}, {
    "deptId": 6,
    "parentId": 0,
    "deptName": "测试部",
    "orderNum": null,
    "createTime": 1515051758000
}, {
    "deptId": 7,
    "parentId": 2,
    "deptName": "开发一部福州分部",
    "orderNum": null,
    "createTime": 1521077535000
}]
```
页面显示效果如下：
![QQ截图20180315103450.png](img/QQ截图20180315103450.png)

其实，在实际使用中我们并不需要配置那么多参数，查看jquery.treegrid.extension.js源码可发现，其默认参数为：
```javascript
$.fn.bootstrapTreeTable.defaults = {
    id: 'menuId',
    code: 'menuId',
    parentCode: 'parentId',
    rootCodeValue: null,
    data: [],
    type: "GET",
    url: null,
    ajaxParams: {},
    expandColumn: null,
    expandAll: true,
    striped: false,
    columns: [],
    toolbar: null,
    height: 0,
    expanderExpandedClass: 'fa fa-chevron-down',
    expanderCollapsedClass: 'fa fa-chevron-up'

};
```
所以使用的时候只需配置几个我们关注的参数即可：
```javascript
$('#deptTreeTable').bootstrapTreeTable({
    id: 'deptId',
    code: 'deptId',
    parentCode: 'parentId',
    url: ctx + 'dept/list',
    ajaxParams: {
        deptName: $(".form").find("input[name='deptName']").val().trim()
    },
    expandColumn: 2,
    striped: true,
    columns: [{
            field: 'selectItem',
            checkbox: true
        },
        {
            title: '编号',
            field: 'deptId',
            width: '50px'
        },
        {
            title: '名称',
            field: 'deptName'
        },
        {
            title: '创建时间',
            field: 'createTime'
        }
    ]
});
```
jquery.treegrid.extension.js还封装了一些方法：
```javascript
$.fn.bootstrapTreeTable.methods = {
    // 返回选中记录的id（返回的id由配置中的id属性指定）
    // 为了兼容bootstrap-table的写法，统一返回数组，这里只返回了指定的id
    getSelections: function(target, data) {
        // 所有被选中的记录input
        var _ipt = target.find("tbody").find("tr").find("input[name='select_item']:checked");
        var chk_value = [];
        // 如果是radio
        if (_ipt.attr("type") == "radio") {
            chk_value.push({ id: _ipt.val() });
        } else {
            _ipt.each(function(_i, _item) {
                chk_value.push({ id: $(_item).val() });
            });
        }
        return chk_value;
    },
    // 刷新记录
    refresh: function(target, parms) {
        if (parms) {
            target.load(parms);
        } else {
            target.load();
        }
    },
    // 重置表格视图
    resetHeight: function(target, height) {
        target.find("tbody").css("height", height + 'px');
    }
    // 组件的其他方法也可以进行类似封装........
};
```
比如获取选中行的数据可使用getSelections：
```javascript
$("#deptTreeTable").bootstrapTreeTable("getSelections");
```
## 附录
源码链接：[https://drive.google.com/open?id=1fgYRpD5CNCn4gj06_MiLm-g2fCjsSYtk](https://drive.google.com/open?id=1fgYRpD5CNCn4gj06_MiLm-g2fCjsSYtk)