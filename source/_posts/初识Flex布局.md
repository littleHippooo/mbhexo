---
title: 初识Flex布局
date: 2017-07-21 15:17:29
tags: CSS3
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

![02fcf9af33dde7a084d0d80fa5dd73ba.png](https://www.tuchuang001.com/images/2017/07/24/02fcf9af33dde7a084d0d80fa5dd73ba.png)

FlexBox主要包含12个属性，其中Flex容器6个，Flex项目6个。
## Flex容器属性
### flex-direction
`flex-direction`属性决定了项目的排列方向，语法如下：
```css
flex-direction: row | row-reverse | column | column-reverse;
```
可取的值有：

1. row（默认值）：项目水平方向排列，起点在左端。

2. row-reverse：项目水平方向排列，起点在右端。

3. column：项目竖直方向排列，起点在上沿。

4. column-reverse：项目竖直方向排列，起点在下沿。

默认情况下，`flex-direction`的取值为`row`：

<iframe height='200' scrolling='no' title='xrvQqe' src='//codepen.io/mrbird/embed/xrvQqe/?height=229&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/xrvQqe/'>xrvQqe</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`flex-direction`属性的值为`row-reverse`时，项目的起点在右端：


<iframe height='200' scrolling='no' title='yoLJYb' src='//codepen.io/mrbird/embed/yoLJYb/?height=263&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/yoLJYb/'>yoLJYb</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`flex-direction`属性的值为`column`时，项目垂直排列，起点在上沿：

<iframe height='473' scrolling='no' title='yoLJOX' src='//codepen.io/mrbird/embed/yoLJOX/?height=473&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/yoLJOX/'>yoLJOX</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`flex-direction`属性的值为`column-reverse`时，项目垂直排列，起点在下沿：

<iframe height='457' scrolling='no' title='OjJXXV' src='//codepen.io/mrbird/embed/OjJXXV/?height=457&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/OjJXXV/'>OjJXXV</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### flex-wrap
`flex-wrap`属性规定了项目在一条轴线上排不下时，是否换行。语法如下：
```css
flex-wrap: nowrap | wrap | wrap-reverse;
```
属性可取的值有：

1. nowrap（默认）：不换行。

2. wrap：换行，第一行在上方。

3. wrap-reverse：换行，第一行在下方。

`flex-wrap`默认取值为`nowrap`，即不换行，如果项目排列方向为水平方向，则项目宽度自动收缩（因为项目的`flex-shrink`属性值默认为1，即如果空间不足，该项目宽度将缩小。）：

<iframe height='204' scrolling='no' title='KvKMNm' src='//codepen.io/mrbird/embed/KvKMNm/?height=204&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/KvKMNm/'>KvKMNm</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

将`flex-wrap`属性值设置为`warp`时：

<iframe height='288' scrolling='no' title='zdYBoj' src='//codepen.io/mrbird/embed/zdYBoj/?height=288&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/zdYBoj/'>zdYBoj</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

将`flex-wrap`属性值设置为`wrap-reverse`时：

<iframe height='300' scrolling='no' title='eEYzgV' src='//codepen.io/mrbird/embed/eEYzgV/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/eEYzgV/'>eEYzgV</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当项目排列方向为竖直方向，如果一列排不下并且`flex-wrap`属性值为`no-wrap`时，项目将会超出容器的高度，项目并不会收缩。
### flex-flow
`flex-flow`属性是`flex-direction`属性和`flex-wrap`属性的简写形式，默认值为`row nowrap`。
### justify-content
`justify-content`属性定义了项目在主轴上的对齐方式。语法如下：
```css
justify-content: flex-start | flex-end | center | space-between | space-around;
```
属性可取的值有：

1. flex-start（默认值）：左对齐。

2. flex-end：右对齐。

3. center： 居中。

4. space-between：两端对齐，项目之间的间隔都相等。

5. space-around：每个项目两侧的间隔相等。项目之间的间隔比项目与边框的间隔大一倍。

默认情况下为左对齐，当`justify-content`属性值设为`flex-end`时：

<iframe height='209' scrolling='no' title='vJYKgo' src='//codepen.io/mrbird/embed/vJYKgo/?height=209&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/vJYKgo/'>vJYKgo</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`justify-content`属性值为`center`时：

<iframe height='209' scrolling='no' title='probdW' src='//codepen.io/mrbird/embed/probdW/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/probdW/'>probdW</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`justify-content`属性值为`space-between`时：

<iframe height='209' scrolling='no' title='dzyXZB' src='//codepen.io/mrbird/embed/dzyXZB/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/dzyXZB/'>dzyXZB</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`justify-content`属性值为`space-around`时：

<iframe height='209' scrolling='no' title='QMWEag' src='//codepen.io/mrbird/embed/QMWEag/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/QMWEag/'>QMWEag</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### align-items
`align-items`属性定义项目在交叉轴上如何对齐。语法如下：
```css
align-items: flex-start | flex-end | center | baseline | stretch;
```
属性可取的值有：

1. flex-start：交叉轴的起点对齐。

2. flex-end：交叉轴的终点对齐。

3. center：交叉轴的中点对齐。

4. baseline: 项目的第一行文字的基线对齐。

5. stretch（默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。

当`align-items`属性值为`flex-start`时（将第2，4个项目高度设置为120px，以更好的区分各属性的效果）：

<iframe height='268' scrolling='no' title='NvWrYp' src='//codepen.io/mrbird/embed/NvWrYp/?height=268&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/NvWrYp/'>NvWrYp</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-items`属性值为`flex-end`时：

<iframe height='268' scrolling='no' title='jLOrpG' src='//codepen.io/mrbird/embed/jLOrpG/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/jLOrpG/'>jLOrpG</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-items`属性值为`center`时：

<iframe height='268' scrolling='no' title='XaWKvO' src='//codepen.io/mrbird/embed/XaWKvO/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/XaWKvO/'>XaWKvO</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-items`属性值为`baseline`时，项目沿着第一行文字的基线对齐：

<iframe height='268' scrolling='no' title='YxzWMy' src='//codepen.io/mrbird/embed/YxzWMy/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/YxzWMy/'>YxzWMy</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-items`属性值为`stretch`（默认值）时，如果项目未设置高度或设为auto，将占满整个容器的高度。

<iframe height='268' scrolling='no' title='aybZjX' src='//codepen.io/mrbird/embed/aybZjX/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/aybZjX/'>aybZjX</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### align-content
`align-content`属性定义了多根轴线（多行）的对齐方式。如果项目只有一根轴线，该属性不起作用。语法如下：
```css
align-content: flex-start | flex-end | center | space-between | space-around | stretch; 
```
属性可取的值有：

1. flex-start：与交叉轴的起点对齐。

2. flex-end：与交叉轴的终点对齐。

3. center：与交叉轴的中点对齐。

4. space-between：与交叉轴两端对齐，轴线之间的间隔平均分布。

5. space-around：每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。

6. stretch（默认值）：轴线占满整个交叉轴。

当`align-content`属性值为`flex-start`时，项目交叉轴的起点对齐：

<iframe height='537' scrolling='no' title='oeNzZx' src='//codepen.io/mrbird/embed/oeNzZx/?height=537&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/oeNzZx/'>oeNzZx</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-content`属性值为`flex-end`时，项目交叉轴的终点对齐：

<iframe height='537' scrolling='no' title='PKoGmJ' src='//codepen.io/mrbird/embed/PKoGmJ/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/PKoGmJ/'>PKoGmJ</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-content`属性值为`center`时，项目交叉轴的中点对齐：

<iframe height='537' scrolling='no' title='proEPQ' src='//codepen.io/mrbird/embed/proEPQ/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/proEPQ/'>proEPQ</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-content`属性值为`space-between`时：

<iframe height='537' scrolling='no' title='XaWjRL' src='//codepen.io/mrbird/embed/XaWjRL/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/XaWjRL/'>XaWjRL</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-content`属性值为`space-around`时：

<iframe height='537' scrolling='no' title='oeNzwx' src='//codepen.io/mrbird/embed/oeNzwx/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/oeNzwx/'>oeNzwx</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

当`align-content`属性值为`stretch`（默认值），项目高度为auto时，项目将占满整个交叉轴：

<iframe height='537' scrolling='no' title='vJYXZg' src='//codepen.io/mrbird/embed/vJYXZg/?height=507&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/vJYXZg/'>vJYXZg</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## 项目属性
### order
`order`属性定义项目的排列顺序。数值越小，排列越靠前，默认为0，它可以接受一个正值，也可以接受一个负值。语法如下：
```css
order: <integer>;
```
默认情况下，因为项目的`order`属性都为0，所以排列顺序按照HTML源码进行排列，比如：
```html
<ul> 
    <li>1</li>  
    <li>2</li> 
    <li>3</li>
    <li>4</li>
</ul>
```
在FlexBox布局里，li默认按1，2，3，4的顺序排列，现在不改变HTML源码的情况下，将序号为1的li移到最末尾：

<iframe height='211' scrolling='no' title='proRge' src='//codepen.io/mrbird/embed/proRge/?height=211&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/proRge/'>proRge</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

这里只需将第一个li的`order`属性值设为大于0的数即可。
### flex-grow
flex-grow属性定义项目的放大比例，默认为0，即如果存在剩余空间，也不放大。语法如下：
```css
flex-grow: <number>
```
如果所有项目的flex-grow属性都为1，则它们将等分剩余空间（如果有的话）：

<iframe height='221' scrolling='no' title='NvWdRr' src='//codepen.io/mrbird/embed/NvWdRr/?height=221&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/NvWdRr/'>NvWdRr</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

从结果可以看到，这三个li的宽度都变大了，等分了外层ul的剩余空间。

如果一个项目的flex-grow属性为2，其他项目都为1，则前者占据的剩余空间将比其他项多一倍：

<iframe height='221' scrolling='no' title='EvxZNR' src='//codepen.io/mrbird/embed/EvxZNR/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/EvxZNR/'>EvxZNR</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### flex-shrink
`flex-shrink`属性定义了项目的缩小比例，默认为1，即如果空间不足，该项目将缩小。语法如下：
```css
 flex-shrink: <number>;
 ```
 如果所有项目的flex-shrink属性都为1，当空间不足时，都将等比例缩小。如果一个项目的flex-shrink属性为0，其他项目都为1，则空间不足时，前者不缩小。负值对该属性无效：

<iframe height='221' scrolling='no' title='vJYgxo' src='//codepen.io/mrbird/embed/vJYgxo/?height=209&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/vJYgxo/'>vJYgxo</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### flex-basis
`flex-basis`属性定义了在分配多余空间之前，项目占据的主轴空间（main size）。浏览器根据这个属性，计算主轴是否有多余空间。它的默认值为auto，即项目的本来大小。基本语法如下：
```css
flex-basis: <length> | auto;
```
`flex-basis`可以手动的设置为一个合法的px值，这样项目原本的width将失效。比如，第一个li的宽度为70px，在将其`flex-basis`属性设置为140px之后：

<iframe height='221' scrolling='no' title='YxzNEm' src='//codepen.io/mrbird/embed/YxzNEm/?height=300&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/YxzNEm/'>YxzNEm</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

### flex
`flex`属性是`flex-grow`, `flex-shrink` 和 `flex-basis`的简写，默认值为`0 1 auto`。**后两个属性可选**。该属性有两个快捷值：`auto (1 1 auto)` 和 `none (0 0 auto)`。
### align-self
`align-self`属性允许单个项目有与其他项目不一样的对齐方式，可覆盖`align-items`属性。默认值为auto，表示继承父元素的`align-items`属性，如果没有父元素，则等同于`stretch`。

语法如下：
```css
align-self: auto | flex-start | flex-end | center | baseline | stretch;
```
比如，将第二个li的`aligh-self`属性值设置为`flex-end`：

<iframe height='315' scrolling='no' title='MvWJGV' src='//codepen.io/mrbird/embed/MvWJGV/?height=315&theme-id=30192&default-tab=result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/MvWJGV/'>MvWJGV</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

