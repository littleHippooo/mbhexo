---
title: CSS3 animation
date: 2017-07-18 16:44:18
tags: CSS3
---
CSS3的animation属性可以绘制各种复杂的动画，animation属性由以下8种属性的简写形式： animation-name，animation-duration，animation-timing-function，animation-delay，animation-iteration-count，animation-direction 和 animation-fill-mode。下面一一介绍这八种属性。
<!--more-->
## animation-name
CSS3中使用@keyframes定义动画的名称以及具体动画的关键帧。而`animation-name`属性则是用于指定使用哪个动画，比如使用@keyframes定义一个简单的动画：
```css
@-webkit-keyframes demo{
    from { left: 0; }
    to { left: 400px ;}
}
```
也可以使用百分比来定义关键帧位置：
```css
@-webkit-keyframes demo{
    0% { left: 0; }
    50% { left: 200px; }
    100% { left: 400px; }
}
```
然后使用`animation-name`属性指定使用demo动画：
```css
div {
    -webkit-animation-name: demo;
}
```
## animation-duration
`animation-duration`指定对象动画的持续时间。属性值为正数，单位可以是秒(s)或者毫秒(ms)。默认值为0，表明动画不执行。比如：

<iframe height='289' scrolling='no' title='QgRQgM' src='//codepen.io/mrbird/embed/QgRQgM/?height=285&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/QgRQgM/'>QgRQgM</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## animation-timing-function
设置对象动画的过渡类型，如果提供多个属性值，以逗号进行分隔。类似于`transition-timing-function`。语法如下：
```css
animation-timing-function: linear | ease | ease-in | ease-out | ease-in-out | step-start | step-end | steps(<number>[, [ start | end ] ]?) | cubic-bezier(<number>, <number>, <number>, <number>) [, linear | ease | ease-in | ease-out | ease-in-out | step-start | step-end | steps(<number>[, [ start | end ] ]?) | cubic-bezier(<number>, <number>, <number>, <number>) ]*;
```
属性可取的值有：

1. `ease`：缓解效果，等同于`cubic-bezier(0.25,0.1,0.25,1.0)`函数，既立方贝塞尔。

2. `linear`：线性效果，等同于`cubic-bezier(0.0,0.0,1.0,1.0)`函数。

3. `ease-in`：渐显效果，等同于`cubic-bezier(0.42,0,1.0,1.0)`函数。

4. `ease-out`：渐隐效果，等同于`cubic-bezier(0,0,0.58,1.0)`函数。

5. `ease-in-out`：渐显渐隐效果，等同于`cubic-bezier(0.42,0,0.58,1.0)`函数。

6. `step-start`：马上转跳到动画结束状态。

7. `step-end`：保持动画开始状态，直到动画执行时间结束，马上转跳到动画结束状态。

8. `steps(<number>[, [ start | end ] ]?)`：第一个参数number为指定的间隔数，即把动画分为n步阶段性展示，第二个参数默认为end，设置最后一步的状态，start为结束时的状态，end为开始时的状态，若设置与animation-fill-mode的效果冲突，而以animation-fill-mode的设置为动画结束的状态。

9. `cubic-bezier(<number>, <number>, <number>, <number>)`：特殊的立方贝塞尔曲线效果。

各种效果对比：

<iframe height='630' scrolling='no' title='WOBzLm' src='//codepen.io/mrbird/embed/WOBzLm/?height=630&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/WOBzLm/'>WOBzLm</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## animation-delay
设置动画延迟执行的时间。默认值0表示立即执行，正数为动画延迟一定时间，负数为截断一定时间内的动画。单位为秒(s)或毫秒(s)。

具体实例：

<iframe height='324' scrolling='no' title='zzQjOK' src='//codepen.io/mrbird/embed/zzQjOK/?height=324&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/zzQjOK/'>zzQjOK</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## animation-iteration-count
指定对象动画循环播放的次数。语法如下：
```css
animation-iteration-count: <number>|infinite; 
```
值为number：自定义动画执行次数，设置值可为0或正整数。infinite：无限循环。

<iframe height='307' scrolling='no' title='dREeoJ' src='//codepen.io/mrbird/embed/dREeoJ/?height=307&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/dREeoJ/'>dREeoJ</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## animation-direction
置对象动画循环播放次数大于1次时，动画是否反向运动。语法如下：
```css
animation-direction: normal | reverse | alternate | alternate-reverse [, normal | reverse | alternate | alternate-reverse ]*;
```
属性可取的值有：

1. normal：正常方向。

2. reverse：动画反向运行,方向始终与normal相反。（FF14.0.1以下不支持）。

3. alternate：动画会循环正反方向交替运动，奇数次（1、3、5……）会正常运动，偶数次（2、4、6……）会反向运动，即所有相关联的值都会反向。

4. alternate-reverse：动画从反向开始，再正反方向交替运动，运动方向始终与alternate定义的相反。（FF14.0.1以下不支持）。

各个效果对比：

<iframe height='375' scrolling='no' title='QgRrEL' src='//codepen.io/mrbird/embed/QgRrEL/?height=375&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/QgRrEL/'>QgRrEL</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## animation-fill-mode
设置对象动画时间之外的状态。语法如下：
```css
animation-fill-mode: none | forwards | backwards | both; 
```
属性可取的值有：

1. none：默认值。不设置对象动画之外的状态。

2. forwards：结束后保持动画结束时的状态，但当animation-direction为0，则动画不执行，持续保持动画开始时的状态。

3. backwards：结束后返回动画开始时的状态。

4. both：结束后可遵循forwards和backwards两个规则。

<iframe height='308' scrolling='no' title='KqLRap' src='//codepen.io/mrbird/embed/KqLRap/?height=308&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/KqLRap/'>KqLRap</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## animation-play-state
设置对象动画的状态，语法如下：
```css
animation-play-state: running | paused 
```
其中running为默认值，表示运行动画中；paused表示暂停动画。例如：

<iframe height='358' scrolling='no' title='owRdwd' src='//codepen.io/mrbird/embed/owRdwd/?height=358&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/owRdwd/'>owRdwd</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

> 参考自[http://isux.tencent.com/css3](http://isux.tencent.com/css3)