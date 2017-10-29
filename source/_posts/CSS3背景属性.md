---
title: CSS3背景属性
date: 2017-07-17 11:41:13
tags: [CSS3,CSS]
---
## background-size
`background-size`属性用来控制背景图片的大小。参数的值可以是数值也可以是百分数，还可以是cover和contain。如果只有一个参数，此值用来规定背景图片的宽度，这个时候背景图片的高度是按照宽度进行等比例缩放；如果有两个参数，第一个参数用来规定背景图片的宽度，第二个参数用来规定背景图片的高度。
<!--more-->
### 数值或百分比
例如：

<iframe height='446' scrolling='no' title='pwBKrV' src='//codepen.io/mrbird/embed/pwBKrV/?height=446&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/pwBKrV/'>pwBKrV</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当设置`background-size`为120%时，尺寸超过容器，图片将会被裁切。
### cover
属性值设置为`cover`之后，背景图像会等比缩放到完全覆盖容器，背景图像有可能超出容器，不过超出的部分将会被裁切。

例如：

<iframe height='339' scrolling='no' title='PjgaEp' src='//codepen.io/mrbird/embed/PjgaEp/?height=339&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/PjgaEp/'>PjgaEp</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### contain
`contain`与`cover`的区别是，`contain`只挑横向或者纵向任意一个方位将容器填充满：

<iframe height='327' scrolling='no' title='yXrEER' src='//codepen.io/mrbird/embed/yXrEER/?height=327&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/yXrEER/'>yXrEER</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## background-origin
`background-origin`属性用于指定背景图片从什么地方开始绘制，但并不限制绘制区域。默认值为`padding-box`语法如下：
```css
background-origin:border-box|padding-box|content-box
```
### border-box
此属性值规定背景图片从border区域开始绘制（包括border）。比如：

<iframe height='345' scrolling='no' title='gRyKQR' src='//codepen.io/mrbird/embed/gRyKQR/?height=345&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/gRyKQR/'>gRyKQR</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

可以看出背景图片是从边框开始渲染的，包括边框区域。
### padding-box
规定背景图片是从padding开始绘制的，包括padding区域，例如：

<iframe height='328' scrolling='no' title='JJVZzd' src='//codepen.io/mrbird/embed/JJVZzd/?height=328&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/JJVZzd/'>JJVZzd</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

可见背景图片是从padding区域开始绘制的。
### content-box
此属性值规定，背景图片是从内容区域开始绘制的，所谓内容区域就是出去border和padding区域，比如：

<iframe height='329' scrolling='no' title='WOWyWy' src='//codepen.io/mrbird/embed/WOWyWy/?height=329&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/WOWyWy/'>WOWyWy</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

可见，背景图片是从内容区域开始绘制的。但右下角padding和border区域都有背景图片的显示，因为`background-origin`属性从名字可以看出，它只规定图片的起源位置，而并不关心图片的结束位置。要限制图片的结束位置，可以使用`background-clip`属性。
## background-clip
`background-clip`属性规定背景图片在哪些区域可以显示。语法如下：
```css
background-clip:border-box|padding-box|content-box|text|no-clip
```
### border-box
`border-box`属性值规定，背景图片可以在边框范围内显示，例如：

<iframe height='330' scrolling='no' title='zzXLOY' src='//codepen.io/mrbird/embed/zzXLOY/?height=330&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/zzXLOY/'>zzXLOY</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

可看到，虽然规定背景图可在边框内显示，但左上区域边框下却没有背景图，因为`background-origin`属性的默认值为`padding-box`！
### padding-box
`padding-box`属性值规定，背景图片可以在padding范围内显示，不能在border区域显示，例如：

<iframe height='328' scrolling='no' title='LLvBYZ' src='//codepen.io/mrbird/embed/LLvBYZ/?height=328&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/LLvBYZ/'>LLvBYZ</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### content-box
`content-box`属性值规定背景图片可以在content区域，也就是除去padding和border的区域内显示，例如：

<iframe height='330' scrolling='no' title='XgQBJr' src='//codepen.io/mrbird/embed/XgQBJr/?height=330&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/XgQBJr/'>XgQBJr</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

可以看出，背景图片这个时候只能够在content范围内显示了。
### text
从前景内容的形状（比如文字）作为裁剪区域向外裁剪，也就是说只有前景内容的形状内显示背景图片，例如只有文字内显示背景。比如：

<iframe height='402' scrolling='no' title='PjgBqQ' src='//codepen.io/mrbird/embed/PjgBqQ/?height=402&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/PjgBqQ/'>PjgBqQ</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

> 参考自：[http://www.softwhy.com/](http://www.softwhy.com/)