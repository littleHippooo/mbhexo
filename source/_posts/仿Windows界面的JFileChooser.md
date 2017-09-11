---
title: 仿Windows界面的JFileChooser
date: 2016-05-30 09:55:23
tags: Java
---
```java
try {
   UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
} catch (Exception e1) {
  e1.printStackTrace();
}
String out = new SimpleDateFormat("yyMMddhhmmss").format(new Date());
JFileChooser fc = new JFileChooser();
//设置默认文件名
fc.setSelectedFile(new File("项目内容表" + out + ".xls"));
fc.setDialogType(JFileChooser.FILES_ONLY);
fc.setDialogTitle("选择保存路径");
fc.setMultiSelectionEnabled(false);
int result = fc.showSaveDialog(fc);
if (result == JFileChooser.APPROVE_OPTION) {
    //保存
    //your code here
} else {
    //取消
　　//your code here
}
```
<!--more-->
如图：

![48583782-file_1487994021089_12e8f.png](img/48583782-file_1487994021089_12e8f.png)

更换图标：

重写其父类JFrame：
```java
JFrame jf=new JFrame();
ImageIcon imgIcon = new ImageIcon(ProExportUtil.class.getResource("icon.png"));
jf.setIconImage(imgIcon.getImage());
```
将上面13行代码改为：
```java
int result = fc.showSaveDialog(jf);
```
效果如图所示：

![38808095-file_1487994049419_48d4.png](img/38808095-file_1487994049419_48d4.png)