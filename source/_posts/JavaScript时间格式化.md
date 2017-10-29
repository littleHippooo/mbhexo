---
title: JavaScript时间格式化
date: 2016-08-30 19:29:22
tags: JavaScript
---
有时候后台传送的时间格式是这样的：1471881600000，或者通过`new Date( )`生成的时间格式是这样的：Tue Aug 30 2016 16:32:38 GMT+0800 (中国标准时间)。JavaScript没有类似于java的`SimpleDateFormat( )`函数，这时候可以自己写一个函数代替：

<!--more-->
```javascript
//时间格式化
Date.prototype.Format = function (fmt) { 
    var o = {
        "M+": this.getMonth() + 1, 
        "d+": this.getDate(), 
        "h+": this.getHours(), 
        "m+": this.getMinutes(),
        "s+": this.getSeconds(), 
        "q+": Math.floor((this.getMonth() + 3) / 3), 
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt)){
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "")
            .substr(4 - RegExp.$1.length));
    }
    for (var k in o){
        if (new RegExp("(" + k + ")").test(fmt)){
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ?
             (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        } 
    }
    return fmt;
}
```
调用方式：`new Date( ).Format("yyyy-MM-dd")`;