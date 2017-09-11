---
title: jQuery选择器总结
date: 2016-09-24 08:43:42
tags: jQuery
---
jQuery选择器和CSS选择器一样，并在其基础上做出了拓展。

可在此页面上练习jQuery选择器：[http://mrbird.leanote.com/single/jQuery-Selectors-Lab-Page](http://mrbird.leanote.com/single/jQuery-Selectors-Lab-Page)

<!--more-->
## 基本选择器
<table>
        <tr>
            <th>
                
                    选择器
                
            </th>
            <th>
                
                    描述
                
            </th>
            <th>
                
                    返回
                
            </th>
            <th>
                
                    示例
                
            </th>
        </tr>
        <tr>
            <td>
                #id
            </td>
            <td>
                根据给定的id匹配一个元素
            </td>
            <td>
                
                    单个元素
                
            </td>
            <td>
                
                    $("#test")选取id为test的元素
                
            </td>
        </tr>
        <tr>
            <td>
                .class
            </td>
            <td>
                根据给定的类名匹配元素
            </td>
            <td>
                
                    集合元素
                
            </td>
            <td>
                
                    $(".test)选取所有class为test的元素
                
            </td>
        </tr>
        <tr>
            <td>
                element
            </td>
            <td>
                根据给定的元素名匹配元素
            </td>
            <td>
                
                    集合元素
                
            </td>
            <td>
                $("p")选取所有&lt;p&gt;元素
            </td>
        </tr>
        <tr>
            <td>
                \*
            </td>
            <td>
                匹配所有元素
            </td>
            <td>
                
                    集合元素
                
            </td>
            <td>
                $("*")选取所有元素
            </td>
        </tr>
        <tr>
            <td>
                
                    selector1,selector2
                
                
                    ......，selectorN
                
            </td>
            <td>
                
                    将每一个选择器匹配到的元素</br>合并后一起返回
                
            </td>
            <td>
                
                    集合元素
                
            </td>
            <td>
                
                    $("div,span,p.myClass")选取所有&lt;div&gt;，</br>&lt;span&gt;和
                
                
                    拥有class为myClass的&lt;p&gt;标签的一组元素
                
            </td>
        </tr>
</table>

## 层次选择器
<table>
        <tr>
            <td>
                <strong>
                    选择器
                </strong>
            </td>
            <td>
                <strong>
                    描述
                </strong>
            </td>
            <td>
                <strong>
                    返回
                </strong>
            </td>
            <td>
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                $("ancestor descendant")
            </td>
            <td>
                
                    选取ancestor元素里的所有descendant
                </br>
                
                    （后代）元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div span")选取&lt;div&gt;里的所有的</br>
                
                
                    &lt;span&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                $("parent&gt;child")
            </td>
            <td>               
选取parent元素下的child</br>
元素与\$(“ancestor descendant”)</br>
有区别，\$(“ancestor descendant”)选择的</br>
是后代元素                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div&gt;span")选取&lt;div&gt;元素下元素</br>
                
                
                    名是&lt;span&gt;的子元素
                
            </td>
        </tr>
        <tr>
            <td>
                $("prev+next")
            </td>
            <td>
                
                    选取紧接在prev元素后的next元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $(".one+div")选取class为one的下一</br>
                
                
                    个&lt;div&gt;同辈元素
                
            </td>
        </tr>
        <tr>
            <td>
                $("prev~siblings)
            </td>
            <td>
                
                    选取prev元素之后的所有siblings元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("#two~div")选取id为two的元素</br>后的
                
                
                    所有&lt;div&gt;同辈元素
                
            </td>
        </tr>
</table>

## 过滤选择器
jQuery过滤选择器规则同CSS中的伪类选择器，都以一个冒号(:)开头。按照不同的过滤规则，过滤选择器可以分为基本过滤器，内容过滤器，可见性过滤器，属性过滤器，子元素过滤器和表单对象属性过滤选择器。
### 基本过滤选择器

<table>
        <tr>
            <td >
                <strong>
                    选择器&nbsp;
                </strong>
            </td>
            <td >
                <strong>
                    描述
                </strong>
            </td>
            <td >
                <strong>
                    返回
                </strong>
            </td>
            <td >
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                :first
            </td>
            <td>
                选取第一个元素
            </td>
            <td>
                单个元素
            </td>
            <td>
                
                    $("div:first")选取所有&lt;div&gt;元素中第一个&lt;div&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :last
            </td>
            <td>
                选取最后一个元素
            </td>
            <td>
                单个元素
            </td>
            <td>
                
                    $("div:last")选取所有&lt;div&gt;元素中最后一个&lt;div&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :not(selector)
            </td>
            <td>
                
                    去除所有与给定选择器匹配的
                
                
                    元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:not(myClass)")选取class不是myClass的&lt;input&gt;
                
                
                    元素
                
            </td>
        </tr>
        <tr>
            <td>
                :even
            </td>
            <td>
                
                    选取索引是偶数的所有元素，
                
                
                    索引从0开始
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:even")选取索引是偶数的&lt;input&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :odd
            </td>
            <td>
                
                    选取索引是奇数的所有元素，
                
                
                    索引从0开始
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:odd")选取索引是奇数的&lt;input&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :eq(index)
            </td>
            <td>
                
                    选取索引等于index的元素，
                
                
                    (index)从0开始
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:eq(1)")选取索引等于1的&lt;input&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :gt(index)
            </td>
            <td>
                
                    选取索引大于index的元素，
                
                
                    (index)从0开始
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:gt(1)")选取索引大于1的&lt;input&gt;元素</br>
                
                
                    （注：大于1，而不包括1）
                
            </td>
        </tr>
        <tr>
            <td>
                :lt(index)
            </td>
            <td>
                
                    选取索引小于index的元素，
                
                
                    (index)从0开始
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:lt(1)")选取索引小于1的&lt;input&gt;元素</br>
                
                
                    （注：小于1，而不包括1）
                
            </td>
        </tr>
        <tr>
            <td>
                :header
            </td>
            <td>
                
                    选取所有的标题元素，如h1，
                
                
                    h2等
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $(":header")选取网页中所有header，如h1,h2...
                
            </td>
        </tr>
        <tr>
            <td>
                :animated
            </td>
            <td>
                
                    选取当前正在执行动画的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div:animate")选取正在执行动画的&lt;div&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :focus
            </td>
            <td>
                
                    获取当前获取焦点的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:focus")获取当前获取焦点的&lt;input&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :root
            </td>
            <td>
                
                    选择文档的根元素
                
            </td>
            <td>
                单个元素
            </td>
            <td>
                
                    $(":root")获取当前文档的根元素
                
            </td>
        </tr>
        <tr>
            <td>
                :lang(language)
            </td>
            <td>
                
                    只选择采用特定语言的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("p:lang(en)")选取带有以 "en" 开头的lang 属性值的</br>
                
                
                    所有 &lt;p&gt; 元素
                
            </td>
        </tr>
</table>

### 内容过滤选择器
<table>
        <tr>
            <td >
                <strong>
                    选择器
                </strong>
            </td>
            <td >
                <strong>
                    描述
                </strong>
            </td>
            <td >
                <strong>
                    返回
                </strong>
            </td>
            <td >
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                :contains(text)
            </td>
            <td>
                
                    选取含有文本内容为"text"的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div:contents('我')")选取含有文本我的&lt;div&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :empty
            </td>
            <td>
                
                    选取不包含子元素和文本的空元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div:empty")选取不包含子元素(包括文本元素)的
                
                
                    &lt;div&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :has(selector)
            </td>
            <td>
                
                    选取含有选择器所匹配的元素的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div:has(p)")选取含有&lt;p&gt;元素的&lt;div&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :parent
            </td>
            <td>
                
                    选取含有子元素或文本的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div:parent")选取拥有子元素（包括文本元素）的
                
                
                    &lt;div&gt;元素
                
            </td>
        </tr>
</table>

### 可见性过滤选择器
<table>
        <tr>
            <td >
                <strong>
                    选择器
                </strong>
            </td>
            <td >
                <strong>
                    描述
                </strong>
            </td>
            <td >
                <strong>
                    返回
                </strong>
            </td>
            <td >
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                :hidden
            </td>
            <td>
                
                    选取所有不可见元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
			\$(":hidden")选取所有不可见元素。包括&lt;input type="hidden/"&gt;，</br>
&lt;div sytle="dispaly:none;"&gt;和&lt;div&gt;等元素。</br>
如果只想选取&lt;input&gt;元素，可以使用\$("input:hidden")</br>
            </td>
        </tr>
        <tr>
            <td>
                :visible
            </td>
            <td>
                
                    选取所有可见元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("input:visible")选取所有可见的&lt;div&gt;元素
                
            </td>
        </tr>
</table>

### 属性过滤选择器
<table>
        <tr>
            <td>
                <strong>
                    选择器
                </strong>
            </td>
            <td>
                <strong>
                    描述
                </strong>
            </td>
            <td>
                <strong>
                    返回
                </strong>
            </td>
            <td>
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                [attribute]
            </td>
            <td>
                
                    选取拥有此属性的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                $("div[id]")选取拥有属性id的元素
            </td>
        </tr>
        <tr>
            <td>
                [attribute=value]
            </td>
            <td>
                
                    选取属性的值为value的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div[title=test]")选取属性title为"test"的&lt;div&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                [attribute!=value]
            </td>
            <td>
                
                    选取属性的值不等于value的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div[title!=test]")选取属性title不等于"test"的&lt;div&gt;</br>
                
                
                    元素（注意：没有属性title的&lt;div&gt;元素也会被选取）
                
            </td>
        </tr>
        <tr>
            <td>
                [attribute^=value]
            </td>
            <td>
                
                    选取属性的值以value开始的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div[title^=test]")选取属性title以"test"开始的&lt;div&gt;
                
            </td>
        </tr>
        <tr>
            <td>
                [attribute$=value]
            </td>
            <td>
                
                    选取属性的值以value结束的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    \$("div[title$=test]")选取属性title以"test"结束的&lt;div&gt;
                
            </td>
        </tr>
        <tr>
            <td>
                [attribute*=value]
            </td>
            <td>
                
                    选取属性的值含有value的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div[title*=test]")选取属性title含有"test"的&lt;div&gt;
                
            </td>
        </tr>
        <tr>
            <td>
                [attribute|=value]
            </td>
            <td>
                
                    选取属性等于给定字符串或以该</br>
                
                
                    字符串为前缀（该字符串后跟一个</br>
                
                
                    "\_"）的元素</br>
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div[title|='en']")选取属性tite等于en或以en为前缀</br>
                
                
                    （该字符串后跟一个连字符"\_"）的元素</br>
                
            </td>
        </tr>
        <tr>
            <td>
                [attribute~=value]
            </td>
            <td>
                
                    选取属性用空格分隔的值中包含</br>
                
                
                    一个给定值的元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("div[title~='uk']")选取属性title用空格分隔的值中包含</br>
                
                
                    字符uk的元素
                
            </td>
        </tr>
        <tr>
            <td>
                
                    [attribute1]</br>
                
                
                    [attribute2]</br>
                
                
                    [attributeN]</br>
                
            </td>
            <td>
                
                    复合属性选择器满足多个条件，</br>
                
                
                    每选择一次，范围缩小一次
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                   \$("div[id][title$='test']")选取拥有属性id，并且属性title</br>
                
                
                    以"test"结束的&lt;div&gt;元素
                
            </td>
        </tr>
</table>

### 子元素过滤选择器
<table>
        <tr>
            <td >
                <strong>
                    选择器
                </strong>
            </td>
            <td >
                <strong>
                    描述
                </strong>
            </td>
            <td >
                <strong>
                    返回
                </strong>
            </td>
            <td >
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                
                    :nth-child</br>
                
                
                    (index/even/</br>
                
                
                    odd/equation)
                
            </td>
            <td>
                
                    选取每个父元素下的第index个</br>
                
                
                    子元素或者奇偶元素（index从1</br>
                
                
                    开始）
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    :eq(index)只匹配一个元素，而:nth-child将为每一个父</br>
                
                
                    元素匹配子元素，并且:nth-child(index)的index是从1</br>
                
                
                    开始的，而eq(index)是从0开始的</br>
                
            </td>
        </tr>
        <tr>
            <td>
                
                    :nth-last-child</br>
                
                
                    (index/even/</br>
                
                
                    odd/equation)</br>
                
            </td>
            <td>
                
                    选取父元素下的倒数第n个子元</br>
                
                
                    素或符合特定顺序规则的元素</br>
                
            </td>
            <td>
                &nbsp;集合元素
            </td>
            <td>
                
                    &nbsp;:nth-last-child(2)表示作为父元素的倒数第2个子元素；</br>
                
                
                    :nth-last-child(3n)表示匹配作为父元素倒数顺序的第3n</br>
                
                
                    个子元素的元素（n表示包括0在内的自然数）</br>
                
            </td>
        </tr>
        <tr>
            <td>
                :first-child
            </td>
            <td>
                
                    选取每个父元素的第一个子元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    :first只返回一个元素，而:first-child选择符将为每个父</br>
                
                
                    元素匹配子元素。例如$("ul li:fisrt-child")选取每个&lt;ul&gt;</br>
                
                
                    中的第一个&lt;li&gt;元素</br>
                
            </td>
        </tr>
        <tr>
            <td>
                :last-child
            </td>
            <td>
                
                    选取每个父元素的最后一个</br>
                
                
                    子元素
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    :last只返回一个元素，而:last-child选择符将为每个父</br>
                
                
                    元素匹配子元素。例如$("ul li:last-child")选取每个&lt;ul&gt;</br>
                
                
                    中的末尾&lt;li&gt;元素</br>
                
            </td>
        </tr>
        <tr>
            <td>
                :only-child
            </td>
            <td>
                
                    如果某个元素是它父元素中唯一</br>
                
                
                    的子元素，那么将会被匹配。如</br>
                
                
                    果父元素中含有其他元素，那么</br>
                
                
                    不会被匹配
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("ul li:only-child")在&lt;ul&gt;中选取是唯一子元素的</br>
                
                
                    &lt;li&gt;元素
                
            </td>
        </tr>
        <tr>
            <td>
                :only-of-type
            </td>
            <td>
                
                    匹配作为父元素唯一一个该类型</br>
                
                
                    的子元素的元素，将其封装为</br>
                
                
                    jQuery对象并返回。
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    $("li:only-of-type")选取li父元素下的唯一的一个li元素
                
            </td>
        </tr>
        <tr>
            <td>
                :first-fo-type
            </td>
            <td>
                
                    匹配作为父元素的第一个该类型</br>
                
                
                    的子元素的元素，将其封装为</br>
                
                
                    jQuery对象并返回
                
            </td>
            <td>
                集合元素
            </td>
            <td>
                
                    \$("span:first-of-type")选取span父元素下的第一个</br>
                
                
                    span元素，等价于\$("span:nth-of-type(1)")
                
            </td>
        </tr>
        <tr>
            <td>
                :last-of-type
            </td>
            <td>
                
                    匹配作为父元素的最后一个该类</br>
                
                
                    型的子元素的元素，将其封装为</br>
                
                
                    jQuery对象并返回
                
            </td>
            <td>
                &nbsp;集合元素
            </td>
            <td>
                
                    \$("span:last-of-type")选取span父元素下的最后一个</br>
                
                
                    span元素，等价于\$("span:nth-last-of-type(1)")
                
            </td>
        </tr>
        <tr>
            <td>
                
                    :nth-of-type</br>
                
                
                    (index/even/</br>
                
                
                    odd/equation)
                
            </td>
            <td>
                
                    匹配作为父元素的同类型子元素中</br>
                
                
                    的第n个(或符合特定顺序的)元素，</br>
                
                
                    将其封装为jQuery对象并返回</br>
                
            </td>
            <td>
                &nbsp;集合元素
            </td>
            <td>
                &nbsp;
                
                    $("span:nth-of-type(2)")选取span父元素下的第二个</br>
                
                
                    span元素
                
            </td>
        </tr>
        <tr>
            <td>
                
                    :nth-last-of-type</br>
                
                
                    (index/even/</br>
                
                
                    odd/equation)
                
            </td>
            <td>
                匹配作为父元素的同类型子元素中</br>
				的倒数第n个（或符合特定倒数顺</br>
				序的）元素，将其封装为jQuery对</br>
				象并返回
                
            </td>
            <td>
                &nbsp;集合元素
            </td>
            <td>
                
                    $("span:nth-last-of-type(2)")选取span父元素下的倒</br>
                
                
                    数第二个span元素
                
            </td>
        </tr>
</table>

`:nth-child()`选择器是很常见的子元素过滤选择器，详细功能如下：

(1) `:nth-child(even)`能选取每个父元素下的索引值是偶数的元素。

(2) `:nth-child(odd)`能选取每个父元素下的索引值是奇数的元素。

(3) `:nth-child(2)`能选取每个父元素下的索引值等于2的元素。

(4) `:nth-child(3n)`能选取每个父元素下的索引值是3的倍数的元素。(n从1开始)

另外，关于:only-child和:only-of-type的区别可以看下面这个例子：
```html
<ul>
    <span id="span">span</span>
    <li id="li1">li1</li>
</ul>
<ul>
    <li id="li2">li2</li>
</ul>
<script>
    console.log($("li:only-child"));
    console.log($("li:only-of-type"));
</script>
```
打印结果：

![89660057-file_1495163472765_82bf.png](img/89660057-file_1495163472765_82bf.png)
### 表单对象属性过滤选择器
此选择器主要是对所选择的表单元素进行过滤，例如选择被选中的下拉框，多选框等元素。
<table>
        <tr>
            <td >
                <strong>
                    选择器
                </strong>
            </td>
            <td >
                <strong>
                    描述
                </strong>
            </td>
            <td >
                <strong>
                    返回
                </strong>
            </td>
            <td >
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                :enabled
            </td>
            <td>
                选取所有可用元素
            </td>
            <td>
                集合元素
            </td>
            <td>
                <p>
                    $("#form1:enabled")选取id为form1的表单内所有可用元素
                </p>
            </td>
        </tr>
        <tr>
            <td>
                :disabled
            </td>
            <td>
                选取所有不可用元素
            </td>
            <td>
                集合元素
            </td>
            <td>
                <p>
                    $("#form2:disabled")选取id为form2的表单内所有不可用元素
                </p>
            </td>
        </tr>
        <tr>
            <td>
                :checked
            </td>
            <td>
                <p>
                    选取所有被选中的元素
                </p>
                <p>
                    （单选框，复选框）
                </p>
            </td>
            <td>
                集合元素
            </td>
            <td>
                <p>
                    $("input:checked")选取所有被选中的&lt;input&gt;元素
                </p>
            </td>
        </tr>
        <tr>
            <td>
                :selected
            </td>
            <td>
                <p>
                    选取所有被选中的选项元素
                </p>
                <p>
                    （下拉列表）
                </p>
            </td>
            <td>
                集合元素
            </td>
            <td>
                <p>
                    $("select option:selected")选取所有被选中的选项元素
                </p>
            </td>
        </tr>
</table>

## 表单选择器
<table>
        <tr>
            <td >
                <strong>
                    选择器
                </strong>
            </td>
            <td >
                <strong>
                    描述
                </strong>
            </td>
            <td >
                <strong>
                    返回
                </strong>
            </td>
            <td >
                <strong>
                    示例
                </strong>
            </td>
        </tr>
        <tr>
            <td>
                :input
            </td>
            <td>
                <p>
                    选取所有&lt;input&gt;，&lt;textarea&gt;,&lt;select&gt;
                </p>
                <p>
                    和&lt;button&gt;元素
                </p>
            </td>
            <td>
                集合元素
            </td>
            <td>
                <p>
                    $(":input")选取所有&lt;input&gt;，&lt;textarea&gt;，&lt;select&gt;
                </p>
                <p>
                    和&lt;button&gt;元素
                </p>
            </td>
        </tr>
        <tr>
            <td>
                :text
            </td>
            <td>
                选取所有的单行文本框
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":text")选取所有的单行文本框
            </td>
        </tr>
        <tr>
            <td>
                :password
            </td>
            <td>
                选取所有的密码框
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":password")选取所有的密码框
            </td>
        </tr>
        <tr>
            <td>
                :radio
            </td>
            <td>
                选取所有的单选框
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":radio")选取所有的单选框
            </td>
        </tr>
        <tr>
            <td>
                :checkbox
            </td>
            <td>
                选取所有的多选框
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":checkbox")选取所有的多选框
            </td>
        </tr>
        <tr>
            <td>
                :submit
            </td>
            <td>
                选取所有的提交按钮
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":submit")选取所有的提交按钮
            </td>
        </tr>
        <tr>
            <td>
                :image
            </td>
            <td>
                选取所有的图像按钮
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":image")选取所有的图像按钮
            </td>
        </tr>
        <tr>
            <td>
                :reset
            </td>
            <td>
                选取所有的重置按钮
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":reset")选取所有的重置按钮
            </td>
        </tr>
        <tr>
            <td>
                :button
            </td>
            <td>
                选取所有的按钮
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":button")选取所有的按钮
            </td>
        </tr>
        <tr>
            <td>
                :file
            </td>
            <td>
                选取所有的上传域
            </td>
            <td>
                集合元素
            </td>
            <td>
                $(":file")选取所有的上传域
            </td>
        </tr>
        <tr>
            <td>
                :hidden
            </td>
            <td>
                选取所有的不可见元素
            </td>
            <td>
                集合元素
            </td>
            <td>
                同前所述
            </td>
        </tr>
</table>