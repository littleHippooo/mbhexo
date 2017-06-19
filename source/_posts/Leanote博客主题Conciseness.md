---
title: Leanote博客主题Conciseness
date: 2017-02-19 10:56:50
tags: [Leanote,theme]
---
主题Conciseness已上架Leanote博客[主题市场](https://leanote.com/member/blog/theme)。该主题修改自[roomcar](http://roomcar.leanote.com/single/me)的pure主题。
<!--more-->

主题预览图如下所示：

![54999990-file_1487997191856_69e5.png](https://www.tuchuang001.com/images/2017/06/13/54999990-file_1487997191856_69e5.png)

该主题可自行修改，这里做几点介绍。     
## 修改图片
编辑主题，找到theme.json文件以下字段：
```xml
...
"BlogImgName": "blogImg.jpg",
"WebImgName": "webImg.png",
"ErrorImgName": "robot.png",    
...
```
`BlogImgName`为博客About Me图片，`WebImgName`为网页小图标，`ErrorImgName`为404页面图片。

假如现在您想将About Me的图片换为自己上传的名为handsomeBoy.png的照片，只需将theme.json文件的BlogImgName字段值换位“handsomeBoy.png”即可。
## 修改About Me连接
编辑主题，找到theme.json文件以下字段：
```xml
"QQ": "123456",
"Weico": "http://weibo.com/",
"Facebook": "https://www.facebook.com/",
```
可将属性值换为自己的连接即可。
## 修改音乐
音乐插件来自：[32空间](https://32mb.space/)。

修改音乐只需修改theme.json文件中的MusicUrl 属性即可。该属性的值为一个数组，格式如下所示：
```javascript
 {"title": "musicTitle","artist":"artist","mp3": "musicUrl","cover": "musicCover"},
```
title为歌曲名，artist为歌手名，mp3为音乐连接，cover为专辑封面。关于这几个值的获取方法，下面做详细介绍：

1.比如在网易云音乐中搜索莫文蔚的《当你老了》，可得到音乐链接为：http://music.163.com/#/song?id=30621954&userid=3425798。其中song的id为30621954。

2.复制该id，打开链接：http://music.163.com/api/song/detail/?id=yourId&ids=%5ByourId%5D&csrf_token=。

3.将链接中的yourId更改为第一条复制的音乐id，然后回车，可看到页面解析出一个json格式内容：
```javascript
{
"songs": [
    {
    "name": "当你老了",
    "id": 30621954,
...
    "artists": [
        {
        "name": "莫文蔚",
        "id": 8926,
        "picId": 0,
        "img1v1Id": 0,
        "briefDesc": "",
        "picUrl": "http://p3.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
        "img1v1Url": "http://p4.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
        "albumSize": 0,
        "alias": [],
        "trans": "",
        "musicSize": 0
    }
        ],
    "album": {
        "name": "当你老了",
        "id": 3104146,
        "type": "EP/Single",
        "size": 1,
        "picId": 7860408627221136,
        "blurPicUrl": "http://p3.music.126.net/2nJOdPf1RlGY_tQdB5ZdPA==/7860408627221136.jpg",
        "companyId": 0,
        "pic": 7860408627221136,
        "picUrl": "http://p4.music.126.net/2nJOdPf1RlGY_tQdB5ZdPA==/7860408627221136.jpg",
        "publishTime": 1424188800007,
...        
        "mp3Url": "http://m2.music.126.net/tQ0pNmpsiHIsxEl-CnMmJg==/7897792022607979.mp3"
        }
    ],
"equalizers": {},
"code": 200
}
```
一大段json数据，和我们有关的就几个，其中`title`这里我们填写为“当你老了”，`artist`为“莫文蔚”，`mp3`为json数据中的mp3Url字段，这里为：[http://m2.music.126.net/tQ0pNmpsiHIsxEl-CnMmJg==/7897792022607979.mp3](http://m2.music.126.net/tQ0pNmpsiHIsxEl-CnMmJg==/7897792022607979.mp3)。`cover`为json文件中的album的picUrl字段值，这里为：[http://p4.music.126.net/2nJOdPf1RlGY_tQdB5ZdPA==/7860408627221136.jpg](http://p4.music.126.net/2nJOdPf1RlGY_tQdB5ZdPA==/7860408627221136.jpg)。所以最终的这首歌的代码为：
```javascript
 {
    "title": "当你老了",
    "artist":"莫文蔚",
    "mp3": "http://m2.music.126.net/tQ0pNmpsiHIsxEl-CnMmJg==/7897792022607979.mp3",
    "cover": "http://p4.music.126.net/2nJOdPf1RlGY_tQdB5ZdPA==/7860408627221136.jpg"
},
```
将这段代码加到theme.json文件中的musicUrl属性中即可。
## 输入特效
在搜索以及评论框内加如了插件activate-power-mode.js特效，如果不需要可以找到0-c.html第55行：
```javascript
<script>
    POWERMODE.colorful = true; 
    POWERMODE.shake = false; 
    document.body.addEventListener('input', POWERMODE);
</script> 
```
将这几行代码删掉即可。
## 弹出层
页面弹出层使用的是sweetAlert.js插件。当删除评论以及未登录状况下点击博文的评论和点赞按钮即可触发，如：

![67095376-file_1487997218085_ff4e.png](https://www.tuchuang001.com/images/2017/06/13/67095376-file_1487997218085_ff4e.png) 

相应API可查看sweetAlert插件官网。在主题share_comment.js文件中可找到相关代码。

如果有疑问，欢迎留言。

**2017年3月27日**

修复一些bug，样式调整。

最新安装包：[github](https://github.com/wuyouzhuguli/Conciseness.git)