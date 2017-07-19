---
title: CSS3滤镜filter
date: 2017-07-19 16:17:30
tags: CSS3
---
CSS滤镜（filter）用于定义滤镜效果，也就是改变元素的透明度、对比度、亮度和模糊度等效果。其包含一系列的函数来实现各种滤镜效果，也可以将这些函数组合起来，以此达到更复杂的滤镜效果。
<!--more-->
## blur()
给图像设置高斯模糊的效果。默认值为0，接受css长度值，不能为百分数。比如给下面的背景图设置不同的模糊度，并对比结果：

<iframe height='667' scrolling='no' title='gRNgzX' src='//codepen.io/mrbird/embed/gRNgzX/?height=667&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/gRNgzX/'>gRNgzX</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

可见，长度值越大，效果越模糊。
## brightness()
用于给图像设置亮暗程度，值为0%时，图像全黑；值为100%时，图像没有任何变化。比如给下面的背景图设置不同的亮度，并对比结果：

<iframe height='652' scrolling='no' title='rwEyNO' src='//codepen.io/mrbird/embed/rwEyNO/?height=652&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/rwEyNO/'>rwEyNO</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## contrast()
调整图像的对比度。值是0%的话，图像会全黑。值是100%，图像不变。值可以超过100%，意味着会运用更低的对比。若没有设置值，默认是1。比如给下面的背景图设置不同的对比度，并对比结果：

<iframe height='937' scrolling='no' title='EXBWVg' src='//codepen.io/mrbird/embed/EXBWVg/?height=937&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/EXBWVg/'>EXBWVg</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## grayscale()
将图像转换为灰度图像。值定义转换的比例。值为100%则完全转为灰度图像，值为0%图像无变化。值在0%到100%之间，则是效果的线性乘子。若未设置，值默认是0。比如给下面的背景图设置不同的灰度值，并对比结果：

<iframe height='662' scrolling='no' title='NgZpYK' src='//codepen.io/mrbird/embed/NgZpYK/?height=662&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/NgZpYK/'>NgZpYK</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## hue-rotate()
给图像应用色相旋转。angle值设定图像会被调整的色环角度值。值为0deg，则图像无变化。若值未设置，默认值是0deg。该值虽然没有最大值，超过360deg的值相当于又绕一圈。比如给下面的背景图设置不同的色相旋转值，并对比结果：

<iframe height='653' scrolling='no' title='LLKWJd' src='//codepen.io/mrbird/embed/LLKWJd/?height=653&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/LLKWJd/'>LLKWJd</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## invert()
反转图像。值定义转换的比例。100%的价值是完全反转。值为0%则图像无变化。若值未设置，值默认是0。比如给下面的背景图设置不同的反转值，并对比结果：

<iframe height='653' scrolling='no' title='rwEyQm' src='//codepen.io/mrbird/embed/rwEyQm/?height=653&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/rwEyQm/'>rwEyQm</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## opacity()
转化图像的透明程度。值定义转换的比例。值为0%则是完全透明，值为100%则图像无变化。若值未设置，值默认是1。该函数与已有的opacity属性很相似，不同之处在于通过filter，一些浏览器为了提升性能会提供硬件加速。比如给下面的背景图设置不同的透明度，并对比结果：

<iframe height='653' scrolling='no' title='EXBWrb' src='//codepen.io/mrbird/embed/EXBWrb/?height=653&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/EXBWrb/'>EXBWrb</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## saturate()
转换图像饱和度。值定义转换的比例。值为0%则是完全不饱和，值为100%则图像无变化。超过100%的值是允许的，则有更高的饱和度。若值未设置，值默认是1。比如给下面的背景图设置不同的饱和度，并对比结果：

<iframe height='649' scrolling='no' title='XgLMQa' src='//codepen.io/mrbird/embed/XgLMQa/?height=649&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/XgLMQa/'>XgLMQa</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## sepia()
将图像转换为深褐色。值定义转换的比例。值为100%则完全是深褐色的，值为0%图像无变化。若未设置，值默认是0。比如给下面的背景图设置不同的褐色值，并对比结果：

<iframe height='664' scrolling='no' title='owrZrP' src='//codepen.io/mrbird/embed/owrZrP/?height=664&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/owrZrP/'>owrZrP</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## drop-shadow()
给图像设置一个阴影效果。该函数与已有的box-shadow属性很相似。不同之处在于，通过滤镜，一些浏览器为了更好的性能会提供硬件加速。参数类型和box-shadow一致，这里就不演示啦。

## url()
URL函数接受一个XML文件，该文件设置了 一个SVG滤镜，且可以包含一个锚点来指定一个具体的滤镜元素。比如通过url函数引入一个svg滤镜资源：
```css
.effect { filter: url(commonfilters.xml#large-blur) }
```