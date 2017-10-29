---
title: Leanote博客主题Material Design
date: 2017-03-16 10:08:51
tags: [Leanote,theme]
---
Material Design（卡片式材料设计）是谷歌在I/O 2014上发布的新的设计语言。在Material的扁平化设计中，它使用了分层元素来营造三维空间。

该主题有Light和Dark两种显示模式，可通过toolBar右侧的按钮切换。博客可在主题文件theme.json中作简单的修改，theme.json文件内容如下：
```javascript
{
    ...
    "WebImgName": "leanote.png",
    "Color": "blue",
    "ColorStrength": "300",
    "BlogImg": "material.jpg",
    "FriendLinks": [
        {"Title": "My Note", "Url": "https://leanote.com/note"},
        {"Title": "Leanote Home", "Url": "https://leanote.com"},
        {"Title": "Leanote BBS", "Url": "http://bbs.leanote.com"},
        {"Title": "Leanote Github", "Url": "https://github.com/leanote/leanote"}
    ]
}
```
<!--more-->
主题预览：

![36585044-file_1493261409300_b2ea.png](img/36585044-file_1493261409300_b2ea.png)

theme.json文件中，`WebImgName` 为网页小图标图片名称+格式名， `BlogImg`为博客标题背景图+格式名，标题的背景图尺寸建议为350X130，`Color`为博客颜色（比如toolBar和按钮等组件的颜色），`ColorStrength`为颜色的浓度。下面为所有可取的值：

![60203856-file_1489661610284_a9ad.png](img/60203856-file_1489661610284_a9ad.png)
![75149486-file_1489661659560_29fd.png](img/75149486-file_1489661659560_29fd.png)
![93654409-file_1489661803530_3b8f.png](img/93654409-file_1489661803530_3b8f.png)
![40242080-file_1489661852720_148da.png](img/40242080-file_1489661852720_148da.png)
![11294248-file_1489661905987_16294.png](img/11294248-file_1489661905987_16294.png)
![84460929-file_1489661939468_8358.png](img/84460929-file_1489661939468_8358.png)
![51822604-file_1489661983452_f8de.png](img/51822604-file_1489661983452_f8de.png)
![58623086-file_1489662023344_6968.png](img/58623086-file_1489662023344_6968.png)
![45930133-file_1489662062694_15be3.png](img/45930133-file_1489662062694_15be3.png)
![91297668-file_1489662116922_127c0.png](img/91297668-file_1489662116922_127c0.png)

这里有一点需要注意，颜色名称必须为全小写，比如Blue应写为blue。

如有问题，欢迎留言。

**2017年3月20日**

修复了几处在火狐浏览器下的bug。

**2017年3月23日**

修复Markdown下点击文章导航不跳转问题。

最新主题包下载地址：[github](https://github.com/wuyouzhuguli/Material-Design.git)
