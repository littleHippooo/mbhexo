---
title: CSS3渐变
date: 2017-07-10 09:22:59
tags: [CSS3,CSS]
---
在CSS3标准发布之前，网页上的渐变效果一般都是设计师使用图形化设计软件生成图片，然后作为页面背景实现的。在CSS3标准发布之后，我们可以直接编写CSS代码来轻松实现渐变效果。渐变主要包含线性渐变和径向渐变。
<!--more-->
## 线性渐变
线性渐变（Linear Gradients）包含向下/向上/向左/向右/对角方向的颜色渐变。基本语法：
```css
background: linear-gradient(direction, color-stop1, color-stop2, ...);﻿​
```
`direction`为渐变方向，`color-stop1`为渐变起始颜色，`color-stop2`为渐变结束颜色。
### 从上到下（默认情况下）
默认情况下，线性渐变方向就是从左到右，所以这个时候`direction`属性可以略去。例如：

<iframe height='272' scrolling='no' title='liner-graident' src='//codepen.io/mrbird/embed/bRmXbY/?height=272&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/bRmXbY/'>liner-graident</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

为了兼容webkit内核浏览器，实际的代码应该为：
```css
div {
    height: 200px;
    width: 200px;
    background: linear-gradient(#FFFFCC,#FF6666);
    background: -webkit-gradient(linear,left top, left bottom,from(#FFFFCC),to(#FF6666));
}
```
关于CSS3属性兼容性前缀，可以使用sublime text 3的[Autoprefixer](https://packagecontrol.io/packages/Autoprefixer)插件来自动生成。

除此之外，还可以指定起止颜色的起始位置，比如下面这个例子：

<iframe height='273' scrolling='no' title='linear-gradient(location)' src='//codepen.io/mrbird/embed/bRmXLj/?height=273&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/bRmXLj/'>linear-gradient(location)</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

从渐变方向10%长度开始到渐变方向60%长度之间，颜色从#FFC渐变到#F66。小于10%部分背景颜色完全为#FFC，大于60%部分背景颜色完全为#F66。
### 从左到右
从左到右只需将`direction`属性值设为`to right`，例如：

<iframe height='280' scrolling='no' title='liner-gradient(to right)' src='//codepen.io/mrbird/embed/qjJeZd/?height=280&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/qjJeZd/'>liner-gradient(to right)</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### 对角方向
可以通过指定水平和垂直的起始位置来制作一个对角渐变。例如从左上角到右下角方向渐变：

<iframe height='275' scrolling='no' title='liner-gradient(对角)' src='//codepen.io/mrbird/embed/RgeXRK/?height=275&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/RgeXRK/'>liner-gradient(对角)</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### 使用任意角度
如果想要在渐变的方向上做更多的控制，你可以定义一个角度，而不用预定义方向（to bottom、to top、to right、to left、to bottom right，等等）。语法：
```css
background: linear-gradient(angle, color-stop1, color-stop2);﻿​
```
`angle`指水平线和渐变线之间的角度，逆时针方向计算。换句话说，0deg将创建一个从下到上的渐变，90deg将创建一个从左到右的渐变。

但是，请注意很多浏览器(Chrome,Safari,firefox等)的使用了旧的标准，即 0deg 将创建一个从左到右的渐变，90deg 将创建一个从下到上的渐变。换算公式 90 - x = y 其中 x 为标准角度，y为非标准角度。

下面的实例演示了如何在线性渐变上使用角度：

<iframe height='935' scrolling='no' title='liner-gradient(use angle)' src='//codepen.io/mrbird/embed/QgZeGB/?height=935&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/QgZeGB/'>liner-gradient(use angle)</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### 使用多个颜色结点
除了设置一组起始颜色和结束颜色外，我们还可以设置多组渐变颜色。比如：

<iframe height='270' scrolling='no' title='liner-gradient(repeat)' src='//codepen.io/mrbird/embed/dRgxvX/?height=270&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/dRgxvX/'>liner-gradient(repeat)</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### 使用透明度
CSS3 渐变也支持透明度（transparency），可用于创建减弱变淡的效果。为了添加透明度，我们使用 rgba() 函数来定义颜色结点。比如：

<iframe height='269' scrolling='no' title='liner-gradient(opacity)' src='//codepen.io/mrbird/embed/JJmgJY/?height=269&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/JJmgJY/'>liner-gradient(opacity)</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### 重复的线性渐变
`repeating-linear-gradient()`函数用于重复线性渐变，语法和`linear-gradient()`相同，例如：

<iframe height='269' scrolling='no' title='repeating-linear-gradient' src='//codepen.io/mrbird/embed/VWEoyP/?height=269&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/VWEoyP/'>repeating-linear-gradient</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

上面例子中，有一个白色条纹从0到.25em线性渐变，接着一条#FF6颜色条纹从.25em到.75em。（#FF6颜色条纹宽度 = .75em - .25em = .5em = 白色条纹宽度的两倍 ＝ .25em * 2）。
## 径向渐变
径向渐变指的是从圆心向外扩散的渐变，为了创建一个径向渐变，必须至少定义两种颜色结点。颜色结点即你想要呈现平稳过渡的颜色。同时，你也可以指定渐变的中心、形状（原型或椭圆形）、大小。默认情况下，渐变的中心是 center（表示在中心点），渐变的形状是 ellipse（表示椭圆形），渐变的大小是 farthest-corner（表示到最远的角落）。
###  颜色结点均匀分布（默认情况下）
如下所示：

<iframe height='272' scrolling='no' title='radial-gradient' src='//codepen.io/mrbird/embed/OgBKrE/?height=272&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/OgBKrE/'>radial-gradient</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### 颜色结点不均匀分布
如下所示：

<iframe height='269' scrolling='no' title='radial-gradient1' src='//codepen.io/mrbird/embed/MoPNLg/?height=269&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/MoPNLg/'>radial-gradient1</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### 重复的径向渐变
如下所示：

<iframe height='270' scrolling='no' title='repeating-dadial-gradient' src='//codepen.io/mrbird/embed/pwxMGX/?height=266&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/pwxMGX/'>repeating-dadial-gradient</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

