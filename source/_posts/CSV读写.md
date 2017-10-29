---
title: CSV读写
date: 2017-09-02 16:13:36
tags: Java
---
CSV是以逗号间隔的文本文件。当导出的数据不涉及公式和复杂的表格样式的时候，可以考虑使用javacsv来代替POI，以便节省性能。

引入javacsv依赖：
```xml
<!-- https://mvnrepository.com/artifact/net.sourceforge.javacsv/javacsv -->
<dependency>
    <groupId>net.sourceforge.javacsv</groupId>
    <artifactId>javacsv</artifactId>
    <version>2.0</version>
</dependency>
```
<!--more-->
## CsvWriter
```java
import java.nio.charset.Charset;
import com.csvreader.CsvWriter;

public class CsvWrite {
    public static void csvWrite(){
        String csvFilePath = "D://test.csv";
        try {
            CsvWriter csvWriter = new CsvWriter(csvFilePath, ',', Charset.forName("UTF-8"));
            // 表头
            String[] csvHeaders = { "编号", "姓名", "年龄" };  
            csvWriter.writeRecord(csvHeaders);  
            // 内容  
            for (int i = 0; i < 5; i++) {  
                String[] csvContent = { i + "", "userName", "1" + i };  
                csvWriter.writeRecord(csvContent);  
            }  
            csvWriter.close();  
        } catch (Exception e) {
            e.printStackTrace();
        }	
    }
    public static void main(String[] args) {
        CsvWrite.csvWrite();
    }
}
```
生成文件如下：

![mrbird_photo_20170926162502.png](img/mrbird_photo_20170926162502.png)

##  CsvReader
```java
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import com.csvreader.CsvReader;

public class CsvRead {
    public static void readCSV() {
        ArrayList<String[]> csvFileList = new ArrayList<String[]>();
        String csvFilePath = "D://test.csv";
        try {
            CsvReader reader = new CsvReader(csvFilePath, ',', Charset.forName("UTF-8"));
            // 跳过表头
            reader.readHeaders();
            // 逐行读入除表头的数据
            while (reader.readRecord()) {
                System.out.println(reader.getRawRecord());
                csvFileList.add(reader.getValues());
            }
            reader.close();
            
            // 遍历读取CSV每行每列  
            for (int row = 0; row < csvFileList.size(); row++) {  
                String[] cells = csvFileList.get(row);
                for(String str : cells){
                	System.out.print(str+"  ");
                }
                System.out.println();
            }  
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        CsvRead.readCSV();
    }
}
```
输出：
```xml
0,userName,10
1,userName,11
2,userName,12
3,userName,13
4,userName,14
0  userName  10  
1  userName  11  
2  userName  12  
3  userName  13  
4  userName  14 
```
javacsv API：[http://javacsv.sourceforge.net/](http://javacsv.sourceforge.net/)