---
title: CSS3 transform
date: 2017-07-18 08:58:23
tags: CSS3
---
transform属性能对元素对象进行变形操作，主要包括以下几种：旋转rotate、缩放scale、移动translate、倾斜skew以及矩阵变形matrix。基本语法：
```css
transform: none | <transform-function>[<transform-function>]*
```
`none`表示不进行变换；`<transform-function>`表示一个或多个变换函数，以空格分开，因此可以同时对一个元素进行transform的多种属性操作。包括：
<!--more-->

1. `rotate(<angle>)`：旋转元素。

2. `scale(<number>[, <number>])`：缩放元素。

3. `translate(<translation-value>[, <translation-value>])`：移动元素。

4. `skew(<angle> [,<angle>])`：倾斜元素。

5. `matrix(<number>,<number>,<number>,<number>,<number>,<number>)`：矩阵变形。

6. `perspective(length)`：透视。

## rotate()
`rotate()`函数能够旋转元素，它主要是在二维空间内进行操作，通过一个角度参数值，来设定旋转的幅度。如果对元素本身或者元素设置了`perspective`值，那么`rotate3d()`函数可以实现一个3维空间内的旋转。基本语法：
```css
transform:rotate(<angle>);
```
取值如下：

1. `rotate(<angle>)`：`<angle>`为一个角度值，单位deg，可以为正数或者负数，正数是顺时针旋转，负数是逆时针旋转。

2. `rotateX(angele)`：相当于`rotate3d(1,0,0,angle)`指定在3维空间内的X轴旋转。

3. `rotateY(angele)`：相当于`rotate3d(0,1,0,angle)`指定在3维空间内的Y轴旋转。

4. `rotateZ(angele)`：相当于`rotate3d(0,0,1,angle)`指定在3维空间内的Z轴旋转。

具体示例如下：

<iframe height='769' scrolling='no' title='JJqbzj' src='//codepen.io/mrbird/embed/JJqbzj/?height=769&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/JJqbzj/'>JJqbzj</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

关于`perspective`见下文介绍。
## scale()
`scale()`函数能够缩放元素。语法如下：
```css
transform:scale(<number>[, <number>]);
```
取值如下：

1. `scale(<number>[, <number>])`表示使元素在X轴和Y轴同时缩放。`<number>`表示缩放倍数，可以是正数，负数和小数。负数是先翻转元素然后再缩放，X值为负，绕Y轴旋转；Y值为负，绕X轴旋转。包含两个参数，如果缺少第二个参数，那么第二个参数的值等于第一个参数。

2. `scaleX(<number>)`表示只在X轴(水平方向)缩放元素。

3. `scaleY(<number>)`表示只在Y轴(垂直方向)缩放元素。

4. `scaleZ(<number>)`表示只在Z轴缩放元素。前提是元素本身或者元素的父元素设定了透视值。

具体示例如下：

<iframe height='519' scrolling='no' title='yXWgLG' src='//codepen.io/mrbird/embed/yXWgLG/?height=519&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/yXWgLG/'>yXWgLG</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## translate()
`translate()`函数能够移动元素。语法如下：
```css
transform:translate(<translation-value>[, <translation-value>]);
```
取值如下：

1. `translate(<translation-value>[, <translation-value>])`表示使元素在X轴和Y轴同时移动，`<translation-value>`表示位移量。包含两个参数，如果省略了第二个参数则第二个参数为0；如果参数为负，则表示往相反的方向移动。

2. `translateX(<translation-value>)`表示只在X轴(水平方向)移动元素。

3. `translateY(<translation-value>)`表示只在Y轴(垂直方向)移动元素。

4. `translateZ(<translation-value>)`表示只在Z轴移动元素，前提是元素本身或者元素的父元素设定了透视值。

具体示例如下：

<iframe height='632' scrolling='no' title='mwYRPw' src='//codepen.io/mrbird/embed/mwYRPw/?height=632&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/mwYRPw/'>mwYRPw</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## skew()
`skew()`函数能够让元素倾斜显示。语法如下：
```css
transform:skew(<angle> [,<angle>]);
```
取值如下：

1. `skew(<angle> [, <angle>])`包含两个参数值，分别表示X轴和Y轴倾斜的角度，如果第二个参数为空，则默认为0，参数为负表示向相反方向倾斜。

2. `skewX(<angle>)`表示只在X轴(水平方向)倾斜。

3. `skewY(<angle>)`表示只在Y轴(垂直方向)倾斜。

<iframe height='498' scrolling='no' title='GEarWO' src='//codepen.io/mrbird/embed/GEarWO/?height=498&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/GEarWO/'>GEarWO</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## perspective
`perspective`为透视的意思，用于设定查看元素的位置，营造一种3D的空间感，值越大，感觉上离得越远；值越小，感觉是离得越近。这对3D变换的元素来说是必须的属性。写法有两种：

1. 单独作为一个属性：`div { perspective: 100px}`。

2. 配合`transform`：`div { transform: perspective(100px) rotateX(60deg) }`。

对比具有`perspective`值及没有`perspective`值的区别：

<iframe height='442' scrolling='no' title='webgNR' src='//codepen.io/mrbird/embed/webgNR/?height=442&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/webgNR/'>webgNR</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

对比`persepctive`值的大小对3D效果的影响：

<iframe height='463' scrolling='no' title='vZwgwR' src='//codepen.io/mrbird/embed/vZwgwR/?height=463&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/vZwgwR/'>vZwgwR</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

上面结果印证了：值越大，感觉上离得越远；值越小，感觉是离得越近的结论。
## transform-origin
`transform`的参照点默认为元素的中心点，如果要改变这个参照点，可以是用`transform-origin`属性进行自定义。

该属性提供2个参数值，第一个用于横坐标，第二个用于纵坐标；如果只提供一个，该值将用于横坐标，纵坐标将默认为50%：

1. percentage：用百分比指定坐标值。可以为负值。

2. length：用长度值指定坐标值。可以为负值。

3. left center right是水平方向取值，而top center bottom是垂直方向的取值。

查看设置不同中心点的旋转效果：

<iframe height='643' scrolling='no' title='OgYpJd' src='//codepen.io/mrbird/embed/OgYpJd/?height=643&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/OgYpJd/'>OgYpJd</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## backface-visibility
`backface-visibility`属性可用于隐藏内容的背面。默认情况下，背面可见，这意味着即使在翻转后，变换的内容仍然可见。但当`backface-visibility`设置为 hidden 时，旋转后内容将隐藏，因为旋转后正面将不再可见。

<iframe height='510' scrolling='no' title='OgYpyq' src='//codepen.io/mrbird/embed/OgYpyq/?height=510&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/OgYpyq/'>OgYpyq</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## transform-style
设置内嵌的元素在 3D 空间如何呈现。有两个值：flat：所有子元素在 2D 平面呈现。preserve-3d：保留3D空间。

比如：

<iframe height='1111' scrolling='no' title='ZyNeJL' src='//codepen.io/mrbird/embed/ZyNeJL/?height=1111&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/ZyNeJL/'>ZyNeJL</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

> 参考自[http://isux.tencent.com/css3/](http://isux.tencent.com/css3/)