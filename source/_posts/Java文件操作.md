---
title: Java文件操作
date: 2016-11-15 15:03:09
tags: Java
---
`java.io.File：File`的每一个实例用来表示硬盘上的一个文件或目录，我们通过File可以:

1.访问一个文件或目录的属性信息，文件名，大小，修改日期，访问权限等。

2.可以创建文件，删除文件，创建目录，删除目录。

3.可以访问目录中的所有子项

但是不能访问文件数据。
<!--more-->
## 基本操作
在项目根目录新建test.txt文件，内容为hello world。以下为基本操作。
```java
public class FileDemo1 {
    public static void main(String[] args) {
        /*
         * 在eclipse中，"."当前目录，指的是项目的根目录
         * separator相当于”/”
         */
        File file = new File("."+File.separator+"test.txt");
        //获取文件名
        String name = file.getName();
        
        /*
         * 获取文件大小。返回值为一个long值，表示占用的字节量
         * 中文以及中文状态下的标点符号都占用两个字节
         * 英文及英文状态下的标点符号占用一个字节
         */
        long length = file.length();
        
        // 获取文件最后修改时间
        long time = file.lastModified();
        
 
        // 查看文件是否具有可运行，可读，可写的权限
        file.canExecute();
        file.canRead();
        file.canWrite();
        
        // 判断当前File对象表示的是否为一个文件
        boolean isFile = file.isFile();
        
        // 判断当前File对象表示的是否为一个目录
        boolean isDir = file.isDirectory();
        
        //是否为一个隐藏文件
        boolean isHidden = file.isHidden());
    }
}
```
## 创建文件
```java
public class FileDemo2 {
    public static void main(String[] args) throws IOException {
        
        // 在当前目录下创建一个文件demo.txt 
        File file = new File("."+File.separator+"demo.txt");
        if(!file.exists()){
            file.createNewFile();
            System.out.println("创建完毕!");	
        }
    }
}
```
## 删除文件
```java
public class FileDemo3 {
    public static void main(String[] args) {
 
        File file = new File("."+File.separator+"demo.txt");
        if(file.exists()){
            file.delete();
            System.out.println("删除完毕!");
        }
    }
}﻿​
```
## 创建目录
```java
public class FileDemo4 {
    public static void main(String[] args) {
        
        // 当前目录下创建一个目录demo
        File dir = new File("demo");
        if(!dir.exists()){
            // 创建目录
            dir.mkdir();
            System.out.println("创建完毕!");
        }
    }
}
```
## 创建多级目录
```java
public class FileDemo5 {
    public static void main(String[] args) {
    	// 在当前目录下创建目录a/b/c/d/e/f
    	File dir = new File(
    		"a"+File.separator +
    		"b"+File.separator +
    		"c"+File.separator +
    		"d"+File.separator +
    		"e"+File.separator +
    		"f"
    	);	
    	if(!dir.exists()){
    		 // mkdirs方法在创建当前目录的同时会将所有不存在的父目录
    		 // 自动创建出来。
    		dir.mkdirs();
    		System.out.println("创建完毕！");
    	}
    }
}   
```
结果：   

![39195276-file_1488010595193_b26e.png](img/39195276-file_1488010595193_b26e.png)
## 删除目录
只能删除空目录。
```java
public class FileDemo6 {
    public static void main(String[] args) {
        File dir = new File("demo");
        if(dir.exists()){
            // 删除目录，只能删除空目录，即: 目录中不能含有任何子项。
            dir.delete();
            System.out.println("删除完毕!");
        }
    }
}
```
## listFiles
获取一个目录下的所有子项。
```java
public class FileDemo7 {
    public static void main(String[] args) {
        File dir = new File(".");
        File[] subs = dir.listFiles();
        for(File sub : subs){
            System.out.println((sub.isFile()?"文件:":"目录:")+sub.getName());
        }
    }
}  
```
## Filefilter
文件过滤器`Filefilter`：获取一个目录下符合条件的子项，需要使用文件过滤器来定义过滤条件。通常使用匿名内部类来实现。
```java
public class FileDemo8 {
    public static void main(String[] args) {
        /*
         * 获取当前目录下所有名字是以"."开头的子项
         * 使用匿名内部类
         */
        FileFilter filter = new FileFilter(){
            public boolean accept(File file) {
                String name = file.getName();
                System.out.println("正在过滤:"+name);
                return name.startsWith(".");
            }
        };
        
        File dir = new File(".");
        /*
         * 该重载的listFiles方法会将当前目录中的每
         * 一个子项都交给过滤器，然后只保留满足过滤器
         * 要求(为true)的子项
         */
        File[] subs = dir.listFiles(filter);
        for(File sub : subs){
            System.out.println(sub.getName());
        }
    }
}
```
输出：
```xml
正在过滤:.classpath
正在过滤:.project
正在过滤:.settings
正在过滤:a
正在过滤:build
正在过滤:src
正在过滤:test.txt
正在过滤:WebContent
.classpath
.project
.settings
```
## 删除含有子项目录
使用“递归”的方式删除含有子项的目录（删除上面创建的a目录）。
```java
public class FileDemo9 {
    public static void main(String[] args) {
        File dir = new File("a");
        deleteFile(dir);
    }
    /**
     * 将给定的File表示的文件或目录删除
     * @param file
     */
    public static void deleteFile(File file){
        if(file.isDirectory()){
            //先将其所有子项删除
            File[] subs = file.listFiles();
            for(File sub:subs){
                //递归
                deleteFile(sub);
            }			
        }
        file.delete();
    }
}           
```
## 读写文件数据
写入：
```java
public class RandomAccessFileDemo1 {
    public static void main(String[] args) throws IOException {
        /*
         * RandomAccessFile创建支持很多模式
         * 常用的有:
         * "r":只读
         * "rw":读写
         */
        RandomAccessFile raf= new RandomAccessFile("demo.dat","rw");
        /*
         * void write(int d)
         * 向文件中写入一个字节，写的是该int值对应的2进制内容中的"低八位",
         * 范围255
         */
        raf.write(27);
        raf.close();
    }
}
```
读取：
```java
public class RandomAccessFileDemo2 {
    public static void main(String[] args) throws IOException {
        RandomAccessFile raf = new RandomAccessFile("demo.dat","r");
        /*
         * int read()
         * 读取一个字节，并以int(低八位)形式返回
         * 若读取到文件末尾则返回值为-1
         */
        int d = raf.read();
        System.out.println(d); // 27
        raf.close();
    }
}
```
## 批量读写
`void write(byte[] data)`：批量写出字节。一次性将给定的字节数组中的所有字节写出。 
```java
public class RandomAccessFileDemo3 {
    public static void main(String[] args) throws IOException {
        RandomAccessFile raf = new RandomAccessFile("demo.dat","rw");
        String str = "摩擦摩擦，是魔鬼的步伐";
        /*
         * byte[] getBytes()
         * String提供的该方法可以将当前字符串
         * 按照系统默认的字符集转换为对应的一组字节
         * 
         * byte[] getBytes(String charset)
         * 按照给定的字符集将字符串转换为一组字节
         * 字符集名称:
         * GBK:国标编码  中文2字节
         * UTF-8:变长编码集，1-4个字节，中文3字节
         * ISO8859-1:欧洲编码，不支持中文
         */
        byte[] data = str.getBytes("GBK");
        raf.write(data);
        System.out.println("写出完毕");
        raf.close();	
    }
}
```
`int read(byte[] data)`：一次性尝试读取给定字节数组长度的字节量，并存入该数组中，返回值为实际读取到的字节量，若返回值为-1,则表示这次没有读到任何数据(文件末尾了)。     
```java
public class RandomAccessFileDemo4 {
    public static void main(String[] args) throws IOException {
        RandomAccessFile raf = new RandomAccessFile("demo.dat","r");
        byte[] data = new byte[100];
        
        int len = raf.read(data);//每次read的长度，不写默认为1
        System.out.println("读到了"+len+"个字节");//读到了22个字节
        /*
         * 该构造方法允许我们将给定的字节数组
         * 中指定范围内的字节转换为对应的字符串
         */
        String str = new String(data,0,len,"GBK");
        System.out.println(str);//摩擦摩擦，是魔鬼的步伐
        raf.close();
    }
}
```
## 复制文件
实际上就是一读一写。
```java
public class CopyDemo {
    public static void main(String[] args) throws IOException {
        RandomAccessFile src = new RandomAccessFile("1.mp4","r");
        RandomAccessFile desc = new RandomAccessFile("1_copy.mp4","rw"	);
        
        byte[] buf = new byte[1024*10];
        int len = -1;
        while((len=src.read(buf))!=-1){
            /*
             * void write(byte[] data,int offset,int len)
             * 将当前数组中从offset指定位置开始，连续len
             * 个字节写出
             */
            desc.write(buf,0,len);
        }
        src.close();
        desc.close();	
    }
}
```
