---
title: 几个精彩的JavaScript代码段
date: 2017-01-12 10:08:01
tags: JavaScript
---
1.根据给定的条件在原有的数组上，得到所需要的新数组
```javascript
var a = [-1, -1, 1, 2, -2, -2, -3, -3, 3, -3];
function f(s, e) {
    var ret = [];
    for (var i in s) { // 根据原有的数组长度进行循环
        ret.push(e(s[i]));
    }
    return ret;
}
f(a, function(n) {
    return n > 0 ? n : 0
}); // 传输一个匿名函数作为逻辑判断​
```
<!--more-->
2.比原生type或typeof更详细的类型监测方法 
```javascript
function type(p) {
    /function.(\w*)\(\)/.test(p.constructor); //通过其构造函数来获取对应的类型。
    return RegExp.$1;
}   
```
3.通过移位运算来替代”parseInt”
```javascript
~~3.14 = > 3;
// ~~ 取整。~取当前数值的反,~~表示再次取反，也就是得到当前自身
// （说明，JS中的“位”运算会将数值自动转换为整）
```
4.将数值转换为16进制的字符串（常用于表示色彩） 
```javascript
(~~ (Math.random() * (1 << 24))).toString(16)
// ~~ 通过位运算来取整。
// << 左移位。将1的二进制数左移24位。而1<<24 == 2^24(RGB模式下最多可表示的色彩数量)
// toString(16) 将数值转换为16进制的字符串输出。
```
5.正则匹配清除两侧空格
```javascript
var trim = function(v){
    var patrn = /^\s*(.*?)\s+$/;
    return (patrn.test(v))? RegExp.$1 : 'null ';
}
```
> 转自：微信公众号：JavaScriptcn