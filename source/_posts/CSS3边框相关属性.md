---
title: CSS3边框相关属性
date: 2017-07-17 09:26:30
tags: CSS3
---
CSS3标准发布之前，对边框的样式的设定是非常单调的。CSS3标准发布之后，我们可以使用图片来定制边框，可以设置元素的阴影以及选择使用哪种盒子模型等。
## border-image
`border-image`属性可以用图片作为边框样式。`border-image`属性可以拆分为5个属性：
```css
border-image-source  // 边框图片源
border-image-slice   // 边框图片切割尺寸
border-image-width   // 边框图片宽度
border-image-outset  // 边框图片区域超出元素边框的尺寸
border-image-repeat  // 边框图片中间部分在元素对应部分的存在方式
```
<!--more-->
### border-image-source
设置边框图片的源，用url()方式规定图片路径，相对和绝对路径都可。语法如下：
```css
border-image-source : none | <url>
```
### border-image-slice
`border-image-slice`用来规定图片的切割位置。语法如下：
```css
border-image-slice: [ <number> | <percentage>]{1,4}
```
属性值可以为number，也可以是percentage。如果是percentage方式，则是相对于图片的尺寸。比如有如下一个边框图片：

![ef7e418ec860a6a9a6ce9dbf8a058434.png](https://www.tuchuang001.com/images/2017/07/17/ef7e418ec860a6a9a6ce9dbf8a058434.png)

每一个小方块的尺寸是27px，那么此图片的长宽尺寸是(27*3)像素。使用如下代码进行切割：
```css
border-image-slice:27px 27px 27px 27px;
```
结果如下图所示：

![34a58685d3967e3afe7634c8cd1fd754.gif](https://www.tuchuang001.com/images/2017/07/17/34a58685d3967e3afe7634c8cd1fd754.gif)

图片被切割后，会被划分为九个区域，这个九个区域会与元素的九个区域是一一对应的。
### border-image-width
`border-image-width`用来规定边框图片宽度，语法如下：
```css
border-image-width : [ <length> | <percentage> | <number> | auto ]{1,4}
```
此属性可以省略，此时边框图片区域与元素的border宽度是一致的。此属性可以有1-4值，取值方式和border-width类似，同时也遵循上右下左方式。
### border-image-outset
`border-image-outset`此属性用来规定边框图片区域超出元素边框的尺寸，语法如下：
```css
border-image-outset : [ <length> | <number> ]{1,4}
```
### border-image-repeat
`border-image-repeat`用来规定，切割后的边框图片中间部分（演示图片中的黄色部分）在元素对应部分的存在方式。语法如下：
```css
border-image-repeat: [ stretch | repeat | round ]{1,2}
```
三种值的含义如下：
- `stretch`：图片以延展方式来填充该区域。
- `repeat`：图片以重复平铺方式来填充该区域。
- `round`：图片以重复平铺方式来填充该区域。如果没有以整数的倍数来填充该区域，图片会进行缩放以便于整数性倍数的平铺填充。

一般都是采用`round`。
### 具体实例
示例1：

<iframe height='300' scrolling='no' title='border-image-one' src='//codepen.io/mrbird/embed/KqYQXR/?height=300&theme-id=30192&default-tab=css&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/KqYQXR/'>border-image-one</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

以上代码中，border-image-slice设置为27，由于没有规定border-image-width，那么将以边框的尺寸为标准，又由于没有规定border-image-repeat属性，则默认采用stretch方式，也就是拉伸被切割的中间区域（也即是演示图中的黄色区域）。

示例2：

<iframe height='300' scrolling='no' title='border-image-two' src='//codepen.io/mrbird/embed/QgPQxr/?height=300&theme-id=30192&default-tab=css&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/QgPQxr/'>border-image-two</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

边框设置为54px，边框图片将会自适应。

示例3：

<iframe height='300' scrolling='no' title='border-image-three' src='//codepen.io/mrbird/embed/JJVpBj/?height=300&theme-id=30192&default-tab=css&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/JJVpBj/'>border-image-three</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

round方式可以自动调整切割后边框图片中间部分（演示图黄色部分）尺寸方式实现重复平铺效果，所以不会出现repeat那样的残缺现象。
## box-shadow
`box-shadow`用来设置元素的投影效果。语法如下：
```css
box-shadow:h-shadow v-shadow blur spread color inset;
```
每个参数的具体意义：
- `h-shadow`：必需，设置元素阴影水平偏移量，可以为负值，单位是像素。
- `v-shadow`：必需，设置元素阴影垂直偏移量，可以为负值，单位是像素。
- `blur`：可选，阴影模糊半径，只能够为正值，如果为0，表示不具有模糊效果，单位像素。
- `spread`：可选，阴影的扩展半径尺寸，可以为负值，单位是像素。
- `color`：可选，设置阴影的颜色；省略此参数，浏览器选取默认颜色，各个浏览器的默认可能不同，有的为透明。
- `inset`：可选，可以将外部阴影改为内部阴影。

### 具体实例
示例1，只设置水平和垂直的偏移量：

<iframe height='300' scrolling='no' title='box-shadow-one' src='//codepen.io/mrbird/embed/QgPQZx/?height=300&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/QgPQZx/'>box-shadow-one</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

示例2，新增模糊半径和阴影颜色：

<iframe height='300' scrolling='no' title='box-shadow-two' src='//codepen.io/mrbird/embed/NgmyeM/?height=300&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/NgmyeM/'>box-shadow-two</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

示例3，设置多个阴影：

<iframe height='300' scrolling='no' title='box-shadow-three' src='//codepen.io/mrbird/embed/WOWMPy/?height=300&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/WOWMPy/'>box-shadow-three</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

## box-sizing
`box-sizing`属性用于指定元素采用哪种盒子模型。语法如下：
```css
box-sizing ：content-box || border-box || inherit
```
如果属性值是content-box，那么将采用标准盒模型；如果属性值是border-box，那么将采用怪异模式盒模型；如果属性值是inherit，那么将采用继承方式。

盒子模型目前安装W3C的标准可以分为两种：标准盒子模型和怪异盒子模型。

- **标准盒子模型**，最常见的盒子模型，在这种盒子模型下，元素实际占宽为：width+padding+border+margin；实际占高为：height+padding+border+margin。
- **怪异盒子模型**，实际占宽：width+margin；实际占高：height+margin。其中width和height包含content，padding，border。

标准盒子模型下元素的width和height构成了元素的内容区域，而这个区域对应着怪异盒子模型下content。

### 具体实例

<iframe height='300' scrolling='no' title='box-sizing' src='//codepen.io/mrbird/embed/mwgxyB/?height=300&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/mwgxyB/'>box-sizing</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

以上代码中，有一个box容器和两个子div，由于精确设定了左右两个子div的宽度，恰好和box容器宽度相同，且采用浮动，所以两个子div可以水平排列。

现在给浮动的两个元素添加padding属性值，观察结果：

<iframe height='300' scrolling='no' title='box-sizing-two' src='//codepen.io/mrbird/embed/GELxpO/?height=300&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/GELxpO/'>box-sizing-two</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

由于默认采用标准盒子模型，给元素添加了padding属性后，元素实际占宽度改变了（比如宽度为width+padding+border+margin，因为增加了padding，所以总体的值变大了），并且大于父元素的宽度，所以导致了换行。我们可以采用怪异盒子模型来解决这个问题：

<iframe height='300' scrolling='no' title='RgOMaL' src='//codepen.io/mrbird/embed/RgOMaL/?height=300&theme-id=30192&default-tab=css,result&embed-version=2' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='https://codepen.io/mrbird/pen/RgOMaL/'>RgOMaL</a> by wuyouzhuguli (<a href='https://codepen.io/mrbird'>@mrbird</a>) on <a href='https://codepen.io'>CodePen</a>.
</iframe>

怪异盒子模型下，元素的width没有改变，所以实际占宽没变（width+margin）。而width在怪异盒子模型下的值为：content+padding+border，因为总体的值没变，border不变，padding变大，所以使得content变小。

> 参考自：[http://www.softwhy.com/](http://www.softwhy.com/)