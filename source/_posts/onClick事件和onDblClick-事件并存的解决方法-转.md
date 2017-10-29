---
title: 'onClick事件和onDblClick 事件并存的解决方法 [转]'
date: 2016-04-20 09:51:37
tags: JavaScript
---
最近项目中遇到了在同一DOM元素上需要添加 onclick 和 ondblclick 2个事件，如果按照正常的方式添加处理，结果发现只会执行onclick，  

而不会执行 ondblclick；这时我们需要对2个事件的处理函数稍作处理就可以实现2个事件并存了，代码如下：
<!--more-->
```html
<script type="text/javascript">  
  var clickTimer = null;  
  function _click(){  
      if(clickTimer) {  
          window.clearTimeout(clickTimer);  
          clickTimer = null;  
      }  
      clickTimer = window.setTimeout(function(){  
           // your click process code here  
           alert("你单击了我");  
      }, 300);  
  }  
  
   function _dblclick(){  
      if(clickTimer) {  
          window.clearTimeout(clickTimer);  
          clickTimer = null;  
      }  
     // your click process code here  
     alert("你双击了我");  
  }  
</script>  
```
处理思想就是：利用定时器延迟执行onclick事件，这样在双击过程中会取消中途触发的单击事件。

> 转自[山哥](https://my.oschina.net/jsan/blog/123181)