---
title: 树形插件jsTree
date: 2018-02-01 09:49:17
tags: jQuery
---
jsTree是一款基于jQuery的树形控件，具有扩展性强，可编辑和可配置的特性，支持HTML，JSON和Ajax数据加载。jsTree官网地址：[https://www.jstree.com/](https://www.jstree.com/)。这里主要介绍的是基于Ajax从数据库获取数据，然后生成树形菜单的用法。jsTree的皮肤可以自由定制，本文使用的是一款第三方jsTree皮肤。
<!--more-->
## 引入依赖
因为其基于jQuery，所以引入jsTree依赖前得先引入jQuery：
```html
<!-- jQuery -->
<script src="https://cdn.bootcss.com/jquery/2.2.0/jquery.min.js"></script>
<!-- jsTree -->
<script src="https://cdn.bootcss.com/jstree/3.3.5/jstree.min.js"></script>
```
由于第三方皮肤没有CDN地址，所以我们下载到本地后手动引入（可在文末得源码中获取）：
```html
<link rel="stylesheet" data-th-href="@{css/jsTree/style.min.css}">
```
皮肤预览：
![32px.png](jsTree/32px.png)

## 数据准备
本文用到的数据表：
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
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('1', '0', '开发部', null, TO_DATE('2018-01-04 15:42:26', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('3', '1', '开发二部', null, TO_DATE('2018-01-04 15:42:29', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('5', '0', '人事部', null, TO_DATE('2018-01-04 15:42:32', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('2', '1', '开发一部', null, TO_DATE('2018-01-04 15:42:34', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('4', '0', '市场部', null, TO_DATE('2018-01-04 15:42:36', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('6', '0', '测试部', null, TO_DATE('2018-01-04 15:42:38', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "MRBIRD"."T_DEPT" VALUES ('7', '2', '一部分部', null, TO_DATE('2018-03-16 10:46:31', 'YYYY-MM-DD HH24:MI:SS'));
```
后端框架为Spring Boot + Mybatis（通用mapper），由于本文的重点是jsTree的使用，所以获取数据的细节和数据格式的处理这里不做阐述，具体可参考文末的源码。最终通过Ajax获取到的JSON数据如下所示：
```json
{
    "code": 0,
    "msg": {
        "id": "0",
        "icon": null,
        "url": null,
        "text": "根节点",
        "state": {
            "opened": true
        },
        "checked": true,
        "attributes": null,
        "children": [{
            "id": "1",
            "icon": null,
            "url": null,
            "text": "开发部",
            "state": null,
            "checked": false,
            "attributes": null,
            "children": [{
                "id": "3",
                "icon": null,
                "url": null,
                "text": "开发二部",
                "state": null,
                "checked": false,
                "attributes": null,
                "children": [],
                "parentId": "1",
                "hasParent": true,
                "hasChildren": false
            }, {
                "id": "2",
                "icon": null,
                "url": null,
                "text": "开发一部",
                "state": null,
                "checked": false,
                "attributes": null,
                "children": [{
                    "id": "7",
                    "icon": null,
                    "url": null,
                    "text": "一部分部",
                    "state": null,
                    "checked": false,
                    "attributes": null,
                    "children": [],
                    "parentId": "2",
                    "hasParent": true,
                    "hasChildren": false
                }],
                "parentId": "1",
                "hasParent": true,
                "hasChildren": true
            }],
            "parentId": "0",
            "hasParent": false,
            "hasChildren": true
        }, {
            "id": "5",
            "icon": null,
            "url": null,
            "text": "人事部",
            "state": null,
            "checked": false,
            "attributes": null,
            "children": [],
            "parentId": "0",
            "hasParent": false,
            "hasChildren": false
        }, {
            "id": "4",
            "icon": null,
            "url": null,
            "text": "市场部",
            "state": null,
            "checked": false,
            "attributes": null,
            "children": [],
            "parentId": "0",
            "hasParent": false,
            "hasChildren": false
        }, {
            "id": "6",
            "icon": null,
            "url": null,
            "text": "测试部",
            "state": null,
            "checked": false,
            "attributes": null,
            "children": [],
            "parentId": "0",
            "hasParent": false,
            "hasChildren": false
        }],
        "parentId": "",
        "hasParent": false,
        "hasChildren": true
    }
}
```
## 基本使用方法
使用Ajax从后台获取到如上所示格式的JSON数据（也就是`r.msg`）,然后使用jsTree生成树形控件：

HTML:
```html
<div id="deptTree"></div>
```
JavaScript:
```javascript
<script data-th-inline="javascript">
var ctx = [[@{/}]];
$(function() {
    createDeptTree();
});

function createDeptTree() {
    $.post(ctx + "dept/tree", {}, function(r) {
        var data = r.msg;
        $('#deptTree').jstree({
            "core": {
                'data': data.children
            }
        });
    })
}
</script>
```
效果如下所示：
<link href="../jsTree/style.min.css" rel="stylesheet" type="text/css" />
<style>
div.deptTree{padding:1rem;width:25%;border:1px solid #efefef}
</style>
<div id="deptTree1" class="deptTree"></div>
<!-- jQuery -->
<script src="https://cdn.bootcss.com/jquery/2.2.0/jquery.min.js"></script>
<!-- jsTree -->
<script src="https://cdn.bootcss.com/jstree/3.3.5/jstree.min.js"></script>
<script>
	$('#deptTree1').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    }
	});
</script>

## 常用操作
上面介绍了最基本的jsTree使用方法，下面开始介绍一些常用的jsTree操作。
### 显示Checkbox
JavaScript代码如下所示：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox" ]
});
```
显示效果如下：
<div id="deptTree2" class="deptTree"></div>
<script>
	$('#deptTree2').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    },
	    "plugins" : [ "checkbox" ]
	});
</script>
此时，被选中的选项默认会有浅蓝色的背景，如果想要去除，只需将js代码改为：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox" ],
    "checkbox" : {
      "keep_selected_style" : false
    }
});
```
效果如下所示：
<div id="deptTree3" class="deptTree"></div>
<script>
	$('#deptTree3').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    },
	    "plugins" : [ "checkbox" ],
	    "checkbox" : {
	      "keep_selected_style" : false
	    }
	});
</script>

### Wholerow插件
该插件可以给选中的项目或者hover的项目添加一个行级别的背景色，js代码如下所示：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox", "wholerow" ]
});
```
效果如下所示：

<div id="deptTree4" class="deptTree"></div>
<script>
	$('#deptTree4').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    },
	    "plugins" : [ "checkbox", "wholerow" ]
	});
</script>

添加该插件后，控件前的虚线没了，具体原因未知=。=
### 取消父子关联
默认情况下，选中父节点后，其下的所有子节点也会跟着被选中，取消父子节点关联只需添加`"checkbox": {"three_state": false}`即可：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox" ],
    "checkbox": {
        "three_state": false // 取消选择父节点后选中所有子节点
    },
});
```
效果如下所示：
<div id="deptTree5" class="deptTree"></div>
<script>
	$('#deptTree5').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    },
	    "plugins" : [ "checkbox" ],
	     "checkbox": {
            "three_state": false 
        },
	});
</script>

### 设置单选

设置单选的前提是必须先取消父子关联，然后在`core`里添加：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children,
        'multiple': false // 取消多选
    },
    "plugins" : [ "checkbox" ],
    "checkbox": {
        "three_state": false // 取消选择父节点后选中所有子节点
    },
});
```
效果如下所示：

<div id="deptTree6" class="deptTree"></div>
<script>
	$('#deptTree6').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }],
	        'multiple': false // 取消多选
	    },
	    "plugins" : [ "checkbox" ],
	     "checkbox": {
            "three_state": false 
        },
	});
</script>

### 全部展开
如果需要初始化控件的时候展开树，可调用jsTree的`open_all()`方法：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox" ]
}).on("loaded.jstree", function (event, data) {
    $('#deptTree').jstree().open_all();
});
```
或者设置`state`：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox", "state" ],
    'state': {
        "opened": true,
    }
});
```

效果如下所示：
<div id="deptTree7" class="deptTree"></div>
<script>
$('#deptTree7').jstree({
	    'core': {
	    	'state':{"opened":true},
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    },
	    "plugins" : [ "checkbox" ]
	}).on("loaded.jstree", function (event, data) {
    $('#deptTree7').jstree().open_all();
});
</script>

### 默认选中
jsTree可以在初始化后默认选中某些节点：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox" ],
    "checkbox": {
        "three_state": false 
    },
}).on("loaded.jstree", function (event, data) {
    $('#deptTree').jstree().open_all();
    $('#deptTree').jstree('select_node', [5, 7], true);
    console.log($('#deptTree').jstree(true).get_selected()); // ["5", "7"]
});
```
效果如下所示：
<div id="deptTree8" class="deptTree"></div>
<script>
$('#deptTree8').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    },
	    "plugins" : [ "checkbox" ],
	    "checkbox": {
        "three_state": false // 取消选择父节点后选中所有子节点
    },
	}).on("loaded.jstree", function (event, data) {
    $('#deptTree8').jstree().open_all();
     $('#deptTree8').jstree('select_node',[5,7],true);
});
</script>


### 绑定选取监听
jsTree可以在选中和取消选中的时候绑定监听事件：
```javascript
$('#deptTree').jstree({
    "core": {
        'data': data.children
    },
    "plugins" : [ "checkbox" ]
}).on("changed.jstree", function (e, data) {
    console.log(data.changed.selected); // newly selected
    console.log(data.changed.deselected); // newly deselected
});
```
效果如下所示：
<div id="deptTree9" class="deptTree"></div>
<script>
$('#deptTree9').jstree({
	    'core': {
	        'data': [{
	            "id": "1",
	            "icon": null,
	            "url": null,
	            "text": "开发部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [{
	                "id": "3",
	                "icon": null,
	                "url": null,
	                "text": "开发二部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": false
	            }, {
	                "id": "2",
	                "icon": null,
	                "url": null,
	                "text": "开发一部",
	                "state": null,
	                "checked": false,
	                "attributes": null,
	                "children": [{
	                    "id": "7",
	                    "icon": null,
	                    "url": null,
	                    "text": "一部分部",
	                    "state": null,
	                    "checked": false,
	                    "attributes": null,
	                    "children": [],
	                    "parentId": "2",
	                    "hasParent": true,
	                    "hasChildren": false
	                }],
	                "parentId": "1",
	                "hasParent": true,
	                "hasChildren": true
	            }],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": true
	        }, {
	            "id": "5",
	            "icon": null,
	            "url": null,
	            "text": "人事部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "4",
	            "icon": null,
	            "url": null,
	            "text": "市场部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }, {
	            "id": "6",
	            "icon": null,
	            "url": null,
	            "text": "测试部",
	            "state": null,
	            "checked": false,
	            "attributes": null,
	            "children": [],
	            "parentId": "0",
	            "hasParent": false,
	            "hasChildren": false
	        }]
	    },
	    "plugins" : [ "checkbox","changed" ],
	    "checkbox": {
        "three_state": false // 取消选择父节点后选中所有子节点
    },
	}).on("loaded.jstree", function (event, data) {
    $('#deptTree9').jstree().open_all();
}).on("changed.jstree", function (e, data) {
	if(data.changed.selected.length) alert("选中节点ID："+data.changed.selected);   // newly selected
    if(data.changed.deselected.length) alert("取消选中节点ID："+data.changed.deselected); // newly deselected
 });
</script>

## 附录
其他方法和属性可参考官方文档（官方文档写的比较抽象=。=）：[https://www.jstree.com/api/](https://www.jstree.com/api/)。

源码链接：[https://drive.google.com/open?id=17rdibWmH9CunPP9vs9sQrJPj5FefzoHj](https://drive.google.com/open?id=17rdibWmH9CunPP9vs9sQrJPj5FefzoHj)