---
title: CSS3文本属性
date: 2017-06-20 09:32:13
tags: CSS3
---
## text-shadow
该属性用于设置文字阴影效果，基本语法如下：
```css
text-shadow:[颜色 x轴 y轴 模糊半径],[颜色 x轴 y轴 模糊半径]...
```
<!--more-->
语法注释:

（1）颜色：表示阴影的颜色值。

（2）x轴：水平方向的偏移量，单位是像素。

（3）y轴：垂直方向的偏移量，单位是像素。

（4）模糊半径：阴影的影响范围，不能为负值，值越大越模糊。

代码实例：

**x轴偏移量演示：**
<iframe width="100%" height="200" src="//jsfiddle.net/wuyouzhuguli/1sht7nhe/embedded/html,css,result/?bodyColor=f7f7f7&accentColor=42b983" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

**多层阴影:**

所谓多层引用，就是给文字施加多个阴影样式即可，之间用逗号分隔。
## text-stroke
text-stroke属性可以设置文字的描边效果。语法如下：
```css
text-stroke：[ text-stroke-width ] || [ text-stroke-color ]
```
语法注释：

（1）`text-stroke-width`：设置元素中文本的描边厚度。

（2）`text-stroke-color`：设置元素中文本的描边颜色。

代码实例：
<iframe width="100%" height="200" src="//jsfiddle.net/wuyouzhuguli/pcmcc3m0/embedded/html,css,result/?bodyColor=f7f7f7&accentColor=42b983" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

`text-stroke`是一个复合属性，也可以将它们拆开单独设置：
<iframe width="100%" height="200" src="//jsfiddle.net/wuyouzhuguli/fd4hqdm7/embedded/html,css,result/?bodyColor=f7f7f7&accentColor=42b983" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

## text-overflow
该属性用于控制文本溢出样式，基本语法如下：
```css
text-overflow：clip | ellipsis
```
语法注释：

（1）`clip`：此属性值表示直接裁切，并不显示省略标记(...)。

（2）`ellipsis`：此属性可以设置当文本溢出时将显示省略标记(...)。

{% note danger %}需要与overflow:hidden和white-space:nowrap配合使用才能够生效。{% endnote %}

代码实例：
<iframe width="100%" height="280" src="//jsfiddle.net/wuyouzhuguli/m39anyLv/embedded/html,css,result/?bodyColor=f7f7f7&accentColor=42b983" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

## text-fill-color
设置文字的填充颜色，同时设置`text-fill-color`和`color`，text-fill-color将会覆盖color属性。

代码实例：

使用`text-fill-color`和`text-stroke`属性来制造**镂空文字**效果：
<iframe width="100%" height="230" src="//jsfiddle.net/wuyouzhuguli/4x0pztcu/embedded/html,css,result/?bodyColor=f7f7f7&accentColor=42b983" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

## word-wrap
该属性提供换行的功能，基本语法：
```css
word-wrap: normal | break-word
```
语法注释：

（1）normal：默认值，保持浏览器的默认处理，只在允许的断字点换行，也就是非连续的英文字符数字或者汉字可以进行换行。

（2）break-word：此属性值可以实现内容换行，也就是可以实现在边界内换行，不能够超出边界。

代码实例：
<iframe width="100%" height="370" src="//jsfiddle.net/wuyouzhuguli/uhkjyewj/embedded/html,css,result/?bodyColor=f7f7f7&accentColor=42b983" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

## @font-face
该属性用于引入网络中的字体，基本语法：
```css
@font-face {
  font-family: <YourWebFontName>;
  src: <source> [<format>][,<source> [<format>]]*;
  [font-weight: <weight>];
  [font-style: <style>];
}
```
语法注释：

（1）YourWebFontName：必需，自定义字体的名称。

（2）source：必需，规定自定义字体的路径，可以是相对路径也可以是绝对路径。

（3）format：可选，规定自定义字体的格式，用来帮助浏览器识别，主要类型:truetype(.ttf)，opentype(.otf)，truetype-aat，embedded-opentype(.eot)，svg(.svg)等。

（4）font-weight：可选，规定字体是否为粗体。

（5）font-style：可选，规定字体的样式，比如斜体。

代码实例：
```css
@font-face {
  font-family: 'MyWebFont';
  src: url('webfont.eot'); /* IE9 Compat Modes */
  src: url('webfont.eot?#iefix') format('embedded-opentype'), /* IE6-IE8 */
       url('webfont.woff') format('woff'), /* Modern Browsers */
       url('webfont.ttf')  format('truetype'), /* Safari, Android, iOS */
       url('webfont.svg#svgFontName') format('svg'); /* Legacy iOS */
}
```

> 参考自[蚂蚁部落](http://www.softwhy.com/qiduan/css3_source/)