---
title: canvas绘制简单图形
date: 2017-04-27 10:01:46
tags: [HTML5,Canvas]
---
canvas是HTML5中专门用来绘制图形的元素。在页面上放置一个canvas元素就相当于创建了一个画布。绘制过程由JS脚本完成。首先在页面上添加一个canvas元素：
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>html5</title>
</head>
<body>
    <canvas id="canvas" width="500" height="400"/>
</body>
</html>
```
<!--more-->
## 基本步骤

使用canvas绘制图形的几个基本步骤：

1.获取canvas对象：
```javascript
var canvas = document.getElementById("canvas");
```
2.取得上下文context，其包含许多绘制的方法：
```javascript
var context = canvas.getContext("2d");
```
目前仅有2d参数可选。

3.设置绘图样式：

绘图样式主要包含图形填充样式`fillStyle`，图形边框样式`strokeStyle`和线宽`lineWidth`。
```javascript
//设置填充样式为红色
context.fillStyle = "red";
//设置边框为黄色
context.strokeStyle = "yellow";
//设置线宽为1px
context.lineWidth = 1;
```
4.开始绘制图形：

具体绘制方法下面陆续展开。
## 绘制矩形

使用`fillRect`方法与`strokeRect`方法来绘制矩形和矩形边框：
```javascript
context.fillRect(x,y,width,height);
context.strokeRect(x,y,width,height);​
```
x，y为矩形左上角起点坐标，width为矩形宽，height为矩形高。

开始绘制：
```javascript
var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");
// 设置canvas画布颜色
context.fillStyle = "#F7F7F7";
context.fillRect(0,0,300,300);
//设置填充颜色，边框颜色
context.fillStyle = "#E4F0C3";
context.strokeStyle = "#F06560";
//设置线宽
context.lineWidth = 1;
//绘制矩形
context.fillRect(50,50,100,100);
//绘制矩形边框
context.strokeRect(50,50,150,150);
```
结果：

![91969758-file_1493260613916_104f4.png](https://www.tuchuang001.com/images/2017/06/11/91969758-file_1493260613916_104f4.png)

关于矩形，还有一个`clearRect`方法，用于清除指定矩形区域像素：
```javascript
context.clearRect(x,y,width,height);
```
在上面的JS脚本中加入下面这行代码：
```javascript
context.clearRect(50,50,50,50);
```
效果：

![1632300-file_1493260859763_12aee.png](https://www.tuchuang001.com/images/2017/06/11/1632300-file_1493260859763_12aee.png)
## 绘制圆形，扇形，椭圆
绘制圆形主要多了开始创建路径beginPath和关闭路径closePath这两个过程。

主要步骤：

1.开始创建路径：
```javascript
context.beginPath();
```
2.绘制圆形路径：

方法：
```javascript
context.arc(x,y,r,sAngle,eAngle,anticlockwise);
```
其中x，y为绘制圆形的起点坐标即圆心，r为圆形半径，sAngle（起始角）和eAngle（结束角）决定了圆的弧度，两者的连线决定了圆的形状，anticlockwise表示是否按逆时针方向绘制，为`boolean`类型。

3.关闭路径：
```javascript
context.closePath();
```
4. 设置填充样式。

绘制圆形示例：
```javascript
var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");
for(var i = 0;i < 6; i++){
    //开始创建路径
    context.beginPath();
    //绘制圆，Math.PI*2为2π弧度
    context.arc(i*25,i*25,i*10,0,Math.PI*2,true);
    //关闭路径
    context.closePath();
    //设置填充颜色
    context.fillStyle = "rgba(66,185,131,0.4)";
    //进行填充
    context.fill();
}
```
{% note danger %}度与弧度换算：1° = 1/180π rad{% endnote %}

效果如下图所示：

![95422784-file_1493263542834_3beb.png](https://www.tuchuang001.com/images/2017/06/11/95422784-file_1493263542834_3beb.png)

假如不关闭路径会怎样呢？将上面的代码改为：
```javascript
for(var i = 0;i < 6; i++){
    //绘制圆，Math.PI*2为2π弧度
    context.arc(i*25,i*25,i*10,0,Math.PI*2,true);
    //设置填充颜色
    context.fillStyle = "rgba(66,185,131,0.4)";
    //进行填充
    context.fill();
}
```
效果如下图所示：

![15979544-file_1493263698000_173b3.png](https://www.tuchuang001.com/images/2017/06/11/15979544-file_1493263698000_173b3.png)

不关闭路径将会导致再绘制第二个圆的时候，第一个圆会根据之前的路径再次绘制一次。所以在这个例子中，第一个圆绘制了5次，第二个圆绘制了4次，以此类推，以至于第一个圆的颜色最深。

关于弧度的参考可见下图：

![45074720-file_1493274183652_16575.png](https://www.tuchuang001.com/images/2017/06/11/45074720-file_1493274183652_16575.png)

顺时针和逆时针的差别举个例子说明：

顺时针，弧度为0.5rad：
```javascript
context.beginPath();
context.arc(100,100,100,0,Math.PI*0.5,false);
context.closePath();
context.fillStyle = "rgba(66,185,131,0.4)";
context.strokeStyle = "#F06560";
context.fill();
context.stroke();
```
效果如下图：

![70222083-file_1493274496615_14f08.png](https://www.tuchuang001.com/images/2017/06/11/70222083-file_1493274496615_14f08.png)

将false改为true，即逆时针时：

![1276531-file_1493274564090_487c.png](https://www.tuchuang001.com/images/2017/06/11/1276531-file_1493274564090_487c.png)

椭圆的绘制公式如下：
```javascript
context.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise);
```
其中x，y为起始坐标，radiusX为椭圆横向半径，radiusY为椭圆纵向半径，rotation为椭圆顺时针旋转角度，startAngle（起始角）和endAngle（结束角）决定了圆的弧度，两者的连线决定了圆的形状，anticlockwise表示是否按逆时针方向绘制，为boolean类型。

绘制一个简单的椭圆：
```javascript
context.beginPath();
context.ellipse(100,100,50,90,Math.PI*0.25,0,Math.PI*2,false);
context.closePath();
context.fillStyle = "rgba(66,185,131,0.4)";
context.fill();
```
效果图：

![69962080-file_1493275424748_cf65.png](https://www.tuchuang001.com/images/2017/06/11/69962080-file_1493275424748_cf65.png)
## 绘制直线
与绘制直线有关的方法主要有两个：
```javascript
context.moveTo(x,y);
```
`moveTo`方法将绘制光标移动到x，y位置。
```javascript
context.lineTo(x,y);
```
`lineTo`方法将从当前光标位置开始，到x，y位置间绘制一条直线。多次调用该方法，则下一次的起点为上一次`lineTo`的终点。

使用`lineTo`方法结合数学公式，绘制一个复杂的图案：
```javascript
var dx = 150;
var dy = 150;
var s = 100;
context.beginPath();
context.fillStyle = "rgba(230,177,163,.5)";
context.strokeStyle = "#e96900";
var dig = Math.PI/15*11;
for(var i = 0;i < 30 ; i++){
    var x = Math.sin(i*dig);
    var y = Math.cos(i*dig);
    context.lineTo(dx+x*s,dy+y*s);
}
context.closePath();
context.fill();
context.stroke();
```
效果图：

![88820416-file_1493276100892_3dd7.png](https://www.tuchuang001.com/images/2017/06/11/88820416-file_1493276100892_3dd7.png)

图形上下文的`lineCap`属性可为直线添加线帽，可用的属性有：

1. butt，默认值，不为直线添加线帽。

2. round，添加圆形线帽。

3. square，添加方形线帽。

例如：
```javascript
context.strokeStyle = "rgba(66,185,131,0.6)";
context.lineWidth = "10";
context.beginPath();
context.moveTo(50,50);
context.lineTo(50,150);
context.lineCap = "round";
context.stroke();
```
效果：

![35700189-file_1493277408167_904a.png](https://www.tuchuang001.com/images/2017/06/11/35700189-file_1493277408167_904a.png)

图形上下文的`lineJoin`属性指定两条线交汇处的形状，可用的值有：

1. miter，默认值，尖角拐角。

2. round，圆角拐角。

3. bevel，斜角拐角。

例如：
```javascript
context.strokeStyle = "rgba(66,185,131,0.6)";
context.lineWidth = "10";
context.beginPath();
context.moveTo(50,50);
context.lineTo(50,150);
context.lineTo(150,150);
context.lineJoin = "bevel";
context.stroke();
```
效果图：

![67976196-file_1493277665849_12c77.png](https://www.tuchuang001.com/images/2017/06/11/67976196-file_1493277665849_12c77.png)

图形上下文的`setLineDash`方法可设置虚线的样式：
```javascript
context.setLineDash(segments);
```
segments为一个数组。数组长度可分为4种情况：

1.当数组长度为1时：
```javascript
context.setLineDash([5]);
```
表示线段长度为5，线段间距离也为5。

2.当数组长度为2时：
```javascript
context.setLineDash([5,10]);
```
表示线段长度为5，线段间距离为10。

3.当数组长度为大于2的偶数时：
```javascript
context.setLineDash([5,10,15,20]);
```
第奇数个数值表示线段长度，第偶数个数值表示线段间距。

4.当数组长度为大于1的奇数时：
```javascript
context.setLineDash([5,10,15]);
```
浏览器会将其解析为：
```javascript
context.setLineDash([5,10,15,5,10,15]);
```
画个虚线试试：
```javascript
context.strokeStyle = "rgba(66,185,131,0.9)";
context.lineWidth = 2;
context.beginPath();
context.moveTo(10,50);
context.lineTo(250,50);
context.setLineDash([15,5]);
context.stroke();
```
效果：

![83425817-file_1493285860047_7f6.png](https://www.tuchuang001.com/images/2017/06/11/83425817-file_1493285860047_7f6.png)

## 绘制曲线
绘制曲线使用`arcTo`方法：
```javascript
context.fillRect(x1,y1,x2,y2,radiusX[radiusY,rotation]);
```
关于坐标参数，可以参考下面这张图：

![38665772-file_1493291085586_168b6.png](https://www.tuchuang001.com/images/2017/06/11/38665772-file_1493291085586_168b6.png)

其中x0，y0为当前点的坐标，x1，y1为绘制圆弧时使用的控制坐标，x2，y2为重点坐标。radiusX为圆弧的半径。radiusY和rotation为隐藏参数，前者表示纵向半径，后者表示顺时针旋转角度。

绘制个曲线图：
```javascript
context.strokeStyle = "rgba(66,185,131,0.9)";
context.lineWidth = 2;
context.beginPath();
context.moveTo(10,50);
//曲线的起点
context.lineTo(100,50);
//(150,50)曲线的控制点，(150,100)曲线的终点，曲线半径为50
context.arcTo(150,50,150,100,50);
//再来一条
context.arcTo(100,100,100,50,50);
context.stroke();
```
效果图：

![7099713-file_1493291886094_1339b.png](https://www.tuchuang001.com/images/2017/06/11/7099713-file_1493291886094_1339b.png)

图形上下文的`bezierCurveTo`方法用以三次绘制贝塞尔曲线。
```javascript
context.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y);﻿​
```
其中cp1x为第一个贝塞尔控制点的 x 坐标，cp1y为第一个贝塞尔控制点的 y 坐标。cp2x为第二个贝塞尔控制点的 x 坐标，cp2y为第二个贝塞尔控制点的 y 坐标。x，y为终点坐标。

例如：
```javascript
context.strokeStyle = "rgba(66,185,131,0.9)";
context.lineWidth = 2;
context.beginPath();
context.moveTo(50, 150);
context.bezierCurveTo(150, 100, 150, 200, 250, 150);
context.stroke();
```
效果图：

![5121381-file_1493293040079_8366.png](https://www.tuchuang001.com/images/2017/06/11/5121381-file_1493293040079_8366.png)

贝塞尔曲线在线生成工具：http://www.j--d.com/bezier

图形上下文的`quadraticCurveTo`方法用以二次绘制贝塞尔曲线：
```javascript
context.quadraticCurveTo(cpx,cpy,x,y);
```
相较于`bezierCurveTo`方法，其只有一个控制点。cpx，cpy为控制点的坐标，x，y为终点坐标。

一个简单的例子：
```javascript
context.strokeStyle = "rgba(66,185,131,0.9)";
context.lineWidth = 2;
context.beginPath();
context.moveTo(50, 50);
context.quadraticCurveTo(250, 150, 150, 50);
context.stroke();
```
效果图：

![e4bd00a2b1d87c18a6b1b433bf58d8d2.png](https://www.tuchuang001.com/images/2017/06/11/e4bd00a2b1d87c18a6b1b433bf58d8d2.png)

> [《HTML5与CSS3权威指南》](https://book.douban.com/subject/26774474/)读书笔记