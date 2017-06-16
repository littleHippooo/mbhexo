---
title: 解決jQuery和其他库的冲突
date: 2016-09-24 00:22:25
tags: jQuery
---
## jQuery库在其他库之后导入
在其他库和jQuery库都被加载完毕后，可以任何时候调用`jQuery.noConflict()`函数来将变量\$的使用权移交给其他JavaScript库。示例如下：
<!--more-->
```html
// ...省略其他代码
<p id="pp">Test-prototype(将被隐藏)</p>
<p >Test-jQuery(将被绑定单击事件)</p>
<!-- 引入 prototype  -->
<script src="lib/prototype.js" type="text/javascript"></script>
<!-- 引入 jQuery  -->
<script src="../../scripts/jquery.js" type="text/javascript"></script>
<script type="text/javascript">
jQuery.noConflict();                //将变量$的控制权让渡给prototype.js
jQuery(function(){                  //使用jQuery
    jQuery("p").click(function(){
        alert( jQuery(this).text() );
    });
});
 
$("#pp").style.display = 'none';	    //使用prototype.js隐藏元素
</script>
 
</body>
// ...省略其他代码
```
然后，就可以在程序里使用jQuery()函数作为jQuery对象的制造工厂。

此外，还有另外一种选择。如果想确保jQuery'不会与其他库冲突，但又想自定义一个快捷方式。可以进行如下操作：
```javascript
// ...省略其他代码
<script type="text/javascript">
var $j = jQuery.noConflict();       //自定义一个比较短快捷方式
$j(function(){                      //使用jQuery，利用自定义快捷方式——$j
    $j("p").click(function(){
        alert( $j(this).text() );
    });
});
 
$("#pp").style.display = 'none';	    //使用prototype.js隐藏元素
</script>
// ...省略其他代码
```
可以自定义备用名称，例如jq，\$j等。

如果不想自定义名称，还想继续使用\$符号，又不能与其他js库冲突的话，可以使用以下两种办法：

其一：
```javascript
<script type="text/javascript">
jQuery.noConflict();                //将变量$的控制权让渡给prototype.js
jQuery(function($){                 //使用jQuery设定页面加载时执行的函数
    $("p").click(function(){        //在函数内部继续使用 $() 方法
        alert( $(this).text() );
    });
});
 
$("#pp").style.display = 'none';     //使用prototype
</script>
```
其二：
```javascript
<script type="text/javascript">
jQuery.noConflict();                //将变量$的控制权让渡给prototype.js
(function($){                       //定义匿名函数并设置形参为$
    $(function(){                   //匿名函数内部的$均为jQuery
        $("p").click(function(){    //继续使用 $() 方法
            alert($(this).text());
        });
    });
})(jQuery);                         //执行匿名函数且传递实参jQuery
 
$("#pp").style.display = 'none';     //使用prototype
</script>
```
## jQuery库在其他库之前导入
如果jQuery库在其他库之前就导入了，那么可以直接使用“jQuery”来做一些jQuery的工作，同时，可以使用\$()方法作为其他库的快捷方式。无需调用`jQuery.noConflict()`函数。示例如下：
```html
<!-- 引入 jQuery  -->
<script src="../../scripts/jquery.js" type="text/javascript"></script>
<!-- 引入 prototype  -->
<script src="lib/prototype.js" type="text/javascript"></script>
</head>
<body>
<p id="pp">Test-prototype(将被隐藏)</p>
<p >Test-jQuery(将被绑定单击事件)</p>
 
<script type="text/javascript">
jQuery(function(){    //直接使用 jQuery ,没有必要调用"jQuery.noConflict()"函数。
    jQuery("p").click(function(){      
        alert( jQuery(this).text() );
    });
});
 
$("#pp").style.display = 'none'; //使用prototype
</script>
</body>
```
