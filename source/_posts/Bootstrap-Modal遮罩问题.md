---
title: Bootstrap Modal遮罩问题
date: 2017-12-31 10:03:52
tags: Bootstrap
---
当同时打开多层Modal并关闭的时候，发现页面的遮罩层并没有消失，可以使用下面的方法手动删除：
```javascript
 $("modal").bind('hide.bs.modal', function() {
     $(".modal-backdrop").remove();
 })
 ```
 <!--more-->