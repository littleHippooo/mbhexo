---
title: IO Stream
date: 2016-11-15 16:49:21
tags: Java
---
我们编写的程序除了自身会定义一些数据信息外，经常还会引用外界的数据，或是将自身的数据发送到外界。比如，我们编写的程序想读取一个文本文件，又或者我们想将程序中的某些数据写入到一个文件中。这时我们就要使用输入与输出。

什么是输入(read):输入是一个从外界进入到程序的方向，通常我们需要“读取”外界的数据时，使用输入。所以输入是用来读取数据的。

什么是输出(write):输出是一个从程序发送到外界的方向，通常我们需要”写出”数据到外界时，使用输出。所以输出是用来写出数据的。 
<!--more-->

InputStream是所有字节输入流的父类，其定义了基础的读取方法，常用的方法如下:

1.`int read()`:读取一个字节，以int形式返回，该int值的”低八位”有效，若返回值为-1则表示EOF。

2.`int read(byte[] d)`:尝试最多读取给定数组的length个字节并存入该数组，返回值为实际读取到的字节量。

OutputStream是所有字节输出流的父类，其定义了基础的写出方法，常用的方法如下:

1.`void write(int d)`:写出一个字节,写的是给定的int的”低八位”。

2.`void write(byte[] d)`:将给定的字节数组中的所有字节全部写出。

## 文件流
### FileOutputStream    
`java.io.FileOutputStream`：文件字节输出流，用于将数据写入到文件中的流，该流是一个低级流。低级流特点:

数据的来源和去向是明确的，真实负责“搬运”数据的流。
```java
public class FOSDemo {
    public static void main(String[] args) throws IOException {
        /*
         * 向文件中写出数据
         * 一个参数的构造方法:
         * FileOutputStream(String path)
         * FileOutputStream(File file)
         * 创建出来的文件输出流是覆盖写操作，若操作的
         * 文件中有数据，会先将数据清除，重写本次写出的数据。
         * 
         * 若希望追加写操作，则需要传入第二个参数
         * 是一个boolean值，为true即可。
         * FileOutputStream(File file,boolean append)
         * FileOutputStream(String path,boolean append)
         */
        // File file=new File("fos.txt");
        // FileOutputStream fos = new FileOutputStream(file,true);
        FileOutputStream fos = new FileOutputStream("fos.txt",true);
        
        String str = "一步两步,一步一步像爪牙,像魔鬼的步伐!";
        fos.write(str.getBytes("UTF-8"));
        fos.close();
    }
}
```
### FileInputStream
`java.io.FileInputStream`：低级流，可以从文件中读取字节（操作过程和RandomAccessFile相似）。
```java
public class FISDemo {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("fos.txt");
        byte[] data = new byte[1024];
        int len = fis.read(data);
        
        String str = new String(data,0,len,"UTF-8");
        System.out.println(str);//一步两步,一步一步像爪牙,像魔鬼的步伐!
        fis.close();	
    }
}
```
### 复制
使用文件流的形式复制文件。
```java
 public class CopyDemo1 {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("fos.txt");
        
        FileOutputStream fos = new FileOutputStream("fos_copy.txt");
 
        byte[] data = new byte[1024*10];
        int len = -1;
        while((len = fis.read(data))!=-1){
        	fos.write(data,0,len);
        }
        System.out.println("复制完毕");
        
        fis.close();
        fos.close();
    }
}
```
## 缓冲流
在读取数据时若以字节为单位读取数据，会导致读取次数过于频繁从而大大的降低读取效率。为此我们可以通过提高一次读取的字节数量减少读写次数来提高读取的效率。

1.`BIS`:是一个处理流，该流为我们提供了缓冲功能。

2.`BOS`:与缓冲输入流相似，在向硬件设备做写出操作时，增大写出次数无疑也会降低写出效率，为此我们可以使用缓冲输出流来一次性批量写出若干数据减少写出次数来提高写 出效率。

3.`BufferedInputStream`是缓冲字节输入流。其内部维护着一个缓冲区(字节数组)，使用该流在读取一个字节时，该流会尽可能多的一次性读取若干字节并存入缓冲区，然后逐一的将字节返回，直到缓冲区中的数据被全部读取完毕，会再次读取若干字节从而反复。这样就减少了读取的次数，从而提高了读取效率。

4.`BufferedOutputStream`缓冲输出流内部也维护着一个缓冲区，每当我们向该流写数据时，都会先将数据存入缓冲区，当缓冲区已满时，缓冲流会将数据一次性全部写出。
### BIS和BOS
`BufferedInputStream`与`BufferedOutputStream`(BIS和BOS):缓冲字节输入流，缓冲字节输出流.这是一对高级流，作用是可以提高读写效率.（作用类似于字节数组）。
```java
public class CopyDemo2 {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("1.mp4");
        BufferedInputStream bis = new BufferedInputStream(fis);
        
        FileOutputStream fos = new FileOutputStream("1_copy2.mp4");
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        
        int d = -1;
        while((d=bis.read())!=-1){
            bos.write(d);
        }
        System.out.println("复制完毕!");
        /*
         * 关闭流的时候，只需要关闭最外层的高级流
         * 即可。因为高级流在关闭自身前会先将其处理
         * 的流关闭。
         */
        bis.close();
        bos.close();
    }
}
```
### flush
`void flush()`，缓冲流都提供了flush的实现。作用是强制将现有缓冲数组中的数据一次性写出。避免了因缓冲数组中数据不够而导致文件内容为空的问题。频繁调用该方法会提高写出次数从而降低写出效率，但是当我们需要有写出数据即时性的时候就要使用。
```java
public class BosDemo {
    public static void main(String[] args) throws IOException {
        FileOutputStream fos = new FileOutputStream("bos.txt");
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        
        String str = "我爱北京天安门";
        byte[] data = str.getBytes();
        
        bos.write(data);
        // bos.flush();
        bos.close();//close内部也有flush()方法.
    }
}
```
## 对象流
对象是存在于内存中的。有时候我们需要将对象保存到硬盘上，又有时我们需要将对象传输到另一台计算机上等等这样的操作。这时我们需要将对象转换为一个字节序列，而这个过程就称为对象序列化。相反，我们有这样一个字节序列需要将其转换为对应的对象，这个过程就称为对象的反序列化。

1.`java.io.ObjectOutputStream`：高级流，功能是将给定的一个对象转换为一组字节，然后通过其处理的流将字节写出。

2.`java.io.ObjectInputStream`：高级流，可以进行对象的反序列化。将 一组字节还原回对象，前提是这一组字节必须是由ObjectOutputStream将一个对象序列化后的字节

读写对象一般用于:保存现有对象到硬盘上；在网络中传输对象。

以下Person类用于测试对象流读写对象：
```java
public class Person implements Serializable{
    private String name;
    private int age;
    private String gender;
    private List<String> otherInfo;
    
    public Person(){
    	
    }
    public Person(String name, int age, String gender, List<String> otherInfo) {
        super();
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.otherInfo = otherInfo;
    }
    // get,set略
    public String toString(){
        return name+","+age+","+gender+","+otherInfo;
    }
}
```
### 对象→字节
```java
public class OOSDemo {
    public static void main(String[] args) throws IOException {
        FileOutputStream fos = new FileOutputStream("person.obj");
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        
        Person p = new Person();
        p.setName("路飞");
        p.setAge(18);
        p.setGender("男");
        
        List<String> otherInfo = new ArrayList<String>();
        otherInfo.add("蒙奇·D·路飞");
        otherInfo.add("要成为海贼王的男人");
        otherInfo.add("积极乐观");
        p.setOtherInfo(otherInfo);
        /*
         * void writeObject(Object obj)
         * 该方法会将给定的对象转换为一组字节，然后写出
         * 
         * 序列化:将一个数据结构转换为一组字节的过程
         * 持久化:将内存中的数据写入硬盘长久保存的过程
         */
        oos.writeObject(p);
        oos.close();
      }
} 
```
### 字节→对象
```java
public class OISDemo {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream("person.obj");
        ObjectInputStream ois = new ObjectInputStream(fis);
        /*
         * Object readObject()
         * 该方法会读取若干字节，然后将其反序列化回对象。
         * 并以Object形式返回，需要自己强制类型转换
         */
        Person p = (Person)ois.readObject();
        System.out.println(p);
        //路飞,18,男,[蒙奇·D·路飞, 要成为海贼王的男人, 积极乐观]
        ois.close();
    }
}
```
## 字符流   
`Reader`是所有字符输入流的父类，而`Writer`是所有字符输出流的父类。字符流是以字符(char)为单位读写数据的。一次处理一个unicode。字符流都是高级流，其底层都是依靠字节流进行读写数据的，所以底层仍然是基于字节读写数据的。

`Reader`的常用方法:

1.`int read()`：读取一个字符，返回的int”值低16”位有效。

2.`int read(char[] chs)`：从该流中读取一个字符数组length个字符并存入该数组，返回值为实际读取到的字符量。

`Writer`的常用方法:

1.`void write(int c)`：写出一个字符,写出给定int值”低16”位表示的字符。

2.`void write(char[] chs)`：将给定字符数组中所有字符写出。

3.`void write(String str)`：给定的字符串写出。

4.`void write(char[] chs,int offset,int len)`：将给定的字符数组中从offset处开始连续的len个字符写出。

### Writer 

`Writer`字符输出流，特点:以字符为单位写出数据。

`OutputStreamWriter`:字符流的一个常用实现类。特点是可以按照指定的字符集将给定的字符串转换为对应的字节后写出。
```java
public class OSWDemo {
    public static void main(String[] args) throws IOException {
        FileOutputStream fos = new FileOutputStream("osw.txt");
        /*
         * 常用构造方法:
         * OutputStreamWriter(OutputStream out)
         * 按照系统默认字符集将字符串转换为字节后写出
         * 
         * OutputStreamWriter(OutputStream out,String charsetName)
         * 按照给定的字符集将字符串转换为字节后写出
         */
        OutputStreamWriter osw = new OutputStreamWriter(fos,"UTF-8");
        osw.write("我爱北京天安门");
        osw.write("天安门上太阳升");
        osw.close();
    }
}
```
### Reader    
`Reader`字符输入流 特点:以字符为单位读取数据

`InputStreamReader`是其常用实现类，作用是可以按照指定的字符集读取字符。
```java
public class ISRDemo {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("osw.txt");
        InputStreamReader isr = new InputStreamReader(fis,"UTF-8");
        
        int d = -1;
        while((d=isr.read())!=-1){
            System.out.print((char)d);
        }
        isr.close();
    }
}
```
### 转码
转码：比如将UTF-8编码的文本文件转换为GBK编码的文本文件

原理:使用UTF-8编码将每一个字符读取出来，再以GBK编码将字符写入另一个文件即可。
```java
public class ChangeCharsetDemo {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("osw.txt");
        InputStreamReader isr = new InputStreamReader(fis,"UTF-8");
        
        FileOutputStream fos= new FileOutputStream("osw_gbk.txt");
        OutputStreamWriter osw = new OutputStreamWriter(fos,"GBK");
        
        char[] data = new char[1024*5];
        int len = -1;
        while((len = isr.read(data))!=-1){
            osw.write(data,0,len);
        }
        System.out.println("转码完毕!");
        osw.close();
        isr.close();	
    }
}
```
### PrintWriter    
缓冲字符输出流，特点是可以以行为单位写出字符串并且该流还具备自动行刷新功能。

传统的缓冲字符输出流是`BufferedWriter`.由于`PrintWriter`在创建的时候内部使用了该流，并且`PrintWriter`还具有自动行刷新，所以比较常用。

`PrintWriter`提供了若干构造方法，可以方便快速创建。
```java
public class PWDemo {
    public static void main(String[] args) throws IOException {
        /*
         * PrintWriter可以直接创建基于文件的写操作:
         * PrintWriter(File file)
         * PrintWriter(String path)
         */
        // File file=new File("pw.txt");
        // PrintWriter pw = new PrintWriter(file,"UTF-8");
        PrintWriter pw = new PrintWriter("pw.txt","UTF-8");
        pw.println("我爱北京天安门");
        pw.println("天安门上太阳升");
        pw.close();
    }
}
```
`PrintWriter`处理其他流的形式：
```java
public class PWDemo2 {
    public static void main(String[] args) throws IOException {
        /*
         * PrintWriter提供了用于处理其他流的构造方法，
         * 既可以处理字符流，也可以处理字节流。
         */
        FileOutputStream fos = new FileOutputStream("pw2.txt");
        /*
         * 若要按照指定字符集写出，需要中间再创建一个
         * OSW来负责转字符集的操作。
         */
        OutputStreamWriter osw = new OutputStreamWriter(fos,"UTF-8");
        PrintWriter pw = new PrintWriter(osw);
        pw.println("随便啦");
        pw.close();	
    }
} 
```
### BufferedReader
`java.io.BufferedReader`：缓冲字符输入流 特点:以行为单位读取字符串。
```java
public class BRDemo {
    public static void main(String[] args) throws IOException {
    	
    	FileInputStream fis= new FileInputStream(
            "src" + File.separator +
            "IO" + File.separator +
            "BRDemo.java");
    	InputStreamReader isr = new InputStreamReader(fis);
    	BufferedReader br = new BufferedReader(isr);
    	/*
    	 * String readLine()
    	 * BufferedReader提供的该方法会读取若干字符，直到读取到
    	 * 换行符为止，然后将换行符之前读取的这若干字符组成一个
    	 * 字符串返回。需要注意，返回的字符串中是不包含换行符的！
    	 * 若返回值为null,说明读取到文件末尾了。
    	 */
    	String line = null;
    	while((line = br.readLine())!=null){
            System.out.println(line);
    	}
    	br.close();
    }
}    
```
