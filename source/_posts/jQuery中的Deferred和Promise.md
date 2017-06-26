---
title: jQuery中的Deferred和Promise
date: 2017-05-20 15:50:25
tags: jQuery
---
jQuery中的Deferred和Promise有助于我们处理Ajax这样的异步过程，以jQuery中的\$.ajax()为例，当嵌套多个\$.ajax()异步函数时，代码就成了下面这样：

<!--more-->

```javascript
$.ajax({
    url: "myUrl1.do",
    success:function(){
        $.ajax({
            url: "myUrl2.do",
            success:function(){
                $.ajax({
                    url: "myUrl3.do",
                    success:function(){
                        $.ajax({
                            url: "myUrl4.do",
                            success:function(r){
                                console.log("假如你愿意一层一层剥开我的心...")
                                console.log(r);
                            }
                        });
                    }
                });
            }
        });
    }
});
```
这种“金字塔”式的代码就是所谓的“回调地狱”。这种风格的代码使得调试变得很困难，使用jQuery中`Promise`对象可以很好的处理这个问题。
## 使用Promise改写\$.ajax()回调
实际上，`$.ajax()`返回的就是`Promise`对象，如：
```javascript
var promise = $.ajax({url:'myUrl.do'});
promise.done(function(){
    // 成功时，执行该函数
})
promise.fail(function(){
    // 失败时，执行该函数
})
promise.always(function(){
    // 无论成功或失败，都执行该函数
})
```
我们也可以用`then()`方法把`done()`和`fail()`合并到一起。
```javascript
promise.then(function(){
    // done
}, function(){
    // fail
})
```
第一个参数表示done方法，第二个方法表示fail方法；如果只传递一个参数的话，就表示done方法。

所以，现在来改写一下上面的“金字塔”代码：
```javascript
var promise1 = $.ajax({url:"myUrl1.do"});
var promise2 = promise1.then(function(){
	return $.ajax({url:"myUrl2.do"});
});
var promise3 = promise2.then(function(){
	return $.ajax({url:"myUrl3.do"});
});
var promise4 = promise3.then(function(){
	return $.ajax({url:"myUrl4.do"});
});
promise4.then(function(r){console.log(r);});
```
是不是好了很多？
## jQuery中的$.when()
当多个Ajax请求都成功的时候，执行某个回调函数，这时候就可以使用`$.when()`方法。如：
```javascript
$.when(
    $.ajax({url:'myUrl1.do'}),
    $.ajax({url:'myUrl2.do'})
).done(function(result1, result2){
    console.log(result1);
    console.log(result2);
}).fail(function(r){
    console.log("error");
})
```
在这个例子中，只有当两个Ajax请求都成功时，才会调用done方法。否则就调用fail方法。
## $.Deferred()
`$.Deferred().promise()`方法可以返回一个Promise对象。`$.Deferred()`包含了三种状态：

1. pending：等待状态

2. resolved：成功（解决）状态

3. rejected：失败（拒绝）状态

默认的状态为pending，可以使用resolve和reject方法来改变状态：
```javascript
var deferred = $.Deferred();
console.log(deferred.state()); //pending

deferred.reject();
console.log(deferred.state()); //rejected
```
或者：
```javascript
var deferred = $.Deferred();
console.log(deferred.state()); //pending

deferred.resolve();
console.log(deferred.state()); //resolved
```
当状态为rejected时，执行fail方法。当状态为resolved时，执行done方法。而always方法无论成功与失败都会执行。

例如，下面这个例子三秒后弹出success：
<iframe height='300' scrolling='no' title='deferred' src='//codepen.io/mrbird/embed/jwGYPp/?height=300&theme-id=30192&default-tab=js&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/jwGYPp/'>deferred</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>
