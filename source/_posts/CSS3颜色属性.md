---
title: CSS3颜色属性
date: 2017-06-05 10:25:37
tags: [CSS3,CSS]
---
## opacity
`opacity`用来设置元素的透明度。取值范围为0~1，0表示完全透明，1表示不透明。
## RGBA
`RGBA`是在`RGB`基础上增加了控制alpha透明度的参数。基本语法如下：
```css
rgba(R,G,B,A)
```
<!--more-->
参数解析:

（1）R(red)：红色值。正整数 | 百分数。 

（2）G(green)：绿色值。正整数 | 百分数。
 
（3）B(blue)：蓝色值。正整数 | 百分数。
 
（4）A(Alpha)：Alpha透明度，取值0~1之间。

R、G、B三个参数的正整数取值是0-255，百分比取值是0.0% - 100.0%。需要特别注意的是，并非所有的浏览器都支持百分数参数值。简单示例如下：
<iframe height='153' scrolling='no' title='rgba' src='//codepen.io/mrbird/embed/eRGewx/?height=153&theme-id=30192&default-tab=css&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/eRGewx/'>rgba</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## HSL()
`HSL`就是色调(Hue)、饱和度(Saturation)和亮度(Lightness)的缩写。

通过三个颜色通道的叠加实现调节颜色的功能。

H：0(或360)表示红色，120表示绿色，240表示蓝色，也可取其他数值来指定颜色。取值为：0 - 360。

S：取值为：0.0% - 100.0%；0% 意味着灰色，而 100% 是全彩。

L：取值为：0.0% - 100.0%；0% 是黑色，100% 是白色。
## HSLA()
`HSLA()`在`HSL()`基础上增加了一个透明度效果。
## currentColor
此属性代表当前元素被应用上的color颜色值，也可以说当前元素的文本颜色值。

例如：
<iframe height='209' scrolling='no' title='currentColor' src='//codepen.io/mrbird/embed/JJrMoo/?height=209&theme-id=30192&default-tab=css&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/JJrMoo/'>currentColor</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

> 参考自[蚂蚁部落](http://www.softwhy.com/qiduan/css3_source/)