---
title: 调教Sublime Text 3
date: 2017-06-29 15:05:20
tags: Sublime Text
---
Sublime Text 3 是一款编辑器软件，自带语法高亮，代码提示，自动补全等让开发者爱不释手的功能。并且启动速度极快，支持自定义主题和装第三方插件。不过刚下载的Sublime Text不仅图标巨丑，主题还难看，建议对其进行一番调教。调教包括配置主题，安装插件，了解快捷键和配置云同步等。

调教之前需要安装Package Control。使用快捷键`Ctrl+Shift+P`呼出Command Palette，然后输入install Package Control，然后Enter即可安装。官方Package Control市场：[https://packagecontrol.io/](https://packagecontrol.io/)。
<!--more-->

## 安装主题
Sublime Text包含很多优秀的第三方主题，不过个人还是比较喜欢[Boxy Theme](https://github.com/ihodev/sublime-boxy)。在Command Palette中输入install，选择Package Control: install Package：

![0dbde8ff58e3737611256ccf2b2bd1ba.png](https://www.tuchuang001.com/images/2017/06/29/0dbde8ff58e3737611256ccf2b2bd1ba.png)

点击Enter呼出Package Control后输入Bosy Theme后点击Enter即可安装。控制台提示安装成功后，使用快捷键`Ctrl+Shift+P`呼出Command Palette，输入boxy，选择Boxy Theme:Activation即可在Boxy Theme自带的几款主题中进行切换：

![ae239d9946016dda0e9247b769fd36e0.png](https://www.tuchuang001.com/images/2017/06/29/ae239d9946016dda0e9247b769fd36e0.png)

个人比较喜欢Yesterday这款主题：

![5dcc47e86698448a0f5ed6d0b0dca108.png](https://www.tuchuang001.com/images/2017/06/29/5dcc47e86698448a0f5ed6d0b0dca108.png)

Yesterday相关配置（Preferences→settings）：
```javascript
{
	"color_scheme": "Packages/Boxy Theme/schemes/Boxy Yesterday.tmTheme",
	"font_size": 11,
	"ignored_packages":
	[
		"Vintage"
	],
	"theme": "Boxy Yesterday.sublime-theme",
	// Settings
	"theme_accent_sky": true,
	"theme_button_rounded": true,
	"theme_find_panel_close_hidden": true,
	"theme_find_panel_size_xs": true,
	"theme_grid_border_size_lg": true,
	"theme_icon_button_highlighted": true,
	"theme_icons_atomized": true,
	"theme_popup_border_visible": true,
	"theme_quick_panel_size_md": true,
	"theme_scrollbar_rounded": true,
	"theme_sidebar_disclosure": true,
	"theme_sidebar_indent_top_level_disabled": true,
	"theme_statusbar_size_md": true,
	"theme_tab_rounded": true,
	"theme_tab_selected_prelined": true
}
```
还可以安装与该主题配套的[Mono File Icons](https://packagecontrol.io/packages/Boxy%20Theme%20Addon%20-%20Mono%20File%20Icons)插件，用于美化不同格式文件的图标样式。安装方法同上，不再赘述。效果如下：

![d093750824d1c06fead594bb60f327fa.png](https://www.tuchuang001.com/images/2017/06/29/d093750824d1c06fead594bb60f327fa.png)

## 图标替换
![52aeb15c4be79cabfe03fd569b828968.png](https://www.tuchuang001.com/images/2017/06/29/52aeb15c4be79cabfe03fd569b828968.png)

可以在[Dribbble](https://dribbble.com/)中搜索Sublime Text，然后下载喜欢的图标。不过大多数素材都是Mac的icns格式的，可以在[https://iconverticons.com/online/](https://iconverticons.com/online/)网站中在线转换为windows中的ico格式。
## 安装插件
推荐几款常用的插件：
### Autoprefixer
在编写CSS代码的时候，经常需要为了兼容不同内核的浏览器而在属性前编写`-webkit-`，`-ms-`,`-moz-`等前缀。使用这款插件可以替代我们自动完成这件事。
插件地址[https://packagecontrol.io/packages/Autoprefixer](https://packagecontrol.io/packages/Autoprefixer)。安装方式和主题的安装一致，不再赘述，下面插件将不再描述安装方法。

安装完成后，可以配置快捷键（Preferences→key Bindings）：
```javascript
[
    {
        "keys": ["alt+shift+p"],
        "command": "autoprefixer"
    }
]
```
或者直接在Command Palette中输入auto，选择第一项：

![0c35a056e4abff8b27b63b9ff3bb5692.png](https://www.tuchuang001.com/images/2017/06/29/0c35a056e4abff8b27b63b9ff3bb5692.png)

效果如下：

![437d80a472f5004a2309600dcf909ee3.gif](https://www.tuchuang001.com/images/2017/06/29/437d80a472f5004a2309600dcf909ee3.gif)

### QuoteHTML
[QuoteHTML](https://packagecontrol.io/packages/QuoteHTML)可将HTML片段转换为字符串片段，在操作DOM的时候非常方便，省去了自己手动拼接的时间。

比如有如下HTML片段：
```html
<select class="form-control" id="typeSel" style="width:260px;padding: 0px 6px;">
    <option value="1">option_1</option>
    <option value="2">option_2</option>
    <option value="3">option_3</option>
    <option value="4">option_4</option>
    <option value="5">option_5</option>
</select>
```
在Command Palette中输入q：

![64673fe81165fafd458a12e66fbebfac.png](https://www.tuchuang001.com/images/2017/06/29/64673fe81165fafd458a12e66fbebfac.png)

可根据实际需求自由选择，这里选择第二项然后敲击Enter，效果如下：

![b82439f2c987456a5a57bf1a46dfe83b.png](https://www.tuchuang001.com/images/2017/06/29/b82439f2c987456a5a57bf1a46dfe83b.png)

真是极其方便的说！也可以自己设置快捷键。
### JsFormat
[JsFormat](https://packagecontrol.io/packages/JsFormat)插件可以将压缩后的JS代码格式化，默认绑定快捷键`Ctrl+Alt+F`,也可以自己设置快捷键：
```javascript
{
    "keys": ["ctrl+alt+f"],
    "command": "js_format",
    "context": [{
        "key": "selector",
        "operator": "equal",
        "operand": "source.javascript"
    }]
}
```
或者在Command Palette中输入format：

![dc31197b6966ca7d1c64f331413a12ec.png](https://www.tuchuang001.com/images/2017/06/29/dc31197b6966ca7d1c64f331413a12ec.png)

值得一提的是，它也可以格式化JSON数据。
### CSSFormat
和JsFormat类似的是，[CSSFormat](https://packagecontrol.io/packages/CSSFormat)用于格式化压缩后的CSS代码。安装完成后，右键选择CSS Format可看到对应的几个选项，不同选项格式化的样式不一样，可自行体验。

也可以在Command Palette中输入format css并按下Enter来格式化CSS代码：

![5c41df13847e48da70dc2a6d2361d2ad.png](https://www.tuchuang001.com/images/2017/06/29/5c41df13847e48da70dc2a6d2361d2ad.png)

### Color​Helper
[ColorHelper]()提供CSS颜色预览，提供颜色转换，并允许在调色板中存储和访问喜爱的颜色。安装该插件后，CSS中颜色属性值前会出现一个相应颜色的小方块，如下图所示：

![113cf5b84f29b009ac817101a66ff9c9.png](https://www.tuchuang001.com/images/2017/06/29/113cf5b84f29b009ac817101a66ff9c9.png)

点击小方块，可以进行颜色格式的转换，如16进制转RGB,RGBA,HSL和HSLA：

![d073ac0487bb58e967e0cfa9373f05f5.png](https://www.tuchuang001.com/images/2017/06/29/d073ac0487bb58e967e0cfa9373f05f5.png)

也可以在调色板中获取自己喜欢的颜色，并插入：

![dbed09b1b2206c44b8e34fcd3d273390.png](https://www.tuchuang001.com/images/2017/06/29/dbed09b1b2206c44b8e34fcd3d273390.png)

### Better Completion
相比Sublime Text 3自带的代码补全功能，[Better Completion](https://packagecontrol.io/packages/Better%20Completion)可以提供更好自动补全功能，支持JavaScript，jQuery，Lodash，Underscore，HTML5，CSS3和Bootstrap等。安装完后在Command Palette输入sbc，然后按下Enter键：

![84136c105aaaa472d34925a48bba9cb3.png](https://www.tuchuang001.com/images/2017/06/29/84136c105aaaa472d34925a48bba9cb3.png)

在弹出的文件中输入如下配置，并且将那些需要开启自动补全功能语言的选项后的false改为true：
```javascript
{
    // `true` means enable it.
    // `false` means disable it.
    "completion_active_list": {
    // build-in completions
    "css-properties": true,
    "gruntjs-plugins": false,
    "html": true,
    "lodash": false,
    "javascript": true,
    "jquery": true,
    "jquery-sq": false, // Single Quote
    "php": false,
    "phpci": false,
    "sql": true,
    "twitter-bootstrap": true,
    "twitter-bootstrap-less-variables": true,
    "twitter-bootstrap3": true,
    "twitter-bootstrap3-sass-variables": false,
    "underscorejs": false,
    "react": false,
    
    // Your own completions?
    // ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/sbc-api-my-angularjs.sublime-settings
    "my-angularjs": false,
    
    // ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/sbc-api-my-glossary.sublime-settings
    "my-glossary": false,
    
    // ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/sbc-api-my-html.sublime-settings
    "my-html": false,
    
    // ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/sbc-api-my-javascript.sublime-settings
    "my-javascript": false
    }
}
```
jQuery自动补全的效果图如下：

![8844e213d90ea331b4ec233557be6f40.png](https://www.tuchuang001.com/images/2017/06/29/8844e213d90ea331b4ec233557be6f40.png)

### Modific
[Modific](https://packagecontrol.io/packages/Modific)突出显示行自上次提交以来的更改情况（支持Git，SVN等版本控制工具）。安装完后，如果在版本控制管理目录下修改了文件行，新增的部分以三角标显示，修改的部分以菱形显示，如下图所示：

![6b1061aa0d544014885ae9caee37283a.png](https://www.tuchuang001.com/images/2017/06/29/6b1061aa0d544014885ae9caee37283a.png)

### WakaTime
[WakaTime](https://packagecontrol.io/packages/WakaTime)插件用于在Dashboard中显示你这周的编程时间，编写代码种类占比等信息。安装完插件后，在Sublime Text编辑器下方会要求您输入密匙并按下Enter即可，密匙获取地址：[https://wakatime.com/settings/account#apikey](https://wakatime.com/settings/account#apikey)：

![c545caa405ef49dd306580c6e99ce209.png](https://www.tuchuang001.com/images/2017/06/29/c545caa405ef49dd306580c6e99ce209.png)

在编写一段时间后，就可以去[https://wakatime.com/dashboard](https://wakatime.com/dashboard)中查看你的编码情况啦：

![826112355e2feb19d4e8f2f44e5de7a3.png](https://www.tuchuang001.com/images/2017/06/29/826112355e2feb19d4e8f2f44e5de7a3.png)

## 常用快捷键
这里只列出了Sublime Text在window中一些比较常用的自带快捷键：
```bash
Alt+R : 开启正则表达式功能
Alt+Enter: 找到匹配目标后全部选择
Ctrl+R：前往 method
Ctrl+M：跳转到对应括号
按Ctrl+Shift+上下键，可替换行
Ctrl+D：选择单词，重复可增加选择下一个相同的单词
Ctrl+L：选择行，重复可依次增加选择下一行
Ctrl+Shift+P：打开命令面板
Ctrl+G：跳转到第几行
Ctrl+W：关闭当前打开文件
Ctrl+KK：删除当前行光标后的所有内容
Ctrl+Shift+W：关闭所有打开文件
Ctrl+Shift+V：粘贴并格式化
Ctrl+Shift+L：选择多行
Ctrl+Shift+Enter：在当前行前插入新行
Ctrl+Shift+K：删除当前行
Ctrl+U：软撤销，撤销光标位置
Ctrl+J：选择标签内容
Ctrl+F：查找内容
Ctrl+Shift+F：查找并替换
Ctrl+H：替换
Ctrl+N：新建窗口
Ctrl+K+B：开关侧栏
Ctrl+Shift+M：选中当前括号内容，重复可选着括号本身
Ctrl+F2：设置/删除标记
Ctrl+/：注释当前行
Ctrl+Shift+/：当前位置插入注释
Ctrl+Alt+/：块注释，并Focus到首行，写注释说明用的
Ctrl+Shift+A：选择当前标签前后，修改标签用的
F11：全屏
Shift+F11：全屏免打扰模式，只编辑当前文件
Alt+F3：选择所有相同的词
Alt+.：闭合标签
Alt+Shift+数字：分屏显示
Alt+数字：切换打开第N个文件
Ctrl+shift+D: 备份多个当前行
Ctrl+shift+T: 恢复已经关闭的标签
```
## 在不同设备下同步个人配置
可以使用Git同步Packages/User/文件夹（可以在Preferences→Browse Packages...打开）下的内容，此文件夹包含Package Control.sublime-settings文件，其中包含所有已安装软件包的列表。使用Git同步到另一台机器，下次启动Sublime Text时，Package Control 将安装任何丢失的软件包的正确版本。

{% note danger %}有些插件安装后需要重启Sublime Text才能生效。插件安装多了，可能引起快捷键的冲突，需要引起注意。{% endnote %}
