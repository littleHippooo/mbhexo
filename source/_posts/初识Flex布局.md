---
title: 初识Flex布局
date: 2017-07-21 15:17:29
tags: CSS
---
传统的CSS布局方法中，一般使用`float`属性和`display:table`来实现布局，但在使用的过程中总有种无法随心所欲的感觉，元素的位置摆放总是显得不是那么的直观，而Flexbox很好的解决了这个问题。Flexbox俗称弹性盒子模型，在开始使用Flexbox之前，首先要声明一个**Flex容器**（Flex Container）。而Flex容器中的元素称为**Flex项目**（Flex Item）。
<!--more-->

声明一个Flex容器：
```css
div {
    display: flex;
}
// 对于行内元素：
div {
    display: inline-flex;
}
```
对于一个Flex容器，其存在两个轴。水平方向的称为**主轴**（main axis），竖直方向的称为**交叉轴**（cross axis）。如下图所示：
