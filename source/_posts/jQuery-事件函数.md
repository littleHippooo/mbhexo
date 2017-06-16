---
title: jQuery 事件函数
date: 2016-10-11 16:43:08
tags: jQuery
---
## 页面载入
### ready()
当DOM载入就绪可以查询及操纵时绑定一个要执行的函数。这个方法纯粹是对向window.load事件注册事件的替代方法。有一个参数对jQuery函数的引用会传递到这个ready事件处理函数中。可以给这个参数任意起一个名字，并因此可以不再担心命名冲突而放心地使用`$`别名。可以在同一个页面中无限次地使用$(document).ready()事件。其中注册的函数会按照（代码中的）先后顺序依次执行。

<!--more-->
示例：    

在DOM加载完成时运行的代码，可以这样写：
```javascript
$(document).ready(function(){
  // 在这里写你的代码...
});
```
使用 `$(document).ready()` 的简写，同时内部的 jQuery 代码依然使用 `$` 作为别名，而不管全局的 `$` 是什么。
```javascript
$(function($) {
  // 你可以在这里继续使用$作为别名...
});﻿​
```
## 事件处理 
### on(eve,[sel],[data],fn)     
`on()`方法在被选元素及子元素上添加一个或多个事件处理程序。

自 jQuery 版本 1.7 起，`on()` 方法是 `bind()`、`live()` 和 `delegate()` 方法的新的替代品。该方法给 API 带来很多便利，我们推荐使用该方法，它简化了 jQuery 代码库。

语法：
```javascript
$(selector).on(event,childSelector,data,function,map)
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                <em>
                    event
                </em>
            </td>
            <td>
                必需。规定要从被选元素移除的一个或多个事件或命名空间。
                <br>
                由空格分隔多个事件值。必须是有效的事件。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    childSelector
                </em>
            </td>
            <td>
                可选。规定只能添加到指定的子元素上的事件处理程序（且不是选择器本身，比如已废弃的 delegate() 方法）。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    data
                </em>
            </td>
            <td>
                可选。规定传递到函数的额外数据。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    function
                </em>
            </td>
            <td>
                可选。规定当事件发生时运行的函数。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    map
                </em>
            </td>
            <td>
                规定事件映射 (
                <em>
                    {event:function, event:function, ...})
                </em>
                ，包含要添加到元素的一个或多个事件，以及当事件发生时运行的函数。
            </td>
        </tr>
</table>

示例：

单击文本时，显示文本的内容：
```javascript
$("p").on("click", function(){
    alert( $(this).text() );
});
```
取消表单提交操作，并通过返回false防止事件冒泡：
```javascript
$("form").on("submit", false)  
```
通过使用`.preventDefault()`取消默认操作：
```javascript
$("form").on("submit", function(event) {
    event.preventDefault();
}); 
```
使用`.stopPropagation()`停止事件冒泡，而不会阻止表单提交：
```javascript
$("form").on("submit", function(event) {
    event.stopPropagation();
});   
```
### off(eve,[sel],[fn])
`off()` 方法通常用于移除通过 `on()` 方法添加的事件处理程序。

自 jQuery 版本 1.7 起，`off()` 方法是 `unbind()`、`die()` 和 `undelegate()` 方法的新的替代品。该方法给 API 带来很多便利，我们推荐使用该方法，它简化了 jQuery 代码库。

语法：
```javascript
$(selector).off(event,selector,function(eventObj),map)
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                <em>
                    event
                </em>
            </td>
            <td>
                必需。规定要从被选元素移除的一个或多个事件或命名空间。
                <br>
                由空格分隔多个事件值。必须是有效的事件。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    selector
                </em>
            </td>
            <td>
                可选。规定添加事件处理程序时最初传递给 on() 方法的选择器。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    function(eventObj)
                </em>
            </td>
            <td>
                可选。规定当事件发生时运行的函数。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    map
                </em>
            </td>
            <td>
                规定事件映射 (
                <em>
                    {event:function, event:function, ...})
                </em>
                ，包含要添加到元素的一个或多个事件，以及当事件发生时运行的函数。
            </td>
        </tr>
</table>

示例：

从所有段落中删除所有事件处理函数：
```javascript
$("p").off()   
```
从所有段落中删除所有单击函数：
```javascript
$("p").off( "click", "**" )
```
通过传递第三个参数，只删除一个先前绑定的处理函数：
```javascript
var foo = function () {
  // code to handle some kind of event
};
 
// ... now foo will be called when paragraphs are clicked ...
$("body").on("click", "p", foo);
 
 
// ... foo will no longer be called.
$("body").off("click", "p", foo); 
```
通过其命名空间解除所有委派的事件处理函数：
```javascript
var validate = function () {
  // code to validate form entries
};
 
// delegate events under the ".validator" namespace
$("form").on("click.validator", "button", validate);
 
$("form").on("keypress.validator", "input[type='text']", validate); 
 
// remove event handlers in the ".validator" namespace
 
$("form").off(".validator");
```
### bind(type,[data],fn)
为每个匹配元素的特定事件绑定事件处理函数。与其相反的函数为`unbind()`。

语法：
```javascript
$(selector).bind(event,data,function,map) 
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                <em>
                    event
                </em>
            </td>
            <td>
                必需。规定添加到元素的一个或多个事件。
                <br>
                由空格分隔多个事件值。必须是有效的事件。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    data
                </em>
            </td>
            <td>
                可选。规定传递到函数的额外数据。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    function
                </em>
            </td>
            <td>
                必需。规定当事件发生时运行的函数。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    map
                </em>
            </td>
            <td>
                规定事件映射 (
                <em>
                    {event:function, event:function, ...})
                </em>
                ，包含要添加到元素的一个或多个事件，以及当事件发生时运行的函数。
            </td>
        </tr>
</table>

示例：    

当每个段落被点击的时候，弹出其文本：
```javascript
$("p").bind("click", function(){
    alert( $(this).text() );
});
```
同时绑定多个事件类型：
```javascript
$('#foo').bind('mouseenter mouseleave', function() {
    $(this).toggleClass('entered');
});
```
同时绑定多个事件类型/处理程序：
```javascript
$("button").bind({
    click:function(){$("p").slideToggle();},
    mouseover:function(){$("body").css("background-color","red");},  
    mouseout:function(){$("body").css("background-color","#FFFFFF");}  
});
```
你可以在事件处理之前传递一些附加的数据：
```javascript
function handler(event) {
    alert(event.data.foo);
}
$("p").bind("click", {foo: "bar"}, handler);
```
通过返回false来取消默认的行为并阻止事件起泡：
```javascript
$("form").bind("submit", function() { return false; })
```
通过使用 `preventDefault()` 方法只取消默认的行为：
```javascript
$("form").bind("submit", function(event){
    event.preventDefault();
});
```
通过使用 `stopPropagation()` 方法只阻止一个事件起泡：
```javascript
$("form").bind("submit", function(event){
    event.stopPropagation();
});﻿​
```
### one(type,[data],fn)  
`one()` 方法为被选元素添加一个或多个事件处理程序，并规定当事件发生时运行的函数。当使用 `one()` 方法时，每个元素只能运行一次事件处理程序函数。

语法：
```javascript
$(selector).one(event,data,function)
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                <em>
                    event
                </em>
            </td>
            <td>
                必需。规定添加到元素的一个或多个事件。由空格分隔多个事件值。必须是有效的事件。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    data
                </em>
            </td>
            <td>
                可选。规定传递到函数的额外数据。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    function
                </em>
            </td>
            <td>
                必需。规定当事件发生时运行的函数。
            </td>
        </tr>
</table>
 
示例：    

当所有段落被第一次点击的时候，显示所有其文本。
```javascript
$("p").one("click", function(){
    alert( $(this).text() );
});﻿​
```
### trigger(type,[data])
`trigger()` 方法触发被选元素上指定的事件以及事件的默认行为（比如表单提交）。这个函数也会导致浏览器同名的默认行为的执行。比如，如果用`trigger()`触发一个'submit'，则同样会导致浏览器提交表单。如果要阻止这种默认行为，应返回false。   

示例：

页面一加载就执行button的click函数：
```javascript
$(document).ready(function(){
    $("button").click(function(){
        alert("123");
    }).trigger("click");
}); 
```
提交第一个表单，但不用submit()
```javascript
$("form:first").trigger("submit")
```
给一个事件传递参数
```javascript
$("p").click( function (event, a, b) {
    // 一个普通的点击事件时，a和b是undefined类型
    // 如果用下面的语句触发，那么a指向"foo",而b指向"bar"
} ).trigger("click", ["foo", "bar"]);
```
下面的代码可以显示一个"Hello World"  
```javascript
$("p").bind("myEvent", function (event, message1, message2) {
    alert(message1 + ' ' + message2);
}).trigger("myEvent", ["Hello","World!"]);﻿​  
```
### triggerHandler(type, [data])
这个方法与`trigger()`类似，但不会执行浏览器默认动作，也不会产生事件冒泡。
## 事件委派
### ~~live(type, [data], fn)~~   
jQuery 给所有匹配的元素附加一个事件处理函数，即使这个元素是以后再添加进来的也有效。这个方法是基本是的 `.bind()` 方法的一个变体。使用 `.bind()` 时，选择器匹配的元素会附加一个事件处理函数，而以后再添加的元素则不会有。为此需要再使用一次 `.bind()` 才行。比如说：
```html
<body>
    <div class="clickme">Click here</div>
</body>
```
可以给这个元素绑定一个简单的click事件：
```javascript
$('.clickme').bind('click', function() {
    alert("Bound handler called.");
});
```
当点击了元素，就会弹出一个警告框。然后，想象一下这之后有另一个元素添加进来了。
```javascript
$('body').append('<div class="clickme">Another target</div>');
```
尽管这个新的元素也能够匹配选择器 ".clickme" ，但是由于这个元素是在调用 `.bind()` 之后添加的，所以点击这个元素不会有任何效果。

`.live()` 就提供了对应这种情况的方法。如果我们是这样绑定click事件的：
```javascript
$('.clickme').live('click', function() {
    alert("Live handler called."); 
});
```
然后再添加一个新元素：
```javascript
$('body').append('<div class="clickme">Another target</div>');
```
然后再点击新增的元素，他依然能够触发事件处理函数。

从 jQuery 1.7 开始，不再建议使用 `.live()` 方法。请使用 `.on()` 来添加事件处理。

与其作用相反的函数为`die()`。
### delegate(sel,[t],[d],fn)   
`delegate()` 方法为指定的元素（属于被选元素的子元素）添加一个或多个事件处理程序，并规定当这些事件发生时运行的函数。使用 `delegate()` 方法的事件处理程序适用于当前或未来的元素（比如由脚本创建的新元素）。

语法：
```javascript
$(selector).delegate(childSelector,event,data,function)
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                <em>
                    childSelector
                </em>
            </td>
            <td>
                必需。规定要添加事件处理程序的一个或多个子元素。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    event
                </em>
            </td>
            <td>
                必需。规定添加到元素的一个或多个事件。由空格分隔多个事件值。必须是有效的事件。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    data
                </em>
            </td>
            <td>
                可选。规定传递到函数的额外数据。
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    function
                </em>
            </td>
            <td>
                必需。规定当事件发生时运行的函数。
            </td>
        </tr>
</table>   

示例：

当点击鼠标时，隐藏或显示 p 元素：

HTML 代码:
```html
<div>
    这是一个段落。
    <button>请点击这里</button>
</div>
```
jQuery 代码:
```javascript
$("div").delegate("button","click",function(){
    $("p").slideToggle();
});﻿​ 
```
`delegate`这个方法可作为`live()`方法的替代，使得每次事件绑定到特定的DOM元素。

以下两段代码是等同的:
```javascript
$("table").delegate("td", "hover", function(){ 
    $(this).toggleClass("hover");
});
$("table").each(function(){   
    $("td", this).live("hover", function(){          
        $(this).toggleClass("hover");    
    });    
});﻿​
```
与其相反的函数是`undelegate()`。
## 事件切换
### hover([over,]out)
当鼠标移动到一个匹配的元素上面时，会触发指定的第一个函数。当鼠标移出这个元素时，会触发指定的第二个函数。

示例：    

鼠标悬停的表格加上特定的类：
```javascript
$("td").hover(
    function () {
        $(this).addClass("hover");
    },
    function () {
        $(this).removeClass("hover");
    }
);﻿​
```
下面连段代码效果相同：
```javascript
$("td").bind("mouseenter mouseleave",handlerInOut);
$("td").hover(handlerInOut);
```
### toggle([s],[easing],[fn])
`toggle()` 方法在被选元素上进行 `hide()` 和 `show()` 之间的切换。

如：在所有 `` 元素上进行隐藏和显示之间的切换：
```javascript
$("button").click(function(){
    $("p").toggle();
});
```
该方法检查被选元素的可见状态。如果一个元素是隐藏的，则运行 `show()`，如果一个元素是可见的，则运行 `hide()` - 这会造成一种切换的效果。

带参数语法：
```javascript
$(selector).toggle(speed,easing,callback) 
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                <em>
                    speed
                </em>
            </td>
            <td>
                可选。规定隐藏/显示效果的速度。
                
                    可能的值：
                
                <ul>
                    <li>
                        毫秒
                    </li>
                    <li>
                        "slow"
                    </li>
                    <li>
                        "fast"
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    easing
                </em>
            </td>
            <td>
                可选。规定在动画的不同点上元素的速度。默认值为 "swing"。
                
                    可能的值：
                
                <ul>
                    <li>
                        "swing" - 在开头/结尾移动慢，在中间移动快
                    </li>
                    <li>
                        "linear" - 匀速移动
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <td>
                <em>
                    callback
                </em>
            </td>
            <td>
                可选。toggle() 方法执行完之后，要执行的函数。
            </td>
        </tr>
</table>

1秒之内动态隐藏和显示p元素：
```javascript
$("button").click(function(){
    $("p").toggle(1000);
});
```
1秒之内动态隐藏和显示p元素，并执行回调函数：
```javascript
$("button").click(function(){
    $("p").toggle(1000,function(){
        alert("toggle() 方法已完成!");
    });﻿​
});
```
`toggle(fn1,fn2...fnN)`函数也可以用于几个函数间的切换，现有如下代码：
```javascript
$("panel h5.head").bind("click",function(){
        var $content=$(this).next("div.content");
        if($content.is(":visible")){
            $content.hide();
        }else{
            $content.show();
        }
    }
);
```
使用`toggle`改写：
```javascript
$("panel h5.head").toggle(
    function(){
        $(this).next("div.content").show();    
    },function(){
        $(this).next("div.content").hide();
    }
);
```
## 事件
### blur([[data],fn])
当元素失去焦点时触发 `blur` 事件。

示例：

触发所有段落的`blur`事件：
```javascript
$("p").blur();
```
任何段落失去焦点时弹出一个 "Hello World!"在每一个匹配元素的blur事件中绑定的处理函数：
```javascript
$("p").blur( function () { alert("Hello World!"); } );﻿​
```
### change([[data],fn])

当元素的值改变时发生 `change` 事件（仅适用于表单字段）。

示例：

当`<input>`文本值发生改变，且失去焦点或者按Enter键的时候触发：
```javascript
$("input").change(function(){
    alert("文本已被修改");
});
```
注意，在输入过程中，虽然值不断改变，但不会触发`change()`，除非`<input>`失去焦点或者按Enter键的时候触发。
### click([[data],fn])
略。
### dblclick([[data],fn])
略。
### error([[data],fn])
当元素遇到错误（没有正确载入）时，发生 error 事件。

如：图片加载错误时，替换为文本提示：
```javascript
$("img").error(function(){
    $("img").replaceWith("<p>图片加载错误!</p>");
});
```
### focus([[data],fn])   
当元素获得焦点时，触发 focus 事件。可以通过鼠标点击或者键盘上的TAB导航触发。这将触发所有绑定的focus函数。

示例：    

当页面加载后将 id 为 'login' 的元素设置焦点：
```javascript
$(document).ready(function(){
    $("#login").focus();
});
```
使人无法使用文本框：
```javascript
$("input[type=text]").focus(function(){
    this.blur();
});﻿​
```
### focusin([data],fn)  
当元素（或在其内的任意元素）获得焦点时发生 `focusin` 事件。

当在元素或在其内的任意元素上发生 focus 事件时，`focusin()` 方法添加要运行的函数。与 `focus()` 方法不同的是，`focusin() `方法在任意子元素获得焦点时也会触发。

例如，现有div：
```html
<div style="border: 1px solid black;padding:10px;">
    First name: <input type="text"><br>
    Last name: <input type="text">
</div>
```
div子元素`<input>`获得焦点时，改变div的颜色：
```javascript
$("div").focusin(function(){
    $(this).css("background-color","#FFFFCC");
});
```
### focusout([data],fn)
与`foucusin`相反。
### keydown([[data],fn])
当键盘或按钮被按下时，发生 `keydown` 事件。

例如：在页面内对键盘按键做出回应，可以使用如下代码：
```javascript
$(window).keydown(function(event){
    switch(event.which) {
        // ...
        // 不同的按键可以做不同的事情
        // 不同的浏览器的keycode不同
        // ...
    }
});
```
### keypress([[data],fn])
`keydown`：用户在键盘上按下某按键是发生。一直按着某按键则会不断触发（opera浏览器除外）。

`keypress`：用户按下一个按键，并产生一个字符时发生（也就是不管类似shift、alt、ctrl之类的键，就是说用户按了一个能在屏幕上输出字符的按键keypress事件才会触发）。一直按着某按键则会不断触发。
### keyup([[data],fn])
当按钮被松开时，发生 `keyup` 事件。
### mousedown([[d,fn])    
当鼠标指针移动到元素上方，并按下鼠标按键时，会发生 `mousedown` 事件。`mousedown` 与 `click` 事件不同，`mousedown` 事件仅需要按键被按下，而不需要松开即可发生。鼠标按键可以为左键右键和滚轮。
### mouseup([[data],fn])
与`mousedown()`相反。

例子：

当鼠标指向`<div>`并按下鼠标按键时，以及松开时触发事件：

HTML：
```html
<div>在这个 div 元素中按下和释放鼠标按钮。</div>
```
jQuery：
```javascript
$("div").mouseup(function(){
    $(this).after("释放鼠标按钮。");
});
$("div").mousedown(function(){
    $(this).after("按下鼠标按钮。");
});
```
### mouseenter([[data],fn])
当鼠标指针穿过元素时，会发生 `mouseenter` 事件。该事件大多数时候会与 `mouseleave` 事件一起使用。
### mouseleave([[data],fn])
当鼠标指针离开元素时，会发生 `mouseleave` 事件。该事件大多数时候会与 `mouseenter` 事件一起使用。

例子：

当鼠标指针进入 `<p>` 元素时，设置背景色为黄色，离开时设置为灰色：

HTML：
```thml
<p>鼠标移动到该段落。</p>
```
jQuery：
```javascript
$("p").mouseenter(function(){
    $("p").css("background-color","yellow");
});
$("p").mouseleave(function(){
    $("p").css("background-color","lightgray");
});
```
### mouseover([[d],fn])    
当鼠标指针位于元素上方时，会发生 `mouseover` 事件。该事件大多数时候会与 `mouseout` 事件一起使用。

注释：与 `mouseenter` 事件不同，不论鼠标指针穿过被选元素或其子元素，都会触发 `mouseover` 事件。
### mouseout([[data],fn])
当鼠标指针从元素上移开时，发生 `mouseout` 事件。
### mousemove([[data],fn])
当鼠标指针在指定的元素中移动时，就会发生 `mousemove` 事件。

例子：

获得鼠标指针在页面中的位置：
```javascript
$(document).mousemove(function(event){
    $("span").text(event.pageX + ", " + event.pageY);
});
```
### resize([[data],fn])
当调整浏览器窗口的大小时，发生 `resize` 事件。

例子：

HTML：
```html
<p>窗口重置了 <span>0</span> 次大小。</p>
```
jQuery：
```javascript
$(window).resize(function(){
    $("span").text(x+=1);
});
```
### scroll([[data],fn])
当用户滚动指定的元素时，会发生 `scroll` 事件。

对元素滚动的次数进行计数：
```javascript
$("div").scroll(function(){
    $("span").text(x+=1);
});
```
### select([[data],fn])
当 textarea 或文本类型的 input 元素中的文本被选择时，会发生 `select` 事件。
```javascript
$("input").select(function(){
    alert("文本已选中!");
});        
```
### submit([[data],fn])    
当提交表单时，会发生 `submit` 事件。该事件只适用于表单元素。  

如果你要阻止表单提交:
```javascript
$("form").submit( function () {
    return false;
});﻿​
```
### unload([[data],fn])
当用户离开页面时，会发生 `unload` 事件。

当发生以下情况下，会触发 `unload` 事件：

1.点击某个离开页面的链接

2.在地址栏中键入了新的 URL

3.使用前进或后退按钮

4.关闭浏览器窗口

5.重新加载页面

`unload()` 方法只应用于 `window` 对象。
```javascript
$(window).unload(function(){
    alert("Goodbye!");
});
```