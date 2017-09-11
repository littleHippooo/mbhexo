---
title: canvas与渐变色
date: 2017-05-02 09:52:45
tags: [HTML5,Canvas]
---
## 线性渐变
绘制线性渐变，需要用到图形上下文的`createLinearGradient`方法来创建`gradient`对象，方法签名如下：
```javascript
var gradient = context.createLinearGradient(x0,y0,x1,y1);
```
(x0,y0)为渐变起始点的坐标，(x1,y1)为渐变结束的的坐标。

接下来需要指定渐变的颜色，可以通过`gradient`对象的`addColorStop`方法来设定，方法签名如下：
```javascript
gradient.addColorStop(stop,color);
```
其中stop为介于 0.0 与 1.0 之间的值，表示渐变中开始与结束之间的位置；color为绘制时使用的颜色。

最后需要做的就是将`gradient`对象赋予给`fillStyle`属性：
```javascript
context.fillStyle = gradient;
```
<!--more-->
绘制一个渐变色矩形：
```javascript
var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");
//设定渐变范围
var g = context.createLinearGradient(0,0,250,150);
//设置渐变起点颜色
g.addColorStop(0,'#FF9999');
//设置渐变终点颜色
g.addColorStop(1,'#FFFF99');
context.fillStyle = g;
context.fillRect(0,0,250,150);
```
显示效果：

![91720573-file_1493711272073_6945.png](img/91720573-file_1493711272073_6945.png)
## 径向渐变
径向渐变指的是沿着圆形的半径方向向外扩散的渐变方式。绘制径向渐变使用的是图形上下文的`createRadialGradient`方法来创建`gradient`对象，方法签名如下：
```javascript
var gradient = context.createRadialGradient(x0,y0,r0,x1,y1,r1);
```
(x0,y0)为渐变的开始圆心坐标，r0为渐变开始圆的半径；(x1,y1)为渐变的结束圆心坐标，r1为渐变结束圆的半径。

剩余的操作和线性渐变一致，不再赘述。

这里绘制一个径向渐变的圆：
```javascript
var g = context.createRadialGradient(100,100,0,100,100,100);
g.addColorStop(0,'#FFFF99');
g.addColorStop(1,'#FF9999');
context.beginPath();
context.arc(100,100,100,0,Math.PI*2,false);
context.fillStyle = g;
context.fill();
```
显示效果：

![38414071-file_1493712408433_17eca.png](img/38414071-file_1493712408433_17eca.png)

> [《HTML5与CSS3权威指南》](https://book.douban.com/subject/26774474/)读书笔记