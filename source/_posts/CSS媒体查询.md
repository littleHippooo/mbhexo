---
title: CSS媒体查询
date: 2017-07-19 15:17:45
tags: CSS
---
一个媒体查询由一个可选的媒体类型和零个或多个使用媒体功能限制样式表范围的表达式组成, 例如宽度，高度和颜色等。这些表达式描述了媒体特征，最终会被解析为true或false。如果媒体查询中指定的媒体类型匹配展示文档所使用的设备类型，并且所有的表达式的值都是true，那么该媒体查询的结果为true。
<!--more-->

举个简单的例子：
```css
<!-- link元素中的CSS媒体查询 -->
<link rel="stylesheet" media="(max-width: 800px)" href="example.css" />

<!-- 样式表中的CSS媒体查询 -->
<style>
@media (max-width: 600px) {
    .facet_sidebar {
        display: none;
    }
}
</style>
```
当媒体查询结果为true时，相应的样式就会被应用。需要注意的是，即使媒体查询结果为false，link还是会加载相应的css文件，只不过这份样式文件不会被应用罢了。

媒体查询中，默认的媒体类型是all。常见的媒体类型有：

<table>
  <tr>
    <th>媒体类型</th>
    <th>描述</th>
  </tr>
  <tr>
    <td>all</td>
    <td>用于所有的媒体设备。</td>
  </tr>
  <tr>
    <td>aural</td>
    <td>用于语音和音频合成器。</td>
  </tr>
  <tr>
    <td>braille</td>
    <td>用于盲人用点字法触觉回馈设备。</td>
  </tr>
  <tr>
    <td>embossed</td>
    <td>用于分页的盲人用点字法打印机。</td>
  </tr>
  <tr>
    <td>handheld</td>
    <td>用于小的手持的设备。</td>
  </tr>
  <tr>
    <td>print</td>
    <td>用于打印机。</td>
  </tr>
  <tr>
    <td>projection</td>
    <td>用于方案展示，比如幻灯片。</td>
  </tr>
  <tr>
    <td>screen</td>
    <td>用于电脑显示器。</td>
  </tr>
  <tr>
    <td>tty</td>
    <td>用于使用固定密度字母栅格的媒体，比如电传打字机和终端。</td>
  </tr>
  <tr>
    <td>tv</td>
    <td>用于电视机类型的设备。</td>
  </tr>
</table>

## 逻辑操作符
媒体查询操作符包括and，not，only和or（也可以是逗号“，”）。
### and
and操作符只有当各个查询都为true时，才返回true。

比如，下面的媒体查询仅在可视区域宽度不小于700像素并且在横屏时有效：
```css
@media (min-width: 700px) and (orientation: landscape) { ... }
```
这里媒体类型默认为all，如果要将媒体类型限制为电脑屏幕，则改写媒体查询为：
```css
@media tv and (min-width: 700px) and (orientation: landscape) { ... }
```
### not
not关键字应用于整个媒体查询，在媒体查询为假时返回真。

比如下面的媒体查询在屏幕宽度大于700px并且非横屏时有效：
```css
@media not (min-width: 700px) and (orientation: landscape) { ... }
```
其等价于：
```css
@media not ((min-width: 700px) and (orientation: landscape)) { ... }
```
### 逗号分隔列表
媒体查询中使用逗号分隔效果等同于 or 逻辑操作符。当使用逗号分隔的媒体查询时，如果任何一个媒体查询返回真，样式就是有效的。

例如，如果你想在最小宽度为700像素或是横屏的手持设备上应用一组样式，你可以这样写：
```css
@media (min-width: 700px), handheld and (orientation: landscape) { ... }
```
### only
only 关键字防止老旧的浏览器不支持带媒体属性的查询而应用到给定的样式：
```css
<link rel="stylesheet" media="only screen and (color)" href="example.css" />
```
## 常用媒体属性
向所有能显示颜色的设备应用样式表：
```css
@media all and (color) { ... }
```
向所有黑白设备应用样式表：
```css
@media all and (monochrome) { ... }
```
向竖屏设备应用样式表：
```css
@media all and (orientation: portrait) { ... }
```
向横屏设备应用样式表：
```css
@media all and (orientation: landscape) { ... }
```
向最小像素密度为300dpi的设备应用样式表：
```css
@media all and (min-resolution: 300dpi) { ... }
```
宽度和高度属性上面例子中有出现，不再赘述。
