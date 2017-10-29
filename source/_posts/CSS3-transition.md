---
title: CSS3 transition
date: 2017-07-18 14:14:32
tags: [CSS3,CSS]
---
transform呈现的是一种变形结果，而Transation呈现的是一种过渡，通俗点说就是一种动画转换过程，如渐显、渐弱、动画快慢等。transition可以和Transform同时使用。transition是一个复合属性，可以同时定义transition-property、transition-duration、transition-timing-function、transition-delay子属性值。
<!--more-->
## transition-property
`transition-property`设置要以动画方式变换的CSS属性。默认值all表示变换所有的属性，如果只针对单个或者多个CSS属性进行变换，就可以用这个属性来进行单独设置。语法如下：
```css
transition-property: all | none | <property>[ ,<property> ]*
```
例如：

<iframe height='543' scrolling='no' title='ModvYa' src='//codepen.io/mrbird/embed/ModvYa/?height=543&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/ModvYa/'>ModvYa</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## transition-duration
`transition-duration`用来定义转换动画的时间长度，即从旧属性换到新属性花费的时间，单位为秒。默认情况下动画过渡时间为0秒。语法如下：
```css
transition-duration:<time>[ ,<time>]*;
```
例如：

<iframe height='476' scrolling='no' title='OgYjXq' src='//codepen.io/mrbird/embed/OgYjXq/?height=476&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/OgYjXq/'>OgYjXq</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## transition-delay
`transition-delay`可以设置动画延迟执行的时间，默认值0表示立即执行，时间可以是正数也可以是负数，负数表示截断规定时间内的动画。单位是秒，也可以是毫秒。语法如下：
```css
transition-delay:<time>[ ,<time>]*;
```
time的取值：

1. 0：不延迟，直接执行。

2. 正数：按照设置的时间延迟。

3. 负数：设置时间前的动画将被截断。

<iframe height='525' scrolling='no' title='dREzWK' src='//codepen.io/mrbird/embed/dREzWK/?height=525&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/dREzWK/'>dREzWK</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## transition-timing-function
`transition-timing-function`可以设置动画的过渡效果，默认值ease。语法如下：
```css
transition-timing-function: linear | ease | ease-in | ease-out | ease-in-out | cubic-bezier(<number>, <number>, <number>, <number>)[ ,linear | ease | ease-in | ease-out | ease-in-out | cubic-bezier(<number>, <number>, <number>, <number>) ]* ;
```
属性可取的值如下：

1. ease：缓解效果，等同于cubic-bezier(0.25,0.1,0.25,1.0)函数，既立方贝塞尔。

2. linear：线性效果，等同于cubic-bezier(0.0,0.0,1.0,1.0)函数。

3. ease-in：渐显效果，等同于cubic-bezier(0.42,0,1.0,1.0)函数。

4. ease-out：渐隐效果，等同于cubic-bezier(0,0,0.58,1.0)函数。

5. ease-in-out：渐显渐隐效果，等同于cubic-bezier(0.42,0,0.58,1.0)函数。

6. cubic-bezier：特殊的立方贝塞尔曲线效果。

各种效果对比：

<iframe height='512' scrolling='no' title='LLojdr' src='//codepen.io/mrbird/embed/LLojdr/?height=512&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/LLojdr/'>LLojdr</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## 多个值的运用
CSS3里头的动画属性可以对应多个值，也就是说可以对进行动画的不同的属性来设置不一样的值。举个例子说明：

<iframe height='529' scrolling='no' title='ZyNXxj' src='//codepen.io/mrbird/embed/ZyNXxj/?height=546&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/ZyNXxj/'>ZyNXxj</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

可以看出第一个元素所有的属性都是在同样的时间内完成了动画，而第二个元素的left,top,background是在不同的时间内完成动画，这就是对变换时间设置了多个值的效果，每个进行动画的属性对应了相应的变换时间。

> 参考自[http://isux.tencent.com/css3](http://isux.tencent.com/css3)