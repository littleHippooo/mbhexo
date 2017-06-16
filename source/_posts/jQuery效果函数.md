---
title: jQuery效果函数
date: 2017-05-18 11:48:43
tags: jQuery
---
## 基本
### show()：
用于显示所有匹配的元素。此外，你还可以指定元素显示的过渡动画效果。 如果元素本身是可见的，则不对其作任何改变。如果元素是隐藏的，则使其可见。
常用语法：`jQueryObject.show( [ duration ] [, easing ] [, complete ] )`。
<table>
    <tr>
      <th>参数</th>
      <th>描述</th></tr>
    <tr>
      <td>duration</td>
      <td>
        可选/String/Number类型指定过渡动画运行多长时间（毫秒数），默认值为400。该参数也可以为字符串"fast"（=200）或"slow"（=600）。</td></tr>
    <tr>
      <td>easing</td>
      <td>
        可选/String类型指定使用何种动画效果，默认为"swing"，还可以设为"linear"或其他自定义的动画样式的函数名称。</td></tr>
    <tr>
      <td>complete</td>
      <td>
        可选/Function类型元素显示完毕后需要执行的函数。函数内的
        <code>this</code>指向当前DOM元素。</td></tr>
</table>
<!--more-->
比如显示p元素，过渡动画为600ms：
```javascript
$("p").show(600); 
// 或者 $("p").show("slow"); $("p").show( { duration: 1000 } );
```
显示p元素，过度动画为200ms，动画效果为linear：
```javascript
$("p").show(600,"linear");
```
显示p元素，并添加回调函数：
```javascript
$("p").show(function(){ alert('显示完毕') });
```
### hide()
用于隐藏所有匹配的元素。作用和`show()`相反，语法一样，这里不再赘述。
例如隐藏p元素，动画速度为fast，并添加回调：
```javascript
$("p").hide("fast",function(){ alert('隐藏完毕') });
```
## 滑动
### slideDown()
用于显示所有匹配的元素，并带有向下滑动的过渡动画效果。 向下滑动的动画效果，即元素可见区域的高度从0逐渐增大到其原有高度(向下逐渐展开)。 如果元素本身是可见的，则不对其作任何改变。如果元素是隐藏的，则使其可见。
语法和`show()`一致，不再赘述。
### slideUp()
效果和`slideUp()`相反，语法一致，不再赘述。
### slideToggle()
用于切换所有匹配的元素，并带有滑动的过渡动画效果。 所谓"切换"，也就是如果元素当前是可见的，则将其隐藏（向上滑动）；如果元素当前是隐藏的，则使其显示（向下滑动）。
语法和`show()`一致，不再赘述。
例如，向上或向下滑动下拉框div元素，并添加回调：
```javascript
$("div").slideToggle(function(){
    var $this = $(this);
    if($this.is(":visible")){
        alert("向下滑动展开");
    }else{
        alert("向上滑动隐藏");
    }
});
```
## 淡入淡出
### fadeIn()
用于显示所有匹配的元素，并带有淡入的过渡动画效果。 淡入的动画效果，即元素的不透明度的比例从0%逐渐增加到100%。 如果元素本身是可见的，则不对其作任何改变。如果元素是隐藏的，则使其可见。
语法和`show()`一致，不再赘述。
### fadeOut()
用于隐藏所有匹配的元素，并带有淡出的过渡动画效果。效果和`fadeIn()`相反，语法和`show()`一致，不再赘述。
### fadeTo()
以渐进的方式把元素从当前透明的过渡到指定的透明度。可以指定过渡时长，目标透明度，回调函数等。
常用语法：`fadeTo(duration,opacity [,complete])`。
例如，将p元素的透明的调整为.5，时长200ms，并添加回调：
```javascript
$( "p" ).fadeTo( "slow" , 0.5, function() {
    // Animation complete.
});
```
### fadeToggle()
用于切换所有匹配的元素，并带有淡入/淡出的过渡动画效果。 所谓"切换"，即如果元素当前是可见的，则将其隐藏（淡出）；如果元素当前是隐藏的，则使其显示（淡入）。语法和`show()`一致，不再赘述。
## 自定义
### animate()
用于执行一个基于css属性的自定义动画。 你可以为匹配的元素设置css样式，`animate()`函数将会执行一个从当前样式到指定的css样式的一个过渡动画。
常用语法：`jQueryObject.animate( cssProperties [, duration ] [, easing ] [, complete ] )`。


| 参数       | 描述   | 
| --------   | -----  | 
| cssProperties    | Object类型一个或多个css属性的键值对所构成的Object对象。 | 
| duration      |   可选/String/Number类型指定动画运行多长时间（毫秒数），默认值为400。该参数也可以为字符串"fast"（=200）或"slow"（=600）。  |
| easing       |   可选/String类型指定使用何种动画效果，默认为"swing"，还可以设为 "linear"或其他自定义的动画样式函数。    | 
| complete       |   可选/Function类型元素显示完毕后需要执行的函数。函数内的this指向当前DOM元素。    | 


大多数非数值的css属性都无法用来执行动画。例如：width、height、left、top都可用于动画，但color、background-color无法用于动画（除非使用[jQuery.Color()](https://github.com/jquery/jquery-color)插件）。除非你为属性值指定了单位（例如：px、em、%），否则默认的数值单位为像素（px）。</br>

速写的css属性可能无法获得完整全面的支持，例如：border、margin等，因此不推荐使用。</br>

你还可以将css属性值设为一些特定的字符串，例如："show"、"hide"、"toggle"，则jQuery会调用该属性默认的动画形式。</br>

此外，css属性值也可以是相对的，你可以为属性值加上前缀"+="或"-="，以便于在原来的属性值上增加或减少指定的数值。例如：`{ "height": "+=100px" }`，表示在原有高度的基础上增加100px。</br>

例如，给div高度调整为300px，宽度调整为400px，动画时长为slow：</br>
```javascript
$("div").animate( { width: "400px", height: "300px" }, "slow" );
```
根据div高度切换显示/隐藏，显示时高度从0增加到原高度，隐藏时高度从原高度减小到0：
```javascript
$("div").animate( { height: "toggle" });
```
### stop()
用于停止当前匹配元素上正在运行的动画。比如div绑定了三个animate动画函数：
```javascript
var $myDiv = $("div");
$myDiv.animate( { height: "+=300px" }, 2000 ); // 动画1
$myDiv.animate( { width: "50%" }, 1000 );  // 动画2
```
假设当前div元素正在执行第一个动画，此时执行以下`stop()`函数时，效果为：
```javascript
$myDiv.stop( ); // 马上停止动画1，继续按顺序执行动画2和动画3
$myDiv.stop( true ); // 马上停止动画1，并且不再执行动画2和动画3
$myDiv.stop( "fx", true ); // 效果和$myDiv.stop( true );一样
$myDiv.stop( true, true ); // 立刻马上执行完动画1，并不再执行动画2和动画3
```
### delay()
用于延迟队列中下一项的执行。`delay()`可以将队列中等待执行的下一个动画延迟指定的时间后才执行。它常用在队列中的两个jQuery效果函数之间，从而在上一个动画效果执行后延迟下一个动画效果的执行时间。
如果下一项不是效果动画（比如show()就不是效果动画），则它不会被加入效果队列中，因此该函数不会对它进行延迟调用。
比如：
```javascript
var $myDiv = $("div");
$myDiv.slideUp( 1000 ).delay( 5000 ).slideDown( 1500 );
//先执行slideUp()，然后等待5s，在执行slideDown()
```
### finish()
停止当前正在运行的动画，删除所有队列中的动画，直接显示最终动画执行完毕的效果。比如div绑定了三个animate动画函数：
```javascript
var $myDiv = $("div");
$myDiv.animate( { height: "+=300px" }, 2000 ); // 动画1
$myDiv.animate( { width: "50%" }, 1000 );  // 动画2
$myDiv.animate( { width: "200px", height: "100px" }, 1000 ); // 动画3
```
假设当前div元素正在执行第一个动画，此时执行`finish()`函数时，立刻停止当前动画，并且div直接变为最终状态（`width: "200px", height: "100px"`）。
## 设置
### jQuery.fx.interval
用于设置jQuery动画每隔多少毫秒绘制一帧图像，该值越小，则动画的触发次数越多，动画效果也更明显、更平滑，当然也就越耗费性能，默认值为13。设置帧数为5：
```javascript
$.fx.interval = 5;
```
### jQuery.fx.off
关闭页面上所有的动画。把这个属性设置为true可以立即关闭所有动画（所有效果会立即执行完毕）。
有些情况下可能需要这样，比如你在配置比较低的电脑上使用jQuery。当把这个属性设成false之后，可以重新开启所有动画。
禁用动画效果：
```javascript
$.fx.off = true; // 禁用动画效果
```
> **参考网站：**</br>
http://www.365mini.com/ </br>
http://caibaojian.com/jquery/