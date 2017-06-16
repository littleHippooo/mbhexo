---
title: CSS优先级规则
date: 2017-04-08 17:30:15
tags: CSS
---
## 特殊性
如果一个元素有两个以上冲突的属性声明，那么特殊性（specificity）高的声明将会胜出。特殊性的值表述为四个部分，如`0,0,0,0`，具体规则：

1.选择器中给定的各个ID属性值，加`0,1,0,0`。

2.选择器中给定的各个类属型值，属性选择和伪类，加`0,0,1,0`。

3.选择器中给定的各个元素和伪元素，加`0,0,0,1`。

4.通配符对特殊性没有任何贡献，加`0,0,0,0`。
<!--more-->

比如：
```css
h1 {color: red;} /* specificity = 0,0,0,1 */
p em {color: purple;} /* specificity = 0,0,0,2 */
*.grape {color: purple;} /* specificity = 0,0,1,0 */
.bright {color: purple;} /* specificity = 0,0,0,1 */
p.bright em.dark {color: maroon;} /* specificity = 0,0,2,2 */
#drop-down {color: green;} /* specificity = 0,1,0,0 */
div#sidebar *[href] {color: black;} /* specificity = 0,1,1,1 */
```
{% note danger %}特殊性大小的比较规则为从左到右，数值大的越大。{% endnote %}

举个例子，考虑有如下规则的html：
```html
<style>
    h1 + p {color: black; font-style: italic} /* specificity = 0,0,0,2 */
    p {color: gray; background: white; font-style: normal} /* specificity = 0,0,0,1 */
    *.aside {color: black; background: silver} /* specificity = 0,0,1,0 */
</style>
<body>
    <h1>Greeting!</h1>
    <p class="aside">It's a fine way to start a day.</p>
    <p>There are many ways to greet a man.</p>
    <h1>Salutations</h1>
    <p>There is nothing finer than a hearty welcome from ...</p>
    <p class="aside">Although a thick and juicy hamburger with...</p>
</body>
```
最终显示如下图所示：

![12850410-file_1491624696068_151ff.png](https://www.tuchuang001.com/images/2017/06/11/12850410-file_1491624696068_151ff.png)
## 内联样式特殊性
特殊性值的第一位是为内联样式保留的，每个内联样式的特殊性都为`1,0,0,0`，比如下面的`h1`元素将显示为绿色：
```html
h1#meadow {color: red}
<h1 id="meadow" style="color: green;">The title</h1>
```
## 重要性
对于某个非常重要的声明，可以在这些声明的结束分号前插入`!important`。如果一个非重要声明和重要声明冲突，胜出的总是重要声明。

如：
```html
<style>
    h1 {color: green !important;}
    h1.title {color: red}
</style>
<body>
    <h1 class="title">Greeting!</h1>
</body>
```
最终`h1`为绿色。
## 继承
对于继承的值没有特殊性，而非0特殊性。举个例子：
```html
<style>
    * {color: lightcoral}
    h1.title {color: black}
</style>
<body>
    <h1 class="title">Meerkat <em>Central</em></h1>
    <p>Welcome to the best place on the web...</p>
</body>
```
显示如下图所示：

![15715845-file_1491625597713_fdef.png](https://www.tuchuang001.com/images/2017/06/11/15715845-file_1491625597713_fdef.png)

结果证明了0特殊性比无特殊性要强。

## 按权重和来源排序
一般来说，权重由大到小的顺序为：

1.读者的重要声明。

2.创作人员的重要声明。

3.创作人员的正常声明。

4.读者的正常声明。

5.用户代理声明。

CSS中的样式一共有三种来源：创作人员、读者和用户代理。

创作人员（author's+style）样式应该是我们最熟悉的，如果你是一个前端开发者，那么你写的那些样式就叫做创作人员样式。

用户代理样式（agent's+style）。用户代理也就是我们通常所说的浏览器（IE、Firefox等等），这些浏览器会提供一些默认的样式。

读者样式（reader's+style）。所谓读者自然就是浏览网页的用户，有些时候这些用户里可能会有人不满意网页的配色，或者字体大小，这时候他们就是通过浏览器提供的接口为网站添加读者样式。

比如：
```css
p em {color: black;} /* author's style sheet*/ 
p em {color: yellow;} /* reader's style sheet*/ 
```
第一条规则将胜出。
```css
p em {color: black !important;} /* author's style sheet*/ 
p em {color: yellow !important;} /* reader's style sheet*/ 
```
第二条规则将胜出。